# Instalar y cargar paquetes
options(repos = c(RSPM = "https://packagemanager.posit.co/cran/latest"),
        error=NULL)

packages <- c("readr", "mapSpain", "shiny", "dplyr", "plotly", "leaflet", "htmltools", "shinythemes", "shinyWidgets", "shinyjs", "sf")
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) install.packages(packages[!installed])
lapply(packages, library, character.only = TRUE)

# Cargar los datos
data <- read_csv("data/hábitos_alimenticios_España.csv", 
                 col_types = cols(...1 = col_skip()))

data <- data %>%
  mutate(across(where(is.character), as.factor),
         across(nivel, as.factor))

ccaa <- esp_get_ccaa(resolution = "1") %>% 
  st_transform(4326)

# Paleta de colores
nivel_colores <- c(
  "1" = "#FFFFB2",
  "2" = "#FECC5C",
  "3" = "#FD8D3C",
  "4" = "#F03B20",
  "5" = "#BD0026"
)

# Definir la UI
ui <- fluidPage(
  useShinyjs(),
  theme = shinytheme("flatly"),
  titlePanel(
    tags$h1("Hábitos alimenticios en España", 
            style = "font-weight: bold; color: #2C3E50; font-size: 30px; font-family: 'Helvetica'; text-align: center; margin-top: 20px; margin-bottom: 30px")
  ),
  
  fluidRow(
    column(4,
           sliderTextInput(
             inputId = "año",
             label = "Selecciona el año:",
             choices = sort(unique(data$año)),
             selected = min(unique(data$año)),
             grid = TRUE,
             animate = FALSE,
             force_edges = TRUE,
             width = "100%"
           ),
           plotlyOutput("piramide", height = "40vh"),
           div(style = "margin-top: 60px;", htmlOutput("ccaa_descripcion"))
    ),
    column(8,
           leafletOutput("spain", height = "45vh"),
           verbatimTextOutput("ccaa_seleccionada"),
           plotlyOutput("stack", height = "35vh")
           )
    )
  )

server <- function(input, output) {  
  output$spain <- renderLeaflet({
    
    ccaa_vol <- data %>%
      filter(año == input$año) %>%
      group_by(ccaa) %>%
      summarise(vol = sum(volumen, na.rm = TRUE))
    
    ccaa_dades <- left_join(ccaa, ccaa_vol, by = c("iso2.ccaa.name.es" = "ccaa"))
    
    pal <- colorNumeric("Reds", domain = c(0, 6e+6), na.color = "transparent")
    
    leaflet(ccaa_dades) %>%
      addProviderTiles(
        "CartoDB.PositronNoLabels",
        options = providerTileOptions(
          noWrap = TRUE,
          minZoom = 5
          )
        ) %>%
          addPolygons(
            layerId = ~iso2.ccaa.name.es,
            label = ~paste0(
              "<strong>", gsub(",.*", "",iso2.ccaa.name.es), "</strong><br>",
              "Consumo total (", input$año, "): ",
              format(round(vol, 1),
                     big.mark = ".",
                     decimal.mark = ",", sep ="")

              ) %>% lapply(HTML),
            labelOptions = labelOptions(
              noHide = FALSE,
              textOnly = FALSE,
              style = list(
                "color" = "black",
                "padding" = "5px 10px",
                "background-color" = "rgba(255,255,255,0.8)",
                "border-radius" = "3px"
              )
            ),
            fillColor = ~pal(vol),
            weight = 1,
            color = "black",
            fillOpacity = 0.7,
            highlightOptions = highlightOptions(
              color = "red",
              weight = 2,
              bringToFront = TRUE
            )) %>%
          addLegend(
            pal = pal,
            values = seq(0, 6e+6, length.out = 5),
            title = paste("Consumo total", input$año),
            position = "topright"
          )  %>%
          fitBounds(lng1 = -10, lat1 = 27, lng2 = 4, lat2 = 50)
    })
    
  selected_region <- reactiveVal("Madrid, Comunidad de")
  
  observeEvent(input$spain_shape_click, {
    selected_region(input$spain_shape_click$id)
  })
  
  output$ccaa_seleccionada <- renderText({
    paste("Región seleccionada:", gsub(",.*", "",selected_region()))
    
  })
  
  output$stack <- renderPlotly({
    req(selected_region(), input$año)
    
    meses_levels <- c("Enero",
                      "Febrero",
                      "Marzo",
                      "Abril",
                      "Mayo",
                      "Junio",
                      "Julio",
                      "Agosto",
                      "Septiembre",
                      "Octubre",
                      "Noviembre",
                      "Diciembre")
    
    df_filt <- data %>%
      filter(ccaa == selected_region(), año == input$año) %>%
      mutate(mes = factor(mes, levels = meses_levels)) %>%
      group_by(mes, nivel) %>%
      summarise(volumen = sum(volumen, na.rm = TRUE), .groups = "drop") %>%
      group_by(mes) %>%
      mutate(volumen_pct = floor(volumen / sum(volumen) * 1000)/10) %>%
      ungroup() %>%
      arrange(nivel, mes) %>%
      mutate(nivel = factor(nivel, levels = sort(unique(nivel), decreasing = FALSE)))
    
    plot_ly(df_filt,
            x = ~mes,
            y = ~volumen_pct,
            color = ~nivel,
            colors = nivel_colores,
            type = "scatter",
            mode = "none",
            stackgroup = "one",
            fill = "tonexty",
            hoverinfo = "text",
            text = ~paste0("Mes: ", mes,
                           "<br>Nivel: ", nivel,
                           "<br>Volumen: ", volumen_pct, "%")) %>%
      layout(
        yaxis = list(title = "Volumen", range = c(0, 100), ticksuffix = "%"),
        xaxis = list(title = paste(gsub(",.*", "",selected_region()), "-", input$año),
                     categoryorder = "array",
                     categoryarray = meses_levels),
        legend = list(title = list(text = "<b>Nivel nutricional</b>"))
      )
  })
  
  output$piramide <- renderPlotly({
    req(selected_region(), input$año)
    
    df_filt <- data %>%
      filter(ccaa == selected_region(), año == input$año) %>%
      group_by(nivel) %>%
      summarise(volumen_total = sum(volumen, na.rm = TRUE), .groups = "drop") %>%
      mutate(
        volumen_pct = floor(volumen_total / sum(volumen_total) * 1000) / 10,
        nivel = factor(nivel, levels = sort(unique(nivel), decreasing = FALSE))
      )
    
    plot_ly(
      data = df_filt,
      x = ~rep("", nrow(df_filt)),
      y = ~volumen_pct,
      color = ~nivel,
      colors = nivel_colores,
      type = "bar",
      opacity = 0.55,
      hoverinfo = "text",
      text = ~paste0("Nivel: ", nivel, "<br>Volumen: ", volumen_pct, "%")
    ) %>%
      layout(
        barmode = "stack",
        xaxis = list(title = paste(gsub(",.*", "",selected_region()), "-", input$año),
                     showticklabels = FALSE),
        yaxis = list(title = "Volumen", range = c(0, 100), ticksuffix = "%"),
        legend = list(title = list(text = "<b>Nivel nutricional</b>"))
      )
  })
  
  output$ccaa_descripcion <- renderUI({
    req(selected_region())
    
    text <- switch(
      selected_region(),
      "Andalucía" = "En Andalucía, la dieta diaria se caracteriza por un uso generoso del aceite de oliva que acompaña a verduras frescas, legumbres y pescados. Los desayunos suelen ser ligeros, mientras que en las comidas predominan platos como el gazpacho, el pescaíto frito o las berenjenas con miel, reflejando la influencia mediterránea y la costa.",
      "Aragón" = "La alimentación diaria en Aragón combina platos contundentes y nutritivos, con especial atención a las carnes de calidad y las legumbres. Los guisos y estofados forman parte habitual, aportando energía para los días fríos de interior, complementados con verduras de temporada y panes artesanales.",
      "Asturias, Principado de" = "En Asturias, la dieta diaria se basa en productos lácteos, especialmente quesos, junto con carnes guisadas y pescados del Cantábrico. Los platos típicos, como la fabada o el cachopo, son habituales en la comida principal, con un consumo frecuente de sidra y verduras locales.",
      "Canarias" = "La dieta cotidiana en Canarias se distingue por la presencia de frutas tropicales, pescados frescos y tubérculos como el gofio y las papas. Las comidas incluyen platos como el sancocho y las tortillas de batata, reflejando la mezcla cultural y el clima subtropical que favorece productos frescos y ligeros.",
      "Cantabria" = "En Cantabria, la dieta diaria equilibra pescados y mariscos frescos con carnes de montaña y quesos tradicionales. Platos como el cocido montañés o la sopa de ajo son habituales, junto a verduras y legumbres, favoreciendo una alimentación rica en nutrientes y sabores intensos.",
      "Castilla y León" = "La alimentación cotidiana en Castilla y León se basa en ingredientes locales como las legumbres, carnes rojas y productos de la tierra. Las comidas suelen ser abundantes y energéticas, con guisos, asados y sopas que reflejan la tradición rural y la influencia de la meseta central.",
      "Castilla-La Mancha" = "En Castilla-La Mancha, la dieta diaria incluye una gran variedad de verduras frescas, cereales y carnes de caza. Platos como el pisto manchego o el gazpacho manchego forman parte del día a día, acompañados de productos locales que reflejan la riqueza agrícola y la cocina tradicional.",
      "Cataluña" = "La dieta diaria catalana se caracteriza por la combinación equilibrada de productos del mar y la montaña. El aceite de oliva, las hortalizas frescas y los arroces son ingredientes comunes, con platos típicos como la escalivada, la coca o la esqueixada, que aportan variedad y sabor a las comidas.",
      "Extremadura" = "En Extremadura, la alimentación cotidiana está marcada por el consumo de productos del cerdo ibérico, legumbres y verduras de temporada. Las migas y guisos tradicionales son frecuentes, reflejando una dieta de raíces rurales que aprovecha al máximo los recursos locales.",
      "Galicia" = "La dieta diaria gallega está dominada por productos del mar, especialmente pescados y mariscos frescos, acompañados de verduras y legumbres. Platos como el pulpo a la gallega o la empanada son habituales, junto a un consumo frecuente de pan de maíz y vinos locales.",
      "Islas Baleares" = "En las Islas Baleares, la dieta cotidiana combina productos mediterráneos como el aceite de oliva, pescados y verduras frescas con influencias insulares. Platos tradicionales como la sobrasada, el frito mallorquín o la ensaimada son habituales en las comidas diarias.",
      "La Rioja" = "La alimentación diaria en La Rioja incluye una fusión de productos de la huerta, carnes y pescados, acompañados de su afamado vino. Las comidas suelen ser equilibradas y sabrosas, con guisos y platos tradicionales que reflejan la riqueza agrícola y gastronómica de la región.",
      "Madrid, Comunidad de" = "En Madrid, la dieta diaria es variada y refleja influencias de toda España debido a su carácter cosmopolita. Se combinan platos tradicionales como el cocido madrileño con opciones más ligeras y modernas, adaptándose al ritmo urbano y a la disponibilidad de ingredientes frescos.",
      "Murcia, Región de" = "La dieta diaria en Murcia destaca por la abundancia de productos de la huerta, arroces y pescados. Platos como el caldero o las migas murcianas son comunes, y el uso del aceite de oliva y las verduras frescas son la base para una alimentación saludable y variada.",
      "Navarra, Comunidad Foral de" = "En Navarra, la dieta diaria combina verduras frescas, carnes y legumbres, reflejando la diversidad del territorio. Platos tradicionales como el ajoarriero o las verduras de temporada son habituales, junto con un consumo importante de productos artesanales y locales.",
      "País Vasco" = "La dieta cotidiana vasca se distingue por su calidad y sofisticación, equilibrando productos del mar y la tierra. Platos como el bacalao al pil-pil, los pintxos y las verduras de temporada forman parte de una alimentación diaria variada y rica en sabores intensos.",
      "Valenciana, Comunidad" = "En la Comunidad Valenciana, la dieta diaria se basa en el consumo de arroces, cítricos y hortalizas frescas. Platos como la paella, el all i pebre o la fideuà son comunes, junto con una tradición culinaria que aprovecha los recursos del mar y la huerta para una alimentación sabrosa y equilibrada."
    )
    
    tagList(
      tags$h3(gsub(",.*", "",selected_region()), style = "font-weight: bold; font-size: 20px"),
      tags$h4(style = "text-align: justify;", text)
    )
  })
}

shinyApp(ui = ui, server = server)
