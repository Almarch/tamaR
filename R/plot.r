#' Plot S3 method for Tama objects
#' 
#' @name plot.Tama
#' @param x a Tama object
#' @examples 
#' tama = new(Tama)
#' plot(Tama)
#' 
#' @export plot
#' 
#' 

if(!isGeneric("plot")){
    setGeneric("plot", function(x, y, ...)
       standardGeneric("plot"))
}

setMethod("plot",
    signature(x = "Tama"),
    function(x) {
        data(icons)
        layout(matrix(c(2,3,4,5,
                        1,1,1,1,
                        6,7,8,9),
                ncol = 4,
                nrow = 3,
                byrow = T),
                heights = c(1,2,1))
        par(mai = rep(0,4))
        plot(as.raster(1-x$GetMatrix()),interpolate=F)
        par(mai = rep(1/2.54,4))
        if(x$GetIcon()[1]) plot(icons$food)       else plot.new()
        if(x$GetIcon()[2]) plot(icons$lights)     else plot.new()
        if(x$GetIcon()[3]) plot(icons$game)       else plot.new()
        if(x$GetIcon()[4]) plot(icons$medicine)   else plot.new()
        if(x$GetIcon()[5]) plot(icons$bathroom)   else plot.new()
        if(x$GetIcon()[6]) plot(icons$status)     else plot.new()
        if(x$GetIcon()[7]) plot(icons$training)   else plot.new()
        if(x$GetIcon()[8]) plot(icons$attention)  else plot.new()
})

