Article on predicting gender by [Cameron Blevins][] and [Lincoln
Mullen][]. See also the [Gender][] package for R described herein.

### Using Packrat

The dependencies for this article are managed with [Packrat][]. Ideally
upon opening the project in RStudio, Packrat should bootstrap itself and
install all the R packages. If that does not happen, then you can use
packrat to install the dependencies manually:

1.  Install Devtools and Packrat:

```
install.packages(c("devtools", "packrat"))
```

2.  Turn on Packrat mode:

```
packrat::on()
```

3.  Install the dependencies:

```
packrat::restore()
```

You should then be able to generate the article by opening `article.Rmd`
and clicking "Knit HTML" (more on using [RMarkdown][]).

  [Cameron Blevins]: http://www.cameronblevins.org/
  [Lincoln Mullen]: http://lincolnmullen.com/
  [Gender]: https://github.com/ropensci/gender
  [Packrat]: http://rstudio.github.io/packrat/
  [RMarkdown]: http://rmarkdown.rstudio.com/
