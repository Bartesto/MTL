
rm(list=ls())
library(stringr)
library(R.utils)

dir = "Z:\\DOCUMENTATION\\BART\\R\\R_DEV\\MTL"
imdir = "W:\\usgs\\109071"
setwd(imdir)
pr = 10971
zone = 51
#sensor = "l5"


## Find list of zipped files
#get everything
allfiles <- list.files(recursive = TRUE)
#get only those that match conditions
wanted <- c(paste0(pr, "m"), paste0(zone, "pre.ers"))
matches <- sapply(wanted, grepl, allfiles)
matches <- apply(data.frame(matches), 1, function(z) sum(z==TRUE))
matches <- matches == 2

# First pass result1 and folds1 is all valid .pre files
result1 <- allfiles[matches]

folds1 <- substr(result1, 1, 8)

## Loop to untar and extract MTL.txt 
## only needs to be done on new data
start <- Sys.time()
for (i in 1:length(result1)){
        setwd(paste0(imdir, "\\", folds1[i]))
        zp.file <- list.files(".", pattern = ".tar.gz")
        mtl.name <- paste0(str_split(zp.file, pattern = "\\.")[[1]][1], "_MTL.txt")
        untar(zp.file,files=mtl.name)
}

total <- Sys.time()-start

## Loop to find out what level of correction applied to scene

L1T <- logical()#empty logical vector
for (i in 1:length(result1)){
        setwd(paste0(imdir, "\\", folds1[i]))
        mtl.file <- list.files(".", pattern = "MTL.txt")
        
        text <- scan(mtl.file, character(0), sep = "\n")
        ind <- grepl("_TYPE = \"L", text)#handles product or data_type
        level <- str_split(text[ind], "\"")[[1]][2]
        L1T[i] <- level == "L1T"
        
}

# Second pass result2 and folds2 are all valid .pre files and "L1T" files
result2 <- result1[L1T]
folds2 <- substr(result2, 1, 8)







