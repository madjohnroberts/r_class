run_analysis <- function(){
  # Reads the test and train data from the UCI HAR dataset. The test and training values are 
  # combined, with the means and standard deviations for the accelerometer data is reported 
  # in a dataframe on a per-subject and per-activity basis.
  
  # Need dplyr
  library(dplyr)
  
  # Read the feature names and find out how many there are
  feature_names <- read.csv('./r_data/r_class/assignment4/UCI HAR Dataset/features.txt', header=FALSE, sep=' ')[,2]
  num_features <- length(feature_names)
  
  # Hardcode the paths cause I'm lazy
  xpaths <- c('./r_data/r_class/assignment4/UCI HAR Dataset/test/X_test.txt',
             './r_data/r_class/assignment4/UCI HAR Dataset/train/X_train.txt')
  
  ypaths <- c('./r_data/r_class/assignment4/UCI HAR Dataset/test/y_test.txt',
              './r_data/r_class/assignment4/UCI HAR Dataset/train/y_train.txt')
  
  spaths <- c('./r_data/r_class/assignment4/UCI HAR Dataset/test/subject_test.txt',
              './r_data/r_class/assignment4/UCI HAR Dataset/train/subject_train.txt')
  
  # Make a holding matrix to dump values into, then dump values into it
  xmat <- matrix(nrow=0, ncol=(num_features)) 
  for (path in xpaths){
    xmat <- rbind(xmat, read.fwf(path, rep(16, each=num_features)))
  }

  # Same for the type of activity
  yvec <- vector(mode='numeric', length=0)
  for (path in ypaths){
    yvec <- rbind(yvec, read.fwf(path, widths = 1))
  }

  # Same for the subjects
  svec <- vector(mode='numeric', length=0)
  for (path in spaths){
    svec <- rbind(svec, read.fwf(path, widths = 2))
  }
  
  # Get the columns we want: any with "mean" or "std" in the name
  ms_cols <- which(grepl('mean', feature_names) | grepl('std', feature_names))
  
  # Make the 'merged' dataframe, only grabbing the columns of interest
  all_df <- data.frame(cbind(svec, yvec, xmat[ms_cols]))
  colnames(all_df) <- c('subject', 'activity_type', feature_names[ms_cols])
  
  # Get activity names and rename the column in the dataframe
  anames <- read.csv('./r_data/r_class/assignment4/UCI HAR Dataset/activity_labels.txt', sep = ' ', header = FALSE)[,2]
  all_df$activity_type <- anames[all_df$activity_type]
  
  # Now the averages of each column within the grouping of subject, activity needs to be calculated.
  averaged <- all_df %>% group_by(subject, activity_type) %>% summarise_all(mean)
  
  write.table(test2, file='./r_data/r_class/assignment4/tidy_dataset.csv', row.names = FALSE)
  
  return(averaged)
  
}