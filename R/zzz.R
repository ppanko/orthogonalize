### Title:    Clean up DLL on exit 
### Author:   Pavel Panko
### Created:  2019-MAR-12
### Modified: 2019-MAR-17

.onUnload <- function(libpath) {
  library.dynam.unload("orthogonalize", libpath)
}
