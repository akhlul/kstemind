library(hashmap)

#> Kamus Sastrawi - stem dictionary used in Sastrawi's stemmer
kamus_sastrawi_raw <- read.table("data-raw/kamus_sastrawi.txt", quote="\"", comment.char="")
kamus_sastrawi <- hashmap(as.vector(kamus_sastrawi_raw[,1]), rep.int(1, length(kamus_sastrawi_raw[,1])))
devtools::use_data(kamus_sastrawi_raw, overwrite = TRUE)
save_hashmap(kamus_sastrawi, "inst/extdata/kamus/sastrawi.hashmap")

#> Kamus Nazief Andriani - stem dictionary used in Nazief and Andriani's stemmer
kamus_nazief_andriani_raw <- read.table("data-raw/kamus_nazief_andriani.txt", quote="\"", comment.char="")
kamus_nazief_andriani <- hashmap(as.vector(kamus_nazief_andriani_raw[,1]), rep.int(1, length(kamus_nazief_andriani_raw[,1])))
devtools::use_data(kamus_nazief_andriani_raw, overwrite = TRUE)
save_hashmap(kamus_nazief_andriani, "inst/extdata/kamus/nazief_andriani.hashmap")

#> Kamus Hidayat - stem dictionary used in Incremental stemmer
kamus_hidayat_raw <- read.table("data-raw/kamus_hidayat.txt", quote="\"", comment.char="")
kamus_hidayat <- hashmap(as.vector(kamus_hidayat_raw[,1]), rep.int(1, length(kamus_hidayat_raw[,1])))
devtools::use_data(kamus_hidayat_raw, overwrite = TRUE)
save_hashmap(kamus_hidayat, "inst/extdata/kamus/hidayat.hashmap")


#> Benchmarking which data type will be used!
#>   *documentation only
#
# library(hashmap)
# library(microbenchmark)
# library(ggplot2)
# library(data.table)
#
# kamus <- read.table("D:/Rumah/skripsilah-sebelum-diskripsikan/_algoritma/kStemInd/data-raw/kamus_sastrawi.txt", quote="\"", comment.char="")
# kamus_hash <- hashmap(as.vector(kamus[,1]), rep.int(1, length(kamus[,1])))
# kamus_df <- data.frame(kamus = as.vector(kamus[,1]), dummy = rep.int(1, length(kamus[,1])))
# kamus_dt <- data.table(
#   kamus = as.vector(kamus[,1]),
#   dummy = rep.int(1, length(kamus[,1])),
#   key = "kamus"
# )
# find_this <- sample(as.vector(kamus[,1]), 1)
# (result <- microbenchmark(
#   look.hash = kamus_hash$has_key(find_this),
#   look.df = dim(kamus_df[kamus_df$kamus == find_this,])[1] >0,
#   look.dt = length(kamus_dt[.(find_this), nomatch= 0L]) > 0,
#   times = 50
# ))
# autoplot(result)
