library(readxl)
library(kstemind)
library(microbenchmark)
library(pbapply)
library(stringdist)
library(readr)

##### Dataset in use (Data)
# sumber : http://wortschatz.uni-leipzig.de/en/download
# link didownload : http://pcai056.informatik.uni-leipzig.de/downloads/corpora/ind_news_2012_10K.tar.gz
dataset_accuration <- read_excel("inputmanual_sample.ns.cdtu.dt.xlsx", sheet = "hasil")
ind_news_2012_10K_sentences <- read_csv("New folder/ind_news_2012_10K-sentences.csv")
dataset <- ind_news_2012_10K_sentences
##### chunk & tokenize sumber data
n <- 10
nr <- nrow(dataset)
chunk_dataset <- split(dataset, rep(1:ceiling(nr/n), each=n, length.out=nr))
cdd <- lapply(chunk_dataset, function(text){paste0(text$sentences, collapse = " ") })
cdt <- lapply(cdd, tokenize_indonesian)
# saveRDS(cdt, "ind_news_2012_10K_sentences.tokenized.rds")

##### summary c&t sumber data
length(cdt)
mean(unlist(lapply(cdt, length)))
sum(unlist(lapply(cdt, length)))
# jumlah chunk : 1000
# rata-rata jumlah kata dalam satu chunk : 196.112
# jumlah kata pada sumber data ini : 196112







##### Empirical Evaluation (EE)
test_EE <- function(STEM_OBJ, dataset = dataset_accuration) {
  stemmer <- STEM_OBJ
  message("   stemming in progress")
  hasil_stemmer <- pbsapply(dataset$word, stemmer$stem_word, USE.NAMES = FALSE)
  ee_ <- length(hasil_stemmer[dataset$manual_stem == hasil_stemmer]) / length(hasil_stemmer)
  cat("  nilai EE : ", ee_, "\n")
  invisible(list(
    ee = ee_
    # stem_word = hasil_stemmer
    )
  )
}

length(dataset_accuration$word)
EE <- c(
  test_EE(stemmer_nazief_andriani$new())$ee,
  test_EE(stemmer_cs$new())$ee,
  test_EE(stemmer_ecs$new())$ee,
  test_EE(stemmer_incremental$new())$ee,
  test_EE(stemmer_nondeterministic$new())$ee,
  test_EE(stemmer_tala_porter$new())$ee,
  test_EE(stemmer_mecs$new())$ee,
  test_EE(stemmer_sastrawi$new())$ee
)
EE_output <- data.frame(stemmer = levels(mb$expr), EE = EE)
EE_output







##### Runtime Benchmark
run_stem_words <- function(STEM_OBJ, tokenized_dataset = cdt) {
  stemmer <- STEM_OBJ
  message("   stemming in progress")
  stem_list_ <- pblapply(tokenized_dataset, function(x) {
    sapply(x, stemmer$stem, USE.NAMES = FALSE)
  })
  invisible(stem_list_)
}
(mb <- microbenchmark(
  nazief = run_stem_words(stemmer_nazief_andriani$new()),
  cs = run_stem_words(stemmer_cs$new()),
  ecs = run_stem_words(stemmer_ecs$new()),
  incremental = run_stem_words(stemmer_incremental$new()),
  nondeterministik = run_stem_words(stemmer_nondeterministic$new()),
  tala = run_stem_words(stemmer_tala_porter$new()),
  mecs = run_stem_words(stemmer_mecs$new()),
  sastrawi = run_stem_words(stemmer_sastrawi$new()),
  times = 10L
))
RT_output <- mb





##### Test stemmer strength (MCW, ICF, WCF, Average CR)
test_strength <- function(STEM_OBJ, tokenized_dataset) {
  # N : jumlah unique words before stemmer
  # S : jumlah unique words after stemmer

  stemmer <- STEM_OBJ
  message("   stemming in progress")
  stem_list_ <- pblapply(tokenized_dataset, function(x) {
    sapply(x, stemmer$stem, USE.NAMES = FALSE)
  })

  arr_after_stem <- unlist(stem_list_, use.names = FALSE)
  arr_before_stem <- unlist(tokenized_dataset, use.names = FALSE)
  arr_no_changes_stem <- arr_before_stem[arr_before_stem==arr_after_stem]
  dist_df <- data.table(
    before = arr_before_stem,
    after = arr_after_stem,
    distance = NA
  )
  u_dist_df <- unique(dist_df)
  set(u_dist_df, i=NULL, 3L, stringdist(u_dist_df[,before], u_dist_df[,after]))

  S <- length(unique(arr_after_stem))
  N <- length(unique(arr_before_stem))
  C <- length(unique(arr_no_changes_stem))

  message("testing a stemmer")
  mwc_ <- N/S
  icf_ <- (N-S)/N
  wcf_ <- (N-C)/N
  arc_ <- u_dist_df[, mean(distance)]

  cat("  nilai MWC : ", mwc_, "\n")
  cat("  nilai ICF : ", icf_, "\n")
  cat("  nilai WCF : ", wcf_, "\n")
  cat("  nilai ARC : ", arc_, "\n\n")
  invisible(list(
    mwc = mwc_,
    icf = icf_,
    wcf = wcf_,
    arc = arc_
    # arr_after = arr_after_stem,
    # arr_before = arr_before_stem
  ))
}

STRENGTH <- list(
  test_strength(stemmer_nazief_andriani$new(), cdt[100:120]),
  test_strength(stemmer_cs$new(), cdt[100:120]),
  test_strength(stemmer_ecs$new(), cdt[100:120]),
  test_strength(stemmer_incremental$new(), cdt[100:120]),
  test_strength(stemmer_nondeterministic$new(), cdt[100:120]),
  test_strength(stemmer_tala_porter$new(), cdt[100:120]),
  test_strength(stemmer_mecs$new(), cdt[100:120]),
  test_strength(stemmer_sastrawi$new(), cdt[100:120])
)
STRENGTH_output <- cbind(data.frame(stemmer = levels(mb$expr)), rbindlist(STRENGTH))

#### Show Output Eval (Strength only 20 data)
EE_output
RT_output
STRENGTH_output

H <- readRDS("output_evaluation.rds")
H$output$EE
H$output$RT
H$output$STRENGTH

# saveRDS(
#   list(
#     EE = EE,
#     RT = RT_output,
#     STRENGTH = STRENGTH,
#     output = list(
#       EE = EE_output,
#       RT = RT_output,
#       STRENGTH = STRENGTH_output
#     )),
#   "output_evaluation.rds"
# )
