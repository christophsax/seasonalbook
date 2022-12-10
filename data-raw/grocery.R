## code to prepare `DATASET` dataset goes here

grocery <- seasonal::import.ts("data-raw/grocery.dat")
usethis::use_data(grocery, overwrite = TRUE)
