#' Global Vars
stemmer <- list(
	stemmer_nazief_andriani$new(),
	stemmer_cs$new(),
	stemmer_ecs$new(),
	stemmer_incremental$new(),
	stemmer_nondeterministic$new(),
	stemmer_tala_porter$new(),
	stemmer_mecs$new(),
	stemmer_sastrawi$new()
)

#' Echo the parameter that was sent in
#' @param msg The message to echo back.
#' @get /nazief
function(msg=""){
  list(output = paste0(
    sapply(tokenize_indonesian(msg), stemmer[[1]]$stem, USE.NAMES = F),
    collapse = " ")
  )
}
