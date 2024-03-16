FROM r-base:4.2.0

RUN mkdir -p /app/tamaR
ADD . /app/tamaR

WORKDIR /app

RUN R -e "source('tamaR/src/TamaRomConvert.r')" \
    && R -e "install.packages(c('Rcpp','shiny','png','shinyjs'))" \
    && R CMD build tamaR \
    && R CMD INSTALL tamaR_*.tar.gz

CMD R -e "library('tamaR'); guizmo = Tama(); guizmo\$run(); go(guizmo,port = 80, host =  '0.0.0.0')"

EXPOSE 80