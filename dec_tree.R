library(rpart)
library(VGAM)


d_somatic = read.csv("/Users/yamamoto/work/result_new/somatic.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
d_germline = read.csv("/Users/yamamoto/work/result_new/germline.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")


d_somatic$dbSNP <- ifelse(d_somatic$dbSNP== "True",1,0)
d_germline$dbSNP <- ifelse(d_germline$dbSNP == "True",1,0)

d_somatic <- dplyr::mutate(d_somatic, othersnp=ifelse(d_somatic$other_misrate == "", 0, 1))
d_germline <- dplyr::mutate(d_germline, othersnp=ifelse(d_germline$other_misrate == "", 0, 1))

d_somatic <- dplyr::mutate(d_somatic, log_pvalue=-log10(dbetabinom.ab(Variants, Depth, shape1 = alpha, shape2 = beta)))
d_somatic$log_pvalue <- ifelse(d_somatic$other_misrate == "", 0, d_somatic$log_pvalue)

d_germline <- dplyr::mutate(d_germline, log_pvalue=-log10(dbetabinom.ab(Variants, Depth, shape1 = alpha, shape2 = beta)))
d_germline$log_pvalue <- ifelse(d_germline$other_misrate == "", 0, d_germline$log_pvalue)


d_germline <- sample_n(tbl = d_germline, size = nrow(d_somatic))


set.seed(sample.int(1000,1))
tmp <- sample(1:nrow(d_somatic), round(nrow(d_somatic)*0.9, digits=0))
#tmp <- sample(1:1285, 1100)

x_somatic <- d_somatic[tmp,]
y_somatic <- d_somatic[-tmp,]
x_germline <- d_germline[tmp,]
y_germline <- d_germline[-tmp,]

x <- rbind(x_somatic, x_germline)
y <- rbind(y_somatic, y_germline)

tree_train <- rpart(category ~ dbSNP + COSMIC + Mismatch.ratio + Depth + Variants + log_pvalue + othersnp + ExAC + Mutation.pattern, data=x)
plot.new(); par(xpd=T); plot(tree_train)
text(tree_train, use.n = T, digits=getOption("digits"))


tree_pred <- predict(tree_train, y, type="class")
table(y$category, tree_pred)

result <- cbind(y, tree_pred)
mismatch_result <- result %>% filter(result$category != result$tree_pred)
#mismatch_result$cohort_count <- as.integer(mismatch_result$cohort_count)

stop("End of script")


