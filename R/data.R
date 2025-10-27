#' Common American Names
#'
#' A dataset containing the most common American first and last name combinations,
#' with both baseline (Estimate) and adjusted (Final estimate) counts.
#'
#' @format A data frame with 6 variables:
#' \describe{
#'   \item{first_name}{Given name}
#'   \item{surname}{Family name}
#'   \item{clean_name}{Standardised lowercase full name}
#'   \item{adjustment}{Numeric adjustment applied}
#'   \item{estimate}{Baseline count value}
#'   \item{final_estimate}{Adjusted count value}
#' }
#'
#' @source Derived from public U.S. name frequency data
"common_names"
