---
title: "Getting and Cleaning Data Course Project"
author: "Christine Pao"
---

The dataset for this project was loaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description of the dataset is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The script that imports the data from the original data files to generate the
tidy dataset is:
run_analysis.R

The script uses the readr and dplyr packages. It will create the two datasets
as local variables in R (combined_data and summarized data) and also write the
datasets to the working directory as text files ("combined_data.txt" and
"summarized_data.txt").

The script expects data to be in subdirectory "UCI HAR Dataset" and will try
to unpack the original zipfile if the subdirectory does not exist. 


The code book that describes the variables, data, and transformations is:
CodeBook.md (generated from CodeBook.Rmd by knitr)

## Assignment Instructions

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for 
    each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set 
    with the average of each variable for each activity and each subject.
