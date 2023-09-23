# [Tamalib](https://github.com/jcrona/tamalib) is live on [R](https://r-project.org) !

This is a package allowing the emulation of a P1 tamagotchi in R, using an object-oriented paradigm.

![Screenshot from 2023-09-15 17-54-02](https://github.com/Almarch/tamaR/assets/13364928/3acdecf1-f4b3-42d7-82a5-3f97140b529c)

## Installation

Start by cloning the git repository:

```bash
git clone https://github.almarch/tamaR.git
```


If you use Windows, you must comment out the line 8 of tamalib.cpp as follows:

```cpp
// #define LINUX
```

Indeed, the time management libraries that I used are OS-dependent. Supported OS are GNU/Linux and Windows, this has not been tested on macOS yet.

The ROM must me converted to 12 bits and to a .h format. Place a rom.bin into the src repository, and run the following command line from tamaR/src:

```bash
java TamaRomConvert rom.bin
```

That should produce a rom.h file in the src directory.

Then, build and install the package with R (R.exe if you use the Windows terminal):

```bash
R CMD build tamaR
```

The package can then be installed:

```bash
R CMD INSTALL tamaR_1.0.0.tar.gz
```

You can then load the package from R:

```r
library(tamaR)
```

## Use

The instanciation of an object of class `Tama` from R will run a tamagotchi and provide an interface for it. The emulation is real-time. A single tamagotchi can be alive on a given R session: instanciating several `Tama`'s will crash them. If you need several pets, run several R sessions.

```r
guizmo = Tama()
```

The screen can be consulted via the `plot` function:

```r
plot(guizmo)
```

Buttons (A, B and C) can be controlled using the `click` method:

```r
guizmo$click("B")
guizmo$click(c("A","C"))
```

R is a scripting language, allowing either a live interaction or the elaboration of custom programs.

Alternatively, the tamagotchi can be played with using a shiny GUI:

```r
guizmo$shiny()
```

The state can be saved and loaded using the corresponding methods:

```r
guizmo$save("myTama.txt")
guizmo$load("myTama.txt")
```

## Server hosting

Shiny is not only a GUI but overall a powerfull web framework. Hence, the app can be used to host a tamagotchi nest on a server that will keep living their life whenever you are not connected. Here is how you can do to prepare a cozy place for your pets:

- your server needs to be accessible via internet. You can open your private network via your internet provider's administrator page: open a port (e.g. 22) and redirect to your server private IP. Be extremely cautious, the threat of cyberattacks is real. On GNU/Linux I would advise to use `firewall` and only authorize access to IPs you know.

- use the linux command `screen` to instanciate as many sessions as the number of pets you need. Run tamaShiny() on each of them and note the session ID.

- from a client computer, install PuTTY and prepare an access to your server. In Connection/SSH/Tunnels, add a new forwarded port with the 4 last numbers of your session ID (it may look like: L8888 | localhost:8888). Open the session and identify.

- from the browser of your client computer, connect to your shiny session (localhost:8888 in the previous example), and enjoy some time with your friend !  

## Note on the C++ structure

Tamalib has been implemented on [Arduino](https://github.com/GaryZ88/Arduinogotchi), with a bit of re-writing. The Arduino version is the starting point for tamaR C++ module. The java module for the ROM conversion has also been adapted from ArduinoGotchi.

Because Rcpp dependencies management was difficult, I gathered all tamalib code into a monolithic tamalib.cpp program.

## Tamacare

This package is a dependency of [tamacare](https://github.com/almarch/tamacare), another R package aiming to provide automatic care for your pet.

## To do

- Implement sound. The frequency does not appear to be correctly collected from the `GetFreq()` method. Moreover, it seems that the `audio` solution to play the frequency on R doesn't work well on Linux (at least not on my environment). 

- Similarily, tamalib could be implemented into [Python](https://www.python.org/). Like R, Python allows scripting and the development of web applications.
