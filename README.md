# Assignment-Getting-and-Cleaning-Data
## This is the Readme that should be used with the script for the Getting and Cleaning Data Course Project, part of the Coursera Getting and Cleaning Data Course.

After studying all available materials, I started to read in the necessary data. I did this using read.table. After the tables were available for detailed analysis, I noticed the number of lines in subject_test, y_test and X_test are all equal; the same applies to subject_train, y_train and X_train. Also, the number of columns of X_test and Y_test is equal to the number of lines in the features-table. This gave me a clue how everything should fit together:
* X_train and X_test contain the measured and calculated values;
* subject_train and subject_test contain the id’s of the persons that were used in the experiments, were subject_train does so for X_train, and subject_test does for X_test;
* y_train and y_test contain the types of activity that was executed during the applicable measurements in X_train and X_test.
* activity_labels contains the descriptions for the 6 types of activities.

Then, there is the question of which columns to use from X_test and X_train. I decided to select the following:
* tBodyAcc_mean()_X
* tBodyAcc_mean()_Y
* tBodyAcc_mean()_Z
* tBodyAcc_std()_X
* tBodyAcc_std()_Y
* tBodyAcc_std()_Z
* tBodyGyro_mean()_X
* tBodyGyro_mean()_Y
* tBodyGyro_mean()_Z
* tBodyGyro_std()_X
* tBodyGyro_std()_Y
* tBodyGyro_std()_Z

My two mean arguments for selecting these columns are:
* the statement in the description: “only the measurements on the mean and standard deviation for each measurement”
* the definition of a tidy data set, which implies that no computation should be carried out with raw data. 

So I selected the chosen columns out of the X-test and X_train data tables.

Then, i prepared for merging the X_test table with y_test and subject_test; and the same actions for X_train with y_train and subject_train.

After these merge-actions, I put the two resulting tables row-wise together into a tables containing all measurements.

Then, i tidied the resulting table up a bit (removing an unnecessary column, and changing the order of the columns).
We still need to decode the Activity, so that it will not have values like 1, 2 and  so on, but LAYING, STANDING etc. This again is a Merge action, this time with     the table named activity_labels.

Again I did some tidying up (changing the order of the columns, because the merge-action put them in an order we don’t want).

Nearly there! Now, we need to give appropriate names to the various columns, and give a nice name to the result, and we’re done!

Then, there’s the question for a second data set containing the averages for each   activity and each subject. I used ‘Group by’ and ‘summarise’ to realise this. And   changed the names of the columns, so that they reflect a difference with the        previous data set. The name of this data set is total_set_mean. 
