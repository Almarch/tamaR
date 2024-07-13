FROM rocker/shiny:4.1.0

RUN R -e "install.packages('Rcpp')"
RUN R -e "install.packages('png')"
RUN R -e "install.packages('bsplus')"
RUN R -e "install.packages('auth0')"

RUN mkdir -p /app/tamaR
ADD . /app/tamaR

WORKDIR /app

RUN if ! [ -f "tamaR/src/rom.h" ]; then \
        R -e "source('tamaR/src/TamaRomConvert.r')"; \
    fi \
    && R CMD build tamaR \
    && R CMD INSTALL tamaR_*.tar.gz

CMD R -e "library('tamaR'); Tama() |> go(port = 80, host =  '0.0.0.0')"

EXPOSE 80