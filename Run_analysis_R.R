library(dplyr)

# assign file name to viriable filename
filename <- "Coursera_DS3_Final.zip"

# Checking if document already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filenFame, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
 
# Create a dataframe for each data set
features <- read.table("C:/Users/crist/Documents/Data Science/Johns Hopkins/Getting and Cleaning Data/Project/Cleaning-Data-Project/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("C:/Users/crist/Documents/Data Science/Johns Hopkins/Getting and Cleaning Data/Project/Cleaning-Data-Project/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("C:/Users/crist/Documents/Data Science/Johns Hopkins/Getting and Cleaning Data/Project/Cleaning-Data-Project/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("C:/Users/crist/Documents/Data Science/Johns Hopkins/Getting and Cleaning Data/Project/Cleaning-Data-Project/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("C:/Users/crist/Documents/Data Science/Johns Hopkins/Getting and Cleaning Data/Project/Cleaning-Data-Project/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("C:/Users/crist/Documents/Data Science/Johns Hopkins/Getting and Cleaning Data/Project/Cleaning-Data-Project/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("C:/Users/crist/Documents/Data Science/Johns Hopkins/Getting and Cleaning Data/Project/Cleaning-Data-Project/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("C:/Users/crist/Documents/Data Science/Johns Hopkins/Getting and Cleaning Data/Project/Cleaning-Data-Project/UCI HAR Dataset/train/y_train.txt", col.names = "code")

# merge x/y test and train data by ROWs
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
# merge Subject, X and Y dataframes
Merged_Data <- cbind(Subject, Y, X)
#Extracts only the measurements on the mean and standard deviation for each measurement
cleandata <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
#replaces codes to activity names from the activities dataframe
cleandata$code <- activities[cleandata$code, 2]

#Uses descriptive activity names to name the activities in the data set
names(cleandata)[2] = "activity"
names(cleandata)<-gsub("Acc", "Accelerometer", names(cleandata))
names(cleandata)<-gsub("Gyro", "Gyroscope", names(cleandata))
names(cleandata)<-gsub("BodyBody", "Body", names(cleandata))
names(cleandata)<-gsub("Mag", "Magnitude", names(cleandata))
names(cleandata)<-gsub("^t", "Time", names(cleandata))
names(cleandata)<-gsub("^f", "Frequency", names(cleandata))
names(cleandata)<-gsub("tBody", "TimeBody", names(cleandata))
names(cleandata)<-gsub("-mean()", "Mean", names(cleandata), ignore.case = TRUE)
names(cleandata)<-gsub("-std()", "STD", names(cleandata), ignore.case = TRUE)
names(cleandata)<-gsub("-freq()", "Frequency", names(cleandata), ignore.case = TRUE)
names(cleandata)<-gsub("angle", "Angle", names(cleandata))
names(cleandata)<-gsub("gravity", "Gravity", names(cleandata))
#creates an unique dataframe set with the average of each variable for each activity and each subject.
FinalData <- cleandata %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)