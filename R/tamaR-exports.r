#' Create a Tama object from the C++ class
#' 
#' @name Tama
#' @return
#' A tamagotchi
#' 
#' @examples
#' tama = new(Tama)
#' tama$GetMatrix()
#' tama$GetIcon()
#' 
#' tama$SetButton(0,T)
#' tama$GetButton()
#' tama$SetButton(0,F)
#' 
#' @export Tama
#' 
#' 

loadModule(module = "Tamalib", TRUE)