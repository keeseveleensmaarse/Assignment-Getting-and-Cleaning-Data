# First, read in all data tables. The relevant tables are named in accordance with   # the name of the sources. 
# It is assumed that all files are present in the current working directory.
#
features          <- read.table("features.txt", header = FALSE, sep = "")
activity_labels   <- read.table("activity_labels.txt", header = FALSE, sep = "")
y_test            <- read.table("y_test.txt", header = FALSE, sep = "")
y_train           <- read.table("y_train.txt", header = FALSE, sep = "")
subject_test      <- read.table("subject_test.txt", header = FALSE, sep = "")
subject_train     <- read.table("subject_train.txt", header = FALSE, sep = "")
X_test            <- read.table("X_test.txt", header = FALSE, sep = "", fill = TRUE)
X_train           <- read.table("X_train.txt", header = FALSE, sep = "", fill = TRUE)
#
# Then, we start working with the ‘test’-tables. A number of columns is selected out # of the X_test table, and stored as X_test_col. Then an id is added to the table,    # for merging purpose. This id is also added to subject_test and to y_test. 
#
X_test_col        <- X_test[,c(1,2,3,4,5,6,121,122,123,124,125,126)]
X_test_col$id     <- 1:nrow(X_test_col)
subject_test$id   <- 1:nrow(subject_test)
y_test$id         <- 1:nrow(y_test)
#
# Next, the tables are merged. First, subject_test is added to X_test_col and the      # result is named X_test_col_sub; then y_test is added to X_test_col_sub and the     # result is named X_test_col_sub_y. 
#
X_test_col_sub    <- merge(X_test_col,subject_test, by = "id")
X_test_col_sub_y  <- merge(X_test_col_sub,y_test, by = "id")
#
# Now we do a similar actions for the ‘train’-tables. So, first select the columns   # and add the id; the latter also for subject_train and y_train.
# 
X_train_col       <- X_train[,c(1,2,3,4,5,6,121,122,123,124,125,126)]
X_train_col$id    <- 1:nrow(X_train_col)
subject_train$id  <- 1:nrow(subject_train)
y_train$id        <- 1:nrow(y_train)
#
# And now we do the merging, similar to the ‘test’-tables.
#
X_train_col_sub   <- merge(X_train_col,subject_train, by = "id")
X_train_col_sub_y <- merge(X_train_col_sub,y_train, by = "id")
#
# Now is the step to combine the rows of the resulting ’test’-table and rows of the resulting ‘ train’-  # table into one total table, named X_total_col_sub_y
#
X_total_col_sub_y <- rbind(X_test_col_sub_y, X_train_col_sub_y)
#
# Now we remove the ‘ Id’-column - it is not needed any more. And we change the order # of the columns in the table, so that Subject and Activity come first.
#
X_total_col_sub_y <- X_total_col_sub_y[ -c(1)]
X_total_col_sub_y <- X_total_col_sub_y[ c(13, 14, 1:12)]
#
# We still need to decode the Activity, so that it will not have values like 1, 2 and # so on, but “ LAYING, STANDING etc. This again is a Merge action, this time with    # table named activity_labels, on column V1.
#
X_total_col_sub_y <- merge(X_total_col_sub_y,activity_labels, by = "V1")
#
# Again change the order of the columns, because the merge-action put them in an     # order we don’t want.
#
X_total_col_sub_y <- X_total_col_sub_y[ c(2, 15, 3:14)]
#
# Nearly there! Now, we need to give appropriate names to the various columns.
#
colnames(X_total_col_sub_y) <- c("Subject", "Activity", "BodyAcc_mean_X","BodyAcc_mean_Y", "BodyAcc_mean_Z", "BodyAcc_std_X","BodyAcc_std_Y", "BodyAcc_std_Z", "BodyGyro_mean_X", "BodyGyro_mean_Y", "BodyGyro_mean_Z", "BodyGyro_std_X","BodyGyro_std_Y", "BodyGyro_std_Z")
#
# Done! Just give a nice name to the result, and we’re done!
#
total_set <- X_total_col_sub_y
#
#
# Then, there’s the question for a second data set containing the averages for each  # activity and each subject. I used ‘Group by’ and ‘summarise’ to realise this. And  # changed the names of the columns, so that they reflect a difference with the       # previous data set. The name of this data set is total_set_mean.  
#
total_set_group <- group_by(total_set, Subject, Activity)
total_set_mean <- summarise(total_set_group, MeanBodyAcc_mean_X = mean(BodyAcc_mean_X), MeanBodyAcc_mean_Y = mean(BodyAcc_mean_Y), MeanBodyAcc_mean_Z = mean(BodyAcc_mean_Z), MeanBodyAcc_std_X = mean(BodyAcc_std_X), MeanBodyAcc_std_Y = mean(BodyAcc_std_Y), MeanBodyAcc_std_Z = mean(BodyAcc_std_Z), MeanBodyGyro_mean_X = mean(BodyGyro_mean_X), MeanBodyGyro_mean_Y = mean(BodyGyro_mean_Y), MeanBodyGyro_mean_Z = mean(BodyGyro_mean_Z), MeanBodyGyro_std_X = mean(BodyGyro_std_X), MeanBodyGyro_std_Y = mean(BodyGyro_std_Y), MeanBodyGyro_std_Z = mean(BodyGyro_std_Z))
#
# End
#