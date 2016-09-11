############ Voyager Media Pred Model #############

data <- read.csv("prediction_sample_data-2.csv", skip = 1)

library(dplyr); library(stats); library(caret); library("foreign")
library(forecast); library(ggplot2); library(scales)

data <- data[1:105, ]
data$RPV <- as.numeric(data$RPV)
data$Visitors <- as.numeric(data$Visitors)
data$Revenue.3 <- as.numeric(data$Revenue.3)
data <- mutate(data, RPD = Visitors * RPV)
#data <- ts(data)

train <- data[31:105, ]
test <- data[1:30,]

#train <- ts(train)
#test <- ts(test)

rf.fit <- train(RPD ~., method = "rf", data = train)
pred.rf <- predict(rf.fit, test)

rftest <- as.data.frame(pred.rf)
test <- as.data.frame(test)
rfrslt <- cbind(test, rftest)

write.csv(rfrslt, file = "VMREVPRED.csv")

prf <- ggplot(rfrslt, aes(RPD, pred.rf)) + geom_point(fill = "green", size = 4)
prf <- prf + geom_point(color = "green", size = 3) 
prf <- prf + scale_x_continuous(labels = comma) + scale_y_continuous(labels = comma)
prf <- prf + labs(title = "Revenue Prediction", x = "Actual Revenue Per Day", y = "Predicted Revenue")
prf <- prf +  geom_smooth(method = lm , color = "red", se = FALSE)
prf 
ggsave(file = "VMREVPRED.png")

anofit <- aov(rfrslt$RPD ~ rfrslt$pred.rf)

sum.ano <- summary(anofit)
sum.ano

corpred <- cor.test(rfrslt$RPD, rfrslt$pred.rf, method = "pearson")
corpred

R2 <- corpred$cor ^ 2
