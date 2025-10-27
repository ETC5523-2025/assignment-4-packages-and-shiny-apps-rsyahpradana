#' Launch the Common Names dashboard
#' @export
run_names_app <- function() {
  appDir <- system.file("shiny", package = "a4syahpradana")
  shiny::runApp(appDir)
}
