library(gender)
library(dplyr)
library(tidyr)

# The gender function is not particular fast. Okay, it is downright slow. So
# it's important that we predict gender as few times as possible, then cache the
# result. The best way to run the function as few times as possible. So if there
# are two "charles" authors in the same year, then we can create a summarized
# data frame of just the unique combinations of names, and then merge the
# results back into the origional data frame.

# We'll start with just the dissertations. This gives us about 35K observations
# instead of about 80K.
diss_gender <- diss %>%
  group_by(author_first_name, year) %>%
  summarize(n = n())

# We need to provide a range of years in which we think the person was born.
min_dissertator_age <- 25
max_dissertator_age <- 45

# Now we will create columns for the minimum year and the maximum year for
# guessing gender.
diss_gender <- diss_gender %>%
  mutate(min_year = year - max_dissertator_age,
         max_year = year - min_dissertator_age)

# Now we need to decide which method to use when predicting the gender. In
# general we want to use IPUMS before 1930 and SSA after 1930, but sometimes
# we'll have to compromise. There are several kinds of obvious cases:
#
# - If max_age < 1930, use IPUMS
#
# - If min_age > 1930, use SSA
#
# The tricky cases are when the terminal values overlap the ranges of one of the
# methods.
#
# - If min_age > 1880 and max_age > 1930, use SSA
#
# If our range of ages was greater than 50, we might have a person who we
# guessed was born before 1880 or after 1930. But by keeping our range smaller
# than 50 (the difference between 1930 and 1880) we can avoid that problem.

# That does indeed match all cases. So now we can write a function to return the
# proper method for a given range of years.
pick_method <- function(min_age, max_age) {
  ifelse(max_age <= 1930, "ipums",
         ifelse(min_age > 1930, "ssa",
         ifelse(min_age > 1880 & max_age > 1930, "ssa", NA)))
}

# Now assign a method to the diss_gender dataset
diss_gender <- diss_gender %>%
  mutate(method = pick_method(min_year, max_year))

apply_gender <- function(df) {
  gender(df$author_first_name, method = df$method,
         years = c(df$min_year, df$max_year))
}

# Now do the prediction, caching the results
diss_results_fn <- "data/diss-gender-results.rda"
if(!file.exists(diss_results_fn)) {
  diss_gender_results <- diss_gender %>%
      rowwise() %>%
      do(gender_author = apply_gender(.))
  save(diss_gender_results, file = diss_results_fn, compress = TRUE)
} else {
  load(diss_results_fn)
}

# Now we have to do the same thing with the AHR. This is a little more tricky,
# because we have to do it for both the authors and the reviewers. We're going
# to assume that authors and reviewers have the same age range, so we can use
# tidyr's gather() function to create a list of all the combination of author
# names and years and avoid predicting names twice. This creates a list of about
# 43K names instead of about 129K names.
ahr_gender <- ahr %>%
  select(author = author_first_name,
         reviewer = reviewer_first_name,
         year = issueDate) %>%
  gather(type_of_name, author_first_name, -year) %>%
  group_by(author_first_name, year) %>%
  summarize(n = n()) %>%
  filter(author_first_name != "")

# We need to provide a range of years in which we think the author was born.
min_author_age <- 26
max_author_age <- 74

# Now we will create columns for the minimum year and the maximum year for
# guessing gender.
ahr_gender <- ahr_gender %>%
  mutate(min_year = year - max_author_age,
         max_year = year - min_author_age)

# Now we need to decide which method to use when predicting the gender. In
ahr_gender <- ahr_gender %>%
  mutate(method = pick_method(min_year, max_year))

# Now do the prediction, caching the results
ahr_results_fn <- "data/ahr-gender-results.rda"
if(!file.exists(ahr_results_fn)) {
  ahr_gender_results <- ahr_gender %>%
      rowwise() %>%
      do(gender_author = apply_gender(.))
  save(ahr_gender_results, file = ahr_results_fn, compress = TRUE)
} else {
  load(ahr_results_fn)
}
