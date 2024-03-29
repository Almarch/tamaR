
glimpse = function(obj,delay = .1){
    obj$start()
    Sys.sleep(delay)
    obj$stop()
} 
