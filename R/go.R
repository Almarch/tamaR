#' A Shiny application to play with your virtual pet
#'
#' @name go
#' @param tama An object of class Tama
#' @param background A png image to use as background. It should be square and imported using png::readPNG
#' @param port The port to use for shiny, default is 1996
#' @export go
#' 
#' 

go = function(tama, port = 1996, background = NULL, host = "127.0.0.1"){

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
        useShinyjs(),
        tags$head(
            tags$link(rel = "icon shortcut",
                      type="image/png",
                      href = ico),
            tags$style(HTML(
            ".big {
                    width: 100px;
                    height: 100px;
                    border: 5px solid black;
                    border-radius: 50%;
                      }

             .menu {
                    width: 150px;
                    height: 80px;
                    border: 1px solid black;
                    border-radius: 10%;
               }"
            ))
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

        ### User board
        fluidRow(column(12,splitLayout(
                     actionButton("A","",class="big"),
                     actionButton("B","",class="big"),
                     actionButton("C","",class="big"))
        )),
        fluidRow(column(12,
            actionButton("start","START",class="big"),
            align = "center"
        )),

        fluidRow(column(12,
            actionButton("stop","STOP",class="big"),
            align = "center"
        )),

        fluidRow(column(12,
            actionButton("autocare",
            ifelse(settings$autocare,
            "disable automatic care",
            "enable automatic care"))
        )),

        fluidRow(column(12,splitLayout(
            textInput("pass_user","User password:"),
            actionButton("save_pass_user","Save",class="menu"))
        )),

        fluidRow(column(12,
            fileInput("background","Change background", multiple = FALSE),
        )),

        fluidRow(
            column(12,splitLayout(
                checkboxInput("care", "Automatic care",      value = F),
                checkboxInput("disc", "Care for discipline", value = T))
        )),

        fluidRow(column(12,
            downloadButton("save", "SAVE"),
            actionButton("p2","P2"),
            actionButton("reset","RESET"),
            fileInput("load","LOAD", multiple = FALSE)
        )),

        fluidRow(column(12,
            actionButton("a","A"),
            actionButton("b","B"),
            actionButton("c","C"),
            actionButton("ac","A+C")
        )),

        fluidRow(column(12,
            actionButton("back","Back",class="big"),
            align = "center"
        ))
    )

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
        etc[["logged_in"]] = c(admin = F,
                                user  = F)
        etc[["running"]] = settings$running
        etc[["autocare"]] = settings$autocare

        ### Conditionnal UI
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
                shinyjs::hide("a")
                shinyjs::hide("b")
                shinyjs::hide("c")
                shinyjs::hide("ac")
                shinyjs::hide("stop")
                shinyjs::hide("start")
                shinyjs::hide("save")
                shinyjs::hide("load")
                shinyjs::hide("reset")
                shinyjs::hide("p2")
                shinyjs::hide("autocare")
                shinyjs::hide("background")
                shinyjs::hide("pass_user")
                shinyjs::hide("save_pass_user")
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
                    shinyjs::show("autocare")
                    shinyjs::show("background")
                    shinyjs::show("pass_user")
                    shinyjs::show("save_pass_user")
                    shinyjs::show("back")

                    if(etc[["running"]]){

                        shinyjs::show("a")
                        shinyjs::show("b")
                        shinyjs::show("c")
                        shinyjs::show("ac")
                        shinyjs::show("stop")
                        shinyjs::hide("start")
                        shinyjs::hide("save")
                        shinyjs::hide("load")
                        shinyjs::hide("p2")
                        shinyjs::hide("reset")

                    } else {

                        shinyjs::hide("a")
                        shinyjs::hide("b")
                        shinyjs::hide("c")
                        shinyjs::hide("ac")
                        shinyjs::hide("stop")
                        shinyjs::show("start")
                        shinyjs::show("save")
                        shinyjs::show("load")
                        shinyjs::show("p2")
                        shinyjs::show("reset")

                    }
                } else if(etc[["logged_in"]]["user"]) {

                    shinyjs::hide("pass")
                    shinyjs::hide("log_in")
                    shinyjs::hide("a")
                    shinyjs::hide("b")
                    shinyjs::hide("c")
                    shinyjs::hide("ac")
                    shinyjs::hide("stop")
                    shinyjs::hide("start")
                    shinyjs::hide("save")
                    shinyjs::hide("load")
                    shinyjs::hide("p2")
                    shinyjs::hide("reset")
                    shinyjs::hide("autocare")
                    shinyjs::hide("background")
                    shinyjs::hide("pass_user")
                    shinyjs::hide("save_pass_user")
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
                    shinyjs::hide("a")
                    shinyjs::hide("b")
                    shinyjs::hide("c")
                    shinyjs::hide("ac")
                    shinyjs::hide("stop")
                    shinyjs::hide("start")
                    shinyjs::hide("save")
                    shinyjs::hide("load")
                    shinyjs::hide("p2")
                    shinyjs::hide("reset")
                    shinyjs::hide("autocare")
                    shinyjs::hide("background")
                    shinyjs::hide("pass_user")
                    shinyjs::hide("save_pass_user")
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

            tama$start()
            Sys.sleep(.1)
            tama$stop()
        })

        observeEvent(input$reset,{
            tama$stop()
            settings$background <<- NULL
            tama$SetROM(settings$ROM)
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
            tama$SetCPU(init)
        })

        output$save <- downloadHandler(
            filename = "save.txt",
            content = function(file) {
                tama$stop()
                state = tama$GetCPU()
                state = as.character(as.hexmode(state))
                state = paste(state, collapse = " ")
                write(state, file)
            }
        )

        observeEvent(input$load,{
            tama$stop()
            inFile <- input$load
            try({
                state = readLines(inFile$datapath)
                state = unlist(strsplit(state,split=" ", fixed=T))
                state = as.numeric(as.hexmode(state))
                tama$SetCPU(state)

                tama$start()
                Sys.sleep(.1)
                tama$stop()
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
            if(!etc[["busy"]] & input$care) {
            etc[["busy"]] = T

            t1 = Sys.time()
            elapsed = as.numeric(difftime(t1,etc[["t0"]],units = "sec"))
            etc[["t0"]] = t1

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
                ### do what has been planned
                if(etc[["todo"]]$wait > 0) {
                    etc[["todo"]]$wait = etc[["todo"]]$wait - elapsed
                } else {
                    etc[["todo"]] = do(tama, etc[["todo"]])
                }
            }
        })

        ## Original gameplay
        observeEvent(input$A,tama$click("A"))
        observeEvent(input$B,tama$click("B"))
        observeEvent(input$C,tama$click("C"))

        observeEvent(input$a,tama$click("A"))
        observeEvent(input$b,tama$click("B"))
        observeEvent(input$c,tama$click("C"))
        observeEvent(input$ac,tama$click(c("A","C"),delay=2))

        ## display screen
        observe({
            output$screen = renderPlot({
                tama$display(background = settings$background)
                etc[["busy"]] = F
                invalidateLater(1000/3, session)
                })
        })
    }   

    shinyApp(ui, server)
}
