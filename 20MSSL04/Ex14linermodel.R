library(ggplot2)

linear_regression <- function(x, y) {
  n <- length(x)  # Number of data points
  
  mean_x <- mean(x)
  mean_y <- mean(y)
  
  num <- sum((x - mean_x) * (y - mean_y))
  den <- sum((x - mean_x)^2)
  m <- num / den  # Slope
  
  c <- mean_y - m * mean_x
  
  return(list(slope = m, intercept = c))
}

predict_values <- function(x, model) {
  return(model$slope * x + model$intercept)
}

data <- read.csv("C:/Users/prana/Downloads/sample14.csv", header = TRUE)

experience <- data$Experience
salary <- data$Salary

model <- linear_regression(experience, salary)

cat("\n--- Linear Regression Model ---\n")
cat("Slope (m):", model$slope, "\n")
cat("Intercept (c):", model$intercept, "\n")

predicted_salaries <- predict_values(experience, model)

ggplot(data, aes(x = Experience, y = Salary)) +
  geom_point(color = "blue", size = 3) +  # Scatter Plot
  geom_line(aes(y = predicted_salaries), color = "red", size = 1) +  
  labs(title = "Experience vs Salary Regression",
       x = "Years of Experience",
       y = "Salary (USD)") +
  theme_minimal()
