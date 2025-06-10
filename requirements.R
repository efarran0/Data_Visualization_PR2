packages <- c(
  "shiny",
  "dplyr",
  "plotly",
  "leaflet",
  "shinyWidgets",
  "sf"
)

new_packages <- setdiff(packages, rownames(installed.packages()))
if (length(new_packages)) install.packages(new_packages)
