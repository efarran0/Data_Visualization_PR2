# Visualització de Dades - PRA2: [hábitos alimentarios en España](https://e26vc3-eric-farran.shinyapps.io/PRA2/)

**Màster en Ciència de dades**
*Universitat Oberta de Catalunya*

Aquest repositori conté una aplicació interactiva desenvolupada en Shiny que explora el consum de cada comunitat autònoma d'Espanya desagregat pels 5 nivells nutricionals mitjançant la visualització de la composició anual com la variació mensual.<br>
Aquesta aplicació forma part del lliurament de la pràctica 2 de l’assignatura de Visualització de Dades del Màster de Ciència de Dades de la Universitat Oberta de Catalunya (UOC).

## Continguts

- [Característiques](#característiques)
- [Ús d'intel·ligències Artificials Generatives (IAGs)](#ús-d'intel·ligències-artificials-generatives-(IAGs))
- [Execució](#execució)
- [Llicència](#llicència)

## Característiques

- **Tecnologia**: R (Shiny, ggplot2, plotly, dplyr, ggstats, shinythemes)
- **Interactivitat**:
  - Filtratge per any i comunitat autònoma
  - Tooltips informatius
- **Documents**:
  - Data original: [Ministerio de agricultura, pesca y alimentación (años 2014-2023, base censo INE 2011)](https://www.mapa.gob.es/es/alimentacion/temas/consumo-tendencias/panel-de-consumo-alimentario/series-anuales/default.aspx)
  - Data preprocessada: data.csv
  - Script de preprocessament: hábitos_alimentarios_preprocesamiento.Rmd
  - Aplicació: app.R
- **Compatibilitat**: Compatible amb navegadors moderns (Chrome, Firefox, Edge) que suportin aplicacions Shiny

## Ús d'intel·ligències artificials generatives (IAGs)

En la narrativa visual s'ha emprat **ChatGPT-4** com assistent a l'hora de generar l'estructuració de l'aplicació Shiny en R i la consulta puntual per a la construcció de les visualitzacions, amb una influència aproximada del 20% sobre la pràctica lliurada.

L'autor ha estat l'encarregat d'elaborar el contingut teòric de la pràctica, supervisar els suggeriments de la IAG, completar el codi d'acord als requeriments de la narrativa i validar el resultat final.<br>

**Així doncs, les IAGs han actuat en tot moment només com a assistents. La responsabilitat sobre el disseny, la presa de decisions i el bon funcionament de l'aplicació recau exclusivament sobre l'autor del recurs.<br>
En cap cas les visualitzacions han estat generades de manera autònoma ni tampoc s'han emprat dades sensibles en la seva construcció.<br>
Aquest ús està alineat amb les directrius de la UOC sobre IA generativa ([Guia de citació de IA](https://openaccess.uoc.edu/bitstream/10609/148823/1/U2_17_GuiaCitarIA_CAT.pdf)), garantint transparència i integritat en el procés.**

## Execució
La narrativa visual és intuïtiva i interactiva. No es requereix cap instal·lació addicional i per ser consultada només cal accedir a l'[aplicació web](https://e26vc3-eric-farran.shinyapps.io/PRA2/).

## Llicència

Aquest treball està sota llicència [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
