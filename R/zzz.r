
ico = base64enc::dataURI(file = "img/icon.png", mime = "image/png")

bg = readPNG("img/background.png")
bg2 = readPNG("img/background2.png")

icons = list()
for(ics in c("attention","bathroom","food","game",
             "lights","medicine","status","training")){
    icons[[ics]] = readPNG(paste0("img/",ics,".png"))
}