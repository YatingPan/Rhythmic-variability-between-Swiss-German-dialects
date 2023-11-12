# Ensure necessary packages are installed
install.packages(c("randomForest", "dplyr", "ggplot2", "caret"))

# Libraries
library(randomForest)
library(dplyr)
library(ggplot2)
library(caret)

# Load your data
data <- read.csv("duration.csv", sep = "\t")

# Basic EDA
summary(data)

# Convert 'dialect' to factor with specified levels
data$dialect <- factor(data$dialect)

# Split data into training and testing sets
set.seed(123)  # Set a random seed for reproducibility
trainIndex <- createDataPartition(data$dialect, p = 0.8, list = FALSE)
train <- data[trainIndex, ]
test <- data[-trainIndex, ]

# Ensure consistent factor levels for 'dialect' in both training and test sets
levels(train$dialect) <- levels(data$dialect)
levels(test$dialect) <- levels(data$dialect)

# Fit the Random Forest model
set.seed(123)
rf.model <- randomForest(as.factor(dialect) ~ ., data=train, importance=TRUE, ntree=500)

# Model Summary
print(rf.model)

# Model Prediction on Test Data
test.prediction <- predict(rf.model, newdata = test)

# Ensure predictions are a factor with the same levels as the test set
test.prediction <- factor(test.prediction, levels = levels(test$dialect))

# Model Evaluation
confusionMatrix(test.prediction, test$dialect)

# Training Accuracy
train.prediction <- predict(rf.model, newdata = train)
train.accuracy <- sum(train.prediction == train$dialect) / length(train$dialect)
cat("Training accuracy =", train.accuracy, "\n")

# Testing Accuracy
test.accuracy <- sum(test.prediction == test$dialect) / length(test$dialect)
cat("Testing accuracy =", test.accuracy, "\n")

# Optional: Variable Importance Plot
varImpPlot(rf.model)
