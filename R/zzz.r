### make graphical resources available

bg = readPNG("img/background.png")
bg2 = readPNG("img/background2.png")

icons = list()
for(ics in c("attention","bathroom","food","game",
             "lights","medicine","status","training")){
    icons[[ics]] = readPNG(paste0("img/",ics,".png"))
}

### www repo for we app

.onLoad <- function(libname, pkgname) {
    resources <- system.file("www", package = "tamaR")
    addResourcePath("www", resources)
}

### make sound files

if(F) {
    library(audio)

    rate      = 44100  # Hz
    duration  = .5 # sec
    time = seq(0,duration,length.out = duration * rate)

    for(freq in c(0,4096,3279,2731,2341,2048,1638,1365,1170)) {
        audioSample(sin(2*pi*freq*time),rate=rate) |>
            save.wave(paste0("inst/www/buzz/",freq,".wav"))
    }
}
