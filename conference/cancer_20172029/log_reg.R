library(rpart)


d_somatic = read.csv("/Users/yamamoto/work/result_new_2/somatic.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
d_germline = read.csv("/Users/yamamoto/work/result_new_2/germline.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")


d_somatic$dbsnp <- ifelse(d_somatic$dbsnp == "True",1,0)
d_germline$dbsnp <- ifelse(d_germline$dbsnp == "True",1,0)

d_somatic <- dplyr::mutate(d_somatic, othersnp=ifelse(d_somatic$other_misrate == "", 0, 1))
d_germline <- dplyr::mutate(d_germline, othersnp=ifelse(d_germline$other_misrate == "", 0, 1))

d_somatic <- dplyr::mutate(d_somatic, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
d_somatic$log_pvalue <- ifelse(d_somatic$other_misrate == "", 0, d_somatic$log_pvalue)

d_germline <- dplyr::mutate(d_germline, log_pvalue=-log10(dbetabinom.ab(variant, depth, shape1 = alpha, shape2 = beta)))
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

log_model = glm(category ~ dbSNP + COSMIC + Mismatch.ratio + Depth + Variants + log_pvalue + ExAC + Mutation.pattern + othersnp, data=x, family = binomial(link="logit"))
summary(log_model)

test_predict <- round(predict(log_model, y, type="response"))
result_tbl <- table(y$category, test_predict)


result <- cbind(y, test_predict)
mismatch_result <- result %>% filter(result$category != result$test_predict)
