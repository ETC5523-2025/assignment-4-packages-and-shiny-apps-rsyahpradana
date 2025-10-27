
# a4syahpradana — Exploring The Most Common Name in America

The **a4syahpradana** R package provides a simple and interactive way to
explore the most common American names.  
It includes a cleaned dataset, a helper function for ranking names, and
a Shiny dashboard to visualise the top-ranked results.

## Installation

You can install the development version from GitHub:

``` r
install.packages("remotes")
remotes::install_github("rsyahpradana/a4syahpradana", build_vignettes = TRUE)
```

## Example

``` r
library(a4syahpradana)

# View top-ranked names
top_ranked_names(n = 10)

# Launch the interactive dashboard (RStudio or browser)
if (interactive()) run_names_app()
```
