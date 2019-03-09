

library(dplyr)

#Filepaths:

filepath_training="./UCI HAR Dataset/train/X_train.txt"
filepath_test="./UCI HAR Dataset/test/X_test.txt"
filepath_features="./UCI HAR Dataset/features.txt"
filepath_activity="./UCI HAR Dataset/activity_labels.txt"

filepath_train_labels="./UCI HAR Dataset/train/y_train.txt"
filepath_test_labels="./UCI HAR Dataset/test/y_test.txt"

filepath_train_subjects="./UCI HAR Dataset/train/subject_train.txt"
filepath_test_subjects="./UCI HAR Dataset/test/subject_test.txt"

#Read data from dataset files

training_set<-read.table(filepath_training)
test_set<-read.table(filepath_test)

#Merge two datasets
total_set<-rbind(training_set,test_set)

#Read features from file
features<-read.table(filepath_features)

#Get columns numbers with mean and std
columns_numbers<-grep("mean|std",features[,2])

#Get columns names with mean und std
columns_names=gsub("[()-]","", features[colum_numbers,2])

#Read activity from file
activity=read.table(filepath_activity)

#Read labels and subjects files
train_labels=read.table(filepath_train_labels)
test_labels=read.table(filepath_test_labels)
train_subjects=read.table(filepath_train_subjects)
test_subjects=read.table(filepath_test_subjects)

#Merge labels and subjects
total_labels=rbind(train_labels,test_labels)
total_subjects=rbind(train_subjects,test_subjects)

#Take only columns with mean and std from total data set
total_set<-total_set[,columns_numbers]

#Change labels from numeric format to text names
total_labels<-activity[total_labels[,1],2]

#Collect all the data together (data, labels, subjects)
final_set<-cbind(total_set,total_labels,total_subjects)

# Change the columns names in the final data set
names(final_set)<-c(columns_names,"activity","subject")

#Making new data set with averaging of each variable for each activity and each subject.
new_data_set<-final_set %>% group_by(activity,subject)

new_data_set<- new_data_set %>% summarize_all(funs(mean))

#Writing the new data set to txt file new_data_set.txt
write.table(new_data_set, file="new_data_set.txt",row.names = FALSE)