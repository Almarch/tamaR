# [Tamalib](https://github.com/jcrona/tamalib) is live on [R](https://r-project.org) !

This is a package allowing the emulation of a P1 tamagotchi in R, using an object-oriented paradigm.

![Screenshot from 2023-09-25 17-07-39](https://github.com/Almarch/tamaR/assets/13364928/44a699a9-e1a2-489c-aaa3-9e53c633a7df)

## Installation

Start by cloning the git repository:

```bash
git clone https://github.almarch/tamaR.git
```


If you use Windows, you must comment out the line 8 of tamaR/src/tamalib.cpp as follows:

```cpp
// #define LINUX
```

Indeed, the time management libraries that I used are OS-dependent. Supported OS are GNU/Linux and Windows, this has not been tested on macOS yet.

The ROM must me converted to 12 bits and to a .h format. Place a rom.bin into the src repository, and run the following command line from tamaR/src:

```bash
java TamaRomConvert rom.bin
```

That should produce a rom.h file in the src directory.

Then, build and install the package with R (R.exe if you use the Windows terminal). From the directory in which tamaR was cloned:

```bash
R CMD build tamaR
R CMD INSTALL tamaR_1.0.0.tar.gz
```

You can then load the package from R:

```r
library(tamaR)
```

## Use

The instanciation of an object of class `Tama` from R prepares a tamagotchi and provides an interface for it. The `run` method launches the real-time emulation. A single tamagotchi can be alive on a given R session: instanciating several `Tama`'s will crash them. If you need several pets, run several R sessions.

```r
guizmo = Tama()
guizmo$run()
```

The screen can be plotted via the `display` method. A custom background can be provided as a png, imported using `png::readPNG`.

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

R is a scripting language, allowing either a live interaction or the elaboration of custom programs.

Alternatively, the tamagotchi can be played with using a shiny GUI. A custom background may still be provided as a png.

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

Shiny is not only a GUI but overall a powerfull web framework. Hence, the app can be used to host a tamagotchi nest on a server that will keep living their life whenever you are not connected. Here is how you can do to prepare a cozy place for your pets:

- your server needs to be accessible via internet. You can open your private network via your internet provider's administrator page: open a port (e.g. 22) and redirect to your server private IP. Be extremely cautious, the threat of cyberattacks is real. On GNU/Linux I would advise to use `firewall` and only authorize access to IPs you know.

- use the linux command `screen` to instanciate as many sessions as the number of pets you need. Run tamaShiny() on each of them and note the session ID.

- from a client computer, install PuTTY and prepare an access to your server. In Connection/SSH/Tunnels, add a new forwarded port (default is 1996, so the line should look like: L1996 | localhost:1996). The session ID is provided as the `port` argument of the `shiny` method. Open the session and identify.

- from the browser of your client computer, connect to your shiny session (localhost:1996 by default), and enjoy some time with your friend !  

## Note on the C++ structure

Tamalib has been implemented on [Arduino](https://github.com/GaryZ88/Arduinogotchi), with a bit of re-writing. The Arduino version is the starting point for tamaR C++ module. The java module for the ROM conversion has also been adapted from ArduinoGotchi.

Because Rcpp dependencies management was difficult, I gathered all tamalib code into a monolithic tamalib.cpp program.

## Tamacare

This package is a dependency of [tamacare](https://github.com/almarch/tamacare), another R package aiming to provide automatic care for your pet.

## Secret Character

An alternative secret character is provided. Will you take up the challenge and find out who this is ? To load the alternative secret character, use the `secret` method:

```r
guizmo$secret()
```

If you are spending time on a tamagotchi, odds are that you may have been a kid in the 90's and this secret character is dedicated to you.

## To do

- Implement sound. The frequency does not appear to be correctly collected from the `GetFreq()` method. Moreover, it seems that the `audio` solution to play the frequency on R doesn't work well on Linux (at least not on my environment).

- Similarily, tamalib could be implemented into [Python](https://www.python.org/). Like R, Python allows scripting and the development of web applications.
