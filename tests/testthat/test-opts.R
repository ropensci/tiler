context("options")

test_that("tiler_options runs as expected", {
  expect_identical(names(tiler_options()), c("python", "osgeo4w"))
  python <- tiler_options()$python
  expect_is(tiler_options(python = "x"), "NULL")
  expect_equal(tiler_options()$python, "x")
  expect_is(tiler_options(python = python), "NULL")
})
