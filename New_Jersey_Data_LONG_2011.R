############################################################################################################################
####
#### Code for preparation of New_Jersey data
####
############################################################################################################################

library("SGP")
library("doMC")
#registerDoMC(4) #  Can run sequentially if you prefer/can't parallelize
#getDoParWorkers()

###
### Reading in .csv files as data.tables - pipe (|) seperated files.
###

my.files <- c("NJASK_2010_2011_Math.csv", "NJASK_2010-2011_ELA.csv")

setwd("../Data")
New_Jersey_Data <- list(Student = foreach (i = my.files, .combine = "rbind", .packages = "data.table", .inorder=FALSE) %dopar% {data.table(read.csv(i, sep="|"))})
setwd("../SGP")


###
### Re-Name the data - substitute _ for . and capitalize names.  Here's a function to do it:  
###

subSpecial <- function(x) {
    s <- strsplit(x, split=".", fixed=TRUE)[[1]]
    s <- paste(toupper(substring(s, 1,1)), toupper(substring(s, 2)), sep="", collapse="_")
    s <- strsplit(s, split="__")[[1]][1]
    return(s) 
}


#  rename:

for (j in 1:dim(New_Jersey_Data[["Student"]])[2]) names(New_Jersey_Data[["Student"]])[j] <- subSpecial(names(New_Jersey_Data$Student)[j])

sapply(New_Jersey_Data[["Student"]], class)

names(New_Jersey_Data[["Student"]])[1] <- "TESTING_YEAR"
New_Jersey_Data[["Student"]]$SCALED_SCORE <- as.numeric(New_Jersey_Data[["Student"]]$SCALED_SCORE) # For SGP function - doesn't always like integers...
New_Jersey_Data[["Student"]]$SUBJECT <- toupper(New_Jersey_Data[["Student"]]$SUBJECT) #  Any field that gets 'keyed' on needs to be ALL CAPS


############################################################################################################################
###  IDENTIFY VALID CASES
### 
### Duplicate rows for individual students may be the only issue:
###        ALL scores are in range of 100 - 300, so NO SCALED_SCORE greater than LOSS and less than HOSS
###        All students in grades 3 - 8 (assume taking grade level examinations?)
###
############################################################################################################################

New_Jersey_Data[["Student"]][["VALID_CASE"]] <- factor(1, levels=1:2, labels=c("VALID_CASE", "INVALID_CASE"))

###  Duplicated Records

key(New_Jersey_Data[["Student"]]) <- c("STUDENT_ID", "TESTING_YEAR", "SUBJECT")

#  Inspect the dublicates first to see what's going on.
dup.ids<-New_Jersey_Data[["Student"]]$STUDENT_ID[which(duplicated(New_Jersey_Data[["Student"]]))]
dups<-New_Jersey_Data[["Student"]][New_Jersey_Data[["Student"]]$STUDENT_ID %in% dup.ids]
length(dup.ids) # only a handful, but we'll try to keep the best of the lot
dim(dups)
summary(dups)

# Invalidate lowest score for duplicates.
key(New_Jersey_Data[["Student"]]) <- c("VALID_CASE", "STUDENT_ID", "TESTING_YEAR", "SUBJECT", "SCALED_SCORE")
key(New_Jersey_Data[["Student"]]) <- c("VALID_CASE", "STUDENT_ID", "TESTING_YEAR", "SUBJECT")
New_Jersey_Data[["Student"]][["VALID_CASE"]][which(duplicated(New_Jersey_Data[["Student"]]) & New_Jersey_Data[["Student"]]$VALID_CASE=="VALID_CASE")-1] <- "INVALID_CASE"

############################################################################################################################
###
###  Create Additional Variables:
###
############################################################################################################################

### Prior Performance Levels
#  Make the Performance Levels an ORDERED factor
New_Jersey_Data[["Student"]]$PERFORMANCE_LEVEL <- ordered(New_Jersey_Data[["Student"]]$PERFORMANCE_LEVEL, levels=c("Partially Proficient", "Proficient", "Advanced Proficient"))

#  Use data.table to select each "Valid" student record from last year and tack on the scaled score and performance level from that record onto the current year record (as *_PRIOR).
key(New_Jersey_Data[["Student"]]) <- c("STUDENT_ID", "SUBJECT", "TESTING_YEAR", "VALID_CASE")
New_Jersey_Data[["Student"]]$SCALED_SCORE_PRIOR <- New_Jersey_Data[["Student"]][SJ(STUDENT_ID, SUBJECT, TESTING_YEAR-1, "VALID_CASE"), mult="last"][,SCALED_SCORE]
New_Jersey_Data[["Student"]]$PERFORMANCE_LEVEL_PRIOR <- New_Jersey_Data[["Student"]][SJ(STUDENT_ID, SUBJECT, TESTING_YEAR-1, "VALID_CASE"), mult="last"][,PERFORMANCE_LEVEL]

###  Unique School Identifier ?

summary(New_Jersey_Data[["Student"]]$DISTRICT_CODE[New_Jersey_Data[["Student"]]$SCHOOL_CODE==150]) #tried with 50, 100, 999 - defintely not a unique ID
summary(New_Jersey_Data[["Student"]]$SCHOOL_CODE) #  All 3 digit numbers

New_Jersey_Data[["Student"]]$UNIQUE_SCHOOL_NUMBER <- New_Jersey_Data[["Student"]]$DISTRICT_CODE*1000 + New_Jersey_Data[["Student"]]$SCHOOL_CODE

summary(New_Jersey_Data[["Student"]]$UNIQUE_SCHOOL_NUMBER)
summary(New_Jersey_Data[["Student"]]$UNIQUE_SCHOOL_NUMBER %% 1000) #  Modulo 1000 returns SCHOOL_CODE

############################################################################################################################
###
###  SGP standard variable names:
###
############################################################################################################################

my.names <- c("YEAR", "Testing.Program", "CONTENT_AREA", "GRADE", "ID", "DISTRICT_NUMBER", "School.Code", "County.Name",
	"DISTRICT_NAME", "SCHOOL_NAME", "DFG", "Gender", "Race.Ethnicity.Combined", "Title.I.LAL", "Title.I.Math",
	"Special.Education..SE.", "General.ED", "Former.LEP", "Current.LEP", "Time.in.District.Less.Than.1.Year",
	"Economically.Disadvantaged", "Migrant", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "VALID_CASE", "SCALE_SCORE_PRIOR",
	"ACHIEVEMENT_LEVEL_PRIOR", "SCHOOL_NUMBER")

names(New_Jersey_Data[["Student"]]) <- my.names
New_Jersey_Data[["Student"]]$SCALE_SCORE_PRIOR <- NULL
New_Jersey_Data[["Student"]]$ID <- factor(New_Jersey_Data[["Student"]]$ID)
levels(New_Jersey_Data[["Student"]]$CONTENT_AREA) <- c("ELA", "MATHEMATICS")
New_Jersey_Data[["Student"]]$Gender[New_Jersey_Data[["Student"]]$Gender==""] <- NA
New_Jersey_Data[["Student"]]$Gender <- droplevels(New_Jersey_Data[["Student"]]$Gender)
levels(New_Jersey_Data[["Student"]]$Gender) <- c("Female", "Male")
levels(New_Jersey_Data[["Student"]]$Race.Ethnicity.Combined) <- c("Asian", "Black", "Hispanic", "Native American", "Other", "Pacific Islander", "White")
levels(New_Jersey_Data[["Student"]]$Title.I.LAL) <- c("No", "Yes")
levels(New_Jersey_Data[["Student"]]$Title.I.Math) <- c("No", "Yes")
levels(New_Jersey_Data[["Student"]]$General.ED) <- c("No", "Yes")
levels(New_Jersey_Data[["Student"]]$Economically.Disadvantaged) <- c("No", "Yes")
levels(New_Jersey_Data[["Student"]]$Migrant) <- c("No", "Yes")

# Save with original variable names in place

New_Jersey_Data_LONG_2011 <- New_Jersey_Data$Student
save(New_Jersey_Data_LONG_2011, file="../Data/New_Jersey_Data_LONG_2011.Rdata", compress=TRUE) #

