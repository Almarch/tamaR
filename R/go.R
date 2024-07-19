#' A Shiny application to play with your virtual pet
#'
#' @name go
#' @param tama An object of class Tama
#' @param background A png image to use as background. It should be square and imported using png::readPNG
#' @param port The port to use for shiny, default is 1996
#' @param host The host to use for shiny, default is "127.0.0.1" (localhost)
#' @param light Should a lighter version of the app be used ? This is more adapted for non-web deployment. Default is TRUE
#' @export go
#' @examples
#' guizmo = Tama()
#' guizmo$start()
#' go(guizmo, light = T)


go = function(tama, background = NULL, port = 1996, host = "127.0.0.1", light = TRUE){

    options(shiny.port = port,
            shiny.host = host)
    refresh_rate = 1000/6 # ms

    credentials <- data.frame(
        user     = c("player", "admin"),
        password = c("qwerty", "qwerty"))

    settings = list(
        background = background,
        enable_care = F,
        running = F,
        ROM = tama$GetROM()
    )

    ui <- fluidPage(
        title = "TaMaGoTcHi",
        useShinyjs(),
        tags$head(
            tags$link(rel  = "icon shortcut",
                      type = "image/png",
                      href = "www/icon.png"),
            tags$link(rel  = "stylesheet",
                      type = "text/css",
                      href = "www/styles.css")
        ),
        headerPanel(""),
        mainPanel(
            uiOutput("UI")
        )
    )

    if(light) {
        server = function(input,output,session){

        ### Reactive values
        etc <- reactiveValues()

        output$UI = renderUI(ui_player())

        ## Original gameplay
        observeEvent(input$A, tama$click("A"))
        observeEvent(input$B, tama$click("B"))
        observeEvent(input$C, tama$click("C"))

        ## display screen
        observe({
            output$screen = renderPlot({
                tama$display(
                    background = settings$background
                )
                invalidateLater(
                    refresh_rate,
                    session
                )
            })
        })
     }
    } else {
        ui <- secure_app(ui) 
        server = function(input,output,session){

            ### Reactive values
            etc <- reactiveValues()

            etc[["state"]] = state_init()
            etc[["busy"]]  = F
            etc[["running"]]   = settings$running
            etc[["enable_care"]]  = settings$enable_care
            etc[["care"]] = F
            etc[["disc"]] = F

            res_auth <- secure_server(
                check_credentials = check_credentials(
                    credentials
                )
            )

            observe({
                user = reactiveValuesToList(res_auth)$user
                if(length(user)>0) {
                    if(user == "player") {
                        output$UI = renderUI(ui_player())
                    } else if(user == "admin") {
                        output$UI = renderUI(ui_admin())
                    }
                }
            })

            observe({
                if(etc[["running"]]) {
                    output$startstop = renderUI(
                        splitLayout(
                            actionButton(
                                "stop",
                                "STOP",
                                class="big"
                            ),
                        cellWidths = c("30%")
                        )
                    )
                    output$admin = renderUI(
                        ui_admin_accordion(
                            running = T,
                            enable_care = settings$enable_care
                        )
                    )
                } else {
                    output$startstop = renderUI(
                        splitLayout(
                            actionButton(
                                "start",
                                "START",
                                class="big"
                            ),
                        cellWidths = c("30%")
                        )
                    )
                    output$admin = renderUI(
                        ui_admin_accordion(
                            running = F,
                            enable_care = settings$enable_care
                        )
                    )
                }
            })
                

            ### register player password
            observeEvent(input$save_pass_player,{
                if(input$pass_player == "") {
                    show_alert(
                        "Error",
                        "Player password cannot be null",
                        type = "error"
                    )
                } else {
                    credentials$password[which(credentials$user == "player")] <<- input$pass_player
                    updateTextInput(
                        session,
                        "pass_player",
                        "Player password:",
                        ""
                    )
                    show_alert(
                        "Success",
                        "Player password has been updated",
                        type = "success"
                    )
                }
            })

            ### register admin password
            observeEvent(input$save_pass_admin,{
                if(input$pass_admin == "") {
                    show_alert(
                        "Error",
                        "Admin password cannot be null",
                        type = "error"
                    )
                } else {
                    credentials$password[which(credentials$user == "admin")] <<- input$pass_admin
                    updateTextInput(
                        session,
                        "pass_admin",
                        "Admin password:",
                        ""
                    )
                    show_alert(
                        "Success",
                        "Admin password has been updated",
                        type = "success"
                    )
                }
            })

            ### admin board
            observeEvent(input$enable_care,{
                settings$enable_care  <<- !settings$enable_care
                etc[["enable_care"]] = settings$enable_care
                if(!settings$enable_care) {
                    etc[["care"]] = F
                }
            })

            observe({
                if(etc[["enable_care"]]) {
                    output$ui_care = renderUI(ui_care_switch())
                    updateActionButton(
                        session,
                        "enable_care",
                        "Disable automatic care"
                    )
                } else {
                    output$ui_care = renderUI(br())
                    updateActionButton(
                        session,
                        "enable_care",
                        "Enable automatic care"
                    )
                }
            })

            observeEvent(input$care, {
                if(input$care) {
                    shinyjs::show("disc")
                    etc[["care"]] = T
                } else {
                    shinyjs::hide("disc")
                    etc[["care"]] = F
                    etc[["disc"]] = F
                }
            })

            observeEvent(input$disc,{
                etc[["disc"]] = input$disc
            })

            observeEvent(input$start,{
                tama$start()
                settings$running <<- T
                etc[["running"]]  <- T
            })

            observeEvent(input$stop,{
                tama$stop()
                settings$running <<- F
                etc[["running"]]  <- F
            })

            observeEvent(input$p2,{
                tama$stop()
                p2(tama)
                settings$background <<- bg2
                tama$glimpse()
            })

            observeEvent(input$reset_aes,{
                tama$stop()
                settings$background <<- NULL
                tama$SetROM(settings$ROM)
                tama$glimpse()
            })

            observeEvent(input$reset_state,{
                tama$stop()
                tama$reset()
                tama$glimpse()
            })

            output$save_state <- downloadHandler(
                filename = "save.txt",
                content = function(file) {
                    tama$stop()
                    state = tama$GetCPU()
                    state = nb2hex(state)
                    write(state, file)
                }
            )

            observeEvent(input$load_state,{
                tama$stop()
                inFile <- input$load_state
                try({
                    state = readLines(inFile$datapath)
                    state = hex2nb(state)
                    tama$SetCPU(state)
                    tama$glimpse()
                })
            })

            output$save_rom <- downloadHandler(
                filename = "rom.h",
                content = function(file) {
                    tama$stop()
                    rom = tama$GetROM()
                    rom = nb2hex(rom)
                    write(rom, file)
                }
            )

            observeEvent(input$load_rom,{
                tama$stop()
                inFile <- input$load_rom
                try({
                    rom = readLines(inFile$datapath)
                    rom = hex2nb(rom)
                    tama$SetROM(rom)
                    tama$glimpse()
                })
            })

            observeEvent(input$background,{
                inFile <- input$background
                try({
                    bg = readPNG(inFile$datapath)
                    settings$background <<- bg
                })
            })

            ## care routine
            observe({
                if(etc[["enable_care"]])
                    if(etc[["care"]])
                        if(!etc[["busy"]]) {
                            etc[["busy"]] = T
                            etc[["state"]] = care_step(
                                tama  = tama,
                                state = etc[["state"]], 
                                time  = Sys.time(),
                                disc  = etc[["disc"]]
                            )
                }
            })

            ## Original gameplay
            observeEvent(input$A, tama$click("A"))
            observeEvent(input$B, tama$click("B"))
            observeEvent(input$C, tama$click("C"))

            observeEvent(input$a, tama$click("A"))
            observeEvent(input$b, tama$click("B"))
            observeEvent(input$c, tama$click("C"))
            observeEvent(input$ac,tama$click(c("A","C"),2))

            ## display screen
            observe({
                output$screen = renderPlot({
                    tama$display(
                        background = settings$background
                    )
                    etc[["busy"]] = F
                    invalidateLater(
                        refresh_rate,
                        session
                    )
                })
            })
        }
    }

    shinyApp(ui, server)
}
