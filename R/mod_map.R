#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_map_ui <- function(id){
  ns <- NS(id)
  tagList(
    leaflet::leafletOutput(
      ns("map"),
      width = const_map_params$width,
      height = const_map_params$height
    )
  )
}

#' map Server Function
#'
#' @noRd
#' @import shiny
#' @import leaflet
#' @importFrom glue glue
#' @importFrom dplyr mutate case_when
mod_map_server <- function(input, output, session, ship_data){
  ns <- session$ns

  output$map <- renderLeaflet({
    if (
      is.null(ship_data$distance) |
      is.null(ship_data$data)
    ) {
      return(NULL)
    }
    dist <- ship_data$distance

    popup_fmt <- "<strong>{header}</strong> <br>
      <strong>Position:</strong> [{lat}, {lon}] <br>
      <strong>Time:</strong> {datetime} <br>"
    dist_popup_fmt <- "<strong>Distance:</strong> {dist} m"

    dist %>%
      mutate(Color = case_when(
        Type == "End" ~ "red",
        Type == "Start" ~ "green"
      )) %>%
      leaflet() %>%
      addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
      setView(
        lng = mean(dist$Lon),
        lat = mean(dist$Lat),
        zoom = const_map_params$zoom
      ) %>%
      addPolylines(
        lng = ~ Lon,
        lat = ~ Lat,
        popup = glue(dist_popup_fmt, dist = signif(dist$Dist[1], 2)),
        options = popupOptions(
          closeButton = FALSE,
          noHide = TRUE,
          closeOnClick = FALSE,
          autoClose = FALSE
        )
      ) %>%
      addAwesomeMarkers(
        lng = ~ Lon,
        lat = ~ Lat,
        icon = makeAwesomeIcon(
          "ship",
          iconColor = "white",
          library = "fa",
          markerColor = ~ Color
        ),
        popup = ~ glue(
          popup_fmt,
          header = Type,
          lon = Lon,
          lat = Lat,
          datetime = Datetime
        )
      ) %>%
      addMiniMap(
        tiles = providers$Esri.WorldGrayCanvas,
        toggleDisplay = TRUE
      )
  })
}

## To be copied in the UI
# mod_map_ui("map_ui_1")

## To be copied in the server
# callModule(mod_map_server, "map_ui_1")

