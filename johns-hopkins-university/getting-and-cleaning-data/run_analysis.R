library("reshape2")
readRenviron(paste(getwd(), ".Renviron", sep = "/"))

# Get dataset_url from the enironment variable.
tidy_data_txt_path = Sys.getenv("tidy_data_txt_path")
tidy_data_csv_path = Sys.getenv("tidy_data_csv_path")

data_prefix_path = "data"
uci_har_path = paste(data_prefix_path, "UCI HAR Dataset", sep = "/")
train_data_path = paste(uci_har_path, "train", sep = "/")
test_data_path = paste(uci_har_path, "test", sep = "/")

activity_labels_path = paste(uci_har_path, "activity_labels.txt", sep = "/")
activityLabels <- read.table(activity_labels_path)
activityLabels[, 2] <- as.character(activityLabels[, 2])

features_path = paste(uci_har_path, "features.txt", sep = "/")
features <- read.table(features_path)
features[, 2] <- as.character(features[, 2])

# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[, 2])
featuresWanted.names <- features[featuresWanted, 2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# Load the datasets
x_train_path = paste(train_data_path, "X_train.txt", sep = "/")
y_train_path = paste(train_data_path, "y_train.txt", sep = "/")
subject_train_path = paste(train_data_path, "subject_train.txt", sep = "/")
train <-
  read.table(x_train_path)[featuresWanted]
trainActivities <- read.table(y_train_path)
trainSubjects <-
  read.table(subject_train_path)
train <- cbind(trainSubjects, trainActivities, train)

x_test_path = paste(test_data_path, "X_test.txt", sep = "/")
y_test_path = paste(test_data_path, "y_test.txt", sep = "/")
subject_test_path = paste(test_data_path, "subject_test.txt", sep = "/")
test <-
  read.table(x_test_path)[featuresWanted]
testActivities <- read.table(y_test_path)
testSubjects <- read.table(subject_test_path)
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)

# turn activities & subjects into factors
allData$activity <-
  factor(allData$activity, levels = activityLabels[, 1], labels = activityLabels[, 2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- ss
dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean,
            tidy_data_txt_path,
            row.names = FALSE,
            quote = FALSE)

write.csv(allData.mean,
          tidy_data_csv_path)