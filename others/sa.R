library(profvis)
library(kstemind)
library(data.table)
cdt <- readRDS("ind_news_2012_10K_sentences.tokenized.rds")
kamus <- kstemind_load_data("kamus_sastrawi")

scdt <- cdt
cdt_table_in_list <- lapply(scdt, as.data.table)
cdt_table <- rbindlist(cdt_table_in_list)
cdt_unique <- unique(cdt_table)
# write_excel_csv(cdt_unique, "cdt_unique.csv")

cdtu.dt <- data.table(word = cdt_unique, root = character(22772))
cdtu.dt

stopwords <- as.data.table(read.table("data-raw/stopwords.txt", quote="\"", comment.char=""))
stopwords
ns.cdtu.dt <- cdtu.dt[!cdtu.dt$word.V1 %in% stopwords$V1]

len <- ns.cdtu.dt[, .N]
for(i in 1:len) {
  if(kamus$has_key(ns.cdtu.dt[i,word.V1]))
    set(ns.cdtu.dt, i, 2L, ns.cdtu.dt[i,word.V1])
}

library(stringr)
wns.cdtu.dt <- ns.cdtu.dt[!str_detect(ns.cdtu.dt$word.V1, "[0-9]")]
wns.cdtu.dt

isample.ns.cdtu.dt <- sample(1:wns.cdtu.dt[,.N], 1000)
sample.ns.cdtu.dt <- wns.cdtu.dt[isample.ns.cdtu.dt, ]
sample.ns.cdtu.dt

library(xlsx)
write.xlsx(sample.ns.cdtu.dt, "sample.ns.cdtu.dt.xlsx")


# ############### How to compare output
library(stringdist)
library(kstemind)
library(stringr)
library(readr)

input_text_uji <- read_csv("others/input-text-uji.txt", col_names = FALSE)
output_lucene_porter_tala <- read_csv("others/output-lucene-porter-tala.txt", col_names = FALSE)
output_nondeterministik_inanlp <- read_csv("others/output-nondeterministik-inanlp.txt", col_names = FALSE)
output_nazief_php <- read_csv("others/output-nazief-php.txt", col_names = FALSE)
output_sastrawi_py <- read_csv("others/output-sastrawi-py.txt", col_names = FALSE)


calculate_ssm <- function(output_stem_a, output_stem_b, original_words = input_text_uji$X1) {
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

stp <- stemmer_tala_porter$new()
snd <- stemmer_nondeterministic$new()
sna <- stemmer_nazief_andriani$new()
ssa <- stemmer_sastrawi$new()
output_kstemind_tala_porter <- sapply(input_text_uji$X1, stp$stem, USE.NAMES = F)
output_kstemind_nondeterministic <- sapply(input_text_uji$X1, snd$stem, USE.NAMES = F)
output_kstemind_nazief_andriani <- sapply(input_text_uji$X1, sna$stem, USE.NAMES = F)
output_kstemind_sastrawi <- sapply(input_text_uji$X1, ssa$stem, USE.NAMES = F)

ssm <- list(
  tala_porter = calculate_ssm(output_kstemind_tala_porter, output_lucene_porter_tala$X1),
  nondeterministic = calculate_ssm(output_kstemind_nondeterministic, output_nondeterministik_inanlp$X1),
  nazief_andriani = calculate_ssm(output_kstemind_nazief_andriani, output_nazief_php$X1),
  sastrawi = calculate_ssm(output_kstemind_sastrawi, output_sastrawi_py$X1)
)
ssm
















