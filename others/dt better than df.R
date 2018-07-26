start <- proc.time()
suf.dt[rule == "particle"]
aggregate_time <- proc.time() - start
aggregate_time

start <- proc.time()
suf.df[suf.df$rule == "particle",]
aggregate_time <- proc.time() - start
aggregate_time

source('D:/skripsi2/kStemInd/R/stemmer_nondeterministic.R')
knd <- stemmer_nondeterministic$new()
knd$stem_word("habiskan")
knd$stem_word("habisi")
knd$stem_word("penyelesaian")

knd$stem_word("ayamnyalah")
knd$stem_word("dimakan")
knd$stem_word("memanjat")

anondet <- kstemind::kstemind_load_data("aturan_nondeterministik")
rules_suffixes <- as.data.table(anondet$suffixes)
rules_particle <- rules_suffixes[rule == "particle"]
rules_possesive_prououn <- rules_suffixes[rule == "possesiveprououn"]

temp_words <- str_replace_all("makankupun", rules_particle$construct, rules_particle$replace_with)
which(temp_words == "makankupunl")
rules_particle$subrule[which(temp_words != "makankupunl")]
##############

temp_words <- str_replace_all("persiapkan", rules_derivational$construct, rules_derivational$replace_with)
temp_words[which(temp_words != "persiapkan")]
rules_derivational$subrule[which(temp_words != "persiapkan")][2]

##############
cl <- kstemind_load_data("closewords_nondeterministik")
cl[type == "p" & root_word %in% c("perang")]

km <- kstemind_load_data("kamus_sastrawi")
km$has_key("panjat")
