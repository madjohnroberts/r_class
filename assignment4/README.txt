The file run_analysis.R is a one-stop r function for reading in the accelerometer
data for the coursera assignment "getting and cleaning data" assignment, I think 
it is assignemnt 4. The function does the following, as described by the comments:

1. Read in the training and test data files. Stack the data vertically using rbind.
   this is repeated for each of the following pairs of files:
   a. x_test.txt and x_train.txt
   b. y_test.txt and y_train.txt
   c. subject_test.txt and subject_train.txt

2. The assignment specifically asked for the average and standard deviation columns.
   These columns have headers with either the characters "mean" or "std" in them.
   The list of column headers for the x datasets is contained in the file "features.txt".
   The list of features is extracted and the names are searched for "mean" and "std".
   Columns matched are indexed and the index is used to select the columns in the 
   x matrix for inclusion in the final dataframe. The name list is also down-selected 
   using the index vector.
   
3. After the downselection vector is determined in step 2 above, the final dataframe is
   constructed by rbinding the subject ID, the activity type, and the downselected data.
   The names of the columsn are assigned following dataframe construction using the same
   selection method as the matrix.
   
4. The activity IDs are translated to activity names by selecting from a vector
   extracted from activity_labels.txt. Just index the labels vector using the ID column.
   
5. The dplyr package is used to make the final dataframe for delivery, where the summary
   table is grouped on each subject and activity type then the mean is calculated for each
   of the variables in the dataframe (which happen to be means and standard deviations).