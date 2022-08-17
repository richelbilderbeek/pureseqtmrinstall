test_that("use", {
  folder_name <- file.path(tempfile(), "pureseqtmr")
  expect_false(pureseqtmr::is_pureseqtm_installed(folder_name = folder_name))
  install_pureseqtm(folder_name = folder_name)
  expect_true(pureseqtmr::is_pureseqtm_installed(folder_name = folder_name))
  uninstall_pureseqtm(folder_name = folder_name)
  expect_false(pureseqtmr::is_pureseqtm_installed(folder_name = folder_name))
})
