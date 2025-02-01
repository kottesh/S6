library(readxl)

data <- read_excel('/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04 data mining lab/datasets/Mobile Sales In India.xlsx')

# data$rating_z <- scale(data$Rating) # used to standardize or (z-score normalize)

mean_rating <- mean(data$Rating)
sd_rating <- sd(data$Rating)

# z-score
data$rating_z <- (data$Rating - mean_rating)/sd_rating

# after performing z-score normalization mean will be 0 and std_dev will be 1
mean(data$rating_z)
sd(data$rating_z)

View(data)
