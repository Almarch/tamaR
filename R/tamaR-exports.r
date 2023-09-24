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

setRcppClass(Class = "Tama",
             CppClass = "Tama",
             module = "Tamalib",
             #fields = list(icons = "list"),
             methods = list(

    display = function() {
        layout(matrix(c(2,3,4,5,
                        1,1,1,1,
                        6,7,8,9),
                ncol = 4,
                nrow = 3,
                byrow = T),
                heights = c(1,2,1))
        par(mai = rep(0,4))
        plot(as.raster(1-.self$GetMatrix()),interpolate=F)
        par(mai = rep(1/2.54,4))
        ics = .self$GetIcon()
        if(ics[1]) plot(icons$food)       else plot.new()
        if(ics[2]) plot(icons$lights)     else plot.new()
        if(ics[3]) plot(icons$game)       else plot.new()
        if(ics[4]) plot(icons$medicine)   else plot.new()
        if(ics[5]) plot(icons$bathroom)   else plot.new()
        if(ics[6]) plot(icons$status)     else plot.new()
        if(ics[7]) plot(icons$training)   else plot.new()
        if(ics[8]) plot(icons$attention)  else plot.new()
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

    shiny = function(){

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
                .self$display()
            })
        }

    #if(!input$mute & tama$GetFreq() != freq){
    #  freq  = tama$GetFreq()
    #  pause(sound)
    #  sound = play(sin(2*pi*freq*tps), rate = rate)
    #}

        shinyApp(ui, server)
    }
))