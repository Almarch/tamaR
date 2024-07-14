#' A Shiny application to play with your virtual pet
#'
#' @name go
#' @param tama An object of class Tama
#' @param background A png image to use as background. It should be square and imported using png::readPNG
#' @param port The port to use for shiny, default is 1996
#' @param host The host to use for shiny, default is "127.0.0.1" (localhost)
#' @param light Should a lighter version of the app be used ? This is more adapted for non-web deployment. Default is FALSE
#' @export go
#' @examples
#' guizmo = Tama()
#' go(Guizmo)
#' 
#' 

go = function(tama, background = NULL, port = 1996, host = "127.0.0.1", light = FALSE){

    options(shiny.port = port,
            shiny.host = host)

    credentials <- data.frame(
        user     = c("player", "admin"),
        password = c("qwerty", "qwerty"))

    settings = list(
        background = background,
        autocare = F,
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

    ui <- secure_app(ui)

    server = function(input,output,session){

        ### Reactive values
        etc <- reactiveValues()
        etc[["t0"]]    = Sys.time()
        etc[["todo"]]  = list(actions = c(), wait = 0)
        etc[["busy"]]  = F
        etc[["dead"]]  = F
        etc[["doing"]] = ""
        etc[["stats"]] = c(hunger = 4, #nb of full hearts
                            happiness = 4)
        etc[["scold"]] = F
        etc[["egg"]]   = T
        etc[["next_check"]] = 0
        etc[["running"]]   = settings$running
        etc[["autocare"]]  = settings$autocare

        res_auth <- secure_server(
            check_credentials = check_credentials(credentials)
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
                output$startstop = renderUI(actionButton("stop","STOP",class="big"))
                output$admin = renderUI(ui_admin_accordion(running = T, autocare = settings$autocare))
            } else {
                output$startstop = renderUI(actionButton("start","START",class="big"))
                output$admin = renderUI(ui_admin_accordion(running = F, autocare = settings$autocare))
            }
        })
            

        ### register player password
        observeEvent(input$save_pass_player,{
            if(input$pass_player == "") {
                shinyalert("Error", "Player password cannot be null", type = "error")
            } else {
                credentials$password[which(credentials$user == "player")] <<- input$pass_player
                updateTextInput(session,"pass_player","Save player password:","")
                shinyalert("Success", "Player password has been updated", type = "success")
            }
        })

        ### register admin password
        observeEvent(input$save_pass_admin,{
            if(input$pass_admin == "") {
                shinyalert("Error", "Admin password cannot be null", type = "error")
            } else {
                credentials$password[which(credentials$user == "admin")] <<- input$pass_admin
                updateTextInput(session,"pass_admin","Save admin password:","")
                shinyalert("Success", "Admin password has been updated", type = "success")
            }
        })

        ### admin board
        observeEvent(input$autocare,{
            settings$autocare  <<- !settings$autocare
            etc[["autocare"]] = settings$autocare
        })

        observe({
            if(etc[["autocare"]]) {
                output$ui_autocare = renderUI(ui_autocare_switch())
                updateActionButton(session,"autocare","disable automatic care")
            } else {
                output$ui_autocare = renderUI(br())
                updateActionButton(session,"autocare","enable automatic care")
            }
        })

        observeEvent(input$care, {
            if(input$care) {
                shinyjs::show("disc")
                shinyjs::show("disc_tag")
            } else {
                shinyjs::hide("disc")
                shinyjs::hide("disc_tag")
            }
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

    #     ## care routine
    #     observe({
    #         if(!etc[["busy"]]) {
    #             etc[["busy"]] = T

    #             t1 = Sys.time()
    #             elapsed = as.numeric(difftime(t1,etc[["t0"]],units = "sec"))
    #             etc[["t0"]] = t1

    #             if(input$care){

    #                 ### if it's an egg, set the clock
    #                 if(etc[["egg"]]) {
    #                     if(is.egg(tama)) {
    #                         etc[["todo"]] = set_clock()
    #                     }
    #                     etc[["egg"]]  = F
    #                 }

    #                 ### if dead, that's over
    #                 if(is.dead(tama)) {
    #                     etc[["dead"]] = T
    #                     etc[["todo"]]$wait = Inf
    #                 }
                    
    #                 ### stop the need to scold if it doesn't cry anymore
    #                 if(!tama$GetIcon()[8]) {
    #                     etc[["scold"]] = F
    #                 }
                    
    #                 ### otherwise, plan an action
    #                 if(is.asleep(tama,"off")){
    #                     etc[["stats"]] = c(hunger = 4,
    #                                     happiness = 4)

    #                 } else if(etc[["todo"]]$wait <= 0 &
    #                         length(etc[["todo"]]$actions) == 0) {

    #                     # end what has been started
    #                     if(etc[["doing"]] != "") {
    #                         if(etc[["doing"]] == "try_to_clean") {
    #                             if(is.dirty(tama,"top")) {
    #                                 # still dirty => asleep, turn the light off
    #                                 etc[["todo"]] = light()
    #                                 etc[["doing"]] = ""
    #                             }

    #                         } else if(etc[["doing"]] == "check_arrow") {
    #                             # now that the arrow is checked, feed
    #                             etc[["todo"]] = feed(ifelse(is.burger(tama),
    #                                             "top",
    #                                             "bottom"),
    #                                         times = 4 - etc[["stats"]]["hunger"])
    #                             etc[["stats"]]["hunger"] = 4
    #                             etc[["doing"]] = ""

    #                         } else if(etc[["doing"]] == "check_status_1") {
    #                             # check hunger
    #                             etc[["stats"]]["hunger"] = nb.hearts(tama)
    #                             etc[["todo"]] = check_status(step = 2)
    #                             etc[["doing"]] = "check_status_2"

    #                         } else if(etc[["doing"]] == "check_status_2") {
    #                             # check happiness
    #                             etc[["stats"]]["happiness"] = nb.hearts(tama)
    #                             etc[["todo"]] = check_status(step = 3)
    #                             etc[["doing"]] = ""

    #                             if(tama$GetIcon()[8] &
    #                             !is.asleep(tama, "on") &
    #                             etc[["stats"]]["hunger"] > 0 &
    #                             etc[["stats"]]["happiness"] > 0){
    #                                 etc[["scold"]] = T
    #                             }
    #                         }

    #                     # check bad screens (clock, light off when not asleep)
    #                     } else if(is.clock(tama)) {
    #                         etc[["todo"]] = unclock()

    #                     } else if(is.dark(tama)) {
    #                         etc[["todo"]] = light()

    #                     # cares
    #                     } else if(is.asleep(tama,"on")) {
    #                         etc[["todo"]] = light()

    #                     } else if(is.dirty(tama,"top")) {
    #                         # double poop: try to clean - or is it asleep ?
    #                         etc[["todo"]] = clean()
    #                         etc[["doing"]] = "try_to_clean"

    #                     } else if(is.dirty(tama,"bottom")) {
    #                         etc[["todo"]] = clean()

    #                     } else if(is.sick(tama)) {
    #                         # heal after double poop that may hide it
    #                         etc[["todo"]] = heal()

    #                     } else if(input$disc & etc[["scold"]]) {
    #                         etc[["todo"]] = scold()
    #                         etc[["scold"]] = F

    #                     } else if(etc[["stats"]]["hunger"] < 4 & !etc[["scold"]]){
    #                         etc[["todo"]] = check_food_arrow()
    #                         etc[["doing"]] = "check_arrow"

    #                     } else if(etc[["stats"]]["happiness"] < 4 & !etc[["scold"]]){

    #                         etc[["todo"]] = play_game(times = min(2,4 - etc[["stats"]]["happiness"]))
    #                         etc[["stats"]]["happiness"] = 4
    #                         etc[["next_check"]] = 0

    #                         # if it's time and it's not sleeping,
    #                         # or if it's crying with no apparent reason
    #                         # reasons: light on when sleeping, hungry, unhappy, to scold
    #                         # hungry and unhappy must be checked, if checked and !=0: "to scold"
    #                     } else if(etc[["t0"]] > etc[["next_check"]] |
    #                                     (tama$GetIcon()[8] &
    #                                     !is.asleep(tama,"on"))) {
    #                             etc[["next_check"]] = etc[["t0"]] + 5*60
    #                             etc[["todo"]] = check_status(step = 1)
    #                             etc[["doing"]] = "check_status_1"
    #                             etc[["scold"]] = F # we will check that
    #                     }
    #                 }
    #             }

    #             ### do what has been planned
    #             if(etc[["todo"]]$wait > 0) {
    #                 etc[["todo"]]$wait = etc[["todo"]]$wait - elapsed
    #             } else {
    #                 if(length(etc[["todo"]]$actions) > 0){

    #                     act = etc[["todo"]]$actions[1]

    #                     if(act %in% c("A","B","C")) {
    #                         tama$click(act)
    #                         etc[["todo"]]$wait =  ifelse(input$care,.4,.1)
    #                     } else {
    #                         etc[["todo"]]$wait = as.numeric(act)
    #                     }

    #                     etc[["todo"]]$actions = etc[["todo"]]$actions[-1]
    #                 }
    #             }
    #         }
    #     })

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
                tama$display(background = settings$background)
                etc[["busy"]] = F
                invalidateLater(1000/6, session)
            })
        })

     }
    shinyApp(ui, server)
}
