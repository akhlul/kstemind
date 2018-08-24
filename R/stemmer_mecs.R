#' Stemmer MECS - implementation of Modified ECS Stemmer
#'
#' @docType class
#' @name stemmer_mecs
#' @export
stemmer_mecs <- R6::R6Class(
    classname    = "stemmer_mecs",
    lock_objects = FALSE,
    parent_env   = asNamespace('kstemind'),

  	#> TODO :
	#> [V]	partial implementation
	#> []   full implementation


	public = list(
		dictionary_name = NULL,
		# myvar = NULL,

		initialize = function(stem_dictionary = "kamus_sastrawi") {
			self$dictionary_name <- stem_dictionary
			private$stem_dictionary <- kstemind_load_data(stem_dictionary)
			private$visitors <- visitors_ecs$new(stem_dictionary = stem_dictionary, tables_visitors = "tabel_visitors_mecs")
		},
		stem_word = function(word) {
			if(private$is_plural(word)) {
				return( private$stem_plural(word) )
			} else {
				return( private$stem_singular(word) )
			}
		},
		stem = function(word) {
		  # 1. Try to load cached data, if already generated
		  key <- list(word)
		  data <- loadCache(key, suffix=".mecs.Rcache")
		  if (!is.null(data)) {
		    return(data);
		  }
		  # 2. If not available, generate it.
		  data <- self$stem_word(word)
		  saveCache(data, key=key, suffix=".mecs.Rcache")
		  return(data)
		}
	),
	private = list(
		stem_dictionary = NULL,
		visitors = NULL,

		# BIG BOSS ========================================================
		is_plural = function(word) {
			matches <- str_match(word, "\\b(.*)-(ku|mu|nya|lah|kah|tah|pun)\\b")
			# examples:
			#	#>				"ampunan-nya" >> [ "ampunan-nya", "ampunan", "nya" ]
			if(!is.na(matches[2])) {
				return(str_detect(matches[2], "\\b(.*)-(.*)\\b"))
			}
			return(str_detect(word, "\\b(.*)-(.*)\\b"))
		},
		stem_plural = function(plural_word){
			rewords <- NULL
			matches <- str_match(plural_word, "\\b(.*)-(ku|mu|nya|lah|kah|tah|pun)\\b")
			if(!is.na(matches[2])) {
				reword <- matches[2]
			} else { reword <- plural_word	}

			# #> 				berbalas-balasan >> balas
			matches <- str_match(reword, "\\b(.*)-(.*)\\b")
			words <- c(matches[2], matches[3])
			rootwords <- c(private$stem_singular(words[1]), private$stem_singular(words[2]))

			# #> 				berbalas-balasan >> balas
			if(!private$stem_dictionary$has_key(words[1]) && rootwords[2] == words[2]) {
				rootwords[2] <- private$stem_singular(paste0('me', words[2]))
			}
			if(rootwords[1] == rootwords[2]) {
				return(rootwords[1])
			} else { return(plural_word)}
		},
		stem_singular = function(word) {
			# init variables
			original_word <- word
			current <- list(
				word = word,
				removal_steps = private$visitors$create_empty_removal_steps()
			)
			self$myvar <- current

			# step 1 : check against the stem dictionary
			#				 : also do not stem short words
			if(private$stem_dictionary$has_key(current$word)){ return(current$word) }
			if(private$is_short_word(current$word)){
				return(current$word)
			}

			# check and do whether precedence adjustment specification satisties
			if(private$cs_precedence_adjustment_specification(original_word)){
				# step 4 : remove any derivational prefixes
				#      5 : remove any prefixes with regex rules in Table II (prefix_disambiguators)
				current <- private$accept_visitors(current$word, current$removal_steps, "prefix")
				if(private$stem_dictionary$has_key(current$word)){ return(current$word)	}

				# step 2 : remove inflectional suffixes
				#      3 : remove any derivational suffixes
				current <- private$accept_visitors(current$word, current$removal_steps, "suffix")
				if(private$stem_dictionary$has_key(current$word)){ return(current$word)	}
			}

			# step 2 : remove inflectional suffixes
			#      3 : remove any derivational suffixes
			#      reset current list
			current <- list(
				word = original_word,
				removal_steps = private$visitors$create_empty_removal_steps()
			)
			current <- private$accept_visitors(current$word, current$removal_steps, "suffix")
			# self$myvar <- current
			if(private$stem_dictionary$has_key(current$word)){ return(current$word)	}

			# step 4 : remove any derivational prefixes
			#      5 : remove any prefixes with regex rules in Table II (prefix_disambiguators)
			current <- private$accept_visitors(current$word, current$removal_steps, "prefix")
			# self$myvar <- current
			if(private$stem_dictionary$has_key(current$word)){ return(current$word)	}

			# ECS step : loopPengembalianAkhiran
			current_word <- private$loop_pengembalian_akhiran(current)
			if(private$stem_dictionary$has_key(current_word)){ return(current_word)	}

			# nothing match, return the original word
			return(original_word)
		},

		# SLAVE ========================================================
		cs_precedence_adjustment_specification = function(word) {
			rules <- "\\bbe(.*)lah\\b|\\bbe(.*)an\\b|\\bme(.*)i\\b|\\bdi(.*)i\\b|\\bpe(.*)i\\b|\\bter(.*)i\\b"
			return(str_detect(word, rules))
		},
		is_short_word = function(word) {
			return(str_length(word) <= 3)
		},
		accept_visitors = function(word, removal_steps, type_of_visitors) {
			if(type_of_visitors == "suffix") {
				return( private$visitors$visit_suffixes(word, removal_steps) )
			} else if(type_of_visitors == "prefix") {
				return( private$visitors$visit_prefixes(word, removal_steps) )
			}
		},
		loop_pengembalian_akhiran = function(data) {
			# return all the prefixes
			rs <- data$removal_steps
			last_word_stemmed <- rs$word_after[nrow(rs)]
			word_prefix <- paste(rs[rs$type == "P", ]$affix, collapse = "")
			word_with_prefix <- str_c(word_prefix, last_word_stemmed)
			# message("word_with_prefix : ", word_with_prefix)

			# return the suffixes
			current_word <- word_with_prefix
			rs_suffix <- rs[rs$type == "S", ]
			if(nrow(rs_suffix) > 0) {
				for (i in nrow(rs_suffix):1) {
					if(rs_suffix$affix[i] == "kan") {
						word_before <- current_word
						
						# try 'k' first
						current_word <- paste0(current_word, "k")
						temp <- private$accept_visitors(current_word, NULL, "prefix")
						if(private$stem_dictionary$has_key(temp$word)){ return(temp$word) }

						# fail use 'k', replace back with 'kan'
						current_word <- paste0(word_before, "kan")
					} else {
						current_word <- paste0(current_word, rs_suffix$affix[i])
					}

					# message("returning suffix : ", current_word)
					temp <- private$accept_visitors(current_word, NULL, "prefix")
					# message("testing with prefix visitors : ", temp$word)

					if(private$stem_dictionary$has_key(temp$word)){ return(temp$word) }
					current_word <- temp$word
				}
			}
			return(current_word)
		}
	)
)