#' Check that `git` is installed
#' @return Nothing.
#' @examples
#' check_git()
#' @author Richèl J.C. Bilderbeek
#' @export
check_git <- function() {
  tryCatch(
    testthat::expect_equal(1, length(gitr::git_version())),
    error = function(msg) {
      stop("'git' not found, please install it. \n", msg)
    }
  )
  NULL
}
