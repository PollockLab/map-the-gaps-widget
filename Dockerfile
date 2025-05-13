FROM rocker/shiny:4.2.1
RUN install2.r rsconnect htmltools bslib mapgl shiny shinythemes
WORKDIR /home/mapthegap
COPY app.R app.R 
COPY deploy.R deploy.R
CMD Rscript deploy.R
