## Script description

*Script will perform 5 steps getting and cleaning data and will produce output file with independent tidy data set with the average of each variable for each activity and each subject.*

1. Data is **loaded and formated** via adding descriptive activity names.

2. Features are loaded and **only labels measurements on the mean and standard deviation** for each measurement is extracted.

3. Training and test datasets are **binded**.

4. Data set containing average of each variable for each activity and each subject is created and exported to **final_output.txt**

## Brief description of main parts of code

This part of code example is using read_delim() function from **reader** package in order to load data and then rename() function from **dplyr** package in order to add descriptive names to variables stored in *actv_txt*

```
actv_txt <- read_delim("./data/activity_labels.txt", col_names = FALSE, delim=" ")
actv_txt <- rename(actv_txt, activity_id = X1, activity_name = X2)
```

This part of code example is using str_replace_all() function from **stringr** package in order to remove all chars that are redundant (i.e. \\))
```
ftrs_txt_vect <- str_replace_all(ftrs_txt_vect, "\\(", "")      
ftrs_txt_vect <- str_replace_all(ftrs_txt_vect, "\\)", "")
ftrs_txt_vect <- str_replace_all(ftrs_txt_vect, "-", ".")
```

This part of code example is using grep() function from **base** package in order to get measurments of mean and std (standard deviation)
```
mean_std <- grep(".*(mean|std)\\(\\).*", ftrs_txt$feature_desc)
```

This part of code example is using c_bind() function from **base** package in order to bind data
```
training_data <- cbind(subject_training, x_training_mean_std, y_training_desc)
```

This part of code example is using %>% to pipe functions group_by(),summarize_all() and arrange() from **dplyr** package over *all_data* dataset and store results in *tidy_data* dataset
```
tidy_data <- all_data %>%
        group_by(activity, subject_id) %>%
        summarize_all(funs(mean)) %>%
        arrange(activity, subject_id)
```

## Script Variables
This is a list of variables used in the script with their usage description
**actv_txt** - dataset containing Descriptive activities mapping
**all_data** - final unformated dataset
**ftrs_mean** - Subset of mean features
**ftrs_txt** - All features
**subject_training** - Dataset loaded from subject_train.txt data
**subject_tst** - Dataset loaded from subject_tst.txt data
**tidy_data** - Final dataset
**training_data** - Dataset with binded training data
**tst_data** - Dataset with binded tst data
**x_training** - Dataset loaded from X_train.txt data
**x_training_mean_std** - Subset of mean and std x_training
**x_tst** - Dataset loaded from X_test.txt data
**x_training** - Dataset loaded from X_train.txt data
**y_training** - Dataset loaded from y_train.txt data
**y_tst** - Dataset loaded from y_test.txt data