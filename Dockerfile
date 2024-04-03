FROM rocker/shiny:4.1.0

RUN mkdir -p /app/tamaR
ADD . /app/tamaR

WORKDIR /app

RUN if ! [ -f "tamaR/src/rom.h" ]; then \
        R -e "source('tamaR/src/TamaRomConvert.r')"; \
    fi \
    && R -e "install.packages(c('Rcpp','png','shinyjs','bsplus'))" \
    && R CMD build tamaR \
    && R CMD INSTALL tamaR_*.tar.gz

CMD R -e "library('tamaR'); guizmo = Tama(); go(guizmo,port = 80, host =  '0.0.0.0')"

EXPOSE 80