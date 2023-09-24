#' Instanciate a Tama object
#' 
#' @name Tama
#' @return
#' A tamagotchi
#' 
#' @examples
#' guizmo = Tama()
#' guizmo$display()
#' guizmo$click("B"); Sys.sleep(3)
#' for(i in 1:7) {guizmo$click("A"); Sys.sleep(.25)}
#' guizmo$display()
#' guizmo$save("tmp.txt")
#' guizmo$load("tmp.txt")
#' 
#' @export Tama
#' @exportClass Tama
#' 
#' 

bg = readPNG("img/background.png")
icons = list()
for(ics in c("attention","bathroom","food","game",
             "lights","medicine","status","training")){
    icons[[ics]] = readPNG(paste0("img/",ics,".png"))
}

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
        if(ics[1]) rasterImage(icons$food     ,  2,26.5, 6,29.5)
        if(ics[2]) rasterImage(icons$lights   , 10,26.5,14,29.5)
        if(ics[3]) rasterImage(icons$game     , 18,26.5,22,29.5)
        if(ics[4]) rasterImage(icons$medicine , 26,26.5,30,29.5)
        if(ics[5]) rasterImage(icons$bathroom ,  2, 2.5, 6, 5.5)
        if(ics[6]) rasterImage(icons$status   , 10, 2.5,14, 5.5)
        if(ics[7]) rasterImage(icons$training , 18, 2.5,22, 5.5)
        if(ics[8]) rasterImage(icons$attention, 26, 2.5,30, 5.5)

    },

    click = function(button = c("A","B","C"),delay = .25){

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

    shiny = function(background = NULL, port = 1996){

        options(shiny.port = port)

        ui = pageWithSidebar(
            headerPanel(""),
            sidebarPanel(
            splitLayout(actionButton("A"," "),
                        actionButton("B"," "),
                        actionButton("C"," "))#,
            #checkboxInput("mute", "mute", value = TRUE)
            ),
            mainPanel(plotOutput("screen"))
        )

        server = function(input,output,session){

            autoInvalidate <- reactiveTimer(1000/6, session)

            #freq  = 0
            #rate = 44100
            #tps = seq(0,10, length.out = 10 * rate)
            #sound = play(0)

            observeEvent(input$A,.self$click("A"))
            observeEvent(input$B,.self$click("B"))
            observeEvent(input$C,.self$click("C"))

            output$screen = renderPlot({
                autoInvalidate()
                .self$display(background = background)
            })
        }

    #if(!input$mute & tama$GetFreq() != freq){
    #  freq  = tama$GetFreq()
    #  pause(sound)
    #  sound = play(sin(2*pi*freq*tps), rate = rate)
    #}

        shinyApp(ui, server)
    },

    secret = function(){
        rom = .self$GetROM()
        rom[7658:7824] = as.numeric(as.hexmode(c(
            "39","c7","93","99","c2","9c","29","14",
            "98","49","c4","98","49","14","9c","29",
            "c2","93","99","d7","99","31","70","90",
            "9","a3","9d","49","88","91","29","14",
            "91","69","10","91","69","14","91","29",
            "28","9a","49","c3","98","1","0","90",
            "39","c7","93","99","c2","9c","29","14",
            "9c","49","e4","9c","49","14","9c","29",
            "c2","93","99","d7","99","31","70","90",
            "9","87","9e","89","90","92","49","28",
            "92","a9","24","92","a9","28","92","49",
            "10","98","89","d7","9a","1","0","90",
            "9","18","9a","49","a4","9c","49","2",
            "9c","29","ca","90","29","4","90","29",
            "3a","9c","e9","96","95","21","30","90",
            "9","60","99","9","90","98","89","14",
            "9d","49","c4","90","49","2","90","79",
            "1f","9e","9","90","95","1","30","90",
            "9","60","99","9","90","98","89","4",
            "9d","49","c4","90","49","2","90","79",
            "2f","9d","9","90","95","1","30")))
        .self$SetROM(rom)
    }
))