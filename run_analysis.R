
setwd("C:/Users/davidmie/Desktop/Coursera/Getting and Cleaning Data")

## Download dataset using the link provided in the assignment discrition
downloadFile <- "data/getdata_dataset.zip"
downloadURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(downloadURL, file.path(getwd(),"Data.zip"))


## unzip file after download is complete
unzip(file.path(getwd(),"Data.zip"))

## change working directory to point to neccessary files
setwd("./UCI HAR Dataset")


## Load feature data
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

## Identify important items We want to keep the means and standard deviations of the variables 
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])

## Replace labels with descriptive activity names
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)



## Read in training features, training activities, and training subjects
train <- read.table("train/X_train.txt")[featuresWanted]
trainActivities <- read.table("train/Y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")

## Combine training subjects with their activities
train <- cbind(trainSubjects, trainActivities, train)
names(train) <- c("Subject", "Activity", featuresWanted.names)

## create an indicator for training group. 
## This will be used later to distinguish between the train and test groups
train$TrainGroup <- 1

## Read in testing features, testing activities, and testing subjects
test <- read.table("test/X_test.txt")[featuresWanted]
testActivities <- read.table("test/Y_test.txt")
testSubjects <- read.table("test/subject_test.txt")

## Combine testing subjects with their activities. Then, adjust column names.
test <- cbind(testSubjects, testActivities, test)
names(test) <-c("Subject", "Activity", featuresWanted.names)


## create an indicator for testing group. 
## This will be used later to distinguish between the train and test groups
test$TrainGroup <- 0

## Create a full dataset by combining the train and test datasets
full_data <- rbind(train,test)


## Load activity labels 
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

## Match activity labels to indexes
full_data$Activity <- activityLabels$V2[match(full_data$Activity,activityLabels$V1)]

## Export final dataset
write.table(x = full_data,file = "tidy_dataset.txt")

