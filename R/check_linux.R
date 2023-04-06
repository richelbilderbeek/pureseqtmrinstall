#' Check that this package is run under Linux
#' @return Nothing.
#' @examples
#' check_linux()
#' @author Richèl J.C. Bilderbeek
#' @export
check_linux <- function() {
  if (as.character(Sys.info()["sysname"]) != "Linux") {
    stop("PureseqTM only runs under Linux")
  }
}

