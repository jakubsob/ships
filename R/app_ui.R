#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
#' @import shiny
#' @importFrom shiny.semantic semanticPage sidebar_layout sidebar_panel main_panel
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    semanticPage(
      sidebar_layout(
        sidebar_panel = sidebar_panel(
          width = 4,
          div(
            id = "select_tut_div",
            mod_select_ui("select_ui_1")
          ),
          div(
            class = "ui raised segment",
            id = "ship_info_tut_div",
            div(
              class = "ui header",
              icon("ship"),
              "Ship Info"
            ),
            mod_info_list_ui("info_list_ui_1")
          ),
          div(
            class = "ui raised segment",
            id = "port_info_tut_div",
            div(
              class = "ui header",
              icon("anchor"),
              "Port Info"
            ),
            mod_info_list_ui("info_list_ui_2")
          ),
          div(
            action_button_animated(
              "help",
              visible_content = icon("question circle outline"),
              hidden_content = "Help",
              style = "style: 100%;"
            )
          )
        ),
        main_panel = main_panel(
          width = 10,
          div(
            id = "map_tut_div",
            mod_map_ui("map_ui_1")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @importFrom shinyjs useShinyjs
#' @importFrom rintrojs introjsUI
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'ships'
    ),
    useShinyjs(),
    introjsUI()
  )
}
