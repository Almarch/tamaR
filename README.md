# <img src="inst/www/icon.png" alt="TaMaGoTcHi" width="40"/> The Tamagotchi is live on <img src="https://cran.r-project.org/Rlogo.svg" alt="R" width="45"/>

This is a package allowing the emulation of a P1 Tamagotchi in R using [TamaLIB](https://github.com/jcrona/tamalib).

<img src="https://upload.wikimedia.org/wikipedia/commons/e/ea/Docker_%28container_engine%29_logo_%28cropped%29.png" width="120px" align="right"/>

[R](https://r-project.org) is a scripting language, allowing either a live interaction or the elaboration of custom programs.

A web app can be launched online using the R library [shiny](https://shiny.posit.co). The online app can be installed either from R, either from [docker](https://docker.com).

<p align="center"><img src="https://github.com/user-attachments/assets/fe3c4fdd-2a94-4edd-ae6a-c61e2424b517" alt = "ezgif" width="400px"/></p>

## 1. Demo version

<img src="https://docs.posit.co/images/product-icons/posit-icon-fullcolor.png" width="60px" align="right"/>

A demo version is kindly hosted on [Posit Cloud](https://posit.co) and available [at this address](https://almarch.shinyapps.io/tamaR). The demo version is slighlty different from the main one, check the information of the <a href = https://github.com/Almarch/tamaR/tree/posit>posit branch</a>. NB: Posit cloud shuts down inactive Shiny sessions, so the game state is lost after deconnection. Use your own server to keep a game consistent timeline.

Another demo version is available on a private virtual server at [at this address](https://creature.ovh). It runs a light version of the app and requires no credentials, so that the pet custody is shared with the world wide web. If someone else is interacting with the pet, please wait a few minutes in order not to turn it crazy. The automatic care feature and the sprites switch are not available on this demo version.

## 2. Installation

Start by cloning the git repository. The ROM (`rom.bin` or `rom.h`) must be placed into the `src` directory.

If you have a `tama.b` ROM, rename it `rom.bin`.

If you have a `rom_12b.h` ROM, rename it `rom.h`. The first line should be: `static unsigned char g_program_b12[] = {`, edit it if necessary.

```bash
git clone https://github.almarch/tamaR.git
cp rom.bin tamaR/src/
```

### 2.1. Installation with <img src="https://upload.wikimedia.org/wikipedia/en/thumb/f/f4/Docker_logo.svg/1920px-Docker_logo.svg.png" alt="docker" width="120"/>

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

### 2.2. Installation as an <img src="https://cran.r-project.org/Rlogo.svg" alt="R" width="30"/> package

tamaR can be installed as an R package. 

If you start with a binary version of the ROM (`rom.bin`), the first step is to convert it into a 12 bits text format. Open R and use the package functions:

```r
source("tamaR/R/convert_rom.R")
source("tamaR/R/nb2hex.R")
convert_rom("tamaR/src/rom.bin", "tamaR/src/rom.h")
```

Still from R, install all required dependencies:

```r
install.packages(c('Rcpp','png','shiny','bsplus','shinyjs','shinymanager','shinyWidgets'))
```

Then leave R. The package can be now be built with [Rcpp](https://rcpp.org) and installed.

```bash
R CMD INSTALL tamaR
```

The package tamaR can now be called from an R console:

```R
library(tamaR)
```

## 3. Use as an <img src="https://cran.r-project.org/Rlogo.svg" alt="R" width="45"/> package

The instanciation of an object of class `Tama` prepares a Tamagotchi and provides an R interface for it. The `start` method launches the real-time emulation. A single Tamagotchi can be alive on a given R session: instancing several `Tama`'s will crash them. If you need several pets, run several R sessions.

```r
guizmo = Tama()
guizmo$start()
```

The Tamagotchi is either running (after calling the `start` method) or off (after calling the `stop` method).

```r
guizmo$stop()
```

### 3.1. Playing with command lines

Once running, the `click` method allows an interaction with the 3 buttons: left (`"A"`), middle (`"B"`) and right (`"C"`). The `delay` argument specify how long the click should last.

```r
guizmo$start()
guizmo$click(button = "B",delay = 1)
Sys.sleep(3)
for(i in 1:7) {
    guizmo$click("A")
    Sys.sleep(.5)
}
```

The display method prints the screen.

```r
guizmo$display()
```

<p align="center"><img src="https://github.com/user-attachments/assets/9e944691-df30-4296-aee2-b47cc8282683" width="800px"/></p>

### 3.2. Game state

The state can be saved anytime using the corresponding method:

```r
guizmo$stop()
guizmo$save("myTama.txt")
guizmo$start()
```

And it can be loaded as well:

```r
guizmo$stop()
guizmo$load("myTama.txt")
guizmo$start()
```

The game state may be reset with the `reset` method:

```r
guizmo$stop()
guizmo$reset()
```

### 3.3. Babysitting

To provide automatic care for your virtual pet, call the `babysit` function on your running Tamagotchi. The `end` argument provides a date at which the automatic care should stop.

```r
guizmo$start()
babysit(guizmo, end = Sys.time() + 10*60) # ten minutes
```

### 3.4. P2 sprites

Using [TamaTool](https://github.com/jcrona/tamatool) ROM editor, a mod of the original P1 ROM has been provided in order to use the P2 sprites.

```r
guizmo$stop()
p2(guizmo)
guizmo$start()
```
<p align="center"><img src="https://github.com/user-attachments/assets/1bf1a760-2aab-497d-9066-83beb1fa9cdd" alt="p2_egg" width="300" align="center"/></p>

This is not a perfect emulation of P2: some animations vary slightly, and the "number game" is not available. The P2 secret character is not available neither.

### 3.5. Shiny app
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Shiny_hex_logo.svg/800px-Shiny_hex_logo.svg.png" alt="Shiny" width="120" align="right"/>

The shiny app may be called from R with the `go` function:

```r
go(guizmo)
```

The `light` argument selects which one of a lighter or a more complete application to use.

- `light = TRUE` (default) is well suited for playing locally ;

- `light = FALSE` is designed for a safer web experience.

To call the app directly from a bash console with the view to deploy it online:

```bash
R -e "library(tamaR); Tama() |> go(port = 1996, light = F)"
```

The app is now available locally at http://127.0.0.1:1996/

## 4. Web deployment

Now that the app is available at port 1996, it may be deployed online. The server will be assumed to be a linux computer behind a router with a fixed public IP.

First of all, you need the public IP of your network and the private IP of your server. The public IP can be accessed from one of the many benevolent website, for instance [this one](https://myip.com). The private IP can be accessed with the command:

```bash
hostname -I
```

### 4.1. Router

The router configuration depends on the internet supplier. The router configuration page may for instance be reached from within the network at http://`<public ip>`:80. Because port 80 might be in competition with other resources, for instance the internet supplier configuration page, we will set up the application to listen to port 8000, which is less commonly used.

The router should be parameterized as such:

- port 8000 should be open to TCP ;

- port 8000 should redirect to your linux server, identified with its private IP.

### 4.2. Firewall

Using a firewall is a first security step for a web server. For instance, [ufw](https://fr.wikipedia.org/wiki/Uncomplicated_Firewall) is free, open-source and easy to use.

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
### 4.3. Web server

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Nginx_logo.svg/768px-Nginx_logo.svg.png" alt="nginx" width="200px" align="right"/> 

A web server software is required to deploy the shiny app with its functionalities. For instance, [nginx](https://nginx.com) is a free, open-source popular solution.

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

### 4.4. Connection

The app is now available world-wide at http://`<public ip>`:8000

It can be played from a smartphone. A shortcut to the webpage may be added to the home screen. 

The Tamagotchi runs backend, so it remains alive when the user disconnects.

## 5. Use as a web app

### 5.1. Authentification

<img src="https://datastorm-open.github.io/shinymanager/reference/figures/shinymanager.png" alt="shinymanager" width="120px" align="right" />

The app is secured with [shinymanager](https://github.com/datastorm-open/shinymanager) and requires the user to authentify. There are 2 user profiles:
 
- ***player***
- ***admin***

Both start with the same password:

- ***qwerty***

<p align="center"><img src="https://github.com/user-attachments/assets/5e61e654-94ca-4b5b-94d0-8802463cec77" lat="auth" width="400px" /></p>

You are strongly encouraged to change both passwords as soon as possible for strong, distinct ones. Connect as ***admin*** to do so.

Only ***admin*** can modify both ***admin*** and ***player*** passwords. The ***player*** can only play. The ***player*** credentials are designed to be shareable with a friend or family member for instance. The ***admin*** credentials should remain confidential.

The ***admin*** can also change the ***player*** name.

### 5.2. Administration

The following settings are available when the user is authentified as ***admin***:

<p align="center"><img src="https://github.com/user-attachments/assets/227fef42-2a80-4e22-b1a2-9e8f7c74e80d" lat="admin" width="400px" /></p>

- Stop or resume the emulation ;

- Management:

    - Set the credentials (player name, admin and player passwords)

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

### 5.3. Original gameplay

The original gameplay is available when the user is authentified as ***player***. The 3 buttons (left, middle, right) are mapped as for the original toy.

<p align="center"><img src="https://github.com/user-attachments/assets/e2d89e4c-4b40-4f24-86eb-ed4f5a2cbe01" lat="gameplay" width="400px" /></p>

The jungle background comes from [this collection](https://www.vecteezy.com/vector-art/294963-a-green-jungle-landscape). It has been cropped to a square, resized to 500*500px, converted to png, and lighten to improve contrasts. Finally, it has been set as background from the administrator board of the shiny web app.

### 5.4. Automatic care

The shiny app also provides the option to automatically care for the hosted pet, a feature inspired from [tamatrix](https://github.com/greysonp/tamatrix). It uses the same routine as the `babysit` function previously described.

<p align="center"><img src="https://github.com/user-attachments/assets/cfa0c452-19a7-4a52-aac9-501609184927" alt="babysitting" width="300"/></p> 

When checking the "automatic care" option, it is possible to choose whether the creature should also be scolded when needed. Indeed, discipline strongly impacts the evolutionary pathway of Tamagotchis.

The automatic care process works on the frontend, so it will not support being launched from several instances. It also requires that a device (or the server itself) keeps a shiny session active.

## 6. Notes

### 6.1. Secret Character

<img src="https://static.wikia.nocookie.net/tamagotchi/images/c/c8/1646940251499.png/revision/latest?cb=20221116221251" alt="maskutchi" width="80" align="right"/>

A new but familiar secret character has snuck in the game. Will you find out who this is ?

Several releases of P1 exist: an older one (1996) and a replica re-release. According to the [fandom](https://tamagotchi.fandom.com/wiki/Tamagotchi_(1996_Pet)), replicas evolve from Maskutchi independently on the discipline level, as opposed to the original 1996 version that requires a strict 0 discipline to unlock the secret character. Testing this property led to the conclusion that the circulating ROM would be the 1996 version, not the latter replica.

### 6.2. C++ structure

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/ISO_C%2B%2B_Logo.svg/800px-ISO_C%2B%2B_Logo.svg.png" alt="c++" width="120" align="right"/>

TamaLIB has been implemented on [Arduino](https://github.com/GaryZ88/Arduinogotchi), with a bit of re-writing. The Arduino version is the starting point for tamaR C++ module, including the ROM conversion step. TamaLIB was converted from C to C++ in order to ensure consistency with R object-orientation. However, because Rcpp dependencies management was not trivial, I gathered all TamaLIB code into a monolithic tamalib.cpp program.

TamaLIB was adapted with attention to its platform agnosticity, so tamaR should run on any OS/architecture that supports R. So far, the package tamaR has been succesfully built, installed and locally tested on linux/amd64 and windows/amd64.

### 6.3. Sound

The buzzer frequency is properly fetched with the `GetFreq` method.

Sound implementation to the web app is being investigated in a feature branch, however, the current approach raises performance issues.

## 7. Legal

### 7.1. Disclaimer

Enabling the web server exposes your server to the internet. Cares have been taken to make the web server application as safe as possible; however, by utilizing this functionality, you acknowledge and agree that you are solely responsible for configuring and securing your web server. The developer and associated parties are not liable for any damages, losses, or security breaches resulting from using the web server application or from using any information found on this page.

### 7.2. License 

This work is licensed under Attribution-NonCommercial 4.0 International.

The ROM is not provided and the author do not endorse game piracy: check your local regulation concerning retro games emulation.

All graphical resources come from the extraordinarily rich Tamagotchi [fandom](https://tamagotchi.fandom.com/wiki/Tamagotchi_(1996_Pet)).
