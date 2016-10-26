setwd("E:/shubbi study/R program/Corsera/Getting and cleaning data/")

#Reading features.txt
features = read.table("UCI HAR Dataset/features.txt",header=F)

#Reading activity_labels.txt
activityLabels = read.table('UCI HAR Dataset/activity_labels.txt',header=F)
colnames(activityLabels)  = c('activityId','activityType')

# Reading training tables:
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Assigin column names to training table
colnames(subject_train)  = "subjectId"
colnames(x_train)        = features[,2] 
colnames(y_train)        = "activityId"

#Merge training data
training_Data = cbind(y_train,subject_train,x_train)


# Reading testing tables:
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Assigin column names to testing table
colnames(subject_test)  = "subjectId"
colnames(x_test)        = features[,2] 
colnames(y_test)        = "activityId"

#Merge testing data
testing_Data = cbind(y_test,subject_test,x_test)

# Combine training and test data to create a final data set
finalData = rbind(training_Data,testing_Data)

#Reading column names
colNames <- colnames(finalData)

# Create vector for defining ID, mean and standard deviation:
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Subset from final data
setForMeanAndStd <- finalData[ , mean_and_std == TRUE]

#  Using descriptive activity names to name the activities in the data set
setWithActivityNames <- merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

#second independent tidy data set with the average of each variable for each activity and each subject.
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# Writing second tidy data set in txt file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)