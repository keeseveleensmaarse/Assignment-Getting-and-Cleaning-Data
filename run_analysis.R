#
# Start with downloading and unzipping the files from the source as indicated 
#
URL <- ”https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip”
files_to_unzip    <- c("UCI HAR Dataset/activity_labels.txt","UCI HAR Dataset/features.txt","UCI HAR Dataset/test/subject_test.txt","UCI HAR Dataset/train/subject_train.txt","UCI HAR Dataset/test/X_test.txt","UCI HAR Dataset/train/X_train.txt","UCI HAR Dataset/test/y_test.txt","UCI HAR Dataset/train/y_train.txt")
download.file(URL,"data.zip", mode="wb")
unzip("data.zip",files = files_to_unzip,exdir="./data",junkpaths=TRUE)
#
# Read in all data tables. The relevant tables are named in accordance with   
# the name of the sources. 
#
features          <- read.table("./data/features.txt", header = FALSE, sep = "")
activity_labels   <- read.table("./data/activity_labels.txt", header = FALSE, sep = "")
y_test            <- read.table("./data/y_test.txt", header = FALSE, sep = "")
y_train           <- read.table("./data/y_train.txt", header = FALSE, sep = "")
subject_test      <- read.table("./data/subject_test.txt", header = FALSE, sep = "")
subject_train     <- read.table("./data/subject_train.txt", header = FALSE, sep = "")
X_test            <- read.table("./data/X_test.txt", header = FALSE, sep = "", fill = TRUE)
X_train           <- read.table("./data/X_train.txt", header = FALSE, sep = "", fill = TRUE)
#
# First of all, we need to select the columns containing the required data.
# I do this by finding the columns containing ‘std’ and ‘mean’ in the names.
#
col_std           <- grep("std", features[,2])  
col_mean          <- grep("mean", features[,2])
#
# Then, we start working with the ‘test’-tables. A number of columns is selected out 
# of the X_test table, and stored as X_test_col. Then an id is added to the table,    
# for merging purpose. This id is also added to subject_test and to y_test. 
#
X_test_col        <- X_test[,c(col_std, col_mean)]
X_test_col$id     <- 1:nrow(X_test_col)
subject_test$id   <- 1:nrow(subject_test)
y_test$id         <- 1:nrow(y_test)
#
# Next, the tables are merged. First, subject_test is added to X_test_col and the      
# result is named X_test_col_sub; then y_test is added to X_test_col_sub and the     
# result is named X_test_col_sub_y. 
#
X_test_col_sub    <- merge(X_test_col,subject_test, by = "id")
X_test_col_sub_y  <- merge(X_test_col_sub,y_test, by = "id")
#

# Now we do a similar actions for the ‘train’-tables. So, first select the columns   
# and add the id; the latter also for subject_train and y_train.
# 
X_train_col       <- X_train[,c(col_std,col_mean)]
X_train_col$id    <- 1:nrow(X_train_col)
subject_train$id  <- 1:nrow(subject_train)
y_train$id        <- 1:nrow(y_train)
#
# And now we do the merging, similar to the ‘test’-tables.
#
X_train_col_sub   <- merge(X_train_col,subject_train, by = "id")
X_train_col_sub_y <- merge(X_train_col_sub,y_train, by = "id")
#
# Now is the step to combine the rows of the resulting ’test’-table and rows of the resulting ‘ train’-  
# table into one total table, named X_total_col_sub_y
#
X_total_col_sub_y <- rbind(X_test_col_sub_y, X_train_col_sub_y)
#
# We still need to decode the Activity, so that it will not have values like 1, 2 and 
# so on, but “ LAYING, STANDING etc. This again is a Merge action, this time with    
# table named activity_labels, on column V1.
#
X_total_col_sub_y <- merge(X_total_col_sub_y,activity_labels, by = "V1")
#
# We do not require the first two columns V1 and Id any more
#
X_total_col_sub_y <- X_total_col_sub_y[,c(-1,-2)]
#
# Nearly there! Now, we need to give appropriate names to the various columns.
#
colnames(X_total_col_sub_y) <- c(as.character(features[c(col1,col2),2]), "Subject", "Activity")
#
# Done! Just give a nice name to the result, and we’re done!
#
total_set         <- X_total_col_sub_y
#
#
# Then, there’s the question for a second data set containing the averages for each  
# activity and each subject. I used ‘Group by’ and ‘summarise_each’ to realise this.      
# The name of this data set is total_set_mean. 
#
# First, the dplyr-package needs to be included.
#
library(dplyr)
total_set_group   <- group_by(total_set, Subject, Activity)
total_set_mean    <- summarise_each(total_set_group, "mean")
#
# And write the result into a file.
#
write.table(total_set_mean, file = "total_set_mean.txt", row.name = FALSE)
#
# End
#