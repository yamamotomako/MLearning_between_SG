d = read.csv("/Users/yamamoto/work/tree/result/gs1286_addsnp.txt", stringsAsFactors = TRUE, header = TRUE, sep="\t")
data_header <- d[1:5]
data_detail <- d[6:16]

colnames(data_detail) <- c("category_name", "dbSNP.old", "cosmic", "exac", "misrate", "depth", "variantNum", "misRateOtherSNP", "depthOtherSNP","variantNumOtherSNP","cohort_count")
data_detail <- transform(data_detail, category=ifelse(category_name=="A",1,0))
data_detail <- transform(data_detail, dbsnp=ifelse(dbSNP.old=="True",1,0))
data_detail <- transform(data_detail, othersnp=ifelse(misRateOtherSNP!="",1,0))

dd <- cbind(data_header, data_detail)
View(dd)

set.seed(777)
tmp <- sample(1:2562, 2100)
x <- dd[tmp,]
y <- dd[-tmp,]


train_model = glm(category ~ dbsnp + cosmic + exac + cohort_count + misrate + depth + variantNum + othersnp, data=x, family = binomial(link="logit"))
summary(train_model)

test_predict <- round(predict(train_model, y, type="response"))
result_tbl <- table(y$category, test_predict)


result <- cbind(y, test_predict)
mismatch_result <- result %>% filter(result$category != result$test_predict)




on.exit()



#caret
library(caret)
library(mlbench)
library(dplyr)
library(dtplyr)

data(Sonar)
set.seed(107)
dim(Sonar)
str(Sonar)

dat_for_ml <- Sonar
inTrain <- createDataPartition(y = dat_for_ml$Class, p=0.7, list=FALSE)

dat_for_train <- dat_for_ml[inTrain,]
dat_for_test <- dat_for_ml[-inTrain,]

dat_for_train$Class %>% table
dat_for_test$Class %>% table

dat_for_test_val <- dat_for_test %>% select(-Class)
dat_for_test_class <- dat_for_test %>% select(Class) %>% unlist

tr <- trainControl(method = "LGOCV", p=0.80)
train_grid <- expand.grid(alpha = 0, lambda = 0)

#train
logit_fit <- train(as.factor(Class) ~ .,
                   data = dat_for_train,
                   method = "glmnet",
                   tuneGrid = train_grid,
                   trContorol = tr,
                   preProc = c("center", "scale"))


data(iris)
train_control <- trainControl(method = "cv", number=10)
grid <- expand.grid(alpha = 0, lambda = 0)
model <- train(Species~., data=iris, trControl=train_control, method="glmnet", tuneGrid=grid)



#memo
result2 <- result[, c(-1)]
cor(result2)
plot(result$dbSNP, result$category)
plot(result$dbSNP, result$ExAc)
plot(result$cosmic, result$ExAc)

library(scatterplot3d)
scatterplot3d(result$dbSNP, result$cosmic, result$ExAC)

#2値分類なので、０〜１で出力、roundで丸めているだけ（四捨五入で近い方）
train_model.p <- round(predict(train_model, type="response"))
train_model.t <- table(x$category, train_model.p)




d <- read.csv("/Users/yamamoto/work/tree/misc/data4a.csv.3")
d.res <- glm(cbind(y, N-y) ~x + f, data = d, family=binomial(link="logit"))
summary(d.res)
#png("logisticGlm.png")
plot(d$x, d$y, col=c("red", "blue")[d$f])

#make new data
xx <- seq(min(d$x), max(d$x), length=1000)
ft <- factor("T", levels=levels(d$f))
df.t <- data.frame(x=xx, f=ft)
#fc <- factor("C", levels=levels(d$f))
#df.c <- data.frame(x=xx, f=fc)

qq.t <- predict(d.res, df.t, type="response")
lines(xx, max(d$N) * qq.t, col="yellow")


#test_result <- predict(train_model, y, type="response")
fit <- fitted(train_model)
log2 <- cbind(log2, fit)
predict <- ifelse(log2$fit>0.5,1,0)
log2 <- cbind(log2, predict)
table(log2$category, log2$predict)




#全データから7割
iris_new = bind_rows(iris %>% filter(Species == "setosa"), iris %>% filter(Species == "virginica"))
index <- sample(nrow(iris_new), nrow(iris_new)*0.7)

#回帰
res <- glm(Species ~ ., iris_new[index,], family = binomial())
summary(res)



