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

    #freq  = 0
    #rate = 44100
    #tps = seq(0,10, length.out = 10 * rate)
    #sound = play(0)

    observeEvent(input$A,{
      click(tama,"A")
    })

      observeEvent(input$B,{
      click(tama,"B")
    })

      observeEvent(input$C,{
      click(tama,"C")
    })

      output$screen = renderPlot({
        autoInvalidate()
        plot(tama)
   
        #if(!input$mute & tama$GetFreq() != freq){
        #  freq  = tama$GetFreq()
        #  pause(sound)
        #  sound = play(sin(2*pi*freq*tps), rate = rate)
        #}
      })
  }
shinyApp(ui, server)
}