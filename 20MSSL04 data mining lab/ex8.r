library(readxl)

data <- read_excel('/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04 data mining lab/datasets/Mobile Sales In India.xlsx')

# min-max normalization

rating_range <- range(data$Rating)
min <- rating_range[1]
max <- rating_range[2]
data$rating_mm <- (data$Rating - min)/(max - min)

# if we check the min and max that will be 0, 1 i.e the values are normalized in the range [0-1]
range(data$rating_mm)

View(data)
