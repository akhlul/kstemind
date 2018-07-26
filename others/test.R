library(testthat)



stemmer <- stemmer_sastrawi$new(stem_dictionary = "kamus_sastrawi")

kamusku <- kstemind_load_data("kamus_sastrawi")
vi <- kstemind_load_data('tabel_visitors_ecs')
taku <- kstemind_load_data("tabel_level_incremental")


# str_replace_all('mempopulerkan', '^memp([aiuo].*)', 'p\\1')
# str_detect('mempopulerkan', '^nemp([aiuo].*)')



library(kstemind)

# membangun objek stemmer
stemmer <- stemmer_nazief_andriani$new()

# melakukan stemming pada sebuah kata
stemmer$stem("pertikaian")

# melakukan stemming pada sebuah teks
teks = "Dalam pasal 4 Undang-undang Nomor 53 Tahun 2010 tentang Disiplin PNS, disebutkan bahwa PNS dilarang menggunakan jabatannya untuk memperkaya diri sendiri ataupun golongan."
cat(sapply(tokenize_indonesian(teks), stemmer$stem, USE.NAMES = F))

# melakukan stemming pada teks yang telah dibuang stopwords
