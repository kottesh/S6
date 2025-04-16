library(dplyr)
library(ggplot2)
library(corrplot)

data <- read.csv("C:/Users/prana/Downloads/sample13.csv", header = TRUE, stringsAsFactors = FALSE)

cat("\n--- Dataset Description ---\n")
print(summary(data))

cat("\n--- Missing Values ---\n")
print(colSums(is.na(data)))

z_score_outliers <- function(data, column) {
  threshold <- 3
  z_scores <- (data[[column]] - mean(data[[column]], na.rm = TRUE)) / sd(data[[column]], na.rm = TRUE)
  return(which(abs(z_scores) > threshold))  
}

modified_z_score_outliers <- function(data, column) {
  threshold <- 3.5
  median_val <- median(data[[column]], na.rm = TRUE)
  mad_val <- mad(data[[column]], na.rm = TRUE)  
  mod_z_scores <- 0.6745 * (data[[column]] - median_val) / mad_val
  return(which(abs(mod_z_scores) > threshold))
}

iqr_outliers <- function(data, column) {
  Q1 <- quantile(data[[column]], 0.25, na.rm = TRUE)
  Q3 <- quantile(data[[column]], 0.75, na.rm = TRUE)
  IQR_value <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR_value
  upper_bound <- Q3 + 1.5 * IQR_value
  return(which(data[[column]] < lower_bound | data[[column]] > upper_bound))
}

cat("\n--- Outliers in Salary Column ---\n")
cat("Z-Score Method: ", z_score_outliers(data, "Salary"), "\n")
cat("Modified Z-Score Method: ", modified_z_score_outliers(data, "Salary"), "\n")
cat("IQR Method: ", iqr_outliers(data, "Salary"), "\n")

# ----------------------------  b. Correlation Matrix ----------------------------
cat("\n--- Correlation Matrix ---\n")
numeric_data <- data %>% select_if(is.numeric)
cor_matrix <- cor(numeric_data, use = "complete.obs")
print(cor_matrix)

# ----------------------------  c. Correlation Between Specific Attributes ----------------------------
cat("\n--- Correlation Between Age & Salary ---\n")
print(cor(data$Age, data$Salary, use = "complete.obs"))

cat("\n--- Correlation Between Salary & Experience ---\n")
print(cor(data$Salary, data$Experience, use = "complete.obs"))

# ----------------------------  d. Visualizing Correlation Matrix ----------------------------
cat("\n--- Correlation Matrix Visualization ---\n")
corrplot(cor_matrix, method = "color", type = "upper", tl.cex = 0.8, number.cex = 0.7)