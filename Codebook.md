## Script description

*Script will perform 5 steps getting and cleaning data and will produce output file with independent tidy data set with the average of each variable for each activity and each subject.*

1. Data is **loaded and formated** via adding descriptive activity names.

2. Features are loaded and **only labels measurements on the mean and standard deviation** for each measurement is extracted.

3. Training and test datasets are **binded**.

4. Data set containing average of each variable for each activity and each subject is created and exported to **final_output.txt**

## Brief description of main parts of code
### Loadin files and formatting names
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


