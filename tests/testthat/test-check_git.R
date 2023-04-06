test_that("git must be installed", {
  expect_silent(check_git())
})
