# $1
## §1.1

## §1.2
pwd <- rstudioapi::getSourceEditorContext()$path
pwd <- dirname(dirname(pwd))  # script in /R folder
if (dir.exists(paste0(pwd, .Platform$file.sep, "data"))) {
  if(!file.exists("amex-default-prediction.zip")) {
    
  }
} else {
  source()
}
paste0(rstudioapi::getSourceEditorContext()$path, .Platform$file.sep, "data")

# §2
