packages <- c(
  "readr", "mapSpain", "shiny", "dplyr", "plotly", "leaflet",
  "htmltools", "shinythemes", "shinyWidgets", "shinyjs", "sf"
)

new_packages <- setdiff(packages, rownames(installed.packages()))
if (length(new_packages)) install.packages(new_packages)

lapply(packages, library, character.only = TRUE)
