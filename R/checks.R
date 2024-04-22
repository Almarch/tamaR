
### utilities
top_right    = function(obj) obj$GetMatrix()[1:8,25:32]
bottom_right = function(obj) obj$GetMatrix()[9:16,25:32]
bottom_left  = function(obj) obj$GetMatrix()[9:16,1:8]

### checks for tamacare
is.sick = function(obj){
    return(all(top_right(obj) == skull))
}

is.dirty = function(obj,x = c("top","bottom")){
    if(x == "top")    to_check = top_right(obj)
    if(x == "bottom") to_check = bottom_right(obj)
    return(all(to_check == poop1) | all(to_check == poop2))
}

is.asleep = function(obj, x = c("on","off")){
    if(x == "on" ) {
        to_check = top_right(obj)
        return(all(to_check ==    Z)  | all(to_check ==    zzz))
    }
    if(x == "off") {
        to_check = obj$GetMatrix()[1:8,17:24]
        return(all(to_check == (1-Z)) | all(to_check == (1-zzz)))
    }
}

is.dark = function(obj){
    return(all(obj$GetMatrix() == 1))
}

is.clock = function(obj){
    return(all(obj$GetMatrix()[13:16,3:10] == M))
}

is.burger = function(obj){
   return(all(obj$GetMatrix()[1:8,1:8] == arrow))
}

is.dead = function(obj){
    to_check = bottom_right(obj)
    return(all(to_check == dead1) |
           all(to_check == dead2) |
           all(to_check == yr   ))
}

nb.hearts = function(obj){
    to_check = obj$GetMatrix()[9:16,]
    h1 = all(to_check[,1:8  ] == heart)
    h2 = all(to_check[,9:16 ] == heart)
    h3 = all(to_check[,17:24] == heart)
    h4 = all(to_check[,25:32] == heart)
    return(4-h1-h2-h3-h4)
}

is.egg = function(obj){
    pic1 = obj$GetMatrix()[1:16,9:24]
    Sys.sleep(.25)
    pic2 = obj$GetMatrix()[1:16,9:24]

    return(all(pic1 == egg1) |
           all(pic1 == egg2) |
           all(pic1 == egg3) |
           all(pic1 == egg4) |

           all(pic2 == egg1) |
           all(pic2 == egg2) |
           all(pic2 == egg3) |
           all(pic2 == egg4) )
}
