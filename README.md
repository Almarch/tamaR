# Tamagotchi is live on R !

This is a package allowing the emulation of a P1 tamagotchi in R using [tamalib](https://github.com/jcrona/tamalib).

[R](https://r-project.org) is a scripting language, allowing either a live interaction or the elaboration of custom programs.

R is also the support for [shiny](https://shiny.posit.co/), a powerfull web framework that opens the possibility to host a tamagotchi online.

![image](https://github.com/Almarch/tamaR/assets/13364928/4b28e6d7-2d51-4ed7-8d70-c04d03397f38)

## Installation

Start by cloning the git repository:

```bash
git clone https://github.almarch/tamaR.git
```

A ROM named "rom.bin" must be placed into the src directory prior to building the package, and converted to 12 bits with Rscript (Rscript.exe if you use the Windows terminal):

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

The tamagotchi can be played with using a shiny GUI. A custom background may still be provided as a png.

```r
guizmo$shiny(p2)
```

The shiny app may be shut down with Ctrl+C.

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

## Server hosting

The shiny app can be used to host a tamagotchi on a server, so that it will stay alive whenever you are not connected. Here is how you can do to prepare a cozy place for your pet:

- your server needs to be accessible via internet. You can open your private network via your internet provider's administrator page: open a port (e.g. 22) and redirect to your server private IP. Be extremely cautious, the threat of cyberattacks is real. On GNU/Linux I would advise to use `firewall` and only authorize access to IPs you know.

- use the linux command `screen` to detach a session. Call the `shiny` method and note the port. If you're hosting several tamagotchis, use a different `port` argument each time.

- from a client computer, install PuTTY and prepare an access to your server. In Connection/SSH/Tunnels, add a new forwarded port (default is 1996, so the line should look like: L1996 | localhost:1996). Open the session and identify.

- from the browser of your client computer, connect to your shiny session (localhost:1996 by default), and enjoy some time with your friend !  

## Notes on the C++ structure

Tamalib has been implemented on [Arduino](https://github.com/GaryZ88/Arduinogotchi), with a bit of re-writing. The Arduino version is the starting point for tamaR C++ module, including the ROM conversion step. However, because Rcpp dependencies management was not trivial, I gathered all tamalib code into a monolithic tamalib.cpp program.

Tamalib was converted from C to C++ in order to ensure consistency with R object-orientation. The user-tailored methods presented in this document and in the manual (`?Tama`) are developped in R, and they rely on lower-level C++ methods. Noteworthily, not all developed C++ methods are used in the R interface: for instance `GetFreq` properly fetches the buzzer frequency and `GetROM` dumps the ROM. These C++ methods are still available to the user and they might have an R implementation later.

This compact, object-oriented version of tamalib can almost readily be packaged into Python. Like R, Python is accessible to a broad community and it allows scripting and the developement of web applications. Furthermore, it opens the possibility for the developement of an Android app.

Tamalib was adapted with attention to its platform agnosticity, so it should run on any OS. The package tamaR has been succesfully built, installed and tested on GNU/Linux and Windows.

## Tamacare

The package tamaR is a dependency of [tamacare](https://github.com/almarch/tamacare), another R package aiming to provide automatic care for your pet.

## Secret Character

A new but familiar secret character has snuck in the game. Will you find out who this is ? If you are spending time on a tamagotchi, odds are that you may have been a kid in the 90's and this secret character is dedicated to you.
