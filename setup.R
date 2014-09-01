# Install the necessary packages

install.packages(c("devtools", "knitr"), dependencies = TRUE)
library(devtools)
install_github("lmullen/gender-data-pkg")
install_github("ropensci/gender", branch = "develop") # development version
