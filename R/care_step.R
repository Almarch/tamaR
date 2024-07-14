
care_step = function(tama, state, disc, time) {

    elapsed = as.numeric(difftime(time,state[["t0"]],units = "sec"))
    state[["t0"]] = time

    ### if it's an egg, set the clock
    if(state[["egg"]]) {
        if(is.egg(tama)) {
            state[["todo"]] = set_clock()
        }
        state[["egg"]]  = F
    }

    ### if dead, that's over
    if(is.dead(tama)) {
        state[["dead"]] = T
        state[["todo"]]$wait = Inf
    }
    
    ### stop the need to scold if it doesn't cry anymore
    if(!tama$GetIcon()[8]) {
        state[["scold"]] = F
    }
    
    ### otherwise, plan an action
    if(is.asleep(tama,"off")){
        state[["stats"]] = c(hunger = 4,
                        happiness = 4)

    } else if(state[["todo"]]$wait <= 0 &
            length(state[["todo"]]$actions) == 0) {

        # end what has been started
        if(state[["doing"]] != "") {
            if(state[["doing"]] == "try_to_clean") {
                if(is.dirty(tama,"top")) {
                    # still dirty => asleep, turn the light off
                    state[["todo"]] = light()
                    state[["doing"]] = ""
                }

            } else if(state[["doing"]] == "check_arrow") {
                # now that the arrow is checked, feed
                state[["todo"]] = feed(ifelse(is.burger(tama),
                                "top",
                                "bottom"),
                            times = 4 - state[["stats"]]["hunger"])
                state[["stats"]]["hunger"] = 4
                state[["doing"]] = ""

            } else if(state[["doing"]] == "check_status_1") {
                # check hunger
                state[["stats"]]["hunger"] = nb.hearts(tama)
                state[["todo"]] = check_status(step = 2)
                state[["doing"]] = "check_status_2"

            } else if(state[["doing"]] == "check_status_2") {
                # check happiness
                state[["stats"]]["happiness"] = nb.hearts(tama)
                state[["todo"]] = check_status(step = 3)
                state[["doing"]] = ""

                if(tama$GetIcon()[8] &
                !is.asleep(tama, "on") &
                state[["stats"]]["hunger"] > 0 &
                state[["stats"]]["happiness"] > 0){
                    state[["scold"]] = T
                }
            }

        # check bad screens (clock, light off when not asleep)
        } else if(is.clock(tama)) {
            state[["todo"]] = unclock()

        } else if(is.dark(tama)) {
            state[["todo"]] = light()

        # cares
        } else if(is.asleep(tama,"on")) {
            state[["todo"]] = light()

        } else if(is.dirty(tama,"top")) {
            # double poop: try to clean - or is it asleep ?
            state[["todo"]] = clean()
            state[["doing"]] = "try_to_clean"

        } else if(is.dirty(tama,"bottom")) {
            state[["todo"]] = clean()

        } else if(is.sick(tama)) {
            # heal after double poop that may hide it
            state[["todo"]] = heal()

        } else if(disc & state[["scold"]]) {
            state[["todo"]] = scold()
            state[["scold"]] = F

        } else if(state[["stats"]]["hunger"] < 4 & !state[["scold"]]){
            state[["todo"]] = check_food_arrow()
            state[["doing"]] = "check_arrow"

        } else if(state[["stats"]]["happiness"] < 4 & !state[["scold"]]){

            state[["todo"]] = play_game(times = min(2,4 - state[["stats"]]["happiness"]))
            state[["stats"]]["happiness"] = 4
            state[["next_check"]] = 0

            # if it's time and it's not sleeping,
            # or if it's crying with no apparent reason
            # reasons: light on when sleeping, hungry, unhappy, to scold
            # hungry and unhappy must be checked, if checked and !=0: "to scold"
        } else if(state[["t0"]] > state[["next_check"]] |
                        (tama$GetIcon()[8] &
                        !is.asleep(tama,"on"))) {
                state[["next_check"]] = state[["t0"]] + 5*60
                state[["todo"]] = check_status(step = 1)
                state[["doing"]] = "check_status_1"
                state[["scold"]] = F # we will check that
        }
    }

    ### do what has been planned
    if(state[["todo"]]$wait > 0) {
        state[["todo"]]$wait = state[["todo"]]$wait - elapsed
    } else {
        if(length(state[["todo"]]$actions) > 0){

            act = state[["todo"]]$actions[1]

            if(act %in% c("A","B","C")) {
                tama$click(act)
                state[["todo"]]$wait =  .4
            } else {
                state[["todo"]]$wait = as.numeric(act)
            }

            state[["todo"]]$actions = state[["todo"]]$actions[-1]
        }
    }
    return(state)
}