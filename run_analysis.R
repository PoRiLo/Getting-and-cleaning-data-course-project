library(dplyr)

# set the working directory to the dataset directory
setwd("./UCI HAR Dataset")

# creating dataframes for test and train data, additional columns for 
# subject and activity are added
col_labels = as.character(read.table("./features.txt")[,2])

testdf <- read.table("./test/X_test.txt", col.names = col_labels)
testdf <- select(testdf,contains("std"), contains("mean"))
testdf$subject <- read.table("./test/subject_test.txt")[,1]
testdf$activity <- read.table("./test/y_test.txt")[,1]

traindf <- read.table("./train/X_train.txt", col.names = col_labels)
traindf <- select(traindf,contains("std"), contains("mean"))
traindf$subject <- read.table("./train/subject_train.txt")[,1]
traindf$activity <- read.table("./train/y_train.txt")[,1]

# merging both dataframes
mergeDF <- merge(traindf, testdf, all = TRUE)

# giving descriptive names to the activities
activity_labels = read.table("./activity_labels.txt")
mergeDF$activity <- factor(mergeDF$activity,
                          levels = activity_labels[, 1],
                          labels = activity_labels[, 2])

# creating a second, independent tidy data set with the average of each variable
#  for each activity and each subject

summarized_df <- mergeDF %>% group_by(activity, subject) %>% summarise_each(funs(mean))
