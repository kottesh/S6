# Load necessary libraries
library(dplyr)
library(ggplot2)
print(getwd())

# Read the dataset
data <- read.csv("/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04/datasets/sample16.csv")  # Replace with your file path

# 1. Basic Dataset Information
cat("\n--- Basic Dataset Information ---\n")
print(str(data))
print(dim(data))
print(colnames(data))

# 2. Summary Statistics
cat("\n--- Summary Statistics ---\n")
summary_statistics <- summary(data)
print(summary_statistics)

# 3. Standard Deviation for Numeric Columns
cat("\n--- Standard Deviation for Numeric Columns ---\n")
std_dev <- sapply(data[sapply(data, is.numeric)], sd, na.rm = TRUE)
print(std_dev)

# 4. Checking for Missing Values
cat("\n--- Missing Values ---\n")
missing_values <- colSums(is.na(data))
print(missing_values)

# 5. Outlier Detection (using IQR method for numeric columns)
cat("\n--- Outlier Detection ---\n")
iqr_outliers <- function(data, column) {
  Q1 <- quantile(data[[column]], 0.25, na.rm = TRUE)
  Q3 <- quantile(data[[column]], 0.75, na.rm = TRUE)
  IQR_value <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR_value
  upper_bound <- Q3 + 1.5 * IQR_value
  return(which(data[[column]] < lower_bound | data[[column]] > upper_bound))
}
numeric_cols <- names(data[sapply(data, is.numeric)])
for (col in numeric_cols) {
  cat(paste("Outliers in", col, ":\n"))
  print(iqr_outliers(data, col))
}

# 6. Correlation Matrix
cat("\n--- Correlation Matrix ---\n")
numeric_data <- data %>% select_if(is.numeric)
cor_matrix <- cor(numeric_data, use = "complete.obs")
print(cor_matrix)

# 7. Visualization: Scatter Plot of Salary vs. Age
ggplot(data, aes(x = Age, y = Salary, color = Category)) +
  geom_point(size = 3, shape = 17) +
  labs(title = "Scatter Plot of Salary vs. Age", x = "Age", y = "Salary") +
  theme_minimal()

# Save the profiled dataset to a new CSV file
write.csv(data, "/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04/datasets/profiled_dataset.csv", row.names = FALSE)  # Change path as needed

cat("\n--- Dataset profiling completed and saved to 'profiled_dataset.csv' ---\n")
