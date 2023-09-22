#' Save and load the game state
#'
#' @name Save
#' @param obj An object of class Tama
#' @param file The name of the file to save to or to load from
#' @examples 
#' Save(tama,"myTama.txt")
#' Load(tama,"myTama.txt")
#' @export Save
#' @export Load
#' 
#' 
#' 

Save = function(obj,file){
    state = obj$GetCPU()
    state = as.character(as.hexmode(state))
    cat(c(state,"\n"),file = file, append = F)
}

Load = function(obj,file){
    state = readLines(file)
    state = unlist(strsplit(state,split=" ", fixed=T))
    state = as.numeric(as.hexmode(state))
    obj$SetCPU(state)
}
