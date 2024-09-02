#' Convert the rom.bin file into a rom.h base 12 format
#'
#' @name convert_rom
#' @param bin A binary ROM
#' @param hfile The output file name
#' @param secret Let a new (but familiar) secret character sneak in the game
#' @examples
#' guizmo = Tama()
#' p2(guizmo)
#' guizmo$start()
#' go(guizmo)

convert_rom = function(bin, hfile = "rom.h", secret = T, ...) {

    obj = readBin(con = bin, what = "raw", n = file.info(bin)$size)
    obj = paste(as.character(obj), collapse = "")

    tmp = ""
    for(i in 1:nchar(obj)){
        if((i+3)%%4) tmp = paste0(tmp,substr(obj,i,i))
    }

    obj = c()
    for(i in 1:(nchar(tmp)/2)){
        obj = c(obj,substr(tmp,2*(i-1)+1,2*(i-1)+2))
    }
    #                               (\__/)
    if(secret){#                    (o^-^)
    obj[7658:7824] = c(#           z(_(")(")
        "39","c7","93","99","c2","9c","29","14","98","49","c4","98","49","14","9c","29",
        "c2","93","99","d7","99","31","70","90","09","a3","9d","49","88","91","29","14",
        "91","69","10","91","69","14","91","29","28","9a","49","c3","98","01","00","90",
        "39","c7","93","99","c2","9c","29","14","9c","49","e4","9c","49","14","9c","29",
        "c2","93","99","d7","99","31","70","90","09","87","9e","89","90","92","49","28",
        "92","a9","24","92","a9","28","92","49","10","98","89","d7","9a","01","00","90",
        "09","18","9a","49","a4","9c","49","02","9c","29","ca","90","29","04","90","29",
        "3a","9c","e9","96","95","21","30","90","09","60","99","09","90","98","89","14",
        "9d","49","c4","90","49","02","90","79","1f","9e","09","90","95","01","30","90",
        "09","60","99","09","90","98","89","04","9d","49","c4","90","49","02","90","79",
        "2f","9d","09","90","95","01","30")
    }

    obj = as.numeric(as.hexmode(obj))
    obj = nb2hex(obj, ...)
    obj = paste0(obj,"\n")

    if(is.null(hfile)) return(obj) else cat(obj, file = hfile, append= F)
}
