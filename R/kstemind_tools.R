#' Tokenizer for Indonesian text
#'
#' @param text string
#' @param do_clean boolean
#'
#' @return array of tokenized string
#' @import stringr textclean htm2txt
#' @export
tokenize_indonesian <- function(text, do_clean = FALSE) {
	if(do_clean) {
		text <- replace_non_ascii(text, remove.nonconverted = FALSE)
		text <- htm2txt(text)
		text <- replace_white(text)
		text <- strip(text, char.keep = "-", digit.remove = TRUE)
	}
  text <- str_to_lower(text)
	text <- str_replace_all(text, "[^A-Za-z0-9 -]", " ")
	text <- str_replace_all(text, "\\W[-]+\\W", " ")
	text <- str_split(text, "\\s+")[[1]]
	text <- text[text != ""]
	return(text)
}

#' Chunking Tokens of Word
#'
#' @param text long string
#' @param chunk_size (default = 100)
#' @param text_id (default = "teks")
#'
#' @return list of chunked tokenized text
#' @import stringr textclean htm2txt
#' @export
chunk_text <- function(text, by_size = F, chunk_size = 100) {
  if(by_size){
    tokenized_text <- tokenize_indonesian(text)
    chunks <- split(tokenized_text, ceiling(seq_along(tokenized_text)/chunk_size))
    num_chars <- str_length(length(chunks))
    chunk_ids <- str_pad(seq(length(chunks)), num_chars, side = "left", pad = "0")
    names(chunks) <- str_c("id_", chunk_ids, sep = "_")
    return(chunks)
  } else {
    chunks <- unlist(str_split(text, "[\\.!?]+"))
    chunks <- str_trim(chunks, "both")
    chunks <- chunks[nchar(chunks) > 0]
    return(chunks)
  }
}


#' Stopwords Removal
#'
#' @param tokenized_text an array of tokens
#'
#' @return filtered array of tokens
#' @export
#'
#' @examples
stopwords_removal <- function(tokenized_text) {
  stopwords <- readRDS("R/visitors/stopwords.rds")
  return(tokenized_text[!tokenized_text %in% stopwords$V1])
}


#' Calculate Stemmer Similarity Metrics (SSM)
#'
#' @param output_stem_a an array of output stemmer A
#' @param output_stem_b an array of output stemmer B
#' @param original_words an array of original word tested in those two stemmer
#'
#' @return list value of SSM in range between 0-100 and df difference from both stemmer
#' @import stringdist
#' @export
#'
#' @examples
calculate_ssm <- function(output_stem_a, output_stem_b, original_words) {
  len_ <- sapply(original_words, str_length, USE.NAMES = F)
  dist_ <- stringdist(output_stem_a, output_stem_b)
  rel_mhd_ <- sapply(1:1000, function(x){
    return(dist_[x]/len_[x])
  }, USE.NAMES = F)
  ssm_ <- abs(100*((sum(rel_mhd_)/1000)-1))
  message("ssm : ", ssm_)
  df_ <- cbind(original_words, output_stem_a, output_stem_b)
  diff_ <- df_[which(df_[,2] != df_[,3]),]
  invisible(list(ssm=ssm_, diff=diff_))
}
