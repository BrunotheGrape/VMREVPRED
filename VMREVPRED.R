############ Voyager Media Pred Model #############

data <- read.csv("prediction_sample_data-2.csv", skip = 1)

library(dplyr); library(stats)

data <- data[1:105, ]
data$RPV <- as.numeric(data$RPV)
data$Visitors <- as.numeric(data$Visitors)
data$Revenue.3 <- as.numeric(data$Revenue.3)
data <- mutate(data, RPD = Visitors * RPV)
data <- ts(data)

train <- data[31:105, ]
test <- data[-train,]
