#' Stemmer Nazief Andriani implementation of Nazief and Andriani's Porter Stemmer
#'
#' @docType class
#' @name stemmer_nazief_andriani
#' @import R.cache
#' @keywords stemmer
#' @return Object of \code{\link{R6Class}} with methods for stemming with Nazief and Andriani algorithm
#' @format An \code{\link{R6Class}} object.
#' @section Methods:
#'
#' \describe{
#'    \item{\code{stem_word(word)}}{
#'      stemming a single word into its stem.
#'    }
#' }
#'
#' @examples
#'
#' @export
stemmer_nazief_andriani <- R6::R6Class(
    classname    = "stemmer_nazief_andriani",
    # inherit      = kstemind_extended,
    lock_objects = FALSE,
    parent_env   = asNamespace('kstemind'),

	#> TODO :
	#> []	encapsulate stem dictionary

	public = list(
		stem_dictionary_name = NULL,
		initialize = function(stem_dictionary = "kamus_sastrawi") {
			self$stem_dictionary_name <- stem_dictionary
			private$stem_dictionary <- kstemind_load_data(stem_dictionary)
			private$visitors <- visitors_cs$new(stem_dictionary = stem_dictionary, tables_visitors = "tabel_visitors_nazief_andriani")
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
		  data <- loadCache(key, suffix=".nazief.Rcache")
		  if (!is.null(data)) {
		    return(data);
		  }
		  # 2. If not available, generate it.
		  data <- self$stem_word(word)
		  saveCache(data, key=key, suffix=".nazief.Rcache")
		  return(data)
		}
	),
	private = list(
		stem_dictionary = NULL,
		visitors = NULL,

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
		is_match = function(word) {
			return(private$stem_dictionary$has_key(word))
		},
		stem_singular = function(word) {
			# init variables
			original_word = word
			current_word = word

			# step 1 : check against the stem dictionary
			#				 : also do not stem short words
			if(private$stem_dictionary$has_key(current_word)){ return(current_word) }
			if(private$is_short_word(current_word)){
				return(current_word)
			}

			# step 2 : remove inflectional suffixes
			#      3 : remove any derivational suffixes
			current_word <- private$accept_visitors(original_word, "suffix")
			if(private$stem_dictionary$has_key(current_word)){ return(current_word)	}

			# step 4 : remove any derivational prefixes
			#      5 : remove any prefixes with regex rules in Table II (prefix_disambiguators)
			current_word <- private$accept_visitors(current_word, "prefix")
			if(private$stem_dictionary$has_key(current_word)){ return(current_word)	}

			# nothing match, return the original word
			return(original_word)
		},

		# SLAVE ========================================================
		is_short_word = function(word) {
			return(str_length(word) <= 3)
		},
		accept_visitors = function(word, type_of_visitors) {
			if(type_of_visitors == "suffix") {
				return( private$visitors$visit_suffixes(word) )
			} else if(type_of_visitors == "prefix") {
				return( private$visitors$visit_prefixes(word) )
			}
		}
	)
)
