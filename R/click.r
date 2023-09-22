#' Activate tamagotchi buttons
#'
#' @name click
#' @param obj An object of class Tama
#' @param button A button to click, must be "A", "B" or "C" ; or a vector of several buttons for simultaneous clicking
#' @param delay The time to keep the buttons clicked, default is 0.25 second
#' @export click
#' 


click = function(obj,button = c("A","B","C"),delay = .25){

    stopifnot("Tama" %in% attr(obj,"class"))
    stopifnot(all(button %in% c("A","B","C")))
    stopifnot(delay > 0)

    for(b in button){
        obj$SetButton(c(A = 0, B = 1, C = 2)[b],T)
    }
    Sys.sleep(delay)
    for(b in button){
        obj$SetButton(c(A = 0, B = 1, C = 2)[b],F)
    }
}