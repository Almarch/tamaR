empty_todo = list(actions = c(), wait = .25, unclick = F)
out = c("C","C","2")

set_clock = function(){

  todo = list(actions = c(),
              wait    = 3)

  todo$actions = c("B",
                   "1.5")
  
  hr  = format(Sys.time(),"%H")
  min = format(Sys.time(),"%M")
  print(paste0("initialization at ",hr,":",min))

  if(hr > 0) for(i in 1:hr){
    todo$actions = c(todo$actions,"A")
  }
  if(min > 0) for(i in 1:min){
    todo$actions = c(todo$actions,"B")
  }
  todo$actions = c(todo$actions,
                   "C",
                   "B",
                   "310")

  return(todo)
}

check_food_arrow = function(){
    print("Food")
    todo = empty_todo
    todo$actions = c("A","B","1")
    return(todo)
}

feed = function(x = c("top","bottom"), times = 1){
    todo = empty_todo
    if(x == "bottom") todo$actions = c("A")
    for(i in 1:times){
        todo$actions = c(todo$actions,"B","6")
    }
    todo$actions = c(todo$actions,out)
    return(todo)
}

light = function(){
    print("Light")
    todo = empty_todo
    todo$actions = c(rep("A",2),
                    "B","A","B",
                    out)
    return(todo)
}

play_game = function(times = 1){
    print("Game")
    todo = empty_todo
    todo$actions = c(rep("A",3),
                     "B")
    for(i in 1:times){
        playlist = sample(c("A","B"),size = 5, T)
        todo$actions = c(todo$actions,
                         "5", # intro
                         c(rbind(playlist,"8")), # each match + result
                         "8") # final score + result
    } 
    todo$actions = c(todo$actions,out)
    return(todo)
}

heal = function(){
    print("Heal")
    todo = empty_todo
    todo$actions = c(rep("A",4),
                     rep(c("B","6"),2), # 2 doses
                     out)
    return(todo)
}

clean = function(){
    print("Clean")
    todo = empty_todo
    todo$actions = c(rep("A",5),
                     "B","8",
                     out)
    return(todo)
}

check_status = function(step = c(1,2,3)){
    todo = empty_todo
    if(step == 1) {
        print("Check")
        todo$actions = c(rep("A",6),
                        "B","2", # age & weight
                        "B","2", # discipline
                        "B","1") # hunger
    } else if(step == 2){
        todo$actions = c("B","1") # happiness
    } else if(step == 3){
        todo$actions = out
    }
    return(todo)
}

scold = function(){
    print("Scold")
    todo = empty_todo
    todo$actions = c(rep("A",7),
                     "B","6",
                     out)
    return(todo)
}

unclock = function(){
    todo = empty_todo
    todo$actions = c("B","5")
    return(todo)
}
