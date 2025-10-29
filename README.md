
# a4syahpradana: Exploring The Most Common Name in America

The **a4syahpradana** R package provides a cleaned dataset and
interactive tools to explore the most common American names. It
includes:

- `common_names`: a dataset of first names, surnames, and adjusted
  population estimates  
- `top_ranked_names()`: a helper function for ranking and summarising
  names  
- `run_names_app()`: a Shiny dashboard for interactive visualisation

## Installation

You can install the development version from GitHub:

``` r
install.packages("remotes")
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-rsyahpradana")
# or
install.packages("devtools")
devtools::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-rsyahpradana")
```

## Example

``` r
# Load package
library(a4syahpradana)
# Explore dataset
data("common_names")
head(common_names)

# View top-ranked names
top_ranked_names(n = 10)
```

## Dashboard

To visualise results interactively, launch the dashboard:

``` r
run_names_app()
```

## Website
