# HMs_Activity

Tutorial on the analysis of activity patterns using trigonometric and cyclic cubic spline hierarchical models. A HTML version of the Tutorial is available at https://hms-activity.netlify.app/.

## Suggested Citation
This work is associated with a publication and a permanent repository. When using this material, we kindly ask you to cite:

- Iannarilli, F., Gerber, B. D., Erb, J., and Fieberg, J. R. (2024). A “How-to” Guide for Estimating Animal Diel Activity Using Hierarchical Models. Journal of Animal Ecology.

- Iannarilli, F., Gerber, B. D., Erb, J., and Fieberg, J. R. (2024). Data, R Code, and Output Supporting: A “How-to” Guide for Estimating Animal Diel Activity Using Hierarchical Models 
Retrieved from the Data Repository for the University of Minnesota.

## License:
This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

## How to compile the Tutorial

The tutorial can be compiled using the package `bookdown`. The HTML version of the tutorial can also be browsed by clicking on the `index.hmtl` file available in the `HMsActivity_book` folder. The related R code is available in a series of `.Rmds` files and the data used throughout this tutorial is provided in the folder `data_input`. 

The tutorial can be compiled by opening the R project `HMs_Activity.Rproj` and then running the following command in the R console:

`bookdown::render_book("index.Rmd", bookdown::gitbook(split_bib=FALSE, new_session = TRUE))`

Compiling the book takes up to several hours on a regular laptop.
