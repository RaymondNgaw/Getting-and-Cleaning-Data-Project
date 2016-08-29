#Load Libraries 
library(dplyr)
library(data.table)
library(tidyr)

# Download file and unzip
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "~/GitHub/Project.zip")
unzip(zipfile = "~/GitHub/Project.zip", exdir = "~/GitHub/Project")

#Extract necessary data
xtrain <- read.table("~/GitHub/TrainTest/UCI HAR Dataset/train/x_train.txt")
ytrain <- read.table("~/GitHub/TrainTest/UCI HAR Dataset/train/y_train.txt")
xtest <- read.table("~/GitHub/TrainTest/UCI HAR Dataset/test/x_test.txt")
ytest <- read.table("~/GitHub/TrainTest/UCI HAR Dataset/test/y_test.txt")
trainsubject <- read.table("~/GitHub/TrainTest/UCI HAR Dataset/train/subject_train.txt")
testsubject <- read.table("~/GitHub/TrainTest/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("~/GitHub/TrainTest/UCI HAR Dataset/features.txt")
activity <- read.table("~/GitHub/TrainTest/UCI HAR Dataset/activity_labels.txt")

#Combining Data Sets
x <- rbind(xtest, xtrain)
y <- rbind(ytest, ytrain)
z <- rbind(trainsubject, testsubject)

#Extracting only Mean and Std from measurements
mean.std <- grep("mean\\(\\)|std\\(\\)", features[, 2])
x <- x[, mean.std] 


#Naming activities
z[, 1] <- activity[z[, 1], 2]


#Labeling variable names
names <- features[mean.std,2]
names(x) <- names
names(z) <- "ID"
names(y) <- "Activity"

#Merging data sets
Cleaned <- cbind(x, y, z)

#Creating tidy data set with average of each variable for each activity and subject.
Cleaned <- data.table(Cleaned)
Final <- Cleaned[, lapply(.SD, mean), by = "ID,Activity"]

write.table(Final, file = "Final.txt", row.names = FALSE)
