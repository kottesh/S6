library(caret)
library(ggplot2)
library(pROC)

file_path <- "/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04/datasets/classification_data.csv"  # Update path if needed
data <- read.csv(file_path)

# Explore Data
print(head(data))  # Display first few rows
summary(data)  # Summary statistics
str(data)  # Structure of dataset

# Data Visualization
ggplot(data, aes(x = Age, y = Salary, color = factor(Purchased))) +
  geom_point() +
  labs(title = "Age vs Salary", color = "Purchased")

# Convert Target Variable to Factor
data$Purchased <- as.factor(data$Purchased)

# Split Data into Train and Test Sets (80-20 split)
set.seed(123)
index <- createDataPartition(data$Purchased, p = 0.8, list = FALSE)
train_data <- data[index, ]
test_data <- data[-index, ]

# Train Logistic Regression Model
logistic_model <- glm(Purchased ~ ., data = train_data, family = binomial)
summary(logistic_model)  # Model summary

# Predict Test Set Results
predictions <- predict(logistic_model, newdata = test_data, type = "response")
predicted_classes <- ifelse(predictions > 0.5, 1, 0)
predicted_classes <- factor(predicted_classes, levels = c(0, 1))

# Compute Accuracy
accuracy <- mean(predicted_classes == test_data$Purchased)
print(paste("Model Accuracy:", round(accuracy * 100, 2), "%"))

# Compute Precision, Recall, and F1-Score
conf_matrix <- confusionMatrix(predicted_classes, test_data$Purchased)
print(conf_matrix)

# Visualize Confusion Matrix
ggplot(data = as.data.frame(conf_matrix$table), aes(x = Prediction, y = Reference, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), vjust = 1) +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Confusion Matrix Heatmap")
