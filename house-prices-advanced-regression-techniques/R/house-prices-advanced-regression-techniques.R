# 1.
## 1.1 libraries
library(data.table)
library(ggplot2)
library(mgcv)
library(gamlss)
library(gamlss.dist)
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
                            " ; ", "kaggle competitions download -c house-prices-advanced-regression-techniques"))
    system(command = paste0("cd ", pwd, .Platform$file.sep, "data",
                            " ; ", "unzip \\*.zip"))
    system(command = paste0("cd ", pwd, .Platform$file.sep, "data",
                            " ; ", "find . -name \\*.zip -delete"))
  }
}

tbl_train <- fread(input = paste0(pwd, .Platform$file.sep, "data",
                                  .Platform$file.sep, "train.csv"),
                   stringsAsFactors = TRUE)
tbl_test <- fread(input = paste0(pwd, .Platform$file.sep, "data",
                                 .Platform$file.sep, "test.csv"),
                  stringsAsFactors = TRUE)
setkey(tbl_train, Id)
setkey(tbl_test, Id)
X_train <- tbl_train[, .SD, .SDcols = !c("Id","SalePrice")]
y_train <- tbl_train$SalePrice
################################################################################
str(tbl_train)
any(  ## any row with na's only?
  tbl_train[, lapply(
    .SD, function(x)sum(is.na(x))
    ), .SDcols = colnames(tbl_train)] == nrow(tbl_train)
)
plot(SalePrice ~., data = tbl_train)
lotNas <- tbl_train[, lapply(
  .SD, function(x)sum(is.na(x))
), .SDcols = colnames(tbl_train)]
idx <- lotNas > nrow(tbl_train) * 0.9
lotNas <- colnames(tbl_train)[idx]
tbl_train <- tbl_train[, .SD, .SDcols = !lotNas]
################################################################################
# 2.
gam_formula <- paste("",colnames(X_train), "", sep = "", collapse = " + ")
gam_formula <- paste0("SalePrice ~ ", gam_formula, collapse = "", sep = "")
gam_formula
gam_formula <- as.formula(gam_formula)


lm(SalePrice~ . , data = tbl_train)
