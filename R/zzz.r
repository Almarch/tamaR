
### make graphical resources available

bg = readPNG("img/background.png")
bg2 = readPNG("img/background2.png")

icons = list()
for(ics in c("attention","bathroom","food","game",
             "lights","medicine","status","training")){
    icons[[ics]] = readPNG(paste0("img/",ics,".png"))
}

### make audio resources available

waves = list()
rate      = 4410
duration  = 1/5
amplitude = 1
tmp = tempfile(fileext = ".wav")

time <- seq(0, duration, length.out = duration * rate)
# amplitude = sin(pi*seq(from = 0, to = 1, length.out = duration * rate))

for(freq in c(0,4096,3279,2731,2341,2048,1638,1365,1170)){
  x <- audioSample(amplitude * sin(2 * pi * freq * time), rate = rate)
  save.wave(x,tmp)
  waves[[paste0(freq,"Hz")]] <- dataURI(file = tmp, mime = "audio/wav")
}

### www repo for we app

.onLoad <- function(libname, pkgname) {
    resources <- system.file("www", package = "tamaR")
    addResourcePath("www", resources)
}