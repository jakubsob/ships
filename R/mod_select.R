#' select UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      class = "ui raised segment",
      div(
        class = "ui header",
        icon("list"),
        "Select Ship"
      ),
      div(
        class = "container",
        div(
          class = "bold fixed-item",
          "Type:"
        ),
        div(
          class = "flex-item",
          shiny.semantic::dropdown_input(
            ns("select_ship_type"),
            choices = "",
            choices_value = "",
            type = "fluid scrolling"
          )
        )
      ),
      div(
        class = "container",
        div(
          class = "bold fixed-item",
          "Name:"
        ),
        div(
          class = "flex-item",
          shiny.semantic::dropdown_input(
            ns("select_ship_name"),
            choices = "",
            choices_value = "",
            type = "fluid scrolling"
          )
        )
      )
    )
  )
}

#' select Server Function
#'
#' @noRd
#' @return List with reactive values:
#'   - ship_type: character, name of selected ship type
#'   - ship_name: character, name of selected ship
#'   - ship_data: tibble with ship data
#'
#' @importFrom shiny.semantic update_dropdown_input
#' @importFrom magrittr %>%
#' @importFrom dplyr filter distinct pull
mod_select_server <- function(input, output, session, data){
  ns <- session$ns

  # Get values for select input
  ship_names <- data$Shipname %>% unique() %>% sort()
  ship_types <- data$Shiptype %>% unique() %>% sort()

  # Update ship type with values from data
  update_dropdown_input(
    session,
    input_id = "select_ship_type",
    choices = ship_types,
    value = ship_types[1]
  )

  # Update ship names with values from data
  update_dropdown_input(
    session,
    input_id = "select_ship_name",
    choices = ship_names,
    value = ""
  )

  observeEvent(input$select_ship_type, {
    req(input$select_ship_type)
    if (input$select_ship_type == "") {
      return()
    }

    ship_names <- data %>%
      filter(Shiptype == input$select_ship_type) %>%
      distinct(Shipname) %>%
      pull(Shipname)

    update_dropdown_input(
      session,
      input_id = "select_ship_name",
      choices = ship_names,
      value = ship_names[1]
    )
  })

  return(
    list(
      ship_type = reactive({ input$select_ship_type }),
      ship_name = reactive({ input$select_ship_name }),
      ship_data = reactive({ data %>% filter(Shipname == input$select_ship_name)})
    )
  )
}

## To be copied in the UI
# mod_select_ui("select_ui_1")

## To be copied in the server
# callModule(mod_select_server, "select_ui_1")

