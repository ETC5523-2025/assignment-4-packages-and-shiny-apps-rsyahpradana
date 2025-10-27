library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)
library(scales)

data <- a4syahpradana::common_names

ui <- navbarPage(
  "THE MOST COMMON NAME IN AMERICA",
  theme = bs_theme(bootswatch = "flatly"),
  tabPanel(
    "Explore",
    sidebarLayout(
      sidebarPanel(
        radioButtons("name_type", "Type of name:",
                     choices = c("First name" = "first",
                                 "Surname"    = "last",
                                 "Full name"  = "full"),
                     selected = "first"),
        radioButtons("measure", "Select measure:",
                     choices = c("Estimate (baseline count)" = "estimate",
                                 "Final estimate (adjusted count)" = "final_estimate"),
                     selected = "estimate"),
        textInput("first_q", "Search first name (optional):", placeholder = "e.g. John"),
        textInput("last_q",  "Search last name (optional):",  placeholder = "e.g. Smith"),
        sliderInput("top_n", "Select ranking limit", min = 5, max = 50, value = 10, step = 1),
        checkboxInput("show_pct", "Show % labels (within Top N)", TRUE),
        checkboxInput("show_table", "Show ranking table", TRUE),
        width = 3
      ),
      mainPanel(
        h5("About this dashboard"),
        p(HTML(
          "This dashboard ranks common American names based on their estimated number of people. ",
          "<b>Estimate</b> is the baseline count of people with that name. ",
          "<b>Final estimate</b> is the adjusted count after data corrections or weighting. ",
          "Explore first names, surnames, or full-name combinations; filter by prefixes; and adjust the ranking limit."
        )),
        h4(textOutput("bar_title")),
        plotOutput("bar_top", height = 480),
        conditionalPanel(
          "input.show_table",
          tags$hr(),
          h4("Ranking summary"),
          tableOutput("tbl")
        ),
        width = 9
      )
    )
  )
)

server <- function(input, output, session) {

  grouped <- reactive({
    mcol <- rlang::sym(input$measure)

    fq <- gsub("[^a-z]+", "", tolower(trimws(input$first_q %||% "")))
    lq <- gsub("[^a-z]+", "", tolower(trimws(input$last_q  %||% "")))

    df <- data |>
      mutate(
        first_key = tolower(first_name),
        last_key  = tolower(surname),
        full_name = paste(first_name, surname)
      )

    if (nzchar(fq)) df <- df |> filter(startsWith(first_key, fq))
    if (nzchar(lq)) df <- df |> filter(startsWith(last_key,  lq))

    name_col <- case_when(
      input$name_type == "first" ~ "first_name",
      input$name_type == "last"  ~ "surname",
      TRUE                       ~ "full_name"
    )

    df |>
      mutate(name = .data[[name_col]]) |>
      group_by(name) |>
      summarise(count = sum(!!mcol, na.rm = TRUE), .groups = "drop") |>
      arrange(desc(count)) |>
      slice_head(n = input$top_n) |>
      mutate(pct = count / sum(count))
  })

  output$bar_title <- renderText({
    kind <- switch(input$name_type,
                   first = "first names",
                   last  = "surnames",
                   full  = "full names")
    metric <- if (input$measure == "estimate") "Estimate (people count)" else "Final estimate (adjusted count)"
    paste0("Top ", input$top_n, " ", kind, " by ", metric)
  })

  output$bar_top <- renderPlot({
    df <- grouped(); req(nrow(df) > 0)
    ggplot(df, aes(x = reorder(name, count), y = count)) +
      geom_col(fill = "#2C7FB8") +
      coord_flip() +
      labs(x = NULL, y = "Number of people") +
      scale_y_continuous(labels = comma) +
      {
        if (isTRUE(input$show_pct))
          geom_text(aes(label = paste0(round(100 * pct, 1), "%")),
                    hjust = -0.1, size = 3)
      } +
      theme_minimal(base_size = 13) +
      theme(panel.grid.minor = element_blank())
  }, res = 120)

  output$tbl <- renderTable({
    grouped() |>
      transmute(Name = name, Count = format(round(count, 0), big.mark = ","))
  }, striped = TRUE, hover = TRUE, spacing = "s")
}

shinyApp(ui, server)
