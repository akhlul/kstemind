#' Stemmer Tala Porter - implementation of Tala's Porter Stemmer
#'
#' @docType class
#' @name stemmer_tala_porter
#' @export
#' @keywords data
#' @return Object of \code{\link{R6Class}} with methods for stemming with Tala's Porter algorithm
#' @format An \code{\link{R6Class}} object.
#' @section Methods:
#' 
#' \describe{
#'    \item{\code{stem_word(word)}}{
#'      stemming a single word into its stem.
#'    }
#'
#'    \item{\code{affix_particle}}{}
#'    \item{\code{affix_possesive}}{}
#'    \item{\code{affix_first_order_prefix}}{}
#'    \item{\code{affix_second_order_prefix}}{}
#'    \item{\code{affix_suffix}}{}
#'    \item{\code{special_words}}{}
#' }
#'
#' @examples
#'
stemmer_tala_porter <- R6::R6Class(
    classname    = "stemmer_tala_porter",
    lock_objects = FALSE,
    parent_env   = asNamespace('kstemind'),

	# TODO :
	# [V]	can handle input word only
	# [V]	can change dynamicaly affixes
	# []	change affix table into data.frame object in .rds file

	public = list(
		affix_particle = c('kah', 'lah', 'pun'),
		affix_possesive = c('ku', 'mu', 'nya'),
		affix_first_order_prefix = setNames(
			data.frame(c('meng', 'meny', 'men', 'mem', 'me', 'peng', 'peny', 'pen', 'pem', 'di', 'ter', 'ke'),
		               c('',     's',    '',    '',    '',   '',     's',    't',   '',    '',   '',    '')),
			c('affix', 'replace_with')),
		affix_second_order_prefix = setNames(
			data.frame(c('ber', 'be', 'per', 'pe'),
			           c('',    '',   '',    '')),
			c('affix', 'replace_with')),
		affix_suffix = c('kan', 'an', 'i'),
		special_words = setNames(
			data.frame(c('belajar', 'pelajar', 'belunjur'),
			           c('ajar',    'ajar',    'unjur')),
			c('word', 'replace_with')),

		initialize = function(stem_dictionary = "kamus_sastrawi") {
			private$flags <- 0
			private$total_syllables <- 0
		},
		stem_word = function(word, stem_derivational = TRUE) {
			private$flags <- 0
			private$total_syllables <- private$count_syllables(word)
			if(private$total_syllables > 2) word <- private$remove_particles(word)
			if(private$total_syllables > 2) word <- private$remove_possessive_pronoun(word)
			if(stem_derivational) word <- private$stem_derivational(word)
			return(word)
		},
		stem = function(word) {
		  # 1. Try to load cached data, if already generated
		  key <- list(word)
		  data <- loadCache(key, suffix=".talaporter.Rcache")
		  if (!is.null(data)) {
		    return(data);
		  }
		  # 2. If not available, generate it.
		  data <- self$stem_word(word)
		  saveCache(data, key=key, suffix=".talaporter.Rcache")
		  return(data)
		}
	),
	private = list(
		total_syllables = 0,
		stem_derivational = function(word) {
			old_length <- str_length(word)
			if(private$total_syllables > 2) word <- private$remove_first_order_prefix(word)
			if(old_length == str_length(word)) {
				if(private$total_syllables > 2) word <- private$remove_second_order_prefix(word)
				if(private$total_syllables > 2) word <- private$remove_suffix(word)
			} else {
				old_length <- str_length(word)
				if(private$total_syllables > 2) word <- private$remove_suffix(word)
				if(old_length != str_length(word)){
					if(private$total_syllables > 2) word <- private$remove_second_order_prefix(word)
				}
			}
			return(word)
		},
		count_syllables = function(word) {
			# return numbers of matched vowels using stringr
			return(str_count(word, "([aiueo])"))
		},
		remove_particles = function(word) {
			word <- private$remove_suffix_extended(word, self$affix_particle)
			private$total_syllables <- private$count_syllables(word)
			return(word)
		},
		remove_possessive_pronoun = function(word) {
			word <- private$remove_suffix_extended(word, self$affix_possesive)
			private$total_syllables <- private$count_syllables(word)
			return(word)
		},
		remove_first_order_prefix = function(word) {
			# utilize immediate function for specific affix data.frame
			this_affix <- self$affix_first_order_prefix
			pattern <- str_c("\\b", this_affix$affix, collapse = "|")
			  this_may_replace_with <- function(a) private$may_replace_with(a, this_affix)
			  word <- str_replace_all(word, pattern, this_may_replace_with)

			private$total_syllables <- private$count_syllables(word)
			return(word)
		},
		remove_second_order_prefix = function(word) {
			# check special_words
			this_sw <- self$special_words
			pattern <- str_c("\\b", this_sw$word, collapse = "|")
			  this_sw_replace_with <- function(a) private$may_replace_with(a, this_sw, by_word = TRUE)
			  word <- str_replace_all(word, pattern, this_sw_replace_with)

			# check by prefix
			this_affix <- self$affix_second_order_prefix
			pattern <- str_c("\\b", this_affix$affix, collapse = "|")
			  this_may_replace_with <- function(a) private$may_replace_with(a, this_affix)
			  word <- str_replace_all(word, pattern, this_may_replace_with)

			private$total_syllables <- private$count_syllables(word)
			return(word)
		},
		remove_suffix = function(word) {
			word <- private$remove_suffix_extended(word, self$affix_suffix)
			private$total_syllables <- private$count_syllables(word)
			return(word)
		},
		may_replace_with = function(keyword, table_, by_word = FALSE) {
			if(by_word) {
			  temp <- table_[table_$word == keyword,]$replace_with
			  if(str_length(temp) > 0) {
				  return(temp)
			  } else return("")
			} else {
			  temp <- table_[table_$affix == keyword,]$replace_with
			  if(str_length(temp) > 0) {
			    return(temp)
			  } else return("")
			}
		},
		remove_prefix_extended = function(word, pattern) {
			affix_pattern <- str_c("\\b(", str_c(pattern, collapse = "|"), ")")
			word <- str_replace(word, affix_pattern, "")
			return(word)
		},
		remove_suffix_extended = function(word, pattern) {
			affix_pattern <- str_c("(", str_c(pattern, collapse = "|"), ")\\b")
			word <- str_replace(word, affix_pattern, "")
			return(word)
		}
	)
)
