# Load necessary libraries
library(rpart)
library(rpart.plot)

# Load dataset
data <- read.csv("C:/Users/prana/Downloads/memory_retention_dataset.csv")

# Convert retention into binary classification (High vs Low)
data$HighRetention <- ifelse(data$Recall_After_1_Week >= 50, 1, 0)

# Train Decision Tree Model
fit <- rpart(HighRetention ~ Time_Spent_mins + Breaks_Taken + Preferred_Learning_Method, 
             data = data, method = "class")

# Visualize Decision Tree
windows()  # Open new plot window
par(mar = c(5, 4, 4, 2) + 0.1)  # Adjust margins
rpart.plot(fit, main = "Decision Tree for Study Retention", type = 4, extra = 101)
