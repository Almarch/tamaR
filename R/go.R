#' A Shiny application to play with your virtual pet
#'
#' @name go
#' @param tama An object of class Tama
#' @param background A png image to use as background. It should be square and imported using png::readPNG
#' @param port The port to use for shiny, default is 1996
#' @param host The host to use for shiny, default is "127.0.0.1" (localhost)
#' @export go
#' @examples
#' guizmo = Tama()
#' go(Guizmo)
#' 
#' 

go = function(tama, background = NULL, port = 1996, host = "127.0.0.1"){

    options(shiny.port = port,
            shiny.host = host)

    tama$stop()
    settings = list(
        password = c(admin = "",
                     user  = ""),
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

        ### First connection screen
        fluidRow(column(12,splitLayout(
            textInput("pass_admin","Administrator password:"),
            actionButton("save_pass_admin","Save",class="menu"))
        )),

        ### Game screen
        fluidRow(column(12,
            mainPanel(plotOutput("screen"))
        )),

        ### Log in prompt
        fluidRow(column(12,splitLayout(
            textInput("pass","Password:"),
            actionButton("log_in","Log in", class = "menu"))
        )),

        ### Buttons
        fluidRow(column(12,
            splitLayout(
                actionButton("A","",class="big"),
                actionButton("B","",class="big"),
                actionButton("C","",class="big")
            ),
            align = "center"
        )),

        fluidRow(column(12,
            splitLayout(
                uiOutput("startstop"),
                actionButton("back","BACK"  ,class="big")
            ),
            align = "center"
        )),
        
        br(),
        
        fluidRow(
            column(12,splitLayout(
                checkboxInput("care", "Automatic care",      value = F),
                checkboxInput("disc", "Care for discipline", value = T))
        )),

        ### Admin board
        fluidRow(column(12,
            uiOutput("admin")
        ))
    )

    server = function(input,output,session){

        ### Reactive values
        etc <- reactiveValues()
        etc[["t0"]]    = Sys.time()
        etc[["todo"]]  = list(actions = c(), wait = 0, unclick = F)
        etc[["busy"]]  = F
        etc[["dead"]]  = F
        etc[["doing"]] = ""
        etc[["stats"]] = c(hunger = 4, #nb of full hearts
                            happiness = 4)
        etc[["scold"]] = F
        etc[["egg"]]   = T
        etc[["next_check"]] = 0
        etc[["logged_in"]] = c(admin = F,
                                user  = F)
        etc[["running"]] = settings$running
        etc[["autocare"]] = settings$autocare

        etc[["freq"]] = 0

        ### Conditionnal UI
        observe({
            if(etc[["running"]]) {

                output$startstop = renderUI(actionButton("stop","STOP",class="big"))
                output$admin = renderUI(
                    bsplus::bs_accordion(id = "admin_running") |> bs_set_opts(
                        panel_type = "info"
                    ) |> bs_append(
                        title = "User settings",
                        content = fluidRow(column(12,
                            splitLayout(
                                textInput("pass_user","User password:"),
                                actionButton("save_pass_user","Save",class="menu")
                            ),
                            br(),
                            fluidRow(column(12,
                                actionButton("autocare",
                                ifelse(settings$autocare,
                                "disable automatic care",
                                "enable automatic care"))
                            )),
                            align = "center"
                        ))
                    ) |> bs_append(
                        title = "Play as admin",
                        content = fluidRow(column(12,
                            splitLayout(
                                actionButton("a","A",class="mid"),
                                actionButton("b","B",class="mid"),
                                actionButton("c","C",class="mid"),
                                actionButton("ac","A+C",class="mid")
                            ),
                            align = "center"
                        ))
                    )
                )
            } else {
                output$startstop = renderUI(actionButton("start","START",class="big"))
                output$admin = renderUI(
                    
                    bsplus::bs_accordion(id = "admin_stopped") |> bs_set_opts(
                        panel_type = "warning"
                    ) |> bs_append(
                        title = "User settings",
                        content = fluidRow(column(12,
                            splitLayout(
                                textInput("pass_user","User password:"),
                                actionButton("save_pass_user","Save",class="menu")
                            ),
                            br(),
                            fluidRow(column(12,
                                actionButton("autocare",
                                ifelse(settings$autocare,
                                "disable automatic care",
                                "enable automatic care"))
                            )),
                            align = "center"
                        ))
                    ) |> bs_append(
                        title = "Aesthetics",
                        content = fluidRow(column(12,
                            splitLayout(
                                actionButton("p2","Switch to P2 sprites"),
                                fileInput("background","Change background", multiple = FALSE)
                            ),
                            br(),
                            splitLayout(
                                downloadButton("save_rom", "Dump the ROM"),
                                fileInput("load_rom", "Load a ROM", multiple = FALSE)
                            ),
                            br(),
                            actionButton("reset_aes","Reset all aesthetics"),
                            align = "center"
                        ))
                    ) |> bs_append(
                        title = "Game state",
                        content = fluidRow(column(12,
                            splitLayout(
                                downloadButton("save_state", "Save the game"),
                                fileInput("load_state", "Load a game", multiple = FALSE)
                            ),
                            br(),
                            actionButton("reset_state","Reset the game"),
                            align = "center"
                        ))
                    )
                )
            }
        })
            
        observe({

            if(etc[["autocare"]]){
                updateActionButton(session,"autocare","disable automatic care")
            } else {
                updateActionButton(session,"autocare","enable automatic care")
            }

            if(settings$password["admin"] == ""){

                shinyjs::show("pass_admin")
                shinyjs::show("save_pass_admin")
                shinyjs::hide("screen")
                shinyjs::hide("pass")
                shinyjs::hide("log_in")
                shinyjs::hide("A")
                shinyjs::hide("B")
                shinyjs::hide("C")
                shinyjs::hide("care")
                shinyjs::hide("disc")
                shinyjs::hide("admin")
                shinyjs::hide("startstop")
                shinyjs::hide("back")

            } else {

                shinyjs::show("screen")
                shinyjs::hide("pass_admin")
                shinyjs::hide("save_pass_admin")

                if(etc[["logged_in"]]["admin"]) {

                    shinyjs::hide("pass")
                    shinyjs::hide("log_in")
                    shinyjs::hide("A")
                    shinyjs::hide("B")
                    shinyjs::hide("C")
                    shinyjs::hide("care")
                    shinyjs::hide("disc")
                    shinyjs::show("admin")
                    shinyjs::show("startstop")
                    shinyjs::show("back")

                } else if(etc[["logged_in"]]["user"]) {
                    
                    shinyjs::hide("pass")
                    shinyjs::hide("log_in")
                    shinyjs::hide("admin")
                    shinyjs::hide("startstop")
                    shinyjs::hide("back")

                    if(etc[["autocare"]]) {

                        shinyjs::show("care")

                        if(input$care){

                            shinyjs::hide("A")
                            shinyjs::hide("B")
                            shinyjs::hide("C")
                            shinyjs::show("disc")

                        } else {

                            shinyjs::show("A")
                            shinyjs::show("B")
                            shinyjs::show("C")
                            shinyjs::hide("disc")

                        }
                    } else {

                        shinyjs::hide("care")
                        shinyjs::show("A")
                        shinyjs::show("B")
                        shinyjs::show("C")
                        shinyjs::hide("disc")

                    }
                } else {

                    shinyjs::show("pass")
                    shinyjs::show("log_in")
                    shinyjs::hide("A")
                    shinyjs::hide("B")
                    shinyjs::hide("C")
                    shinyjs::hide("care")
                    shinyjs::hide("disc")
                    shinyjs::hide("admin")
                    shinyjs::hide("startstop")
                    shinyjs::hide("back")

                }
            }
        })

        ### register admin password
        observeEvent(input$save_pass_admin,{
            if(input$pass_admin != ""){
                    settings$password["admin"] <<- input$pass_admin
                    shinyjs::refresh()
            }
        })

        ### register user password
        observeEvent(input$save_pass_user,{
            if(input$pass_user != "" &
            input$pass_user != settings$password["admin"]){
                settings$password["user"] <<- input$pass_user
            }
            updateTextInput(session,"pass_user","User password:","")
        })

        ### log in
        observeEvent(input$log_in, {
            shinyjs::hide("log_in")
            updateTextInput(session,"pass","Password:","")
            Sys.sleep(2)
            shinyjs::show("log_in")
            if(input$pass == settings$password["admin"]) etc[["logged_in"]]["admin"] = T
            if(input$pass == settings$password["user" ] &
            settings$password["user"] != "") etc[["logged_in"]]["user"] = T
        })

        ### admin board
        observeEvent(input$autocare,{
            settings$autocare  <<- !settings$autocare
            etc[["autocare"]]   <- settings$autocare
        })

        observeEvent(input$start,{
            tama$start()
            settings$running <<- T
            etc[["running"]]  <- T
        })

        observeEvent(input$back,{
            shinyjs::refresh()
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

        ## play sound
        observe({
            new_freq = tama$GetFreq()
            if(new_freq != etc[["freq"]]){
                try(removeUI("audio"))
                insertUI(
                    selector = "#screen",
                    where = "afterEnd",
                    tags$audio(id = "audio",
                               src = paste0("www/buzz/",new_freq,".wav"),
                               type = "audio/wav",
                               autoplay = T)
                )
                etc[["freq"]] = new_freq
            }
            invalidateLater(1000/30,session)
        }, priority = 1)

        ## care routine
        observe({
            if(!etc[["busy"]]) {
                etc[["busy"]] = T

                t1 = Sys.time()
                elapsed = as.numeric(difftime(t1,etc[["t0"]],units = "sec"))
                etc[["t0"]] = t1

                if(input$care){

                    ### if it's an egg, set the clock
                    if(etc[["egg"]]) {
                        if(is.egg(tama)) {
                            etc[["todo"]] = set_clock()
                        }
                        etc[["egg"]]  = F
                    }

                    ### if dead, that's over
                    if(is.dead(tama)) {
                        etc[["dead"]] = T
                        etc[["todo"]]$wait = Inf
                    }
                    
                    ### stop the need to scold if it doesn't cry anymore
                    if(!tama$GetIcon()[8]) {
                        etc[["scold"]] = F
                    }
                    
                    ### otherwise, plan an action
                    if(is.asleep(tama,"off")){
                        etc[["stats"]] = c(hunger = 4,
                                        happiness = 4)

                    } else if(etc[["todo"]]$wait <= 0 &
                            length(etc[["todo"]]$actions) == 0) {

                        # end what has been started
                        if(etc[["doing"]] != "") {
                            if(etc[["doing"]] == "try_to_clean") {
                                if(is.dirty(tama,"top")) {
                                    # still dirty => asleep, turn the light off
                                    etc[["todo"]] = light()
                                    etc[["doing"]] = ""
                                }

                            } else if(etc[["doing"]] == "check_arrow") {
                                # now that the arrow is checked, feed
                                etc[["todo"]] = feed(ifelse(is.burger(tama),
                                                "top",
                                                "bottom"),
                                            times = 4 - etc[["stats"]]["hunger"])
                                etc[["stats"]]["hunger"] = 4
                                etc[["doing"]] = ""

                            } else if(etc[["doing"]] == "check_status_1") {
                                # check hunger
                                etc[["stats"]]["hunger"] = nb.hearts(tama)
                                etc[["todo"]] = check_status(step = 2)
                                etc[["doing"]] = "check_status_2"

                            } else if(etc[["doing"]] == "check_status_2") {
                                # check happiness
                                etc[["stats"]]["happiness"] = nb.hearts(tama)
                                etc[["todo"]] = check_status(step = 3)
                                etc[["doing"]] = ""

                                if(tama$GetIcon()[8] &
                                !is.asleep(tama, "on") &
                                etc[["stats"]]["hunger"] > 0 &
                                etc[["stats"]]["happiness"] > 0){
                                    etc[["scold"]] = T
                                }
                            }

                        # check bad screens (clock, light off when not asleep)
                        } else if(is.clock(tama)) {
                            etc[["todo"]] = unclock()

                        } else if(is.dark(tama)) {
                            etc[["todo"]] = light()

                        # cares
                        } else if(is.asleep(tama,"on")) {
                            etc[["todo"]] = light()

                        } else if(is.dirty(tama,"top")) {
                            # double poop: try to clean - or is it asleep ?
                            etc[["todo"]] = clean()
                            etc[["doing"]] = "try_to_clean"

                        } else if(is.dirty(tama,"bottom")) {
                            etc[["todo"]] = clean()

                        } else if(is.sick(tama)) {
                            # heal after double poop that may hide it
                            etc[["todo"]] = heal()

                        } else if(input$disc & etc[["scold"]]) {
                            etc[["todo"]] = scold()
                            etc[["scold"]] = F

                        } else if(etc[["stats"]]["hunger"] < 4 & !etc[["scold"]]){
                            etc[["todo"]] = check_food_arrow()
                            etc[["doing"]] = "check_arrow"

                        } else if(etc[["stats"]]["happiness"] < 4 & !etc[["scold"]]){

                            etc[["todo"]] = play_game(times = min(2,4 - etc[["stats"]]["happiness"]))
                            etc[["stats"]]["happiness"] = 4
                            etc[["next_check"]] = 0

                            # if it's time and it's not sleeping,
                            # or if it's crying with no apparent reason
                            # reasons: light on when sleeping, hungry, unhappy, to scold
                            # hungry and unhappy must be checked, if checked and !=0: "to scold"
                        } else if(etc[["t0"]] > etc[["next_check"]] |
                                        (tama$GetIcon()[8] &
                                        !is.asleep(tama,"on"))) {
                                etc[["next_check"]] = etc[["t0"]] + 5*60
                                etc[["todo"]] = check_status(step = 1)
                                etc[["doing"]] = "check_status_1"
                                etc[["scold"]] = F # we will check that
                        }
                    }
                }

                ### do what has been planned
                if(etc[["todo"]]$wait > 0) {
                    etc[["todo"]]$wait = etc[["todo"]]$wait - elapsed
                } else if(etc[["todo"]]$unclick){
                    for(b in 0:2) tama$SetButton(b,F)
                    etc[["todo"]]$wait = ifelse(input$care,.4,.1)
                    etc[["todo"]]$unclick = F
                } else {
                    if(length(etc[["todo"]]$actions) > 0){

                        act = etc[["todo"]]$actions[1]

                        if(act %in% c("A","B","C")) {
                            tama$SetButton(c(A = 0, B = 1, C = 2)[act], T)
                            etc[["todo"]]$wait = .1
                            etc[["todo"]]$unclick = T
                        } else if(act == "AC") {
                            for(b in c(0,2)) tama$SetButton(b,T)
                            etc[["todo"]]$wait = 2
                            etc[["todo"]]$unclick = T
                        } else {
                            etc[["todo"]]$wait = as.numeric(act)
                        }

                        etc[["todo"]]$actions = etc[["todo"]]$actions[-1]
                    }
                }
            }
        })

        ## Original gameplay
        observeEvent(input$A | input$a, {etc[["todo"]] = list(wait = 0, actions = "A", unclick = F)})
        observeEvent(input$B | input$b, {etc[["todo"]] = list(wait = 0, actions = "B", unclick = F)})
        observeEvent(input$C | input$c, {etc[["todo"]] = list(wait = 0, actions = "C", unclick = F)})
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
