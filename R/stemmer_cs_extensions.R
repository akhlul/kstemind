#' Visitors CS - Internal Function for Prefixes Removal in Confix Stripping Stemmer
#'
#' @docType class
#' @name visitors_cs
#'
visitors_cs <- R6::R6Class(
    classname    = "visitors_cs",
    lock_objects = FALSE,
    parent_env   = asNamespace('kstemind'),

	#> TODO :
	#> []	nothing

	public = list(
		initialize = function(stem_dictionary = "kamus_sastrawi", tables_visitors = "tabel_visitors_cs") {
			private$stem_dictionary <- kstemind_load_data(stem_dictionary)
			private$tables_visitors <- kstemind_load_data(tables_visitors)
		},
		visit_prefixes = function(word) {
			table_plain_prefixes <- private$tables_visitors$plain_prefixes
			for(r in 1:dim(table_plain_prefixes)[1]) {
				word <- private$replace_by_index(table_plain_prefixes, r, word)
				if(private$stem_dictionary$has_key(word)){ return(word)	}
			}

			table_complex_prefixes <- private$tables_visitors$complex_prefixes
			prefixes_rules <- length(unique(table_complex_prefixes$rule))
			word_per_rule <- NULL

			for(r in 1:prefixes_rules) {
				prefixes_subrules <- table_complex_prefixes[table_complex_prefixes$rule == r, ]
				word_per_rule <- word
				for(sr in 1:nrow(prefixes_subrules)) {
					word <- private$replace_by_index(prefixes_subrules, sr, word_per_rule)
					if(private$stem_dictionary$has_key(word)){ return(word)	}
				}
			}

			return(word)
		},
		visit_suffixes = function(word) {
			table_suffixes <- private$tables_visitors$suffixes
			for(r in 1:dim(table_suffixes)[1]) {
				word <- private$replace_by_index(table_suffixes, r, word)
				if(private$stem_dictionary$has_key(word)){ return(word)	}
			}

			return(word)
		}
	),
	private = list(
		stem_dictionary = NULL,
		tables_visitors = NULL,

		replace_by_index = function(table, index, word) {
			construct <- table$construct[index]
			replace_with <- table$replace_with[index]
			# Debug Only
			# rule <- table$rule[index]
			# subrule <- table$subrule[index]
			# message(
			# 	rule, '(', subrule, ') : ', str_replace_all(word, construct, replace_with)
			# 	)
			return(str_replace_all(word, construct, replace_with))
		}
	)
)
