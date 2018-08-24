################################################################
# Level table creator for Incremental Stemmer
################################################################
library(readxl)
level_suffixes <- read_excel("data-raw/table_levels_incremental.xlsx", sheet = "suffixes")
level_prefixes <- read_excel("data-raw/table_levels_incremental.xlsx", sheet = "prefixes")

level <- list(
  suffixes = level_suffixes,
  prefixes = level_prefixes
)

# devtools::use_data(level_incremental, overwrite = TRUE)
saveRDS(level, "inst/extdata/visitors/level_incremental.rds")

################################################################
# affixes rule table creator for Non-Deterministic Stemmer
################################################################
library(readxl)
rule_suffixes <- read_excel("data-raw/table_affix_nondet.xlsx", sheet = "suffixes")
rule_prefixes <- read_excel("data-raw/table_affix_nondet.xlsx", sheet = "prefixes")
rule_group <- read_excel("data-raw/table_affix_nondet.xlsx", sheet = "groups")

rules <- list(
  suffixes = rule_suffixes,
  prefixes = rule_prefixes,
  group = rule_group
)

# devtools::use_data(level_incremental, overwrite = TRUE)
saveRDS(rules, "inst/extdata/visitors/aturan_nondeterministik.rds")

################################################################
# affixes rule table creator for Non-Deterministic Stemmer
################################################################
library(readxl)
library(data.table)
closewords <- read_excel("data-raw/table_closewords_nondet.xlsx", sheet = "words")

closewords <- as.data.table(closewords)

# devtools::use_data(level_incremental, overwrite = TRUE)
saveRDS(closewords, "inst/extdata/visitors/closewords_nondeterministik.rds")
