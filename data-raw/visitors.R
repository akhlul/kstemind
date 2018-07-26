################################################################
# Visitors table creator for CS
################################################################
library(readxl)
visitors_suffixes <- read_excel("data-raw/table_visitors_cs.xlsx", sheet = "suffixes")
visitors_complex_prefixes <- read_excel("data-raw/table_visitors_cs.xlsx", sheet = "complex_prefixes")
visitors_plain_prefixes <- read_excel("data-raw/table_visitors_cs.xlsx", sheet = "plain_prefixes")

visitors_cs <- list(
  suffixes = visitors_suffixes,
  plain_prefixes = visitors_plain_prefixes,
  complex_prefixes = visitors_complex_prefixes
)

# devtools::use_data(visitors_cs, overwrite = TRUE)
saveRDS(visitors_cs, "R/visitors/cs.rds")

################################################################
# Visitors table creator for ECS
################################################################
library(readxl)
visitors_suffixes <- read_excel("data-raw/table_visitors_ecs.xlsx", sheet = "suffixes")
visitors_complex_prefixes <- read_excel("data-raw/table_visitors_ecs.xlsx", sheet = "complex_prefixes")
visitors_plain_prefixes <- read_excel("data-raw/table_visitors_ecs.xlsx", sheet = "plain_prefixes")

visitors_ecs <- list(
  suffixes = visitors_suffixes,
  plain_prefixes = visitors_plain_prefixes,
  complex_prefixes = visitors_complex_prefixes
)

# devtools::use_data(visitors_cs, overwrite = TRUE)
saveRDS(visitors_ecs, "R/visitors/ecs.rds")

################################################################
# Visitors table creator for MECS
################################################################
library(readxl)
visitors_suffixes <- read_excel("data-raw/table_visitors_mecs.xlsx", sheet = "suffixes")
visitors_complex_prefixes <- read_excel("data-raw/table_visitors_mecs.xlsx", sheet = "complex_prefixes")
visitors_plain_prefixes <- read_excel("data-raw/table_visitors_mecs.xlsx", sheet = "plain_prefixes")

visitors_mecs <- list(
  suffixes = visitors_suffixes,
  plain_prefixes = visitors_plain_prefixes,
  complex_prefixes = visitors_complex_prefixes
)

# devtools::use_data(visitors_cs, overwrite = TRUE)
saveRDS(visitors_mecs, "R/visitors/mecs.rds")

################################################################
# Visitors table creator for Sastrawi
################################################################
library(readxl)
visitors_suffixes <- read_excel("data-raw/table_visitors_sastrawi.xlsx", sheet = "suffixes")
visitors_complex_prefixes <- read_excel("data-raw/table_visitors_sastrawi.xlsx", sheet = "complex_prefixes")
visitors_plain_prefixes <- read_excel("data-raw/table_visitors_sastrawi.xlsx", sheet = "plain_prefixes")

visitors_sastrawi <- list(
  suffixes = visitors_suffixes,
  plain_prefixes = visitors_plain_prefixes,
  complex_prefixes = visitors_complex_prefixes
)

# devtools::use_data(visitors_cs, overwrite = TRUE)
saveRDS(visitors_sastrawi, "R/visitors/sastrawi.rds")

################################################################
# Visitors table creator for Nazief-Andriani
################################################################
library(readxl)
visitors_suffixes <- read_excel("data-raw/table_visitors_nazief_andriani.xlsx", sheet = "suffixes")
visitors_complex_prefixes <- read_excel("data-raw/table_visitors_nazief_andriani.xlsx", sheet = "complex_prefixes")
visitors_plain_prefixes <- read_excel("data-raw/table_visitors_nazief_andriani.xlsx", sheet = "plain_prefixes")

visitors_nazief_andriani <- list(
  suffixes = visitors_suffixes,
  plain_prefixes = visitors_plain_prefixes,
  complex_prefixes = visitors_complex_prefixes
)

# devtools::use_data(visitors_cs, overwrite = TRUE)
saveRDS(visitors_nazief_andriani, "R/visitors/nazief_andriani.rds")
