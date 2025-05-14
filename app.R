# install mapgl if not already installed
list.of.packages <- c("mapgl")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(mapgl)
library(shiny)
library(bslib)
library(shinythemes)

ui <- page_sidebar(
  title = "Map the gaps!",
  
  sidebar = sidebar(
    selectInput("taxa",
      selected = "plant",
      "Select a species group",
      choices = c("Reptiles" = "ar", 
                  "Mammals" = "mammal", 
                  "Plants" = "plant", 
                  "Vertebrates" = "vert"))
    ),
  
  card(
    full_screen = TRUE,
    maplibreCompareOutput("map")
  ),
  # Use the darkly theme
  theme = shinythemes::shinytheme("sandstone")
)

server <- function(input, output, session) {
  
  sel_taxa <- reactive({
    
    readRDS(paste0("outputs/m-richness-", input$taxa, ".rds"))

  })
  
  sel_io_url <- reactive({
    
    if(input$taxa == "mammal"){
      taxonname = "Mammalia"
    }
    if(input$taxa == "plant"){
      taxonname = "Plantae"
    }
    if(input$taxa == "ar"){
      taxonname = "Reptilia" ## NOTE: this is wrong, we need Amphibia too but trying for now ----
    }
    if(input$taxa == "vert"){
      taxonname = "Animalia" ## NOTE: this is wrong, Animalia has inverts too ----
    }
    
    paste0("https://tiler.biodiversite-quebec.ca/cog/tiles/{z}/{x}/{y}?url=https://object-arbutus.cloud.computecanada.ca/bq-io/io/inat_canada_heatmaps/",taxonname, "_density_inat_1km.tif&rescale=0,1&colormap_name=magma&bidx=1&expression=b1")
  })
  
  output$map <- renderMaplibreCompare({
    
    m1 = maplibre(bounds = c(-177.40777,35.93066,-12.79625,71.44204), 
                  style = carto_style("dark-matter")) |>
      add_raster_source(
        id = "inat",
        tiles= sel_io_url()
      ) |>
      add_raster_layer(
        id = 'inat-layer',
        source = 'inat',
        raster_opacity = .5
      ) |> 
      add_fullscreen_control(position = "top-left") |> 
      add_navigation_control()
    
    mapgl::compare(m1, sel_taxa())
  })
    
}

shinyApp(ui, server)