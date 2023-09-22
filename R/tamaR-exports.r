#' Create a Tama object from the C++ class
#' 
#' @name Tama
#' @return
#' A tamagotchi
#' 
#' @examples
#' tama = Tama()
#' plot(Tama)
#' 
#' @export Tama
#' @exportClass Tama
#' 
#' 

setRcppClass(Class = "Tama",
             module = "Tamalib")