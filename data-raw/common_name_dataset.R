library(dplyr)
library(readr)
library(stringr)

raw <- read_csv("data-raw/adjusted-name-combinations-list.csv", show_col_types = FALSE)

common_names <- raw |>
  transmute(first_name = str_squish(FirstName),
            surname = str_squish(Surname),
            clean_name = str_squish(cleanName),
            adjustment = round(suppressWarnings(as.numeric(Adjustment)), 2),
            estimate = round(suppressWarnings(as.numeric(Estimate)), 2),
            final_estimate = round(suppressWarnings(as.numeric(finalEstimate)), 2)) |>
  filter(!is.na(first_name),
         !is.na(surname),
         !is.na(estimate),
         !is.na(final_estimate)) |>
  distinct(clean_name, .keep_all = TRUE)

usethis::use_data(common_names, overwrite = TRUE)
