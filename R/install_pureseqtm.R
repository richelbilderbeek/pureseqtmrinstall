#' Install PureseqTM to a local folder
#' @inheritParams pureseqtmr::install_pureseqtm
#' @return Nothing.
#' @examples
#' \dontrun{
#'   install_pureseqtm()
#' }
#' @author Richèl J.C. Bilderbeek
#' @export
install_pureseqtm <- function(
  folder_name = pureseqtmr::get_default_pureseqtm_folder(),
  pureseqtm_url = pureseqtmr::get_pureseqtm_url()
) {
  pureseqtmrinstall::check_linux()
  if (pureseqtmr::is_pureseqtm_installed(folder_name = folder_name)) {
    stop("PureseqTMis already installed")
  }

  # Create the folder if needed, do not warn if it is already present
  dir.create(folder_name, showWarnings = FALSE, recursive = TRUE)


  # Check if already cloned
  pureseqtm_folder <- normalizePath(
    file.path(
      folder_name,
      basename(pureseqtm_url)
    )
  )

  bin_filename <- normalizePath(file.path(pureseqtm_folder, "PureseqTM.sh"))
  if (!dir.exists(pureseqtm_folder) || !file.exists(bin_filename)) {

    curwd <- getwd()
    on.exit(setwd(curwd))
    setwd(folder_name)

    # If the folder already exists, remove it, else git will complain
    if (dir.exists(basename(pureseqtm_url))) {
      unlink(basename(pureseqtm_url), recursive = TRUE)
    }
    pureseqtmr::check_git()
    system2(
      command = "git",
      args = c(
        "clone",
        paste0(pureseqtm_url, ".git")
      ),
      stdout = NULL,
      stderr = NULL
    )
    setwd(curwd)
    message("Done cloning repo at ", curwd)
  }
  testthat::expect_true(dir.exists(pureseqtm_folder))

  # Does the binary exist?
  if (!file.exists(bin_filename)) {
    stop(
      "Could not find 'bin_filename' at ",
      bin_filename
    )
  }

  # Binaries are made for Linux, recompile on other OSes
  if (rappdirs::app_dir()$os != "unix") {
    make_foldername <- file.path(pureseqtm_folder, "source_code")
    make_filename <- file.path(make_foldername, "Makefile")
    testthat::expect_true(file.exists(make_filename))
    curwd <- getwd()
    setwd(make_foldername)
    system2("make")
    setwd(curwd)
  }

  # binary file is executable
  testthat::expect_true(
    file.info(bin_filename)$mode != as.octmode("0600")
  )
}
