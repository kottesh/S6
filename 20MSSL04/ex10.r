library(readxl)

data <- read_excel('/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04 data mining lab/datasets/Mobile Sales In India.xlsx')

decimal_scale <- function(rating) {
  max_rating <- max(abs(rating))
  
  pow <- 0
  
  while (max_rating / 10^pow >= 1) {
    pow <- pow + 1
  }
  
  rating / 10^pow
}

data$rating_ds <- decimal_scale(data$Rating)

# decimal scaling
range(data$rating_ds)

View(data)
