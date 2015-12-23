# README

This project analyses wearable computing data, collected from Samsung Galaxy S smartphone the accelerometers.

The source data for this project is here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description of smartphone physical activity data collection is available here: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This repository contains three files (in addition to this README):

### 1. [run_analysis.R](https://github.com/mparam83/gettingandcleaningdata_courseproject/blob/master/run_analysis.R)
This is the main R script for this project. When run, it transforms the source data into a tidy data set containing the average he average of each mean and standard deviation variable in the source data for each physical activity and each subject.

More specifically, run_analysis.R does the following:

1. Merges training and the test datasets from the source data to create one data set.
2. Extracts means and standard deviations for each measurement collected through the smartphone. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each physical activity and each subject (person in the dataset.

### 2. [tidy_uci_hcr.txt](https://github.com/mparam83/gettingandcleaningdata_courseproject/blob/master/tidy_uci_har.txt)
This is the tidy dataset that results from the analysis performed in this project. It adheres to the principles of tidy data: each variable in a different column and each observation of that variable in a different row (more on tidy data from Hadley Wickham's paper) [here](http://vita.had.co.nz/papers/tidy-data.pdf). It is a wide-format tidy dataset.
It can easily be read back into R using the following code:

```r
tidydata <- read.table(file = "tidy_uci_har.txt", header = T)
```
### 3. [CodeBook.md](https://github.com/mparam83/gettingandcleaningdata_courseproject/blob/master/CodeBook.Rmd)
This is the Codebook for this project. The Codebook describes the data used in the project, the relevant variables, and the processess I carried out to transform the data from its raw form into the [final tidy dataset] (https://github.com/mparam83/gettingandcleaningdata_courseproject/blob/master/tidy_uci_har.txt) included in this repo.


