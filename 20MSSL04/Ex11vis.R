library(ggplot2)

data <- read.csv("C:/Users/prana/Downloads/sample.csv") 

print(head(data))

summary_statistics <- summary(data)
print(summary_statistics)

std_dev <- sapply(data[sapply(data, is.numeric)], sd, na.rm = TRUE)
print(std_dev)

split_data <- split(data, data$Category)
print(split_data)

data$AgeGroup <- cut(
  data$Age,
  breaks = c(0, 20, 30, 40, 50, Inf), # Define age ranges
  labels = c("0-20", "21-30", "31-40", "41-50", "51+"),
  right = FALSE
)

# Split data by age groups
split_data <- split(data, data$AgeGroup)
print(split_data)

ggplot(data, aes(x = Age, y = Salary, shape = AgeGroup, color = AgeGroup)) +
  geom_point(size = 3) + # Use `shape` for different point shapes
  labs(
    title = "Scatter Plot of Salary vs. Age",
    x = "Age",
    y = "Salary"
  ) +
  theme_minimal()
