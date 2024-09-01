# <img src="inst/www/icon.png" alt="TaMaGoTcHi" width="40"/> The Tamagotchi is live on <img src="https://cran.r-project.org/Rlogo.svg" alt="R" width="45"/>

This is a package allowing the emulation of a P1 Tamagotchi in R using [TamaLIB](https://github.com/jcrona/tamalib).

[R](https://r-project.org) is a scripting language, allowing either a live interaction or the elaboration of custom programs.

<img src="https://upload.wikimedia.org/wikipedia/commons/e/ea/Docker_%28container_engine%29_logo_%28cropped%29.png" width="120px" align="right"/>

A web app can be launched online using the R library [shiny](https://shiny.posit.co). The online app can be installed either with R, either without, using [docker](https://docker.com).

Check out the demo instance: https://almarch.shinyapps.io/tamaR

<p align="center"><img src="https://github.com/user-attachments/assets/73957a59-64c4-4a3d-a7e6-bc7b5ac83d6f" alt = "ezgif" width="800px"/></p>


## Note on the POSIT branch

This branch is dedicated to publication on POSIT Cloud.

On the [main](https://github.com/Almarch/tamaR/tree/main) branch, the ROM should be converted and integrated to the package so Tamagotchi instanciation are immediately functional. In the alternative POSIT branch, the ROM is not integrated to the package and it should be added to the working app.

Therefore on the POSIT branch the installation process is simplified for RStudio and the package does not contain the ROM.

## 1. Installation

Install the package from RStudio:

```r
devtools::install_github("https://github.com/Almarch/tamaR/tree/posit")
library(tamaR)
go()
```

## 2. Demo

A demo instance is available [here](https://almarch.shinyapps.io/tamaR).

- Connect as admin with the default credentials: **admin**, password: **qwerty**.

- Start by changing the passwords.

- Enable the automatic care bot if you wish the player to use it.

- From the "aesthetics" panel, load a working Tamagotchi ROM <i>e.g</i>. **tama.b**, **rom.bin**, **rom.h** or **rom_12b.h**.

- Finally, don't forget to launch the emulation using the START button before leaving the admin board.

- You may now connect as **player** and enjoy the game !

## 3. Use as a web app

Have a look to the full [documentation](https://github.com/Almarch/tamaR/tree/main#4-use-as-a-web-app).

## 4. License 

This work is licensed under Attribution-NonCommercial 4.0 International.

The ROM is not provided and the author do not endorse game piracy: check your local regulation concerning retro games emulation.

All graphical resources come from the extraordinarily rich Tamagotchi [fandom](https://tamagotchi.fandom.com/wiki/Tamagotchi_(1996_Pet)).
