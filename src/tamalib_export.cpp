// tama_export.cpp

// Include Rcpp system header file (e.g. <>)
#include <Rcpp.h>

// Include our definition of the student file (e.g. "")
#include "tamalib.h"

// Expose (some of) the Tamalib class
RCPP_MODULE(Tamalib) {             // Name used to "loadModule" in R script
  Rcpp::class_<Tama>("Tama")       // This must be the C++ class name.
  .constructor()
  .method("run", &Tama::run)
  .method("GetFreq", &Tama::GetFreq)
  .method("GetMatrix", &Tama::GetMatrix)
  .method("GetIcon", &Tama::GetIcon)
  .method("SetCPU", &Tama::SetCPU)
  .method("GetCPU", &Tama::GetCPU)
  .method("GetROM", &Tama::GetROM)
  .method("SetROM", &Tama::SetROM)
  .method("SetButton", &Tama::SetButton)
  .method("GetButton", &Tama::GetButton);
}