# We need to guess at the range of ages for book authors. 25 to 75 seems
# sensible enough.
min_age <- 25
max_age <- 75

# Now we will create columns for the minimum year and the maximum year for
# guessing gender.
ahr <- ahr %>%
  mutate(min_year = issueDate - max_age,
         max_year = issueDate - min_age)

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

# Now assign a method to the AHR dataset
ahr <- ahr %>%
  mutate(method = pick_method(min_year, max_year))

pass_through <- function(x) { return(x) }

apply_gender <- function(df) {
  gender(df$first_name, method = df$method,
         years = c(df$min_year, df$max_year))
  }

ahr_gender <- ahr %>%
  group_by(first_name, vol_issue_ID, Author_Full, Reviewer_First,
           Reviewer_Full, category) %>%
  do(gender_author = apply_gender(.))

# Finally we are ready to predict the gender. Because we have to combine years
# we're going to do this as a for loop, which is ugly.
# ahr_gender.l <- vector(mode = "list", nrow(ahr))

# for(i in 1:nrow(ahr)) {
#   row <- ahr[i, ]
#   result <- gender(row$first_name, method = row$method,
#                    years = c(row$min_year, row$max_year))
#   ahr_gender.l[[i]] <- result
# }

# ahr_gender.df <- ahr_gender.l %>% do.call(rbind.data.frame, .)
