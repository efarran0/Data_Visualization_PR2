# Visualització de Dades - PRA2: hábitos alimentarios en España

**Màster Universitari en Ciència de Dades**
*Universitat Oberta de Catalunya*

Aquest repositori es basa en una aplicació interactiva desenvolupada en Shiny que explora el consum de cada comunitat autònoma d'Espanya. El volum total es desagrega en cinc nivells nutricionals per facilitar la visualització de la composició anual i la variació mensual en un format de dashboard interactiu.<br>
Aquesta aplicació forma part del lliurament de la pràctica 2 de l’assignatura de Visualització de Dades del Màster de Ciència de Dades de la Universitat Oberta de Catalunya (UOC).

## Continguts

- [Característiques](#característiques)
- [Ús d'intel·ligències Artificials Generatives (IAGs)](#ús-d'intel·ligències-artificials-generatives-(IAGs))
- [Execució](#execució)
- [Llicència](#llicència)

## Característiques

- **Tecnologia**: R (readr, sf, shiny, shinywidgets, shinyjs, shinythemes, htmltools, mapspain, leaflet, plotly, dplyr)
- **Interactivitat**:
  - Filtratge per any i comunitat autònoma
  - Tooltips informatius
- **Documents**:
  - Data original: [Ministerio de agricultura, pesca y alimentación (años 2014-2023, base censo INE 2011)](https://www.mapa.gob.es/es/alimentacion/temas/consumo-tendencias/panel-de-consumo-alimentario/series-anuales/default.aspx)
  - Data preprocessada: data.csv
  - Script de preprocessament: hábitos_alimentarios_preprocesamiento.Rmd
    <br>Extracció de dades d'interès des de múltiples fitxers xlsx amb múltiples fulles.
  - Aplicació: app.R

- **Compatibilitat**: Compatible amb navegadors moderns (Chrome, Firefox, Edge) que suportin aplicacions Shiny

## Ús d'intel·ligències artificials generatives (IAGs)

En la narrativa visual s'ha emprat **ChatGPT-4** com assistent a l'hora de generar l'estructuració de l'aplicació Shiny en R i la consulta puntual per a la construcció de les visualitzacions, amb una influència aproximada del 20% sobre la pràctica lliurada.

L'autor ha estat l'encarregat d'elaborar el contingut teòric de la pràctica, supervisar els suggeriments de la IAG, completar el codi d'acord als requeriments de la narrativa i validar el resultat final.<br>

**Així doncs, les IAGs han actuat en tot moment només com a assistents. La responsabilitat sobre el disseny, la presa de decisions i el bon funcionament de l'aplicació recau exclusivament sobre l'autor del recurs.<br>
En cap cas les visualitzacions han estat generades de manera autònoma ni tampoc s'han emprat dades sensibles en la seva construcció.<br>
Aquest ús està alineat amb les directrius de la UOC sobre IA generativa ([Guia de citació de IA](https://openaccess.uoc.edu/bitstream/10609/148823/1/U2_17_GuiaCitarIA_CAT.pdf)), garantint transparència i integritat en el procés.**

## Execució
La visualització no està disponible en línia **degut a la gran quantitat de paquets i al volum de dades que es fa servir**. Per a consultar-la es pot visualitzar els documents de la carpeta sreenshots o bé executar l'app en local aplicant els següents pasos:

1. **Obre Rstudio i situat a la consola**
2. **Clona el repositori GitHub**
   <br>url <- "https://github.com/efarran0/Data_Visualization_PRA2/archive/main.zip"
   <br>download.file(url, destfile = "repo.zip")
   <br>unzip("repo.zip")

4. **Prepara les llibreries requerides**
   <br>source("Data_Visualization_PRA2-main/requirements.R")
5. **Executa el runApp en R**
   <br>shiny::runApp("Data_Visualization_PRA2-main/docs")

## Llicència

Aquest treball està sota llicència [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html).
