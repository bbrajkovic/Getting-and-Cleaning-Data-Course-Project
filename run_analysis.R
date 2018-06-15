library(dplyr)
library(readr)
library(stringr)


## DATA LOADING AND FORMATING ##

actv_txt <- read_delim("./data/activity_labels.txt", col_names = FALSE, delim=" ")              # Load activity_labels.txt
actv_txt <- rename(actv_txt, activity_id = X1, activity_name = X2)

ftrs_txt <- read_delim("./data/features.txt", col_names = FALSE, delim=" ")                     # Load features.txt
ftrs_txt <- rename(ftrs_txt, feature_id = X1, feature_desc = X2)

subject_training <- read_delim("./data/train/subject_train.txt", col_names = FALSE, delim=" ")  # Load subject_train.txt
subject_training <- rename(subject_training, subject_id = X1)

y_training <- read_table("./data/train/y_train.txt", col_names = FALSE)                         # Load y_train.txt
y_training <- rename(y_training, activity_id = X1)

x_training <- read_table("./data/train/X_train.txt", col_names = FALSE)                         # Load X_train.txt
ftrs_txt_vect <- as.vector(unlist(ftrs_txt[,2]))                                                # Getting names
ftrs_txt_vect <- str_replace_all(ftrs_txt_vect, "\\(", "")                                      # Formating content
ftrs_txt_vect <- str_replace_all(ftrs_txt_vect, "\\)", "")
ftrs_txt_vect <- str_replace_all(ftrs_txt_vect, "-", ".")
colnames(x_training) <- ftrs_txt_vect

mean_std <- grep(".*(mean|std)\\(\\).*", ftrs_txt$feature_desc)                                 # Extracting only the measurements on the mean and standard deviation
ftrs_mean <- ftrs_txt[mean_std,]                                                                # Subsetting for mean and std

x_training_mean_std <- x_training[,mean_std]                                                    # Subsetting for mean and std
y_training_merge <- merge(y_training, actv_txt)
y_training_desc <- y_training_merge[,2]

training_data <- cbind(subject_training, x_training_mean_std, y_training_desc)                  # Bind training data
training_data <- rename(training_data, activity = y_training_desc)


## READ AND FORMAT TEST DATA ##

subject_tst <- read_delim("./data/test/subject_test.txt", col_names = FALSE, delim=" ")         # Load subject_test.txt
subject_tst <- rename(subject_tst, subject_id = X1)
y_tst <- read_table("./data/test/y_test.txt", col_names = FALSE)                                # Load y_test.txt
y_tst <- rename(y_tst, activity_id = X1)
x_tst <- read_table("./data/test/X_test.txt", col_names = FALSE)                                # Load X_test.txt
colnames(x_tst) <- ftrs_txt_vect
x_tst_mean_std <- x_tst[,mean_std]                                                              # Subsetting for mean and std
y_tst_merge <- merge(y_tst, actv_txt)                                                           # Adding descriptive activity names based on y_tst ~ actv_txt
y_tst_desc <- y_tst_merge[,2]

tst_data <- cbind(subject_tst, x_tst_mean_std, y_tst_desc)                                      # Binding test data
tst_data <- rename(tst_data, activity = y_tst_desc)


## BIND TRAINING AND TEST DATA ##

all_data <- rbind(training_data, tst_data)

tidy_data <- all_data %>%                                                                       # Creating second data set with average of each variable for each activity and each subject
        group_by(activity, subject_id) %>%
        summarize_all(funs(mean)) %>%
        arrange(activity, subject_id)

write.table(tidy_data, "./code/final_output.txt", row.names = FALSE)                            # Create final output file