data <- read.csv('/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04 data mining lab/ex4/S-Mart.csv')

data$Price <- as.numeric(gsub("[^0-9].", "", data$Price))
data$Price[is.na(data$Price)] <- 0

data$DiscountedPrice <- as.numeric(gsub("[^0-9].", "", data$DiscountedPrice))
data$DiscountedPrice[is.na(data$DiscountedPrice)] <- 0

price_range <- range(data$Price) # returns min ans max

# finding bin breaks
bin_width <- (price_range[2] - price_range[1]) / 5 # 5 says the no of bins i.e., groups.
bin_breaks <- seq(price_range[1], price_range[2], by=bin_width)

#print(bin_breaks)

#creating bins
data$bin <- cut(
  data$Price,
  breaks=bin_breaks,
  labels=c('Lowest', 'Lower-Middle', 'Middle', 'Upper-Middle', 'Highest'),
  include.lowest=TRUE
)

bin_summary <- aggregate(
  cbind(Price, DiscountedPrice) ~ bin, # ~ bin means group by
  data = data,
  FUN = function(x) round(mean(x), 2)
)

print(bin_summary)

bin_summary$discount_percentage <- round((1 - (bin_summary$DiscountedPrice / bin_summary$Price)) * 100, 2)
View(bin_summary)
