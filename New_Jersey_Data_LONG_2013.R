################################################################################
###
### Create New Jersey Data LONG for 2013
###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load data

New_Jersey_Data_ELA <- read.csv("Data/Base_Files/NJASK_2012_2013_ELA.csv", sep="|")
New_Jersey_Data_MATH <- read.csv("Data/Base_Files/NJASK_2012_2013_MATH.csv", sep="|")


### Combine ELA and MATH

New_Jersey_Data_LONG_2013 <- rbind(New_Jersey_Data_ELA, New_Jersey_Data_MATH)


### Tidy up data

names(New_Jersey_Data_LONG_2013) <- c("YEAR", "Testing.Program", "CONTENT_AREA", "GRADE", "ID", "Student.ID..SSID.", "DISTRICT_NUMBER", "School.Code", "County.Name",
	"DISTRICT_NAME", "SCHOOL_NAME", "DFG", "Gender", "Race.Ethnicity.Combined","Title.I.LAL", "Title.I.Math", "Special.Education..SE.", "General.ED", "Former.LEP",
	"Current.LEP", "Time.in.District.Less.Than.1.Year", "Economically.Disadvantaged", "Migrant", "Homeless", "SCALE_SCORE", "ACHIEVEMENT_LEVEL")   

New_Jersey_Data_LONG_2013$Homeless <- NULL
New_Jersey_Data_LONG_2013$Former.LEP <- NULL
New_Jersey_Data_LONG_2013$Testing.Program <- NULL

New_Jersey_Data_LONG_2013$YEAR <- as.character(New_Jersey_Data_LONG_2013$YEAR)
New_Jersey_Data_LONG_2013$GRADE <- as.character(New_Jersey_Data_LONG_2013$GRADE)

New_Jersey_Data_LONG_2013$CONTENT_AREA <- as.character(New_Jersey_Data_LONG_2013$CONTENT_AREA)
New_Jersey_Data_LONG_2013$CONTENT_AREA[New_Jersey_Data_LONG_2013$CONTENT_AREA=="Math"] <- "MATHEMATICS"

New_Jersey_Data_LONG_2013$ID <- as.character(New_Jersey_Data_LONG_2013$ID)

New_Jersey_Data_LONG_2013$Gender[New_Jersey_Data_LONG_2013$Gender==""] <- NA
New_Jersey_Data_LONG_2013$Gender <- factor(New_Jersey_Data_LONG_2013$Gender)
levels(New_Jersey_Data_LONG_2013$Gender) <- c("Female", "Male")

levels(New_Jersey_Data_LONG_2013$Race.Ethnicity.Combined) <- c("Asian", "Black", "Hispanic", "Native American", "Other", "Pacific Islander", "White")

levels(New_Jersey_Data_LONG_2013$General.ED) <- c("General Education: No", "General Education: Yes")

New_Jersey_Data_LONG_2013$Current.LEP[New_Jersey_Data_LONG_2013$Current.LEP==""] <- NA
New_Jersey_Data_LONG_2013$Current.LEP <- factor(New_Jersey_Data_LONG_2013$Current.LEP)
levels(New_Jersey_Data_LONG_2013$Current.LEP) <- c("Less than 1 Year", "1 Year", "2 Years", "3 Years", "Yes")

levels(New_Jersey_Data_LONG_2013$Time.in.District.Less.Than.1.Year) <- c("Time in District Less than 1 Year: No", "Time in District Less than 1 Year: Yes")

levels(New_Jersey_Data_LONG_2013$Economically.Disadvantaged) <- c("Economically Disadvantaged: Yes", "Economically Disadvantaged: No", "Economically Disadvantaged: Yes")
New_Jersey_Data_LONG_2013$Economically.Disadvantaged <- as.character(New_Jersey_Data_LONG_2013$Economically.Disadvantaged)
New_Jersey_Data_LONG_2013$Economically.Disadvantaged <- factor(New_Jersey_Data_LONG_2013$Economically.Disadvantaged)

levels(New_Jersey_Data_LONG_2013$Migrant) <- c("Migrant: No", "Migrant: Yes")

New_Jersey_Data_LONG_2013$Title.I.LAL <- factor(1, levels=1, labels="Title I LAL: No")
New_Jersey_Data_LONG_2013$Title.I.Math <- factor(1, levels=1, labels="Title I Math: No")

New_Jersey_Data_LONG_2013$ACHIEVEMENT_LEVEL[New_Jersey_Data_LONG_2013$ACHIEVEMENT_LEVEL==""] <- NA
New_Jersey_Data_LONG_2013$ACHIEVEMENT_LEVEL <- factor(New_Jersey_Data_LONG_2013$ACHIEVEMENT_LEVEL)
New_Jersey_Data_LONG_2013$ACHIEVEMENT_LEVEL <- factor(New_Jersey_Data_LONG_2013$ACHIEVEMENT_LEVEL, levels=c("Partially Proficient", "Proficient", "Advanced Proficient"), ordered=TRUE)

New_Jersey_Data_LONG_2013$SCHOOL_NUMBER <- New_Jersey_Data_LONG_2013$DISTRICT_NUMBER*1000 + New_Jersey_Data_LONG_2013$School.Code

### Indentify Valid Cases

New_Jersey_Data_LONG_2013$VALID_CASE <- "VALID_CASE"
New_Jersey_Data_LONG_2013$VALID_CASE[is.na(New_Jersey_Data_LONG_2013$ID)] <- "INVALID_CASE"

New_Jersey_Data_LONG_2013 <- as.data.table(New_Jersey_Data_LONG_2013)
setkeyv(New_Jersey_Data_LONG_2013, c("VALID_CASE", "ID", "YEAR", "CONTENT_AREA"))

###  Inspect the dublicates first to see what's going on.
dup.ids<-New_Jersey_Data_LONG_2013$ID[which(duplicated(New_Jersey_Data_LONG_2013, by=key(New_Jersey_Data_LONG_2013)))]
dups<-New_Jersey_Data_LONG_2013[New_Jersey_Data_LONG_2013$ID %in% dup.ids]
length(dup.ids) # only a handful, but we'll try to keep the best of the lot
dim(dups)
summary(dups)

# Invalidate lowest score for duplicates.

setkeyv(New_Jersey_Data_LONG_2013, c("VALID_CASE", "ID", "YEAR", "CONTENT_AREA", "SCALE_SCORE"))
setkeyv(New_Jersey_Data_LONG_2013, c("VALID_CASE", "ID", "YEAR", "CONTENT_AREA"))
New_Jersey_Data_LONG_2013[["VALID_CASE"]][which(duplicated(New_Jersey_Data_LONG_2013, by=key(New_Jersey_Data_LONG_2013)) & New_Jersey_Data_LONG_2013$VALID_CASE=="VALID_CASE")-1] <- "INVALID_CASE"


# ENROLLMENT_STATUS

New_Jersey_Data_LONG_2013$STATE_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled State: Yes", "Enrolled State: No"))
New_Jersey_Data_LONG_2013$DISTRICT_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled District: Yes", "Enrolled District: No"))
New_Jersey_Data_LONG_2013$SCHOOL_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled School: Yes", "Enrolled School: No"))

# Save the results

save(New_Jersey_Data_LONG_2013, file="Data/New_Jersey_Data_LONG_2013.Rdata")

