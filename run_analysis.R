#------ Libraries ------
library(data.table)
library(dplyr)
------------------------
#
#
#
#  
#Set WD
setwd("F:/Jornada_do_Cientista/2021/C_JHU/Data_Science/Course3/getdata_projectfiles_UCI HAR Dataset")
#
#
#
# 
#Download procedure ------------------------------------------------
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "CourseDataset.zip"
if (!file.exists(destFile)){
  download.file(URL, destfile = destFile, mode='wb')
}
if (!file.exists("./UCI_HAR_Dataset")){
  unzip(destFile)
}
#--------------------------------------------------------------------
#
#
#
# 
#Reading the data into variables ------------------------------------
x_test <- read.table("./test/X_test.txt", header = F)
x_train <- read.table("./train/X_train.txt", header = F)
y_test <- read.table("./test/y_test.txt", header = F)
y_train <- read.table("./train/y_train.txt", header = F)
sub_test <- read.table("./test/subject_test.txt", header = F)
sub_train <- read.table("./train/subject_train.txt", header = F)
#Labels and Names
dat_labels <- read.table("./activity_labels.txt", header = F)
dat_names <- read.table("./features.txt", header = F)
#--------------------------------------------------------------------
#
#
#
#
#Merging the variable tables-----------------------------------------
all_x <- rbind(x_test, x_train)
all_y <- rbind(y_test, y_train)
all_sub <- rbind(sub_test, sub_train)
#
#
#
#
names(all_y) <- "activity_count"
names(dat_labels) <- c("activity_count", "activity")
names(all_sub) <- "subject"
names(all_x) <- dat_names$V2
#
#
#
#
activity <- left_join(all_y, dat_labels, "activity_count")[, 2]
dataset <- cbind(all_sub, activity)
dataset <- cbind(dataset, all_x)
#
#
#
#
all_sub_x_names <- dat_names$V2[grep("mean\\(\\)|std\\(\\)", dat_names$V2)]
dataset_n <- c("subject", "activity", as.character(all_sub_x_names))
dataset <- subset(dataset, select=dataset_n)
#--------------------------------------------------------------------
#
#
#
#
#----- The average -----# -------------------------------------------
dataset_final <- aggregate(. ~subject + activity, dataset, mean)
dataset_final <- dataset_final[order(dataset_final$subject, dataset_final$activity),]


write.table(dataset_final, file = "tidydata.txt",row.name=FALSE)








