% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tamaR-exports.r
\name{Tama}
\alias{Tama}
\title{Instanciate a Tama object}
\value{
An object of class Tama
}
\description{
Instanciate a Tama object
}
\examples{
guizmo = Tama()
guizmo$start()
guizmo$display()
guizmo$click("B"); Sys.sleep(3)
for(i in 1:7) {guizmo$click("A"); Sys.sleep(.25)}
guizmo$click("C"); Sys.sleep(3)
Sys.sleep(300)
guizmo$display()
guizmo$save("babytchi.txt")
guizmo$stop()
guizmo$reset()
guizmo$load("babytchi.txt")
guizmo$start()


}
