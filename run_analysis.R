#Loading required packages and dataset

library(dplyr)
setwd("/Coursera/Data_science_Johns_Hopkins/Getting_and_Cleaning_Data/Week4/") #set working directory 
file_name <- "DSGC_week4_final.zip"
file_addr <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_addr, file_name, method="curl")
unzip(file_name, exdir="./DataDir")
setwd("/Coursera/Data_science_Johns_Hopkins/Getting_and_Cleaning_Data/Week4/DataDir/UCI HAR Dataset/")

features <- read.table("features.txt", col.names = c("n","functions"))
# activity labels
#a_label <- read.table("activity_labels.txt"))
#a_label[,2] <- as.character(a_label[,2])

act_labels <- read.table("activity_labels.txt", col.names = c("code", "activity"))

# 1. Merges the training and the test sets to create one data set.

#test sets
X_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_test <- read.table("test/subject_test.txt", col.names = "subject")

#train sets
X_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")

#mergeing
X_merge <- rbind(X_train, X_test)
y_merge <- rbind(y_train, y_test)
Subject_merge <- rbind(subject_train, subject_test)
Data_merged <- cbind(Subject_merge, y_merge, X_merge)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

Data_tidy <- Data_merged %>% select(subject, code, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set.

Data_tidy$code <- act_labels[Data_tidy$code, 2]


#4. Appropriately labels the data set with descriptive variable names.

names(Data_tidy)[2] = "activity"
names(Data_tidy)<-gsub("Acc", "Accelerometer", names(Data_tidy))
names(Data_tidy)<-gsub("Gyro", "Gyroscope", names(Data_tidy))
names(Data_tidy)<-gsub("BodyBody", "Body", names(Data_tidy))
names(Data_tidy)<-gsub("Mag", "Magnitude", names(Data_tidy))
names(Data_tidy)<-gsub("^t", "Time", names(Data_tidy))
names(Data_tidy)<-gsub("^f", "Frequency", names(Data_tidy))
names(Data_tidy)<-gsub("tBody", "TimeBody", names(Data_tidy))
names(Data_tidy)<-gsub("-mean()", "Mean", names(Data_tidy), ignore.case = TRUE)
names(Data_tidy)<-gsub("-std()", "STD", names(Data_tidy), ignore.case = TRUE)
names(Data_tidy)<-gsub("-freq()", "Frequency", names(Data_tidy), ignore.case = TRUE)
names(Data_tidy)<-gsub("angle", "Angle", names(Data_tidy))
names(Data_tidy)<-gsub("gravity", "Gravity", names(Data_tidy))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Tidy_DataSet <- Data_tidy %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Tidy_DataSet, "../Tidy_DataSet.txt", row.name=FALSE , quote = FALSE)

#Checking variable names and the tidy dataset

str(Tidy_DataSet)

Tidy_DataSet
