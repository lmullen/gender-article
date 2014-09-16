# Load the data and do any cleaning

library(dplyr)
library(stringr)

# The dissertations data has already been cleaned.
# See https://github.com/lmullen/dissertations-data
diss <- read.csv("data/h_diss2.csv", stringsAsFactors = FALSE) %>%
  tbl_df()

# The AHR data has been converted to UTF8. For some entries the first name
# column contains first and middle names, so we're going to parse out just the
# first names.
ahr <- read.csv("data/ahr.utf8.csv", stringsAsFactors = FALSE) %>%
  tbl_df() %>%
  mutate(author_first_name = word(Author_First),
         reviewer_first_name = word(Reviewer_First))
