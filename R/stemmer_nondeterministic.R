#' Stemmer Non-Deterministic - implementation of Non-Deterministic Stemmer
#'
#' @docType class
#' @name stemmer_nondeterministic
#' @import data.table
#'
#' @export
stemmer_nondeterministic <- R6::R6Class(
    classname    = "stemmer_nondeterministic",
    lock_objects = FALSE,
    parent_env   = asNamespace('kstemind'),

    #> TODO :

	public = list(
		dictionary_name = NULL,

		initialize = function(stem_dictionary = "kamus_sastrawi", closewords = "closewords_nondeterministik") {
			self$dictionary_name <- stem_dictionary
			private$stem_dictionary <- kstemind_load_data(stem_dictionary)
            private$closewords_dt <- kstemind_load_data(closewords)
            private$rules_nondet <- kstemind_load_data("aturan_nondeterministik")
		},
		stem_word = function(word) {
            if(private$is_plural(word)) {
                return(private$stem_plural(word))
            } else {
                return(private$stem_singular(word))
            }
		},
		stem = function(word) {
		  # 1. Try to load cached data, if already generated
		  key <- list(word)
		  data <- loadCache(key, suffix=".nondet.Rcache")
		  if (!is.null(data)) {
		    return(data);
		  }
		  # 2. If not available, generate it.
		  data <- self$stem_word(word)
		  saveCache(data, key=key, suffix=".nondet.Rcache")
		  return(data)
		}
	),
	private = list(
		stem_dictionary = NULL,
        closewords_dt = NULL,
        rules_nondet = NULL,

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
			} else { return(plural_word) }
		},
		stem_singular = function(word) {
			original_word <- word
			morphemes <- list(
				word = word,
				affix = list(
					particle_suffix = NULL,
					possessive_pronoun_suffix = NULL,
					derivational_suffix = NULL,
					derivational_prefix = c()
				)
			)

			# 1. check word against dictionary and word length
			if(private$stem_dictionary$has_key(word)){ return(word) }
			if(private$is_short_word(word)) {
				return(word)
			}

			# 2. check whether prefix is better (prefix first)
			# ###
			if(private$is_prefix_better(word)){
				temp_morphemes <- private$remove_derivational_prefix(morphemes)
				if(private$stem_dictionary$has_key(temp_morphemes$word)) {
					return(temp_morphemes$word)
				}
			}

			# 3. stem the suffix (inflectional and derivational)
			morphemes <- private$remove_inflectional_suffix(morphemes);
			if(private$stem_dictionary$has_key(morphemes$word)) {
				return(morphemes$word)
			}
			morphemes <- private$remove_derivational_suffix(morphemes);
			if(private$stem_dictionary$has_key(morphemes$word)) {
				return(morphemes$word)
			}

			# 4. stem the prefix if suffix first
			if(length(morphemes$affix$derivational_prefix) == 0) {
				morphemes <- private$remove_derivational_prefix(morphemes)
				if(private$stem_dictionary$has_key(morphemes$word)) {
					return(morphemes$word)
				}
			}

			# 5. if not found any matches return the original
			return(original_word)
		},

		# SLAVE ========================================================
		is_short_word = function(word) {
			return(str_length(word) <= 3)
		},
		is_prefix_better = function(word) {
			rules <- "\\bber(.*)lah\\b|\\bber(.*)an\\b|\\bme(.*)i\\b|\\bme(.*)kan\\b|\\bdi(.*)i\\b|\bpe(.*)i\\b|\\bter(.*)i\\b"
			return(str_detect(word, rules))
		},
		is_may_valid_affix = function(word) {
			rules <- "\\bbe(.*)i\\b|\\bdi(.*)an\\b|\\bke(.*)i\\b|\\bke(.*)kan\\b|\\bme(.*)an\\b|\\bse(.*)i\\b|\\bse(.*)kan\\b|\\bte(.*)an\\b"
			return(!str_detect(word, rules))	
		},
		remove_derivational_prefix = function(morphemes) {
			# do in maximum 3 times:
				# get substring in 4-letters, 3-letters, 2-letters
				# match substring to group table by length-of-substring order
				# if match:
					# filter tabel_affix.prefixes berdasarkan grup terpilih
					# tabrakin replace_with ke hasil filter tsb,
					# simpan semua hasilnya dalam arr temp
					# if use closewords:
						# cek masing arr termasuk dalam kata dasar ngga
						# kalo dapet cek ke closewordnya dlu
						# closeweod ktemu langsung break if
						# sampai ujung ngga ketemu fallback ke default (belum dibuat ditabel, asumsi ngga ada perubahan)
					# else:
						# cek masing arr termasuk dalam kata dasar ngga
						# kalo ada langung break if

			# initial <- morphemes$word
			prefix_group <- as.data.table(private$rules_nondet$group)
			prefix_group <- prefix_group[type == "prefix"]
			prefix_test <- as.data.table(private$rules_nondet$prefixes)

			for(counter in 1:3) {
				# prefix_candidate
				prefix_candidates <- c(
					str_sub(morphemes$word, 1, 4),
					str_sub(morphemes$word, 1, 3),
					str_sub(morphemes$word, 1, 2)
				)

				matches_in_group <- prefix_group[name %in% prefix_candidates]
				if(nrow(matches_in_group) > 0) {
					selected_group <- matches_in_group[1]
					morphemes$affix$derivational_prefix <- c(morphemes$affix$derivational_prefix, selected_group[1, name])

					tests <- prefix_test[rule == selected_group$name[1]]
					test_results <- str_replace_all(morphemes$word, tests$construct, tests$replace_with)

					unique_test_results <- unique(test_results)
					matches_in_dict <- unique_test_results[private$stem_dictionary$has_keys(unique_test_results)]
					# print(matches_in_dict)

					if(!is.na(tests$closewords[1])){
						# use closewords
						type_closeword <- tests$closewords[1]
						selected_closewords <- private$closewords_dt[type == type_closeword & root_word %in% matches_in_dict]

						if(selected_closewords[, .N] > 0) {
							morphemes$word <- selected_closewords$root_word[1]
							return(morphemes)
						}
						if(length(matches_in_dict) > 0) {
							morphemes$word <- matches_in_dict[1]
							return(morphemes)	
						}
						morphemes$word <- str_replace_all(morphemes$word, selected_group$def_construct, selected_group$def_replace_with)
					} else {
						# if matches in dictionary
						if(!identical(matches_in_dict, character(0))) {
							morphemes$word <- matches_in_dict[1]
							return(morphemes)
						}
						morphemes$word <- test_results[test_results != morphemes$word][1]
					}
				}
			}
			return(morphemes)
		},
		remove_inflectional_suffix = function(morphemes) {
			# regex replace suffix partikel dalam array "temp_words"
			# cek apakah isi temp_word besubah dengan !indentical()
			# if !indentical():
				# masukin nama affix ke morphemes$affix$particle_suffix
				# try:
					# regex replace suffix pp dalam array "temp_words"
					# cek apakah isi temp_word besubah dengan !indentical()
					# if !indentical():
						# masukin nama affix ke morphemes$affix$pp_suffix	
						# return hasil
			# regex replace suffix pp dalam array "temp_words"
			# cek apakah isi temp_word besubah dengan !indentical()
			# if !indentical():
				# masukin nama affix ke morphemes$affix$pp_suffix	
				# return hasil
			# return initial if no changes

			rules_suffixes <- as.data.table(private$rules_nondet$suffixes)
			rules_particle <- rules_suffixes[rule == "particle"]
			rules_possessive_pronoun <- rules_suffixes[rule == "possessiveprououn"]

			# (kah lah pun)
			temp_words <- str_replace_all(morphemes$word, rules_particle$construct, rules_particle$replace_with)
			if(!identical(which(temp_words != morphemes$word), integer(0))) {
				morphemes$affix$particle_suffix <- rules_particle$subrule[which(temp_words != morphemes$word)]
				morphemes$word <- temp_words[which(temp_words != morphemes$word)]
				# try (ku mu nya)
				temp_words <- str_replace_all(morphemes$word, rules_possessive_pronoun$construct, rules_possessive_pronoun$replace_with)
				if(!identical(which(temp_words != morphemes$word), integer(0))) {
					morphemes$affix$possessive_pronoun_suffix <- rules_possessive_pronoun$subrule[which(temp_words != morphemes$word)]
					morphemes$word <- temp_words[which(temp_words != morphemes$word)]
				}
				return(morphemes)
			}
			# try (ku mu nya)
			temp_words <- str_replace_all(morphemes$word, rules_possessive_pronoun$construct, rules_possessive_pronoun$replace_with)
			if(!identical(which(temp_words != morphemes$word), integer(0))) {
				morphemes$affix$possessive_pronoun_suffix <- rules_possessive_pronoun$subrule[which(temp_words != morphemes$word)]
				morphemes$word <- temp_words[which(temp_words != morphemes$word)]
				return(morphemes)
			}

			return(morphemes)
		},
		remove_derivational_suffix = function(morphemes) {
			# an kan i
			
			# check is_may_valid_affix()
			# if true:
				# buang suffix derivational (an ka i) masukin dalam temp_array
				# if ada perubahan:
					# masing2 lakukan remove_derivational_suffix
					# if ada yng cocok dengan kamus:
						# return morphemes kalo cocok dengan kamus
					# try untuk masing2 affix yang dapat dirubah:
						# terapkan remove_derivational_suffix()
			# return original_morphemes kalo ngga ada perubahan

			original_morphemes <- morphemes
			rules_suffixes <- as.data.table(private$rules_nondet$suffixes)
			rules_derivational <- rules_suffixes[rule == "derivational"]

			if(private$is_may_valid_affix(morphemes$word)) {
				temp_words <- str_replace_all(morphemes$word, rules_derivational$construct, rules_derivational$replace_with)
				if(!identical(which(temp_words != morphemes$word), integer(0))) {
					
					matches_in_dict_boolean <- private$stem_dictionary$has_keys(temp_words)
					if(any(matches_in_dict_boolean)) {
						morphemes$affix$derivational_suffix <- rules_derivational$subrule[matches_in_dict_boolean]
						morphemes$word <- temp_words[matches_in_dict_boolean][1]
						return(morphemes)
					}

					matches_in_affix <- temp_words[which(temp_words != morphemes$word)]
					for (i in 1:length(matches_in_affix)) {
						morphemes$affix$derivational_suffix <- rules_derivational$subrule[which(temp_words != morphemes$word)][i]
						morphemes$word <- matches_in_affix[i]
						morphemes <- private$remove_derivational_prefix(morphemes)
						if(private$stem_dictionary$has_keys(morphemes$word)){
							return(morphemes)
						}
					}
				}
			}

			# no found any perubahan
			return(original_morphemes)
		}
	)
)
