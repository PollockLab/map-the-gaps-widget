# Base R Shiny image
FROM rocker/geospatial

# Make a directory in the container
RUN mkdir /home/mapthegap

# Install R dependencies
RUN R -e "install.packages(c('pak')); \
          pak::pak(c('mapgl'))"

# Copy the Shiny app code
COPY app.R /home/mapthegap/app.R

# Run the R Shiny app
CMD ["R", "-e", "library(shiny); setwd('/home/mapthegap/'); addResourcePath('www', '/home/mapthegap/www'); source('app.R')"]