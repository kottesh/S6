library(dplyr)

data <- read.csv("C:/Users/prana/Downloads/sample.csv", header = TRUE, stringsAsFactors = FALSE)

replace_missing <- function(data, column, method) {
  if (method == "mean") {
    data[[column]][is.na(data[[column]])] <- mean(as.numeric(data[[column]]), na.rm = TRUE)
  } else if (method == "mode") {
    mode_value <- names(sort(table(data[[column]]), decreasing = TRUE))[1]
    data[[column]][is.na(data[[column]])] <- mode_value
  }
  return(data)
}

min_max_normalization <- function(data, column) {
  data[[column]] <- (data[[column]] - min(data[[column]], na.rm = TRUE)) / 
    (max(data[[column]], na.rm = TRUE) - min(data[[column]], na.rm = TRUE))
  return(data)
}

max_abs_scaling <- function(data, column) {
  data[[column]] <- data[[column]] / max(abs(data[[column]]), na.rm = TRUE)
  return(data)
}

binning <- function(data, column, bins) {
  data[[column]] <- cut(as.numeric(data[[column]]), breaks = bins, labels = FALSE, include.lowest = TRUE)
  return(data)
}

cat("\nOriginal Dataset:\n")
print(data)

repeat {
  cat("\nMenu:")
  cat("\n1. Remove Rows with Missing Values")
  cat("\n2. Remove Columns with Missing Values")
  cat("\n3. Replace Missing Values with Mean")
  cat("\n4. Replace Missing Values with Mode")
  cat("\n5. Perform Min-Max Normalization")
  cat("\n6. Perform Max-Abs Scaling")
  cat("\n7. Perform Binning (Discretization)")
  cat("\n8. Exit")
  
  choice <- as.integer(readline(prompt = "Enter your choice: "))
  
  if (choice == 1) {
    data <- na.omit(data)
    cat("\nDataset after removing rows with missing values:\n")
    print(data)
    
  } else if (choice == 2) {
    data <- data[, colSums(is.na(data)) == 0]
    cat("\nDataset after removing columns with missing values:\n")
    print(data)
    
  } else if (choice == 3) {
    column <- readline(prompt = "Enter column name to replace missing values with mean: ")
    data <- replace_missing(data, column, "mean")
    cat("\nDataset after replacing missing values with mean:\n")
    print(data)
    
  } else if (choice == 4) {
    column <- readline(prompt = "Enter column name to replace missing values with mode: ")
    data <- replace_missing(data, column, "mode")
    cat("\nDataset after replacing missing values with mode:\n")
    print(data)
    
  } else if (choice == 5) {
    column <- readline(prompt = "Enter column name for Min-Max Normalization: ")
    data <- min_max_normalization(data, column)
    cat("\nDataset after Min-Max Normalization:\n")
    print(data)
    
  } else if (choice == 6) {
    column <- readline(prompt = "Enter column name for Max-Abs Scaling: ")
    data <- max_abs_scaling(data, column)
    cat("\nDataset after Max-Abs Scaling:\n")
    print(data)
    
  } else if (choice == 7) {
    column <- readline(prompt = "Enter column name for Binning: ")
    bins <- as.integer(readline(prompt = "Enter number of bins: "))
    data <- binning(data, column, bins)
    cat("\nDataset after Discretization (Binning):\n")
    print(data)
    
  } else if (choice == 8) {
    cat("\nExiting...\n")
    break
    
  } else {
    cat("\nInvalid choice! Please enter a valid option.\n")
  }
}
