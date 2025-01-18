data <- read.csv('/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04 data mining lab/ex4/S-Mart.csv')

data$Price <- as.numeric(gsub("[^0-9].", "", data$Price))
data$Price[is.na(data$Price)] <- 0

data$DiscountedPrice <- as.numeric(gsub("[^0-9].", "", data$DiscountedPrice))
data$DiscountedPrice[is.na(data$DiscountedPrice)] <- 0

price_range <- range(data$Price)

# finding bin breaks
bin_width <- (price_range[2] - price_range[1]) / 5 # 5 says the no of bins i.e., groups.
bin_breaks = seq(price_range[1], price_range[2], by=bin_width)

#print(bin_breaks)

#creating bins
data$bin <- cut(
  data$Price,
  breaks=bin_breaks,
  labels=c('Lowest', 'Lower-Middle', 'Middle', 'Upper-Middle', 'Highest'),
  include.lowest=TRUE
)

# View(data) with this we could see the data in table format.

bounds <- data.frame(
  bin = levels(data$bin),
  lower = bin_breaks[-length(bin_breaks)], # c(0, 200, 400, 600, 800) \
  upper = bin_breaks[-1] # c(200, 400, 600, 800, 1000)                / this creates a vector. 
)

# View(bin_bounds)

data$smoothPrice <- data$Price

for (i in 1:nrow(bounds)) {
  low = bounds$lower[i]
  high = bounds$upper[i]
  
  # finds the bin indices matching lower, middle...,
  indices = which(data$bin == bounds$bin[i])
  
  for (j in indices) {
    if (abs(data$Price[j] - low) >= abs(data$Price[j] - high)) {
      data$smoothPrice[j] <- high
    } else {
      data$smoothPrice[j] <- low
    }
  }
}

View(data)

