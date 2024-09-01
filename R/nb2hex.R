nb2hex = function(x, header = "static unsigned char g_program_b12[] = {"){
    
    x = as.character(as.hexmode(x))
    x = paste0("00",x)
    x = substr(x,start = nchar(x) - 1, stop = nchar(x))
    x = paste0("0x",toupper(x),",")

    y = paste0(header,"\n")
    for(i in 1:length(x)) {
        y = paste0(y, x[i])

        if(!i %% 18) {
            y = paste0(y, "\n")
        } else if(!i %% 3) {
            y = paste0(y, " ")
        }
    }
    y = paste0(y,"};")
    return(y)
}

hex2nb = function(x){

    for(pat in c("static unsigned char g_program_b12[] = {",
                 "static const unsigned char g_program_b12[] PROGMEM = {",
                 "\n",
                 "0x",
                 " ",
                 "};")) {
        x = gsub(pattern = pat,
                replacement = "",
                x = x,
                fixed = T)
    }

    x = unlist(strsplit(x,split=","))
    x = as.numeric(as.hexmode(x))
    return(x)
}