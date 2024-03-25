do = function(obj,todo){

  if(length(todo$actions) > 0){
    act = todo$actions[1]

    if(act %in% c("A","B","C")) {
      obj$click(button = act)
    } else {
      todo$wait = as.numeric(act)
    }
  todo$actions = todo$actions[-1]
  }
  Sys.sleep(.4) # click + delay cannot go <0.5 sec
  return(todo)
}