# KStemInd

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> **kstemind** adalah library R berisi kompilasi algoritma stemmer bahasa Indonesia yang siap pakai

Salah satu tahapan penting dari *text preprocessing* adalah stemming. Stemming merupakan teknik memotong imbuhan kata sehingga mendapatkan kata dasarnya. Perkembangan stemming di Indonesia cukup besar yang dimulai pada tahun 1995, yakni dengan adanya algoritma Nazief-Andriani. Sampai saat ini, kurang lebih terdapat 15 algoritma stemming yang dikembangkan namun hanya empat yang siap pakai. Dalam dekade terakhir juga, perbandingan algoritma stemming masih belum dilakukan secara empiris. Library ini dibangun untuk menjawab tantangan tersebut

Library ini berisi :

1. 8 algoritma **Stemmer bahasa Indonesia**  yakni:  
1. Fungsi pendukung *text preprocessing*
    1. Tokenization: `tokenize_indonesian`
    1. Chunking: `chunk_tokenized_text`
    1. Stopword Removal: `stopword_removal`

## Daftar Isi

- [Install](#installasi)
- [Usage](#penggunaan)
- [Penjelasan API](#dokumentasi)
- [Maintainers](#maintainers)
- [License](#license)

## Installasi

Clone repository ini atau download source code dan ekstrak folder didalamnya. Adapun installasinya dilakukan pada konsol R dengan perintah:

```R
> # install.packages("devtools")
> library(devtools)
> install_deps('/path/to/folder/kstemind', dependencies="logical")
> install('/path/to/folder/kstemind')
>
> library(kstemind)
```

## Penggunaan

Jalankan perintah dibawah ini untuk melakukan stemming untuk sebuah kata menggunakan algoritma Nazief-Andriani.

```r
library(kstemind)

# membangun objek stemmer
stemmer <- stemmer_nazief_andriani$new()

# melakukan stemming pada sebuah kata
stemmer$stem("pertikaian")
#> [1] "tikai"

# melakukan stemming pada sebuah teks
teks = "Dalam pasal 4 Undang-undang Nomor 53 Tahun 2010 tentang Disiplin PNS, disebutkan bahwa PNS dilarang menggunakan jabatannya untuk memperkaya diri sendiri ataupun golongan."
cat(sapply(tokenize_indonesian(teks), stemmer$stem, USE.NAMES = F))
#> dalam pasal 4 undang-undang nomor 53 tahun 2010 tentang disiplin pns sebut bahwa pns larang guna jabat untuk kaya diri sendiri atau golong
```

## Dokumentasi

### Stemmer

secara umum, objek stemmer disamakan teknis pembangun yakni:

```r
#' algorithm name   : nama algoritma yang digunakan (cs, sastrawi, tala_porter, dll.)
#' stem_dictionary  : parameter yang digunakan dalam string, pilihannya adalah 
#'                    ("kamus sastrawi" (default), "kamus nazief andriani", "kamus hidayat")
#' ...              : parameter tambahan khusus lainnya yang digunakan untuk stemmer tersebut
stemmer_algoritm_name$new(stem_dictionary, ...)
```

dan dalam penggunaannya ada dua perintah yang diterapkan pada keseluruhan objek yakni:

```r
#' membangun objek stemmer terpilih
stemmer <- stemmer_algoritm$new()

#' mendapatkan kata dasar dari sebuah kata menerapkan "memoization"
#' input            : sebuah string kata (bukan kalimat)
stemmer$stem(input)

#' sedangkan mendapatkan kata dasar dari sebuah kata tanpa "memoization"
#' input            : sebuah string kata (bukan kalimat)
stemmer$stem_word(input)
```

berikut daftar objek stemmer yang dapat digunakan tertera beserta fungsi pembangun objek stemmer tersebut.
1. Nazief-Andriani:   
    `stemmer_nazief_andriani(stem_dictionary = "kamus_sastrawi")`
1. (Tala) Porter:  
    `stemmer_tala_porter(stem_dictionary = "kamus_sastrawi")`
1. Confix Stripping:  
    `stemmer_cs(stem_dictionary = "kamus_sastrawi")`
1. Enhanced Confix Stripping:  
    `stemmer_ecs(stem_dictionary = "kamus_sastrawi")`
1. Incremental:  
    `stemmer_incremental(stem_dictionary = "kamus_sastrawi", criteria="first")`  
1. Modified Enhanced Confix Stripping:  
    `stemmer_mecs(stem_dictionary = "kamus_sastrawi", closewords = "closewords_nondeterministik")`
1. Nondeterministic :  
    `stemmer_nondeterministic(stem_dictionary = "kamus_sastrawi")`
1. Sastrawi:  
    `stemmer_sastrawi(stem_dictionary = "kamus_sastrawi")`

## Maintainers

[@kjarom](https://git.stis.ac.id/kjarom/)

## License

[STIS](LICENSE) © Ahlul Karom
