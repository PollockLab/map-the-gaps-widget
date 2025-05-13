library(mapgl)

url <- "https://object-arbutus.cloud.computecanada.ca/bq-io/io/inat_canada_heatmaps/All_density_inat_1km.tif"
densmap <- rast(url)
# vals <- global(densmap, "range", na.rm = TRUE) |>
#   unlist(use.names = FALSE) |>
#   round(2)
# 
bounds <- st_bbox(densmap) |>
    st_as_sfc(crs = st_crs(densmap)) |>
    st_transform(crs = 4326) |>
    st_bbox() |>
    as.numeric()
saveRDS(bounds, "~/Documents/GitHub/blitzthegap-story-mapgl-mapthegap/bounds.rds")


m1 = maplibre(bounds = bounds, 
         style = carto_style("dark-matter")) |>
  add_raster_source(
    id = "inat",
    tiles="https://tiler.biodiversite-quebec.ca/cog/tiles/{z}/{x}/{y}?url=https://object-arbutus.cloud.computecanada.ca/bq-io/io/inat_canada_heatmaps/Mammalia_density_inat_1km.tif&rescale=0,1&colormap_name=magma&bidx=1&expression=b1"
  ) |>
  add_raster_layer(
    id = 'inat-layer',
    source = 'inat',
    raster_opacity = .5,
  ) |> 
  add_fullscreen_control(position = "top-left") |> 
  add_navigation_control()
m1
saveRDS(m1, "outputs/m1-bdqc.rds")


## make maps for each taxa

map_taxa = function(taxa){
  
  if(taxa == "plant"){
    richness = terra::rast(paste0(here::here(), "/data/",taxa,".richness.tif"))[[1]]
  } else {
    richness = terra::rast(paste0(here::here(), "/data/",taxa,".richness.tif"))
  }
  
  m = maplibre(bounds = bounds, 
               style = carto_style("voyager")) |>
    add_image_source(id = "richness",
                     data = richness,
                     colors = viridis::magma(20)
    ) |>
    add_raster_layer(
      id = 'richness-layer',
      source = 'richness',
      raster_opacity = 0.7
    ) 
  
  saveRDS(m, paste0(here::here(), "/outputs/m-richness-",taxa,".rds"))
}

map_taxa("ar")
map_taxa("plant")
map_taxa("vert")
map_taxa("mammal")


# 
# 
# 
# inat_raw = terra::rast("data/Mammalia_density_inat_1km.tif")
# canada = terra::vect("data/canada-polygon/canada.outline.shp")
# canada = project(canada, crs(inat_raw))
# inat = crop(inat_raw, canada, mask = TRUE) |>
#   aggregate(factor = 10, fun = "sum") |>
#   aggregate(factor = 10, fun = "sum") |>
#   aggregate(factor = 10, fun = "sum") |>
#   aggregate(factor = 10, fun = "sum") |>
#   aggregate(factor = 10, fun = "sum")
# inat = sqrt(inat)
# saveRDS(inat, "data/inat_mammalia.rds")
# 
# m1 = maplibre(bounds = bounds, 
#               style = carto_style("voyager")) |>
#   add_image_source(id = "inat",
#                    data = inat,
#                    colors = viridis::turbo(5)
#   ) |>
#   add_raster_layer(
#     id = 'inat-layer',
#     source = 'inat',
#     raster_opacity = 1, raster_fade_duration = 0
#   ) 
# m1
# saveRDS(m1, "outputs/m1.rds")
# 
# richness = terra::rast("data/mammal.richness.tif")
# m2 = maplibre(bounds = bounds, 
#          style = carto_style("voyager")) |>
#   add_image_source(id = "richness",
#                    data = richness,
#                    colors = viridis::turbo(20)
#   ) |>
#   add_raster_layer(
#     id = 'richness-layer',
#     source = 'richness',
#     raster_opacity = 0.7
#   ) 
# saveRDS(m2, "outputs/m2.rds")
# 
# mapgl::compare(m1, m2) 
# 
# m2 = readRDS("outputs/m2.rds")
# m2
# 
# 
# library(rgbif)
# temp = map_fetch(country = "CA",base_style = "gbif-dark")
# 
# maplibre(bounds = bounds, 
#               style = carto_style("voyager")) |>
#   add_image_source(id = "gbif", 
#                     url = "https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@2x.png?srs=EPSG:4326&bin=square&squareSize=16&taxonKey=359&country=CA&hasCoordinateIssue=false&style=purpleYellow-noborder.poly") |>
#   add_fill_layer(id = "gbif-layer",
#                  source = "gbif")
#   
#   ../../../map/occurrence/density/{z}/{x}/{y}@2x.png?srs=EPSG:4326&bin=square&squareSize=16&taxonKey=359&country=CA&hasCoordinateIssue=false&style=purpleYellow-noborder.poly
#   add_box_source(
#     id = "inat",
#     tiles ="https://tile.gbif.org/omt/{z}/{x}/{y}@2x.png?style=gbif-dark&bin=square&squareSize=16&taxonKey=359&country=CA&hasCoordinateIssue=false&style=purpleYellow-noborder.poly"
#   ) |>
#   add_raster_layer(
#     id = 'inat-layer',
#     source = 'inat',
#     raster_opacity = 0.7
#   ) |> 
#   add_fullscreen_control(position = "top-left") |> 
#   add_navigation_control()
# 
# leaflet() %>% 
#   addTiles() %>%
#   addTiles(urlTemplate='https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?style=scaled.circles&taxonKey=359&country=CA') 
# 
# 
