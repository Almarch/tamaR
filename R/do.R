do = function(obj,todo, delay1 = .25, delay2 = .25){

  if(length(todo$actions) > 0){
    act = todo$actions[1]

    if(act %in% c("A","B","C")) {
      obj$click(button = act, delay = delay1)
    } else {
      todo$wait = as.numeric(act)
    }
  todo$actions = todo$actions[-1]
  }
  Sys.sleep(delay2)
  return(todo)
}