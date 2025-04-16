library(ggplot2)

data <- read.csv("C:/Users/prana/Downloads/sample15.csv", header = TRUE)

### 🔹 (a) Univariate Analysis
cat("\n--- Univariate Analysis ---\n")

# Summary statistics
summary_stats <- summary(data)
print(summary_stats)

# Histogram for numerical columns
num_cols <- sapply(data, is.numeric)
data_num <- data[, num_cols]  # Select only numeric columns

for (col in colnames(data_num)) {
  print(ggplot(data_num, aes_string(x = col)) +
          geom_histogram(color = "black", fill = "blue", bins = 30) +
          labs(title = paste("Histogram of", col), x = col, y = "Count") +
          theme_minimal())
}

# Density Plot
for (col in colnames(data_num)) {
  print(ggplot(data_num, aes_string(x = col)) +
          geom_density(fill = "red", alpha = 0.5) +
          labs(title = paste("Density Plot of", col), x = col, y = "Density") +
          theme_minimal())
}

### 🔹 (b) Bivariate Analysis
cat("\n--- Bivariate Analysis ---\n")

# Compute correlation matrix
cor_matrix <- cor(data_num, use = "complete.obs")
print(cor_matrix)

# Scatter Plots for first two numeric columns
if (ncol(data_num) >= 2) {
  print(ggplot(data_num, aes_string(x = colnames(data_num)[1], y = colnames(data_num)[2])) +
          geom_point(color = "blue") +
          labs(title = "Scatter Plot of Two Variables") +
          theme_minimal())
  
  # Regression Line
  print(ggplot(data_num, aes_string(x = colnames(data_num)[1], y = colnames(data_num)[2])) +
          geom_point(color = "blue") +
          geom_smooth(method = "lm", color = "red") +
          labs(title = "Regression Line") +
          theme_minimal())
}

### 🔹 (c) Box-plot for Random Numbers
set.seed(123)  # For reproducibility
random_numbers <- rnorm(100, mean = 50, sd = 10)  # Generate 100 random numbers

# Boxplot
random_df <- data.frame(Random_Numbers = random_numbers)
ggplot(random_df, aes(y = Random_Numbers)) +
  geom_boxplot(fill = "cyan", color = "black") +
  labs(title = "Box-plot for Random Numbers") +
  theme_minimal()
