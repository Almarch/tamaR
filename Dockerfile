FROM rocker/shiny:4.4.1

RUN R -e "install.packages('Rcpp', version = '1.0.13')"
RUN R -e "install.packages('png', version = '0.1-8')"
RUN R -e "install.packages('bsplus', version = '0.1.4')"
RUN R -e "install.packages('shinyjs', version = '2.1.0')"
RUN R -e "install.packages('shinymanager', version = '1.0.410')"
RUN R -e "install.packages('shinyWidgets', version = '0.8.6')"

RUN mkdir -p /app/tamaR
ADD . /app/tamaR

WORKDIR /app

RUN if ! [ -f "tamaR/src/rom.h" ]; then \
        R -e "source('tamaR/R/convert_rom.R'); source('tamaR/R/nb2hex.R'); convert_rom('tamaR/src/rom.bin', 'tamaR/src/rom.h')"; \
    fi \
    && R CMD INSTALL tamaR

CMD R -e "library('tamaR'); Tama() |> go(port = 80, host =  '0.0.0.0', light = FALSE)"

EXPOSE 80