## Getting and Cleaning Data - Course Project
library(readr)
library(dplyr)

## Unpack the dataset in the current directory

zipfile <- "getdata_projectfiles_UCI HAR Dataset.zip"
datadir <- "UCI HAR Dataset"
if(!file.exists(datadir)) {
    unzip(zipfile)
}

## dataFileInfo: read a data file and print some info about it
dataFileInfo <- function (filename,n=NULL) {
    rlines <- readLines(filename)
    print(length(rlines))
    if(is.null(n)) {
        print(unique(rlines))    
    } else if (n > 0) {
        print(head(rlines,n=n))
    }
}

## Load activity index to activity name mapping
## each line has index and name separated by a space
actfile <- paste(datadir,"activity_labels.txt",sep="/")
activity_map <- read_delim(actfile, " ", col_names=c("act_id","act_name"), 
                           col_types="ic")


## Load column index to variable name (feature) mapping
## each line has index and name separated by a space
varfile <- paste(datadir,"features.txt",sep="/")
variable_map <- read_delim(varfile, " ", col_names=c("var_id","var_name"), 
                           col_types="ic")

## select mean and standard deviation columns to read from x data files
## x data is all doubles
var_fwfpos <- fwf_widths(rep(16,561),variable_map$var_name)
x_vars <- grep("mean\\()|std\\()",variable_map$var_name)
x_fwfpos <- var_fwfpos[x_vars,]
x_coltype <- paste0(rep("d",length(x_vars)),collapse="")

## remove parentheses from variable names
## replace dashes and commas with underscore
x_fwfpos$col_names <- sub("\\()","",x_fwfpos$col_names)
x_fwfpos$col_names <- gsub("[-,]","_",x_fwfpos$col_names)

## ======================
## Load train data subset
## ======================

## train data subdirectory
traindir <- paste(datadir,"train",sep="/")

## data file (fixed width, 561 features per row, 7352 rows)
xtrainfile <- paste(traindir,"x_train.txt",sep="/")
xtraindata <- read_fwf(xtrainfile, x_fwfpos, n_max=8000, col_types=x_coltype)
trainrows <- nrow(xtraindata)

## activity ID for each x data row
## convert activity index to factor using activity_map
ytrainfile <- paste(traindir,"y_train.txt",sep="/")
ytraindata <- read_delim(ytrainfile, " ", col_names=c("activity_id"), 
                           col_types="i")
ytrainfactor <- factor(sapply(ytraindata, function(x) activity_map$act_name[x]),
                       levels = activity_map$act_name)

## subject ID for each x data row
subjtrainfile <- paste(traindir,"subject_train.txt",sep="/")
subjtraindata <- read_delim(subjtrainfile, " ", col_names=c("subject_id"), 
                            col_types="i")

## add train/test subset column
subsettrain <- factor(rep("train",trainrows), c("train","test"))

## combine train data into a single tidy dataset
traindata <- bind_cols(subset=subsettrain, subjtraindata, 
                       activity=ytrainfactor, xtraindata)

## ======================
## Load test data subset
## ======================

## test data subdirectory
testdir <- paste(datadir,"test",sep="/")

## data file (fixed width, 561 features per row, 2947 rows)
xtestfile <- paste(testdir,"x_test.txt",sep="/")
xtestdata <- read_fwf(xtestfile, x_fwfpos, n_max=3000, col_types=x_coltype)
testrows <- nrow(xtestdata)

## activity ID for each x data row
## convert activity index to factor using activity_map
ytestfile <- paste(testdir,"y_test.txt",sep="/")
ytestdata <- read_delim(ytestfile, " ", col_names=c("activity_id"), 
                         col_types="i")
ytestfactor <- factor(sapply(ytestdata, function(x) activity_map$act_name[x]),
                       levels = activity_map$act_name)

## subject ID for each x data row
subjtestfile <- paste(testdir,"subject_test.txt",sep="/")
subjtestdata <- read_delim(subjtestfile, " ", col_names=c("subject_id"), 
                           col_types="i")

## add train/test subset column
subsettest <- factor(rep("test",testrows), c("train","test"))

## combine test data into a single tidy dataset
testdata <- bind_cols(subset=subsettest, subjtestdata, 
                      activity=ytestfactor, xtestdata)

## ===============================
## Tidy Dataset 1: combined_data
## ===============================

## combine train and test subsets into a single dataset
combined_data <- bind_rows(traindata,testdata)

## ===============================
## Tidy Dataset 2: summarized_data
## ===============================

## create a tidy dataset with the mean of each variable for each
## subject and activity.
summarized_data <- combined_data %>% 
    group_by(subject_id,activity) %>%
    summarize(across(all_of(x_fwfpos$col_names), mean, .names = "mean_{.col}"),
              .groups = "drop")
