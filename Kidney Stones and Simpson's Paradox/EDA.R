library(dplyr)
library(readr)
library(ggplot2)

data <- read_csv("D:/Python/Portfolio Projects/Kidney Stones and Simpson's Paradox/kidney_stone_data.csv")

head(data)
summary(data)

# Calculate the number and frequency of success and failure of each treatment 
data %>% group_by(treatment,success) %>% summarise(N=n()) %>% mutate(Freq=round(N/sum(N),2))

# Calculate number and frequency of success and failure by stone size for each treatment
sum_data <- data %>% group_by(treatment,stone_size,success) %>% summarise(N=n()) %>% mutate(Freq=round(N/sum(N),2))

sum_data %>% ggplot(aes(x=treatment,y=N)) + geom_bar(aes(fill=stone_size),stat='identity')

#finding confounding variable
library(broom)
test_res <- chisq.test(data$treatment,data$stone_size)
tidy(test_res)


# Run a multiple logistic regression
m <- glm(data=data, success ~ stone_size + treatment, family="binomial")

# Print out model coefficient table in tidy format

tidy(m)


# Save the tidy model output into an object
tidy_m <- tidy(m)
tidy_m
# Plot the coefficient estimates with 95% CI for each term in the model
tidy_m %>%
  ggplot(aes(x = term, y = estimate)) + 
  geom_pointrange(aes(ymin = estimate - 1.96 * std.error, 
                      ymax = estimate + 1.96 * std.error)) +
  geom_hline(yintercept = 0)


# Is small stone more likely to be a success after controlling for treatment option effect?
# Options: Yes, No (as string)
small_high_success <- "Yes"

# Is treatment A significantly better than B?
# Options: Yes, No (as string)
A_B_sig <- "No"



knitr::stitch_rhtml("D:/Python/Portfolio Projects/Kidney Stones and Simpson's Paradox/EDA.r")

dev.off() # clear plots
cat("\014") #ctrl+L
