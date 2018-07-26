#' Visitors ECS - Internal Function for Prefixes Removal in Enhanced CS Stemmer
#'
#' @docType class
#' @name visitors_ecs
#'
visitors_ecs <- R6::R6Class(
    classname    = "visitors_ecs",
    lock_objects = FALSE,
    parent_env   = asNamespace('kstemind'),

	#> TODO :
	#> []	return list(word:char(), removals_step:df)
	#>             word:char()

	public = list(
		initialize = function(stem_dictionary = "kamus_sastrawi", tables_visitors = "tabel_visitors_ecs") {
			private$stem_dictionary <- kstemind_load_data(stem_dictionary)
			private$tables_visitors <- kstemind_load_data(tables_visitors)
		},
		create_empty_removal_steps = function() {
			return(data.frame(
				type=character(),
				rule=character(),
				word_before=character(),
				word_after=character(),
				affix=character(),
				stringsAsFactors=FALSE))
		},
		visit_prefixes = function(word, removal_steps = NULL) {
			table_plain_prefixes <- private$tables_visitors$plain_prefixes
			for(r in 1:nrow(table_plain_prefixes)) {
				word_before <- word
				word <- private$replace_by_index(table_plain_prefixes, r, word)
				if(word == ""){ return(list(word = word_before, removal_steps = removal_steps)) }
				if(!is.null(removal_steps) && (word_before != word)) {
					removal_steps[nrow(removal_steps) + 1, ] <- c(
						"P",
						table_plain_prefixes$rule[r],
						word_before,
						word,
						str_replace_all(word_before, word, ""))
				}
				if(private$stem_dictionary$has_key(word)){ return(list(word = word, removal_steps = removal_steps))	}
			}

			table_complex_prefixes <- private$tables_visitors$complex_prefixes
			prefixes_rules <- length(unique(table_complex_prefixes$rule))
			word_per_rule <- NULL

			# loop per rules
			for(r in 1:prefixes_rules) {
				prefixes_subrules <- table_complex_prefixes[table_complex_prefixes$rule == r, ]
				word_per_rule <- word
				
				rule <- NULL
				word_before <- word
				word_after <- NULL
				affix <- NULL

				# loop per subrules
				for(sr in 1:nrow(prefixes_subrules)) {
					word <- private$replace_by_index(prefixes_subrules, sr, word_per_rule)
					if(word == ""){ return(list(word = word_before, removal_steps = removal_steps)) }

					# changes per subrule
					rule <- table_complex_prefixes$rule[r]
					word_after <- word
					affix <- str_replace_all(word_before, word, "")

					if(private$stem_dictionary$has_key(word)){ 
						return(list(word = word, removal_steps = removal_steps))	
					}
				}
				
				# added for function: 'loop_pengembalian_akhiran'
				if(!is.null(removal_steps) && (word_before != word)) {
					removal_steps[nrow(removal_steps) + 1, ] <- c(
						"P", rule, word_before, word_after, affix)
				}
			}

			return(list(word = word, removal_steps = removal_steps))
		},
		visit_suffixes = function(word, removal_steps = NULL) {
			table_suffixes <- private$tables_visitors$suffixes
			for(r in 1:nrow(table_suffixes)) {
				word_before <- word
				word <- private$replace_by_index(table_suffixes, r, word)
				if(word == ""){ return(list(word = word_before, removal_steps = removal_steps)) }
				if(word_before != word) {
					removal_steps[nrow(removal_steps) + 1, ] <- c(
						"S",
						table_suffixes$rule[r],
						word_before,
						word,
						str_replace_all(word_before, word, ""))
				}
				if(private$stem_dictionary$has_key(word)){ return(list(word = word, removal_steps = removal_steps))	}
			}

			return(list(word = word, removal_steps = removal_steps))
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
			# 	rule, '(', subrule, ')[', construct,'] : ', str_replace_all(word, construct, replace_with)
			# 	)
			return(str_replace_all(word, construct, replace_with))
		}
	)
)
