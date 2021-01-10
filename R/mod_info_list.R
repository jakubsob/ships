#' info_list UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_info_list_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(id = ns("list_placeholder"))
  )
}

#' info_list Server Function
#'
#' @noRd
#' @importFrom shinyjs html
#' @importFrom shiny.semantic list_container
#' @importFrom glue glue glue_collapse
#' @importFrom purrr imap
#' @importFrom magrittr %>%
mod_info_list_server <- function(input, output, session, list_format, list_data){
  ns <- session$ns

  observeEvent(list_data(), {
    if (!is.list(list_data())) return()

    list_format %>%
      imap(function(x, n) {
        list(
          header = x$header,
          description = glue(x$description, x = list_data()[[n]]),
          icon = x$icon
        )
      }) %>%
      list_container() %>%
      as.character() %>%
      html(id = "list_placeholder")

  }, ignoreInit = TRUE)

}

## To be copied in the UI
# mod_info_list_ui("info_list_ui_1")

## To be copied in the server
# callModule(mod_info_list_server, "info_list_ui_1")

