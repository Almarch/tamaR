#' A Shiny application to play with your virtual pet
#'
#' @name go
#' @param tama An object of class Tama
#' @param background A png image to use as background. It should be square and imported using png::readPNG
#' @param port The port to use for shiny, default is 1996
#' @export go
#' 
#' 

go = function(tama, background = NULL, port = 1996, host = "127.0.0.1"){

  options(shiny.port = port,
          shiny.host = host)
  password = c(admin = "",
               user  = "")

    ui <- fluidPage(
        useShinyjs(),
        tags$head(
            tags$link(rel = "icon shortcut",
                      type="image/png",
                      href = "data:image/png;base64,AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABILAAASCwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWj4MsGVbH+RpQAXIAAAADjQeA147IQJsFQ4AJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAoAGUuGTv8EzKv/VX5B/1IvA5Ncdjj/MKNz/1lzNvcAAAAGAAAAAAAAAAAAAAAAAAAAAAAAAAAgEgA4TS0Cj2o9A8V0Xhj/b2Ie/3dbFP94WhP/cGId/21lIf9+Uwr+LhwDUwAAAAAAAAAAAAAAAAAAAAAZDAApbFsa8B+yiP8Ow5//BMyr/wTMq/8EzKv/BMyr/wTMq/8EzKv/EMCb/2JvLv4wGwNVAAAAAAAAAAAAAAAAXzkEshm4kP8EzKv/BMyr/wTMq/8EzKv/BMyr/wTMq/8EzKv/BMyr/wTMq/8IyKX/YkcOygAAAAAAAAAAAAAAAGVmJ/EEzKv/BMyr/y6jdP9cdTf/JK2C/wTMq/8EzKv/BMyr/wTMq/8EzKv/BMyr/19fI+MAAAAAAAAAAAAAAABiTBPOBcuq/wTMq/9Pg0n/FbyV/29iHv8Gy6n/BMyr/wTMq/8EzKv/BMyr/wTMq/9rYiH0AAAAAAAAAAAAAAAAQSYCeRm4kP8EzKv/S4dO/wTMq/9Dj1j/F7qT/wTMq/8EzKv/BMyr/wTMq/8EzKv/cV8b+AAAAAMAAAAAAAAAABcPACI6k2L6BMyr/wbKqP8EzKv/BMyr/wTMq/8EzKv/BMyr/wTMq/8EzKv/Ccil/2VtK/9xXBn2Z00R2DwjAm4AAAAAOFozqgTMq/8EzKv/BMyr/wTMq/8EzKv/BMyr/wTMq/8EzKv/BMyr/wTMq/8XupP/HbSK/xi6kv9bNgOrAAAAAE47DqEEzKv/BMyr/wTMq/8EzKv/BMyr/wTMq/8EzKv/BMyr/wTMq/8Gyqn/Wnc5/111Nv9edDX/aUkM1QAAAABgOQG0DMSh/xe6kv90Xhf/FruU/wTMq/8EzKv/BMyr/wTMq/8EzKv/BMyr/wbLqf8FzKr/BMyr/2hZGuUAAAAATS4CkSCxh/8Gyqn/MaBw/wrHpP8EzKv/BMyr/wTMq/8spXf/Er6Z/xm4kP9oRgrSZkMIyl1EDb9DKAR6AAAAABsQADA7kV/4BMyr/wTMq/8EzKv/BMyr/wTMq/8KxqP/eFoT/yasgP9IiVH/IRUAPgAAAAAAAAAAAAAAAAAAAAAAAAAAPzcSiieqff8LxqP/BMyr/wTMq/8EzKv/BMyr/wTMq/8Ow57/WlAZywAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAElFwRERysGiFJJGLhSZS/ZVnQ68Fh5PvdcZyzoY0AIwhkPADIAAAAAAAAAAAAAAAAAAAAA8B8AAOAPAACADwAAAAcAAAAHAAAABwAAAAcAAAADAAAAAAAAgAAAAIAAAACAAAAAgAAAAIAHAADABwAAwA8AAA=="),
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
        fluidRow(column(12,
            textInput("pass_admin","Administrator password:"),
            actionButton("save_admin_pwd","Save",class="menu")
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

        br(),
        br(),
        br(),

        fluidRow(
            column(12,splitLayout(
                checkboxInput("care", "Automatic care",      value = F),
                checkboxInput("disc", "Care for discipline", value = T))
        )),

        ### Admin board
        fluidRow(column(12,splitLayout(
            actionButton("A_","A"),
            actionButton("B_","B"),
            actionButton("C_","C"),
            actionButton("AC","A+C"))
        )),

        # when running
        fluidRow(column(12,
            actionButton("stop","STOP"),
        )),

        # when stopped
        fluidRow(column(12,
            actionButton("start","START"),
        )),

        fluidRow(column(12,splitLayout(
            actionButton("save_state","SAVE"),
            actionButton("load_state","LOAD"),
            actionButton("reset_state","RESET"))
        )),

        fluidRow(column(12,
            checkboxInput("autocare","allow automatic care"),
        )),

        fluidRow(column(12,
            actionButton("background","change background"),
        )),

        fluidRow(column(12,splitLayout(
            actionButton("save_rom","dump ROM"),
            actionButton("load_rom","replace ROM"))
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
        etc[["logged_in"]] = c(play = F,
                               auto = F)

        ### Conditionnal UI
        observe({
        if(password["play"] == "" &
           password["auto"] == ""){
        shinyjs::hide("screen")
        shinyjs::hide("care")
        shinyjs::hide("disc")
        shinyjs::hide("A")
        shinyjs::hide("B")
        shinyjs::hide("C")
        shinyjs::hide("pass")
        shinyjs::hide("log_in")
        shinyjs::show("pass_play")
        shinyjs::show("pass_auto")
        shinyjs::show("register")
        } else {
        shinyjs::show("screen")
        shinyjs::hide("pass_play")
        shinyjs::hide("pass_auto")
        shinyjs::hide("register")
        if(etc[["logged_in"]]["play"]){
            shinyjs::show("A")
            shinyjs::show("B")
            shinyjs::show("C")
            shinyjs::hide("care")
            shinyjs::hide("disc")
            shinyjs::hide("pass")
            shinyjs::hide("log_in")
        } else if(etc[["logged_in"]]["auto"]) {
            shinyjs::show("care")
            shinyjs::hide("pass")
            shinyjs::hide("log_in")
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
            shinyjs::hide("A")
            shinyjs::hide("B")
            shinyjs::hide("C")
            shinyjs::hide("care")
            shinyjs::hide("disc")
            shinyjs::show("pass")
            shinyjs::show("log_in")
        }
    }})

    ### register password
    observeEvent(input$register,{
            if(input$pass_play != "" &
               input$pass_auto != "" &
               input$pass_play != input$pass_auto){
            password["play"] <<- input$pass_play
            password["auto"] <<- input$pass_auto
    }
})

### log in
observeEvent(input$log_in, {
    Sys.sleep(2)
    if(input$pass == password["play"]) etc[["logged_in"]]["play"] = T
    if(input$pass == password["auto"]) etc[["logged_in"]]["auto"] = T
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
                    etc[["todo"]] = play_game(times = 4 - etc[["stats"]]["happiness"])
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

    ## display screen
        observe({
            output$screen = renderPlot({
                tama$display(background = background)
                etc[["busy"]] = F
                invalidateLater(1000/3, session)
              })
        })
    }

    shinyApp(ui, server)
}
