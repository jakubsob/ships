#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @noRd
#'
#' @import shiny
#' @importFrom dplyr n_distinct
#' @importFrom tibble tibble
#' @importFrom rintrojs introjs
app_server <- function(input, output, session) {

  # Load data
  data <- ships

  # Reactive values for storing data for selected ship and calculated ship distance
  ship_data <- reactiveValues(
    data = NULL,
    distance = NULL
  )

  # Get ship selection from selection module
  selected <- callModule(mod_select_server, "select_ui_1", data)

  # Run map module
  callModule(mod_map_server, "map_ui_1", ship_data)

  # Prepare data for ship info module
  ship_info_list <- reactive({
    dist <- ship_data$distance[1, ]
    if (is.null(dist)) return(NULL)

    list(
      Speed = signif(dist$Speed, 1),
      Dwt = dist$Dwt,
      Length = dist$Length,
      Width = dist$Width
    )
  })

  # Prepare data for port info module
  port_info_list <- reactive({
    dest <- ship_data$data$Port[1]
    if (is.null(dest)) return(NULL)

    dest_data <- data %>% filter(Port == dest)
    list(
      Destination = dest,
      Shipname = n_distinct(dest_data$Shipname),
      Shiptype = n_distinct(dest_data$Shiptype)
    )
  })

  # Call info list modules
  callModule(mod_info_list_server, "info_list_ui_1", const_ship_info_list$items, ship_info_list)
  callModule(mod_info_list_server, "info_list_ui_2", const_port_info_list$items, port_info_list)

  # When selection changes recalculate longest distance
  observeEvent(selected$ship_data(), {
    ship_data$data <- selected$ship_data()
    ship_data$distance <- longest_distance(selected$ship_data())
  }, ignoreInit = TRUE)

  # Trigger tutorial when help button is clicked
  observeEvent(input$help, {
    tutorial_df <- tibble(
      element = paste0("#", names(const_tutorial$elements)),
      intro = unlist(const_tutorial$elements)
    )
    introjs(session, options = list(steps = tutorial_df))
  }, ignoreInit = TRUE)
}
