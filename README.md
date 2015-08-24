This repository contains the text and code for this article:

> Cameron Blevins [Cameron Blevins](http://www.cameronblevins.org/) and [Lincoln Mullen](http://lincolnmullen.com/), "Jane, John ... Leslie? A Historical Method for Algorithmic Gender Prediction," *Digital Humanities Quarterly* (forthcoming 2015).

This article is accompanied by the [gender package](https://github.com/ropensci/gender) for the [R programming language](http://www.r-project.org/).


### Description of the repository

If you want to read the pre-print (well, pre-digital publication) version of this article, the files `Blevins-and-Mullen.gender-prediction.pdf` and `Blevins-and-Mullen.gender-predicition.html` contain the text and figures.

If you wish to reproduce the article's figures for yourself, the article's source code is contained in `article.Rmd`.

The dependencies for this article are managed with [packrat](http://rstudio.github.io/packrat/). Ideally upon opening the project directory in R, packrat will bootstrap itself and install all the R packages. If that does not happen, then you can use packrat to install the dependencies manually:

1.  Install devtools and packrat: `install.packages(c("devtools", "packrat"))`
2.  Turn on packrat mode: `packrat::on()`
3.  Install the dependencies: `packrat::restore()`

You should then be able to generate the article by running `make all`.

The file `article.Rmd` depends on some computationally intensive datasets which we have generated in `data/`. Should you wish to reproduce those, you can re-run our scripts in the `R/` directory.
