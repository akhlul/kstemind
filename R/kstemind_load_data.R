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
			return(load_hashmap("R/kamus/sastrawi.hashmap"))
		},
		"kamus_nazief_andriani" = {
			return(load_hashmap("R/kamus/nazief_andriani.hashmap"))
		},
		"kamus_hidayat" = {
			return(load_hashmap("R/kamus/hidayat.hashmap"))
		},
		"tabel_visitors_ecs" = {
		  return(readRDS("R/visitors/ecs.rds"))
		},
		"tabel_visitors_nazief_andriani" = {
		  return(readRDS("R/visitors/nazief_andriani.rds"))
		},
		"tabel_visitors_cs" = {
		  return(readRDS("R/visitors/cs.rds"))
		},
		"tabel_visitors_mecs" = {
		  return(readRDS("R/visitors/mecs.rds"))
		},
		"tabel_visitors_sastrawi" = {
		  return(readRDS("R/visitors/sastrawi.rds"))
		},
		"tabel_level_incremental" = {
		  return(readRDS("R/visitors/level_incremental.rds"))
		},
		"aturan_nondeterministik" = {
		  return(readRDS("R/visitors/aturan_nondeterministik.rds"))
		},
		"closewords_nondeterministik" = {
		  return(readRDS("R/visitors/closewords_nondeterministik.rds"))
		},
		{
			print("unable to get the data")
    		return(NULL)
		}
	)
}
