#' Create a tamagotchi in a shiny environment
#'
#' @name tamaShiny
#' @export tamaShiny

tamaShiny = function(tama = NULL){
    #library(audio)

  data(icons)
  if(is.null(tama)) tama = new(Tama)

  ui = pageWithSidebar(
    headerPanel(""),
    sidebarPanel(
      splitLayout(actionButton("A"," "),
                  actionButton("B"," "),
                  actionButton("C"," "))#,
      #checkboxInput("mute", "mute", value = TRUE)
    ),
    mainPanel(
      plotOutput("screen")
    )
  )

  server = function(input,output,session){

    autoInvalidate <- reactiveTimer(1000/6, session)

    lay = matrix(c(2,3,4,5,
                1,1,1,1,
                6,7,8,9),
              ncol = 4,
              nrow = 3,
              byrow = T)

    #freq  = 0
    #rate = 44100
    #tps = seq(0,10, length.out = 10 * rate)
    #sound = play(0)

    observeEvent(input$A,{
      tama$SetButton(0,T)
      Sys.sleep(.25)
      tama$SetButton(0,F)
    })

      observeEvent(input$B,{
      tama$SetButton(1,T)
      Sys.sleep(.25)
      tama$SetButton(1,F)
    })

      observeEvent(input$C,{
      tama$SetButton(2,T)
      Sys.sleep(.25)
      tama$SetButton(2,F)
    })

      output$screen = renderPlot({
        autoInvalidate()
        layout(lay, heights = c(1,2,1))
        par(mai = rep(0,4))
        plot(as.raster(1-tama$GetMatrix()),interpolate=F)
        par(mai = rep(1/2.54,4))
        if(tama$GetIcon()[1]) plot(icons$food)       else plot.new()
        if(tama$GetIcon()[2]) plot(icons$lights)     else plot.new()
        if(tama$GetIcon()[3]) plot(icons$game)       else plot.new()
        if(tama$GetIcon()[4]) plot(icons$medicine)   else plot.new()
        if(tama$GetIcon()[5]) plot(icons$bathroom)   else plot.new()
        if(tama$GetIcon()[6]) plot(icons$status)     else plot.new()
        if(tama$GetIcon()[7]) plot(icons$training)   else plot.new()
        if(tama$GetIcon()[8]) plot(icons$attention)  else plot.new()
   
        #if(!input$mute & tama$GetFreq() != freq){
        #  freq  = tama$GetFreq()
        #  pause(sound)
        #  sound = play(sin(2*pi*freq*tps), rate = rate)
        #}
      })
  }
shinyApp(ui, server)
}