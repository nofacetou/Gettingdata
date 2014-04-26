#set the filepath for the input and output files
filepath_X_train <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/UCI HAR Dataset/train/X_train.txt"
filepath_y_train <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/UCI HAR Dataset/train/y_train.txt"
filepath_subject_train <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/UCI HAR Dataset/train/subject_train.txt"
filepath_X_test <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/UCI HAR Dataset/test/X_test.txt"
filepath_y_test <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/UCI HAR Dataset/test/y_test.txt"
filepath_subject_test <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/UCI HAR Dataset/test/subject_test.txt"
filepath_feature <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/UCI HAR Dataset/features.txt"
activity_labels <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/UCI HAR Dataset/activity_labels.txt"
tidy_csv <- "D:/Document/My Copy/Copy/Portable Python 2.7.3.2/App/Scripts/getdata-002/Gettingdata/tidy.csv"

#get the activity labels
activity <- read.table(activity_labels)

#get the variable list
var <- read.table(filepath_feature)
#only read the columns that contain "mean()" and "std()"
mean_col <-grepl("mean()", var$V2, fixed=TRUE)
std_col <-grepl("std()", var$V2, fixed = TRUE)
all <- mean_col + std_col
var.sub <- subset(var, all[var$V1]==TRUE)
col <- var.sub$V1

mycols <- rep("NULL", 561)
mycols[col]<-NA

#read all the datasets, and change the colume names using the variable list
X_train <- read.table(filepath_X_train, colClasses=mycols)
colnames(X_train) <- var.sub$V2
X_test <- read.table(filepath_X_test, colClasses=mycols)
colnames(X_test) <- var.sub$V2
y_train <- read.table(filepath_y_train)
colnames(y_train) <- "activity_code"
y_test <- read.table(filepath_y_test)
colnames(y_test) <- "activity_code"
subject_train <- read.table(filepath_subject_train)
colnames(subject_train) <- "ID"
subject_test <- read.table(filepath_subject_test)
colnames(subject_test) <- "ID"

#merge the above 6 datasets into 2 separate datasets: train and test
test <- cbind(ID=subject_test$ID, activity_code=y_test$activity_code,X_test)
train <- cbind(ID=subject_train$ID, activity_code=y_train$activity_code,X_train)
#label the activity code
train$activity_code<-factor(train$activity_code,levels=activity$V1, labels=activity$V2)
test$activity_code<-factor(test$activity_code,levels=activity$V1, labels=activity$V2)

#merge train and test into one dataset
all <- rbind(train,test)

#get the average of each variable for each activity and each subject
library("reshape2")
all_molten <- melt(all, id=c("ID","activity_code"))
tidy <- dcast(all_molten, formula= ID + activity_code ~ variable, mean)
#create new tidy dataset csv file
write.csv(tidy, file = tidy_csv , row.names=FALSE)

