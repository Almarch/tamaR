FROM r-base:4.2.0

RUN mkdir -p /app/tamaR
ADD . /app/tamaR
WORKDIR /app

RUN R -e "source('tamaR/src/TamaRomConvert.r')" \
    && R -e "install.packages(c('Rcpp','shiny','png'))" \
    && R CMD build tamaR \
    && R CMD INSTALL tamaR_1.0.0.tar.gz \
    && rm tamaR_1.0.0.tar.gz \
    && rm -r tamaR


CMD R -e "library('tamaR'); guizmo = Tama(); guizmo\$run(); guizmo\$shiny(port = 8000, host =  '0.0.0.0')"

EXPOSE 8000