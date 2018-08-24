#' kstemind_load_data
#'
#' @param data string: the name of the data. Other than the specified option below will return NULL.
#'   options : ("kamus_sastrawi", "kamus_nazief", "kamus_hidayat").
#' 			   ("tabel_visitors_cs", "tabel_visitors_ecs", "tabel_level_incremental"),
#'			   ("aturan_nondeterministik")
#'
#' @return primary dataset in hashmap or data.frame
#' @import hashmap
#'
#' @examples
#' my_data <- kstemind_load_data("kamus_sastrawi")
#'
kstemind_load_data <- function(data) {
	switch(data,
		"kamus_sastrawi" = {
			this_path <- system.file("extdata/kamus", "sastrawi.hashmap", package = "kstemind")
			return(load_hashmap(this_path))
		},
		"kamus_nazief_andriani" = {
			this_path <- system.file("extdata/kamus", "nazief_andriani.hashmap", package = "kstemind")
			return(load_hashmap(this_path))
		},
		"kamus_hidayat" = {
			this_path <- system.file("extdata/kamus", "hidayat.hashmap", package = "kstemind")
			return(load_hashmap(this_path))
		},
		"tabel_visitors_ecs" = {
			this_path <- system.file("extdata/visitors", "ecs.rds", package = "kstemind")
			return(readRDS(this_path))
		},
		"tabel_visitors_nazief_andriani" = {
			this_path <- system.file("extdata/visitors", "nazief_andriani.rds", package = "kstemind")
			return(readRDS(this_path))
		},
		"tabel_visitors_cs" = {
		  	this_path <- system.file("extdata/visitors", "cs.rds", package = "kstemind")
			return(readRDS(this_path))
		},
		"tabel_visitors_mecs" = {
		  	this_path <- system.file("extdata/visitors", "mecs.rds", package = "kstemind")
			return(readRDS(this_path))
		},
		"tabel_visitors_sastrawi" = {
		  	this_path <- system.file("extdata/visitors", "sastrawi.rds", package = "kstemind")
			return(readRDS(this_path))
		},
		"tabel_level_incremental" = {
		  	this_path <- system.file("extdata/visitors", "level_incremental.rds", package = "kstemind")
			return(readRDS(this_path))
		},
		"aturan_nondeterministik" = {
		  	this_path <- system.file("extdata/visitors", "aturan_nondeterministik.rds", package = "kstemind")
			return(readRDS(this_path))
		},
		"closewords_nondeterministik" = {
		  	this_path <- system.file("extdata/visitors", "closewords_nondeterministik.rds", package = "kstemind")
			return(readRDS(this_path))
		},
		{
			print("unable to get the data")
    		return(NULL)
		}
	)
}
