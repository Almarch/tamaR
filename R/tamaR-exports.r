#' Create a Tama object from the C++ class
#' 
#' @name Tama
#' @return
#' A tamagotchi
#' 
#' @examples
#' tama = new(Tama)
#' 
#' @export Tama
#' 
#' 

loadModule(module = "Tamalib", TRUE)