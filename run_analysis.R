setwd("~/Desktop/coursera/Getting and Cleaning Data/UCI HAR Dataset")
library(data.table); library(dplyr)

##assign name for files
features<- read.table("./features.txt", header = FALSE, col.names = c("n","function"))
activity<- read.table("./activity_labels.txt", header=FALSE, col.names = c("code","activity"))
subject_test<- read.table("./test/subject_test.txt", header = FALSE, col.names = "subject")
x_test<- read.table("./test/X_test.txt",header = FALSE, col.names = features$function.)
y_test<- read.table("./test/y_test.txt",header = FALSE, col.names = "code")
subject_train <- read.table("./train/subject_train.txt", header = FALSE, col.names = "subject")
x_train <- read.table("./train/X_train.txt", header = FALSE, col.names = features$function.)
y_train <- read.table("./train/y_train.txt", header = FALSE, col.names = "code")

##merge the training and the test sets to create one data set
x<- rbind(x_test, x_train)
y<- rbind(y_test, y_train)
subject<- rbind(subject_test, subject_train)
data1<- cbind(subject, x, y)

##Extracts only the measurements on the mean and standard deviation for each measurement.
data2<- select(data1, subject, code, contains("mean"), contains("std"))

##Uses descriptive activity names to name the activities in the data set
activity<- as.character(activity[,2])
data2$code<- activity[data2$code]

##Appropriately labels the data set with descriptive variable names.
names(data2)[2]="activity"
names(data2)<-gsub("^t","Time",names(data2))
names(data2)<-gsub("^f","Frequency",names(data2))
names(data2)<-gsub("Acc","Accelerometer",names(data2))
names(data2)<-gsub("Gyro","Gyroscope",names(data2))
names(data2)<-gsub("Mag","Magnitude",names(data2))
names(data2)<-gsub("mean","Mean",names(data2))
names(data2)<-gsub("std","StandardDeviation",names(data2))
names(data2)<-gsub("-","_",names(data2))
names(data2)<-gsub("BodyBody","Body",names(data2))
names(data2)<-gsub("tBody","TimeBody",names(data2))
names(data2)<-gsub("^f","Frequency",names(data2))

##From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.
TidyData <- aggregate(data2[,3:81], by = list(activity = data2$activity, subject = data2$subject),FUN = mean)
write.table(TidyData, file="tidydata.txt", row.names = FALSE)
