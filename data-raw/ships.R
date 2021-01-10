## code to prepare `ships` dataset goes here

# path <- "../../ships.csv"
# ships <- readr::read_csv(path)
# ships <- ships %>%
#   dplyr::select(-c(port, date, SHIPTYPE)) %>%
#   dplyr::rename_with(.fn = stringr::str_to_title) %>%
#   dplyr::rename(Shiptype = Ship_type, ShipId = Ship_id, IsParked = Is_parked, WeekNb = Week_nb) %>%
#   dplyr::mutate(dplyr::across(c(Destination, Port), stringr::str_to_title))
# usethis::use_data(ships, overwrite = TRUE, internal = TRUE)
