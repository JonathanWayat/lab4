library(reshape2)

# 1 taska
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

#add column names 
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

names(y_train) <- "activity"
names(y_test) <- "activity"

# merge in dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

# 2 taska
# determine which columns contain "mean()" or "std()"

#find columns with "mean()" or "std()"
meanstdcols <- grepl("mean\\(\\)", names(combined)) |
  grepl("std\\(\\)", names(combined))

# check if we have ID and activity
meanstdcols[1:2] <- TRUE

# remove bad columns
combined <- combined[, meanstdcols]

# 3-4 taska
# convert the activity column from integer to factor
combined$activity <- factor(combined$activity, labels=c("Walking",
                                                        "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

# 5 taska
# create the tidy data set
melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)

# get result
write.csv(tidy, "lab4.csv", row.names=FALSE)
