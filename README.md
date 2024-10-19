# HMs_Activity
Tutorial on the analysis of activity patterns using trigonometric and cyclic cubic spline hierarchical models.

The folder contains files to compile the tutorial using the package `bookdown`. The HTML version of the tutorial can be browsed by clicking on the `index.hmtl` file available in the `HMsActivity_book` folder. The related R code is available in a series of `.Rmds` files and the data used throughout this tutorial is provided in the folder `data_input`.

The tutorial can be compiled by opening the R project `HMs_Activity.Rproj` and then running the following command in the R console:

`bookdown::render_book("index.Rmd", bookdown::gitbook(split_bib=FALSE, new_session = TRUE))`

Compiling the book takes up to several hours on a regular laptop.
