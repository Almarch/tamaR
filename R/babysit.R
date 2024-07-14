#' An automatic routine to care for your virtual pet
#'
#' @name babysit
#' @param tama An object of class Tama
#' @param end A POSIXct date: when should the baybsitting end ?
#' @param disc Is the babysitter allowed to scold the Tamagotchi when needed ?
#' @export babysit
#' @examples
#' guizmo = Tama()
#' guizmo$start()
#' babysit(guizmo, end = Sys.time() + 3600)
#' go(guizmo)

state_init = function() {
    return(
        state = list(
            t0 = Sys.time(),
            todo = list(
                actions = c(),
                wait = 0
            ),
            dead = F,
            doing = "",
            stats = c(
                hunger = 4, #nb of full hearts
                happiness = 4
            ),
            scold = F,
            egg = T,
            next_check = 0
        )
    )
}

babysit = function(tama, end, disc = TRUE) {
    state = state_init()
    while(Sys.time() < end) {
        state = care_step(
            tama = tama,
            state = state,
            disc = disc,
            time = Sys.time())
        Sys.sleep(.1)
    }
}
