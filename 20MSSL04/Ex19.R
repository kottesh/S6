library(arules)
library(arulesViz)


file_path <- "/home/kottes/worktree/uni/3rd year/sem 6/20MSSL04/datasets/sample19.csv"
transactions <- read.transactions(file_path, format = "basket", sep=",")

summary(transactions) 

# Apply FP-Growth
frequent_itemsets <- eclat(transactions, parameter = list(support = 0.1, minlen = 2))
inspect(frequent_itemsets)

# Association Rules
rules <- apriori(transactions, parameter = list(supp = 0.1, conf = 0.2, minlen = 2))

if (length(rules) > 0) {
  inspect(rules)
  inspect(head(sort(rules, by = "lift"), 5))  # Top 5 rules
  plot(rules, method = "graph", engine = "htmlwidget")
} else {
  print("No association rules generated. Try reducing support or confidence.")
}
