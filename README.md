GettingAndCleaningData
======================

Repository for Getting and Cleaning Data project files.

**run_analysis.R** is a script which performs an analysis on the following data:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
~ downloaded 13/NOV/2014

Original data held:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Once the above zipped file is extracted into your working directory, run_analysis.R can be sourced into R and will perform the following analysis.

Eight files are read into R:
1. Subjects - training
2. Activity - training
3. Data - training
4. Subjects - test
5. Activity - test
6. Data - test
7. Activity labels
8. Measurement variable labels

Please refer to codebook for further details of the data.

The files will be combined into one dataset of 10299 observations and 563 variables.
Only the measurements for "mean" and "standard deviation" will be preserved for analysis.
This provides a data set of 10299 observations and 68 variables (subject, activity and 66 measurements)

The activities are labelled as follows: (in the final analysis they are sorted alphabetically)
WALKING
WALKING_UPSTAIRS
WALKING_DOWNSTAIRS
SITTING
STANDING
LAYING

The 66 measurement variable names are preserved from the original raw data in camel case with only hyphens and parentheses removed.

**The final analysis presents the MEAN for each of the measurement variables - grouped by subject and activity.**

These data are written to a .txt file (HAR.txt) in the ./Samsung/UCI HAR Dataset directory.

A copy of the text file is available here:
https://s3.amazonaws.com/coursera-uploads/user-2be883be8ca9b875d49c8ac0/972587/asst-3/8a3da4a0734911e4b013effee5e9e330.txt
