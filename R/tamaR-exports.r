#' Instanciate a Tama object
#' 
#' @name Tama
#' @return
#' An object of class Tama
#' 
#' @examples
#' guizmo = Tama()
#' guizmo$start()
#' guizmo$display()
#' guizmo$click("B"); Sys.sleep(3)
#' for(i in 1:7) {guizmo$click("A"); Sys.sleep(.25)}
#' guizmo$click("C"); Sys.sleep(3)
#' Sys.sleep(300)
#' guizmo$display()
#' guizmo$save("babytchi.txt")
#' guizmo$stop()
#' guizmo$reset()
#' guizmo$load("babytchi.txt")
#' guizmo$start()
#' 
#' 
#' @export Tama
#' @exportClass Tama
#' 
#' 

setRcppClass(Class = "Tama",
             CppClass = "Tama",
             module = "Tamalib",
             methods = list(

    display = function(background = NULL) {
        if(is.null(background)) background = bg
        tmp = .self$GetMatrix()
        ics = .self$GetIcon()

        main = array(0,dim = c(16,32,4))
        for(i in 1:3) main[,,i] = 1-tmp
        main[,,4] = tmp
        plot(c(0,32),c(0,32),type="n",axes=F,xlab="",ylab="",asp=1)
        rasterImage(background,-1, -1, 33, 33)
        rasterImage(main,0,8,32,24,interpolate = F)
        if(ics[1]) rasterImage(icons$food     ,  2,26.25, 6,29.75)
        if(ics[2]) rasterImage(icons$lights   , 10,26.25,14,29.75)
        if(ics[3]) rasterImage(icons$game     , 18,26.25,22,29.75)
        if(ics[4]) rasterImage(icons$medicine , 26,26.5 ,30,29.75)
        if(ics[5]) rasterImage(icons$bathroom ,  2, 2.5 , 6, 5.5 )
        if(ics[6]) rasterImage(icons$status   , 10, 2.5 ,14, 5.25)
        if(ics[7]) rasterImage(icons$training , 18, 2.5 ,22, 5.5 )
        if(ics[8]) rasterImage(icons$attention, 26, 2.5,30,  5   )

    },

    click = function(button = c("A","B","C"),delay = .1){

        stopifnot(all(button %in% c("A","B","C")))
        stopifnot(delay > 0)

        for(b in button){
            .self$SetButton(c(A = 0, B = 1, C = 2)[b],T)
        }
        Sys.sleep(delay)
        for(b in button){
            .self$SetButton(c(A = 0, B = 1, C = 2)[b],F)
        }
    },

    save = function(file){
        state = .self$GetCPU()
        state = as.character(as.hexmode(state))
        cat(c(state,"\n"),file = file, append = F)
    },

    load = function(file){
        state = readLines(file)
        state = unlist(strsplit(state,split=" ", fixed=T))
        state = as.numeric(as.hexmode(state))
        .self$SetCPU(state)
    },

    reset = function(){
        init = rep(0,384)
        init[ 2] = 1
        init[ 9] = 1
        init[33] = 96
        init[34] = 219
        init[35] = 127
        init[36] = 42
        init[37] = 203
        init[38] = 113
        init[44] = 12
        init[48] = 10
        init[52] = 8
        init[56] = 6
        init[60] = 4
        init[64] = 2
        .self$SetCPU(init)
    },

    glimpse = function(delay = .1){
    .self$start()
    Sys.sleep(delay)
    .self$stop()
} 
))