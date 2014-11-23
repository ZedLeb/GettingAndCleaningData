## Coursera: Data Science Specialization: Getting and Cleaning Data.
## Project to demonstrate the ability to collect, work with, and clean a data set.
## The goal is to prepare tidy data that can be used for later analysis.

## STEP 1: Merge the training and the test sets to create one data set.

# file location for training data 
  train_subjects <- "./Samsung/UCI HAR Dataset/train/subject_train.txt"
  train_activity <- "./Samsung/UCI HAR Dataset/train/y_train.txt"
  train_data     <- "./Samsung/UCI HAR Dataset/train/X_train.txt"

# file location for test data 
  test_subjects <- "./Samsung/UCI HAR Dataset/test/subject_test.txt"
  test_activity <- "./Samsung/UCI HAR Dataset/test/Y_test.txt"
  test_data     <- "./Samsung/UCI HAR Dataset/test/X_test.txt"

# file location for features (to be used as variable names)
  features <- "./Samsung/UCI HAR Dataset/features.txt"

# file location for activity labels (to be used to describe activity)
  activity <- "./Samsung/UCI HAR Dataset/activity_labels.txt"

# read in training data  
  train_subjects <- read.table(train_subjects, sep ="")
  train_activity <- read.table(train_activity, sep ="")
  train_data     <- read.table(train_data, sep ="", check.names = TRUE)

# read in test data
  test_subjects <- read.table(test_subjects, sep ="")
  test_activity <- read.table(test_activity, sep ="")
  test_data     <- read.table(test_data, sep ="", check.names = TRUE)

# read in variable names
  features <- read.table(features, sep = "")

# read in activity labels
  activity <- read.table(activity, sep = "")

# Replace column names with variable names in both training and test data sets (Used the make.names check that occurs during data.frame to ensure removal of duplicate variable names - this also appears to take care of parentheses and hyphens.  The variables are left with a number of periods - which are removed later).
  colnames(test_data) <- features$V2
  data.frame(test_data)-> test_data
  colnames(train_data) <- features$V2
  data.frame(train_data)-> train_data

# Test that there are no duplicated columns (repeat for training data)  
#   allcols <- colnames(test_X)
#   dupecols <- duplicated(colnames(test_X))
#   allcols[dupecols]  ### should be "character(0)"
#   rm(allcols)
#   rm(dupecols)

# Bind the test and training data sets
  alldata <- rbind(test_data, train_data)
  allactivity <- rbind(test_activity, train_activity)
  allsubjects <- rbind(test_subjects, train_subjects)

# Bind the all data sets to give first untidy data frame  
  untidy_1 <- cbind(allsubjects, allactivity, alldata)

# Give new columns descriptive names to facilitate next step
  colnames(untidy_1)[1] <- "subject"
  colnames(untidy_1)[2] <- "activity"

## STEP 2: Extract only the measurements on the mean and standard deviation for each measurement. 

# Use dplyr chain to select relevant columns i.e. those containing "mean" and "std" (this was a analysis decision - see code book for explanation)
  library(dplyr)

  untidy_2 <- untidy_1 %>%
        select(subject, activity, contains("mean"), contains("std"), -contains("meanFreq"), -contains("gravityMean"), -contains("BodyAccMean"), -contains("angle"))

# This process leaves only subject plus activity plus 66 measurement variables.

# check for NA values in data frame
  colSums(is.na(untidy_2))
  all(colSums(is.na(untidy_2))== 0)  ## should be TRUE


## STEP 3: Use descriptive activity names to name the activities in the data set 

# First need common variable names for joining columns - the numerical activity is labelled activity in untidy_2
  names(activity) <- c("activity", "activityname")

# Use dplyr to join activity table to provide descriptive labels  
  untidy_3 <- left_join(untidy_2, activity)

# Remove unwanted numerical activity column and arrange data frame into tidy wide form.
  untidy_3$activity <- NULL  

  tidy_1 <- arrange(untidy_3[, c(1,68,2:67)], subject)


## STEP 4: Appropriately label the data set with descriptive variable names. 

# Remove the periods from the variable names to give clearer variable names.  Camel case style of variable name was retained (this was a analysis decision - see code book for explanation)
  colnames(tidy_1) <- gsub("\\.", "", colnames(tidy_1))
  colnames(tidy_1) <- gsub("mean", "Mean", colnames(tidy_1))


## STEP 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

# Group and summarise to get means for each measurement
  tidy_1grp <- group_by(tidy_1, subject, activityname)
  tidy_2 <- summarise_each(tidy_1grp, funs(mean))

# Write a txt file to upload to Coursera
  write.table(tidy_2, file = "./Samsung/UCI HAR Dataset/HAR.txt", row.names = FALSE)
