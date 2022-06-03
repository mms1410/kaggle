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
tbl_train[, Id := NULL]
##
old_colnames <- colnames(tbl_train)
new_colnames <- gsub(patter = "1st", replacement = "First", x = old_colnames)
new_colnames <- gsub(pattern = "2nd", replacement = "Second", x = new_colnames)
new_colnames <- gsub(pattern = "3", replacement = "Third", x = new_colnames)
colnames(tbl_train) <- new_colnames
colnames(tbl_test) <- new_colnames
names_train <- colnames(tbl_train)[-which(colnames(tbl_train) == "SalePrice")]
################################################################################
str(tbl_train)
## any row with NA's only?
any(
  tbl_train[, lapply(
    .SD, function(x)sum(is.na(x))
    ), .SDcols = colnames(tbl_train)] == nrow(tbl_train)
)
## define help function for NA impute 
imputeNA <- function(column) {
  if (any(is.na(column))) {
    if (is.factor(column)) {
      probs <- table(column) / sum(table(column))
      impute <- sample(x = names(table(column)),
                       size = sum(is.na(column)),
                       prob = probs, replace = TRUE)
      column[is.na(column)] <- impute
      column
    } else if (is.numeric(column)) {
      column[is.na(column)] <- median(column, na.rm = TRUE)
      column
    }
  } else {
    column
  }
}
## impute NA's
tbl_train[, (colnames(tbl_train)) := lapply(.SD, imputeNA), .SDcols = colnames(tbl_train)]
################################################################################
# 2.
gam_formula_lin <- paste("",names_train, "", sep = "", collapse = " + ")
gam_formula_lin <- paste0("SalePrice ~ ", gam_formula_lin, collapse = "", sep = "")
gam_formula_lin
gam_formula_lin <- as.formula(gam_formula_lin)

gam_formula_s <- paste("s(",names_train, ")", sep = "", collapse = " + ")
gam_formula_s <- paste0("SalePrice ~ ", gam_formula_s, collapse = "", sep = "")
gam_formula_s
gam_formula_s <- as.formula(gam_formula_s)

model_gam_lin <- gamlss::gamlss(formula = gam_formula_lin, data = tbl_train)
predictAll(model_gam_lin, newdata = tbl_test)
predict(model_gam_lin, tbl_train)

model_gam_lin <- mgcv::gam(formula = gam_formula_lin, data = tbl_train)
model_gam_s <- mgcv::gam(formula = gam_formula_s, data = tbl_train)
model_gam_s <- gamlss::gamlss(formula = gam_formula_s, data = tbl_train)