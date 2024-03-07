# Tamalib is live on R !

This is a package allowing the emulation of a P1 tamagotchi in R using [tamalib](https://github.com/jcrona/tamalib).

[R](https://r-project.org) is a scripting language, allowing either a live interaction or the elaboration of custom programs.

![image](https://github.com/Almarch/tamaR/assets/13364928/a6abad1b-8332-4234-ba14-b589757bf69b)

## Installation

Start by cloning the git repository:

```bash
git clone https://github.almarch/tamaR.git
```

A ROM named "rom.bin" must then be placed into the src directory. The ROM has to be converted to 12 bits (use Rscript.exe from a Windows terminal):

```bash
Rscript tamaR/src/TamaRomConvert.r
```

Build and install the package with R (R.exe if you use the Windows terminal):

```bash
R CMD build tamaR
R CMD INSTALL tamaR_1.0.0.tar.gz
```

The package can now be loaded from R:

```r
library(tamaR)
```

## Use

The instanciation of an object of class `Tama` prepares a tamagotchi and provides an R interface for it. The `run` method launches the real-time emulation. A single tamagotchi can be alive on a given R session: instancing several `Tama`'s will crash them. If you need several pets, run several R sessions.

```r
guizmo = Tama()
guizmo$run()
```

The screen can be plotted via the `display` method. A custom background can be provided as a square-ish png, imported using `png::readPNG`.

```r
guizmo$display()
data(p2)
guizmo$display(p2)
```

Buttons (A, B and C) can be controlled using the `click` method. The `delay` argument tells how long the click should last:

```r
guizmo$click("B")
Sys.sleep(3)
guizmo$click(c("A","C"),delay=2)
```

The state can be saved anytime using the corresponding method:

```r
guizmo$save("myTama.txt")
```

However, you cannot load a state into a running `Tama` (the result may be glitched). Use the methods in the following order:

```r
guizmo = Tama()
guizmo$load("myTama.txt")
guizmo$run()
```

## ShinyGotchi

The package tamaR is a dependency for [shinyGotchi](https://github.com/almarch/shinyGotchi), an R package that leverages [shiny](https://shiny.posit.co/) to host a tamagotchi online.

## Notes on the C++ structure

Tamalib has been implemented on [Arduino](https://github.com/GaryZ88/Arduinogotchi), with a bit of re-writing. The Arduino version is the starting point for tamaR C++ module, including the ROM conversion step. However, because Rcpp dependencies management was not trivial, I gathered all tamalib code into a monolithic tamalib.cpp program.

Tamalib was converted from C to C++ in order to ensure consistency with R object-orientation. The user-tailored methods presented in this document and in the manual (`?Tama`) are developped in R, and they rely on lower-level C++ methods. Noteworthily, not all developed C++ methods are used in the R interface: for instance `GetFreq` properly fetches the buzzer frequency and `GetROM` dumps the ROM. These C++ methods are still available to the user and they might have an R implementation later.

This compact, object-oriented version of tamalib can almost readily be packaged into Python. Like R, Python is accessible to a broad community and it allows scripting and the developement of web applications. Furthermore, it opens the possibility for the developement of an Android app.

Tamalib was adapted with attention to its platform agnosticity, so it should run on any OS. The package tamaR has been succesfully built, installed and tested on GNU/Linux and Windows.

## Secret Character

A new but familiar secret character has snuck in the game. Will you find out who this is ? If you are spending time on a tamagotchi, odds are that you may have been a kid in the 90's and this secret character is dedicated to you.
