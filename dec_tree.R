library(rpart)


d = read.csv("/Users/yamamoto/work/tree/result/gs1286_addsnp.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
#d <- d[6:9]

d$category <- ifelse(d$category == "A","somatic","germline")
d <- transform(d, othersnp=ifelse(misRate_otherSNP!="",1,0))
View(d)


set.seed(777)
tmp <- sample(1:2562, 2100)
x <- d[tmp,]
y <- d[-tmp,]



tree_train <- rpart(category ~ dbSNP + cosmic + ExAC + cohort_count + misRate + depth + variantNum + misRate_otherSNP, data=x)
plot.new(); par(xpd=T); plot(tree_train)
text(tree_train, use.n = T, digits=getOption("digits"))


tree_pred <- predict(tree_train, y, type="class")
table(y$category, tree_pred)

result <- cbind(y, tree_pred)
mismatch_result <- result %>% filter(result$category != result$tree_pred)


nrow(filter(result, category=="germline"))
nrow(filter(result, category=="others"))
nrow(filter(result, category=="somatic"))


nrow(filter(x, category=="germline"))
nrow(filter(x, category=="others"))
nrow(filter(x, category=="somatic"))


nrow(filter(y, category=="germline"))
nrow(filter(y, category=="others"))
nrow(filter(y, category=="somatic"))





