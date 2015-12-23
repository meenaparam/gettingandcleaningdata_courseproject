## Title: Getting and Cleaning Data - Course Project
## Author: Meenakshi Parameshwaran
## Date: 19th Dec 2015

## Part 1 - Merges the training and the test sets to create one data set.

# check the working directory
getwd()

# Step 1 - get and unzip the datasets (in case the datasets are not already in the working directory)

myurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url = myurl, destfile = "week3data.zip", mode = "curl" )

unzip(zipfile = "week3data.zip", exdir = "./") # unzips to the same directory

list.dirs() # let's see which folders are there

x <- list.dirs() # assign the directories to an object so I can navigate using it

# the files that I want are in the "UCI HAR Dataset" folder.

list.files(x) # let's see which files are in the UCI HAR dataset folders

# Step 2 - read in the relevant datasets

# clarification information from the discussion forums online says that we need to merge te 6 files in the test and train folders

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Step 3 - combine the datasets all together

# I can see the dimensions oand it looks like the x_ dfs have the most variables - the subject_ and y_ dfs only have 1 variable each. The test dfs all have the same number of obs - 2947. Likewise, the train dfs all have the same number of obs - 7352. This means I probably just need to cbind the extra columns on.

test <- cbind(x_test, y_test, subject_test)
train <- cbind(x_train, y_train, subject_train)

# Now append the test dataset to the train dataset
tt <- rbind(test, train) 

## Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 

# Step 4 -  name the columns so I can figure out which ones hold the mean and SD

# in the zipped file, there is a txt file called "features.txt" - this has 561 elements which are the variable names

varnames <- read.table(file = "./UCI HAR Dataset/features.txt")
varnames <- as.character(varnames[,2]) # just keep the second column which has the actual variable names. Put the varnames into a character vector.

# check out the V1 columns as some of these must be idenfitiers for the subjects and activities listed in the README.txt file that came with the datasets

table(test[,562]) # this has 6 categories, so is probably the activity measure
table(test[,563]) # this has 9 categories between 1 and 30, so is probably the subject measure
table(train[,562]) # this has 6 categories, so is probably the activity measure
table(train[,563]) # this has 9 categories between 1 and 30, so is probably the subject measure

# add two more elements to the end of the varnames vector - "activity" and "subject"

varnames <- c(varnames, "activity", "subject") # now this holds the original list of measurement variable names plus a varname for activity and one for subject

names(tt) <- varnames # assign the varnames to the columns of my tt dataframe.
names(tt)

# Step 5 - keep just the columns with -mean() and -std()in them
library(dplyr)
ttmeans <- select(tt, contains("-mean()")) # this throws an error that there are duplicated column names - Error: found duplicated column name

duplicated(names(tt)) # yes, there are duplicated column names,

# remove duplicated column names
tt <- tt[!duplicated(names(tt))]

# try finding the means columns again
ttmeans <- select(tt, contains("-mean()"))

# find the std columns
ttstds <- select(tt, contains("-std()"))

# get the subject and activity columns
ttids <- select(tt, activity, subject)

# combined the means, stds, and ids
ttnew <- cbind(ttids, ttmeans, ttstds)

# check the dimensions
dim(ttnew)

# check the variable names
names(ttnew)

# all seems ok

## Part 3 - Uses descriptive activity names to name the activities in the data set

table(ttnew$activity)
ttnew$activity <- factor(ttnew$activity, levels = c(1,2,3,4,5,6), labels = c("WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
table(ttnew$activity)

## Part 4 - Appropriately labels the data set with descriptive variable names. 

# the variable names are already pretty descriptive as I have used the names that come from the features.txt file. I just need to do a few tweaks to make it clearer. I need to be explicit about what the abbreviations means. I should keep the variable names lowercase, without hyphens, and make them descriptive.

# reminder of the current names
names(ttnew)

# get rid of the ()s
names(ttnew) <- gsub("\\(|\\)", "", names(ttnew))

# replace the first occurrence of t with time-
names(ttnew) <- sub("^t", "time-", names(ttnew))

# replace the first occurence of f with frequency-
names(ttnew) <- sub("^f", "frequency-", names(ttnew))

# replace Acc with -accelerometer
names(ttnew) <- sub("Acc", "-accelerometer", names(ttnew))

# replace Gyro with -gyroscope
names(ttnew) <- sub("Gyro", "-gyroscope", names(ttnew))

# replace Jerk with -jerk
names(ttnew) <- sub("Jerk", "-jerk", names(ttnew))

# replace Mag with -magnitude
names(ttnew) <- sub("Mag", "-magnitude", names(ttnew))

# make all variable names lowercase
names(ttnew) <- tolower(names(ttnew))

# check through
names(ttnew)

# changes instances of bodybody to body
names(ttnew) <- sub("bodybody", "body", names(ttnew))

# final check - looks ok
names(ttnew)

## Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy <- ttnew %>% group_by(subject, activity) %>% summarise_each(funs(mean(., na.rm=TRUE)))

# write out the table
write.table(x = tidy, file = "tidy_uci_har.txt", sep="\t", row.names = F) 

# test it works by reading the data back in
tidydata <- read.table(file = "tidy_uci_har.txt", header = T)
# yep, the tidy dataset is reading in ok

# END #
                                                                            