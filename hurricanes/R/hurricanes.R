# 1
## 1.1 load packages
library(data.table)

## 1.2 load data
pwd <- dirname(rstudioapi::getSourceEditorContext()$path)
pwd <-  dirname(pwd)  # script inside ../R folder
if (!dir.exists(paste0(pwd, .Platform$file.sep, "data"))) {
  ## create data folder
  dir.create(paste0(pwd, .Platform$file.sep, "data"))
  ## shell?system command
  if (!file.exists(paste0(pwd, .Platform$file.sep, "data",
                          .Platform$file.sep, "data_description.txt"))) {
    system(command = paste0("cd ", pwd, .Platform$file.sep, "data",
                            " ; ", "kaggle datasets download -d noaa/hurricane-database"))
    system(command = paste0("cd ", pwd, .Platform$file.sep, "data",
                            " ; ", "unzip \\*.zip"))
    system(command = paste0("cd ", pwd, .Platform$file.sep, "data",
                            " ; ", "find . -name \\*.zip -delete"))
  }
}
atlantic <- fread(input = paste0(pwd, .Platform$file.sep, "data", .Platform$file.sep, "atlantic.csv"),
                   na.strings = "-999")
pacific <- fread(input = paste0(pwd, .Platform$file.sep, "data", .Platform$file.sep, "pacific.csv"),
                 na.string = "-999")
