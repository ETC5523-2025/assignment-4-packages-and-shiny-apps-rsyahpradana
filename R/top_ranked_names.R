#' Get top-ranked names
#'
#' Summarises and ranks names by count using either baseline or adjusted values.
#'
#' @param data Data frame, default is \code{a4syahpradana::common_names}
#' @param type "first" for first names or "last" for surnames
#' @param measure Either "estimate" or "final_estimate"
#' @param starts_with Optional prefix to filter names (case-insensitive)
#' @param n Number of top names to return
#'
#' @return A tibble with columns Name and Count.
#' @export
top_ranked_names <- function(data = a4syahpradana::common_names,
                             type = c("first","last"),
                             measure = c("estimate","final_estimate"),
                             starts_with = NULL,
                             n = 10) {
  type <- match.arg(type)
  measure <- match.arg(measure)

  name_col <- if (type == "first") "first_name" else "surname"
  col <- rlang::sym(measure)

  df <- data |>
    mutate(name = .data[[name_col]])

  if (!is.null(starts_with) && nzchar(trimws(starts_with))) {
    prefix <- tolower(trimws(starts_with))
    df <- df |> filter(startsWith(tolower(name), prefix))
  }

  df |>
    group_by(name) |>
    summarise(Count = sum(!!col, na.rm = TRUE), .groups = "drop") |>
    arrange(desc(Count)) |>
    slice_head(n = n)
}
