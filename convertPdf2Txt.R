# extract two column pdfs
require(pdftools)
require(tidyverse)

# set path
loadpath="~/Thesis /PDF Data/New Files"
savepath="~/Thesis /PDF Data/Text Data"
setwd(loadpath)

# get all files in the path
filelist <- list.files(loadpath,pattern = "\\.PDF$")

for (s in 1:length(filelist)){
  filename=filelist[[s]]
  writename=str_replace(filename,pattern=".PDF", replacement=".txt")
  # extract text
  txt <- pdf_text(filelist[s])
  # print the text in utf-8
  writename=paste0(savepath,"/",writename)
  write(txt,file=writename)
}
