library(arules)

# Read the dataset
#weather_data <- read.csv("C:/Users/prana/Downloads/sample18.csv")
weather_data <- read.csv("/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04/datasets/weather_data.csv")
print(head(weather_data, 5))

# Convert data into transaction format
weather_trans <- as(weather_data, "transactions")

# Generate association rules with support ≥ 0.2 and confidence ≥ 0.6
rules <- apriori(weather_trans, parameter = list(supp = 0.2, conf = 0.6, minlen = 2))

# Inspect all rules
inspect(rules)

# Sort rules by lift and inspect the top 5 rules
inspect(head(sort(rules, by = "lift"), 5))

# Subset rules where right-hand side (rhs) contains "Rainfall=Heavy"
heavy_rain_rules <- subset(rules, rhs %in% "Rainfall=Heavy")
inspect(heavy_rain_rules)

# Subset rules where rhs contains "Natural_Calamity=Yes"
calamity_rules <- subset(rules, rhs %in% "Natural_Calamity=Yes")
inspect(calamity_rules)

# Subset rules where rhs contains "Natural_Calamity=No"
normal_weather_rules <- subset(rules, rhs %in% "Natural_Calamity=No")
inspect(normal_weather_rules)
