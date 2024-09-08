# <img src="inst/www/icon.png" alt="TaMaGoTcHi" width="40"/> The Tamagotchi is live on <img src="https://cran.r-project.org/Rlogo.svg" alt="R" width="45"/>

This is a package allowing the emulation of a P1 Tamagotchi in R using [TamaLIB](https://github.com/jcrona/tamalib).

<img src="https://docs.posit.co/images/product-icons/posit-icon-fullcolor.png" width="80px" align="right"/>

[R](https://r-project.org) is a scripting language, allowing either a live interaction or the elaboration of custom programs.

A demo version is kindly hosted on [Posit Cloud](https://posit.co) and available [at this address](https://almarch.shinyapps.io/tamaR).

<p align="center"><img src="https://github.com/user-attachments/assets/fe3c4fdd-2a94-4edd-ae6a-c61e2424b517" alt = "ezgif" width="400px"/></p>

## 1. Note on the <i>posit</i> branch

The demo version is slighlty different from the main one:

<table>
    <tr>
        <th><i>main</i> branch</th><th><i>posit</i> branch</th>
    </tr>
    <tr>
        <td>The package contains the ROM</td><td>The package does not contain the ROM</td>
    </tr>
    <tr>
        <td>Provide the ROM prior to install the package</td><td>Provide the ROM on the fly to the running app</td>
    </tr>
    <tr>
        <td>Must be installed with <code>R CMD INSTALL</code></td><td>Can be installed with <code>devtools</code></td>
    </tr>
    <tr>
        <td>Documentation <a href = https://github.com/Almarch/tamaR/tree/main>here</a></td><td>Documentation below</td>
    </tr>
</table>

NB: Posit cloud shuts down inactive Shiny sessions, so the game state is lost after deconnection. Use your own server to keep a game consistent timeline.

## 2. Installation

Install the package from RStudio using the script available in `app/app.R`.

```r
devtools::install_github("https://github.com/Almarch/tamaR/tree/posit")
library(tamaR)
go()
```

## 3. Demo

The demo instance is available [here](https://almarch.shinyapps.io/tamaR).

- Connect as admin with the default credentials: **admin**, password: **qwerty**.

- Change the passwords.

- Enable the automatic care bot if you wish the player to use it.

- From the "aesthetics" panel, load a working Tamagotchi ROM <i>e.g</i>. **tama.b**, **rom.bin**, **rom.h** or **rom_12b.h**.

- Finally, don't forget to launch the emulation using the START button before leaving the admin board.

- You may now connect as **player** and enjoy the game !

## 3. Use as a web app

Check out the main [doc](https://github.com/Almarch/tamaR/tree/main#5-use-as-a-web-app).

## 4. License 

This work is licensed under Attribution-NonCommercial 4.0 International.

The ROM is not provided and the author do not endorse game piracy: check your local regulation concerning retro games emulation.

All graphical resources come from the extraordinarily rich Tamagotchi [fandom](https://tamagotchi.fandom.com/wiki/Tamagotchi_(1996_Pet)).
