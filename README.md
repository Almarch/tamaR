# <img src="inst/www/icon.png" alt="TaMaGoTcHi" width="35"/> The Tamagotchi is live on <img src="https://cran.r-project.org/Rlogo.svg" alt="R" width="45"/>

This is a package allowing the emulation of a P1 Tamagotchi in R using [TamaLIB](https://github.com/jcrona/tamalib).

[R](https://r-project.org) is a scripting language, allowing either a live interaction or the elaboration of custom programs.

A web app can be launched online using the R library [shiny](https://shiny.posit.co). The online app can be installed either with R, either without, using [docker](https://docker.com).

![311432812-dbf7285f-a233-4667-8983-b687dc40f67d](https://github.com/Almarch/tamaR/assets/13364928/aefe1e81-267b-49c3-8b2f-952dd32a0528)

## Installation

Start by cloning the git repository. A ROM named "rom.bin" must then be placed into the src directory.

```bash
git clone https://github.almarch/tamaR.git
cp rom.bin tamaR/src/
```

### Installation as a docker container

tamaR can be installed and launched as a docker container. As such, R installation is not required.

```bash
cd tamaR
docker build -t tama .
```

The container can now be run:

```bash
docker run -d -p 1996:80 tama
```

The shiny app is directly available at http://127.0.0.1:1996/

### Installation as an R package

tamaR can be installed as an R package. To do so, the first step is to convert the ROM into 12 bits. Then the package can be built with [Rcpp](https://rcpp.org) and installed.

```bash
Rscript tamaR/src/TamaRomConvert.r
R -e "install.packages(c('Rcpp','shiny','png','shinyjs','bsplus'))"
R CMD build tamaR
R CMD INSTALL tamaR_*.tar.gz
```

The package tamaR can now be called from an R console.

```R
library(tamaR)
```

![image](https://github.com/Almarch/tamaR/assets/13364928/a6abad1b-8332-4234-ba14-b589757bf69b)

## Use as an R package

The instanciation of an object of class `Tama` prepares a Tamagotchi and provides an R interface for it. The `start` method launches the real-time emulation. A single Tamagotchi can be alive on a given R session: instancing several `Tama`'s will crash them. If you need several pets, run several R sessions.

```r
guizmo = Tama()
guizmo$start()
```

The screen can be plotted via the `display` method. A custom background can be provided as a square-ish png, imported using `png::readPNG`.

```r
guizmo$display()
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

However, you cannot load a state into a running `Tama` (the result may be glitched). Stop the emulation first using `stop`:

```r
guizmo$stop()
guizmo$load("myTama.txt")
guizmo$start()
```

Finally, you can launch the shiny app from a running Tamagotchi using the `go` function.

```r
go(guizmo, port = 1996)
```

The app is now available locally at http://127.0.0.1:1996/

## Web deployment

Now that the app is available at port 1996, it may be deployed online. The server will be assumed to be a linux computer behind a router with a fixed public IP.

First of all, you need the public IP of your network and the private IP of your server. The public IP can be accessed from one of the many benevolent website, for instance [this one](https://myip.com). The private IP can be accessed with the command:

```bash
hostname -I
```

### Router

The router configuration depends on the internet supplier. The router configuration page may for instance be reached from within the network at http://`<public ip>`:80. Because port 80 might be in competition with other resources, for instance the internet supplier configuration page, we will set up the application to listen to port 8000, which is less commonly used.

The router should be parameterized as such:

- port 8000 should be open to TCP ;

- port 8000 should redirect to your linux server, identified with its private IP.

### Firewall

Using a firewall is a first security step for a web server. For instance, [ufw](https://fr.wikipedia.org/wiki/Uncomplicated_Firewall) does the job and is easy to use.

```bash
sudo apt install ufw
sudo ufw enable
sudo systemctl enable ufw
```

Port 8000 should be open to TCP. After configuring the router it may be checked and it has to be restarted.

```bash
sudo ufw allow 8000/tcp
sudo ufw status
sudo systemctl restart ufw
```

### Web server

A web server software is required to deploy the shiny app with its functionalities. For instance, [nginx](https://nginx.com) is a popular solution.

```bash
sudo apt install nginx
sudo systemctl enable nginx
```

A configuration file should be provided for the app. Place the following configuration in an app file in the /etc/nginx/sites-available/ folder:

```
server {
        listen 8000;
        server_name _;

        location / {
                proxy_pass http://localhost:1996;
                proxy_redirect http://localhost:1996/ $scheme://$http_host/;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_read_timeout 20d;
                proxy_buffering off;
        }
}
```

Create a symlink in the /etc/nginx/sites-enabled/ folder, and restard nginx:

```bash
sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
sudo systemctl restart nginx
```

### Connection

The app is now available world-wide at http://`<public ip>`:8000

It can be played from a smartphone. A shortcut to the webpage may be added to the home screen. 

The Tamagotchi runs backend, so it remains alive when the user disconnects.

## Use as a web app

### Passwords

At first connection, the app requires the set-up of an administrator password. This passwords allows reaching the administrator board, from which the game can be parameterized. Among other parameterizations, the administrator must define an user password. The user password cannot be null and should be different from the administrator password. The user password may be changed from the administrator board, whereas the administrator password cannot be changed further. At each future connection, it is possible to connect either with the administrator password to reach the administrator board ; either with the user password to play the game.

![pwd](https://github.com/Almarch/tamaR/assets/13364928/59311c44-5693-4905-9c75-8b509eb7ad98)

For optimal security, provide strong passwords. At each log in, a 2 seconds delay is observed to hamper brute force cracking attempts. Tamagotchi has not been designed as a multi-player game. Several users attempting to interact simultaneously with the toy will not work well.

### Administration

The following settings are available from the administrator board:

- Stop or resume the emulation ;

- Go back to the log-in screen ;

- User settings:

    - Set or modify the user password ;

    - Enable the use of the automatic care feature.

- Play as admin (the game must be running):

    - Click A+C buttons simultaneously to turn the sound on or off, or to set up the clock.

- Aesthetics (the game must be stopped):

    - Change the background for a light, square png ;

    - Switch the sprites to the P2 ones ;

    - Dump the ROM or load a new, customized one ;

    - Reset all aesthetics.

- Game state (the game must be stopped):

    - Save the game or load a previously saved one ;

    - Reset the game state (as the back button from the original toy).


### Original gameplay

The original gameplay is available when the user is connected using the user password.

The 3 buttons (left, middle, right) are mapped as for the original toy.

![game](https://github.com/Almarch/tamaR/assets/13364928/8d80eca2-1161-4cd1-844e-c69313d6d666)

The jungle background comes from [this collection](https://www.vecteezy.com/vector-art/294963-a-green-jungle-landscape). It has been cropped to a square, resized to 500*500px, converted to png, and lighten to improve contrasts. Finally, it has been set as background from the administrator board.

### Automatic care

The shiny app also provides the option to automatically care for the hosted pet, a feature inspired from [tamatrix](https://github.com/greysonp/tamatrix).

When checking the "automatic care" option, it is possible to choose whether the creature should also be disciplined. Indeed, discipline strongly impact the evolutionary pathway of Tamagotchis.

![care](https://github.com/Almarch/tamaR/assets/13364928/dd6a2b13-d03a-46a3-aea8-f4d540a01582)

The automatic care process works on the frontend, so it will not support being launched from several instances. It also requires that a device (or the server itself) keeps a shiny session active.

### P2 sprites

Using [TamaTool](https://github.com/jcrona/tamatool) ROM editor, a mod of the original P1 ROM has been provided in order to use the P2 sprites.

![p2](https://github.com/Almarch/tamaR/assets/13364928/d28fb569-0a98-43e1-9ecd-e50e39cd12d8)

This is not a perfect emulation of P2: some animations vary slightly, and the "number game" is not available. The P2 secret character is not available neither.

## Secret Character

A new but familiar secret character has snuck in the game. Will you find out who this is ?

## Notes on the C++ structure

TamaLIB has been implemented on [Arduino](https://github.com/GaryZ88/Arduinogotchi), with a bit of re-writing. The Arduino version is the starting point for tamaR C++ module, including the ROM conversion step. TamaLIB was converted from C to C++ in order to ensure consistency with R object-orientation. However, because Rcpp dependencies management was not trivial, I gathered all TamaLIB code into a monolithic tamalib.cpp program.

TamaLIB was adapted with attention to its platform agnosticity, so tamaR should run on any OS/architecture that supports R. So far, the package tamaR has been succesfully built, installed and locally tested on linux/amd64 and windows/amd64.

## To do

The sound has not been implemented in the R shiny app yet. However, it is properly fetched with the GetFreq method.

## Disclaimer

Enabling the web server exposes your server to the internet. Cares have been taken to make the web server application as safe as possible; however, by utilizing this functionality, you acknowledge and agree that you are solely responsible for configuring and securing your web server. The developer and associated parties are not liable for any damages, losses, or security breaches resulting from using the web server application or from using any information found on this page.

## License 

This work is licensed under Attribution-NonCommercial 4.0 International.

All graphical resources come from the extraordinarily rich Tamagotchi [fandom](https://tamagotchi.fandom.com/wiki/Tamagotchi_(1996_Pet)).
