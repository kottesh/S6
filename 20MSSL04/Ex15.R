# Load necessary libraries
library(ggplot2)
library(fastICA)  # For ICA
library(NMF)      # For NMF

# Load dataset
data <- read.csv("C:/Users/prana/Downloads/sample15.csv", header = TRUE)

# Convert categorical variables to numeric 
data <- data[sapply(data, is.numeric)]  

# Normalize the data (important for PCA, ICA, SVD, NMF)
data_scaled <- scale(data)

### 🔹 PCA (Principal Component Analysis)
pca_result <- prcomp(data_scaled, center = TRUE, scale. = TRUE)

# Variance explained by each Principal Component
pca_var <- pca_result$sdev^2
pca_var_exp <- pca_var / sum(pca_var) * 100  # Percentage of variance explained

cat("\n--- PCA Results ---\n")
print(pca_result$rotation)  # Principal Components
cat("\nExplained Variance (%):\n", pca_var_exp, "\n")

# PCA Scatter Plot (First 2 Components)
pca_df <- as.data.frame(pca_result$x)
ggplot(pca_df, aes(x = PC1, y = PC2)) +
  geom_point(color = "blue", size = 3) +
  labs(title = "PCA: First Two Principal Components") +
  theme_minimal()

### 🔹 ICA (Independent Component Analysis)
# Fix for ICA: Apply PCA first to reduce redundancy
pca_pre <- prcomp(data_scaled, center = TRUE, scale. = TRUE)
data_pca_reduced <- pca_pre$x[, 1:5]  # Keep only top 5 principal components

# Add small noise to prevent singularity
set.seed(123)
data_pca_reduced_noisy <- data_pca_reduced + 
  matrix(rnorm(nrow(data_pca_reduced) * ncol(data_pca_reduced), mean = 0, sd = 1e-6), 
         nrow = nrow(data_pca_reduced), ncol = ncol(data_pca_reduced))

# Perform ICA
ica_result <- fastICA(data_pca_reduced_noisy, n.comp = 2)

cat("\n--- ICA Results ---\n")
print(ica_result$S)  # Independent Components

# ICA Scatter Plot
ica_df <- as.data.frame(ica_result$S)
ggplot(ica_df, aes(x = V1, y = V2)) +
  geom_point(color = "red", size = 3) +
  labs(title = "ICA: Independent Components") +
  theme_minimal()

### 🔹 SVD (Singular Value Decomposition)
svd_result <- svd(data_scaled)

cat("\n--- SVD Results ---\n")
cat("U Matrix:\n", svd_result$u, "\n")
cat("D Singular Values:\n", svd_result$d, "\n")
cat("V Matrix:\n", svd_result$v, "\n")

### 🔹 NMF (Non-Negative Matrix Factorization)
# Ensure all values are non-negative
data_scaled_nmf <- abs(data_scaled)

# Check if NMF package is installed correctly
if (!requireNamespace("Biobase", quietly = TRUE)) {
  install.packages("Biobase", dependencies = TRUE)
}
if (!requireNamespace("NMF", quietly = TRUE)) {
  install.packages("NMF", dependencies = TRUE)
}

# Run NMF
nmf_result <- nmf(data_scaled_nmf, 2, method = "lee")  # Factor into 2 components

cat("\n--- NMF Results ---\n")
cat("Basis Matrix (W):\n", basis(nmf_result), "\n")
cat("Coefficient Matrix (H):\n", coef(nmf_result), "\n")
