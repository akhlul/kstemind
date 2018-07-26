#' Stemmer Incremental - implementation of Hidayat's Incremental Stemmer
#'
#' @docType class
#' @name stemmer_incremental
#' @export
stemmer_incremental <- R6::R6Class(
    classname    = "stemmer_incremental",
    lock_objects = FALSE,
    parent_env   = asNamespace('kstemind'),

    #> TODO :
	#> []	has criteria (first, shortest, longest)

	public = list(
		dictionary_name = NULL,
        criteria = NULL,

		initialize = function(stem_dictionary = "kamus_sastrawi", criteria = "first") {
			self$dictionary_name <- stem_dictionary
            self$criteria <- criteria
			private$stem_dictionary <- kstemind_load_data(stem_dictionary)
            private$tables_levels <- kstemind_load_data("tabel_level_incremental")
		},
		stem_word = function(word) {
            return(private$stem_internal(word))
		},
        stem = function(word) {
          # 1. Try to load cached data, if already generated
          key <- list(word)
          data <- loadCache(key, suffix=".incremental.Rcache")
          if (!is.null(data)) {
            return(data);
          }
          # 2. If not available, generate it.
          data <- self$stem_word(word)
          saveCache(data, key=key, suffix=".incremental.Rcache")
          return(data)
        }
	),
	private = list(
		stem_dictionary = NULL,
        tables_levels = NULL,

		# BIG BOSS ========================================================
		stem_internal = function(word, criteria) {
            # 0. initialize array to save candidate stem words also save the original word
            original_word <- word
            current_words <- c(word)

            # 1. check whether word is short word or has included in stem dictionary
            if(private$stem_dictionary$has_key(original_word)){ return(original_word) }
			if(private$is_short_word(original_word)) {
				return(original_word)
			}

            # 2. do incremental stemmer in five levels
            for (lvl in 1:5) {
                current_words <- private$stem_prefix_by_level(current_words, lvl)
                # print(current_words)
                current_words <- private$stem_suffix_by_level(current_words, lvl)
                # print(current_words)
            }
            # print(current_words)

            # 3. cleaning the candidate stem words
            #    => erase_duplication -> ascending sort -> check dictionary
            current_words <- unique(sort(current_words))
            current_words <- current_words[private$stem_dictionary$has_keys(current_words)]

            # 4. return to original words if has no candidate stem words
            if(length(current_words) == 0){ current_words <- original_word }

            # 4. select candidates by a criteria (shortest, first, longest)
            switch(self$criteria,
                "shortest" = {
                    return(current_words[1])
                },
                "longest" = {
                    return(current_words[1])
                },
                {
                    return(current_words[1])
                }
            )

		},

		# SLAVE ========================================================
		is_short_word = function(word) {
			return(str_length(word) <= 3)
		},
        stem_prefix_by_level = function(words, lvl) {
            table_prefixes <- private$tables_levels$prefixes
            prefixes_lvl <- table_prefixes[table_prefixes$level == lvl, ]
            new_words <- words
            # message("lvl => ", lvl, " (prefix)")
            for(r in 1:nrow(prefixes_lvl)) {
                for(w in 1:length(words)){
                    temp_word <- private$replace_by_index(prefixes_lvl, r, words[w])
				    if(!private$is_short_word(temp_word) & !(temp_word %in% new_words)) {
                        # message('    >>> [',prefixes_lvl$rule[r],'][',prefixes_lvl$subrule[r],'] -> ',temp_word)
                        new_words <- c(new_words, temp_word)
                    }
                }
			}
            return(new_words)
        },
        stem_suffix_by_level = function(words, lvl) {
            table_suffixes <- private$tables_levels$suffixes
            suffixes_lvl <- table_suffixes[table_suffixes$level == lvl, ]
            new_words <- words
            # message("lvl => ", lvl, " (suffix)")
            for(r in 1:nrow(suffixes_lvl)) {
                for(w in 1:length(words)){
                    temp_word <- private$replace_by_index(suffixes_lvl, r, words[w])
				    if(!private$is_short_word(temp_word) & !(temp_word %in% new_words)) {
                        # message('    >>> [',suffixes_lvl$rule[r],'][',suffixes_lvl$subrule[r],'] -> ',temp_word)
                        new_words <- c(new_words, temp_word)
                    }
                }
			}
            return(new_words)
        },
        replace_by_index = function(table, index, word) {
			construct <- table$construct[index]
			replace_with <- table$replace_with[index]
			rule <- table$rule[index]
			# subrule <- table$subrule[index]
			# message(
			# 	rule, '(', subrule, ') : ', str_replace_all(word, construct, replace_with)
			# 	)
			return(str_replace_all(word, construct, replace_with))
		}
	)
)