################################################################################
###
### Create New Jersey Data LONG for 2015
###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


###  Make necessary changes to the SGP object for the 2015 analyses
load("Data/New_Jersey_SGP.Rdata")

setnames(New_Jersey_SGP@Data, c("ID", "Student.ID..SSID."), c("OLD_ID", "ID"))
New_Jersey_SGP@Data[ID=="NULL", ID := NA]
New_Jersey_SGP@Data[is.na(ID), ID := OLD_ID]

####  Deal with duplicate records.  TEMPORARY FIX TO TAKE HIGHEST SCORE
setkey(New_Jersey_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID, SCALE_SCORE)
setkey(New_Jersey_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID)
New_Jersey_SGP@Data[which(duplicated(New_Jersey_SGP@Data))-1, VALID_CASE := "INVALID_CASE"]


### Load 2015 raw PARCC data

New_Jersey_Data_LONG_2015 <- fread("Data/Base_Files/NJ_PARCC_2014_2015.csv", colClasses=rep("character", 153))


### Tidy up data

####  YEAR
New_Jersey_Data_LONG_2015[, YEAR := '2015']

#### GRADE
# table(New_Jersey_Data_LONG_2015$testCode, New_Jersey_Data_LONG_2015$assessmentGrade)
New_Jersey_Data_LONG_2015[, GRADE := gsub("Grade ", "", assessmentGrade)]
New_Jersey_Data_LONG_2015[which(testCode=="ALG01"), GRADE := "8"]
New_Jersey_Data_LONG_2015[which(GRADE==""), GRADE := "EOCT"]
# table(New_Jersey_Data_LONG_2015$testCode, New_Jersey_Data_LONG_2015$GRADE)

####  CONTENT_AREA / "subject"
New_Jersey_Data_LONG_2015[, CONTENT_AREA := toupper(gsub(" ", "_", subject))]
New_Jersey_Data_LONG_2015[which(CONTENT_AREA == "ENGLISH_LANGUAGE_ARTS/LITERACY"), CONTENT_AREA := "ELA"]

####  ACH LEVEL / "summativePerformanceLevel"
New_Jersey_Data_LONG_2015[, ACHIEVEMENT_LEVEL := paste("Level", summativePerformanceLevel)]
New_Jersey_Data_LONG_2015[which(ACHIEVEMENT_LEVEL=="Level "), ACHIEVEMENT_LEVEL := NA]

####  Demographic variables
setnames(New_Jersey_Data_LONG_2015, 
				 c("stateStudentIdentifier", "optionalStateData7", "summativeScaleScore", "firstName", "lastName", 
				 	"responsibleSchoolInstitutionIdentifier", "responsibleSchoolInstitutionName", "responsibleDistrictIdentifier", "responsibleDistrictName",
				 	"sex", "federalRaceEthnicity", "primaryDisabilityType", "titleIIILimitedEnglishProficientParticipationStatus", "economicDisadvantageStatus", "migrantStatus"), 
				 c("ID", "SCALE_SCORE", "SCALE_SCORE_ACTUAL", "FIRST_NAME", "LAST_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME", 
				 	"Gender", "Race.Ethnicity.Combined", "Special.Education..SE.", "Current.LEP", "Economically.Disadvantaged", "Migrant"))

New_Jersey_Data_LONG_2015[,DISTRICT_NAME:=as.factor(DISTRICT_NAME)]
setattr(New_Jersey_Data_LONG_2015$DISTRICT_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2015$DISTRICT_NAME), capwords))

New_Jersey_Data_LONG_2015[,SCHOOL_NAME:=as.factor(SCHOOL_NAME)]
setattr(New_Jersey_Data_LONG_2015$SCHOOL_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2015$SCHOOL_NAME), capwords))

New_Jersey_Data_LONG_2015[,FIRST_NAME:=as.factor(FIRST_NAME)]
# setattr(New_Jersey_Data_LONG_2015$FIRST_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2015$FIRST_NAME), capwords)) # Crashes R if done in one step
tmp.fname <- sapply(levels(New_Jersey_Data_LONG_2015$FIRST_NAME), capwords, USE.NAMES = FALSE)
levels(New_Jersey_Data_LONG_2015$FIRST_NAME) <- tmp.fname

New_Jersey_Data_LONG_2015[,LAST_NAME:=as.factor(LAST_NAME)]
# setattr(New_Jersey_Data_LONG_2015$LAST_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2015$LAST_NAME), capwords))
tmp.lname <- sapply(levels(New_Jersey_Data_LONG_2015$LAST_NAME), capwords, USE.NAMES = FALSE)
levels(New_Jersey_Data_LONG_2015$LAST_NAME) <- tmp.lname

New_Jersey_Data_LONG_2015[,Gender:=as.factor(Gender)]
setattr(New_Jersey_Data_LONG_2015$Gender, "levels", c("Female", "Male"))

New_Jersey_Data_LONG_2015[Race.Ethnicity.Combined == "", Race.Ethnicity.Combined := as.character(NA)]
New_Jersey_Data_LONG_2015[,Race.Ethnicity.Combined:=as.factor(as.numeric(Race.Ethnicity.Combined))]
setattr(New_Jersey_Data_LONG_2015$Race.Ethnicity.Combined, "levels", c("Native American", "Asian", "Black", "Hispanic", "White", "Pacific Islander", "Two or More Races"))
New_Jersey_Data_LONG_2015[,Race.Ethnicity.Combined:=as.character(Race.Ethnicity.Combined)]

New_Jersey_Data_LONG_2015[Special.Education..SE. == "", Special.Education..SE. := as.character(NA)]

New_Jersey_Data_LONG_2015[Current.LEP == "", Current.LEP := as.character(NA)]
New_Jersey_Data_LONG_2015[,Current.LEP:=factor(Current.LEP)]
setattr(New_Jersey_Data_LONG_2015$Current.LEP, "levels", c("No", "Yes"))
New_Jersey_Data_LONG_2015[,Current.LEP:=as.character(Current.LEP)]

New_Jersey_Data_LONG_2015[Economically.Disadvantaged=="", Economically.Disadvantaged:=as.character(NA)]
New_Jersey_Data_LONG_2015[,Economically.Disadvantaged:=factor(Economically.Disadvantaged)]
setattr(New_Jersey_Data_LONG_2015$Economically.Disadvantaged, "levels", c("Economically Disadvantaged: No", "Economically Disadvantaged: Yes"))
New_Jersey_Data_LONG_2015[,Economically.Disadvantaged:=as.character(Economically.Disadvantaged)]

New_Jersey_Data_LONG_2015[Migrant == "", Migrant := as.character(NA)]
New_Jersey_Data_LONG_2015[,Migrant:=factor(Migrant)]
setattr(New_Jersey_Data_LONG_2015$Migrant, "levels", c("Migrant: No", "Migrant: Yes"))
New_Jersey_Data_LONG_2015[,Migrant:=as.character(Migrant)]

### ENROLLMENT_STATUS

New_Jersey_Data_LONG_2015[,STATE_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
New_Jersey_Data_LONG_2015[,DISTRICT_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
New_Jersey_Data_LONG_2015[,SCHOOL_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled School: No", "Enrolled School: Yes"))]


####  Set SCALE_SCORE to numeric and only include non-NA scores in long data
New_Jersey_Data_LONG_2015[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
New_Jersey_Data_LONG_2015[,SCALE_SCORE:=as.numeric(SCALE_SCORE_ACTUAL)]
New_Jersey_Data_LONG_2015 <- New_Jersey_Data_LONG_2015[!is.na(SCALE_SCORE)]

### Indentify Valid Cases

New_Jersey_Data_LONG_2015[, VALID_CASE := "VALID_CASE"]


####  Invalidate duplicate cases based on PARCC flags as described in "8-25-15 PARCC Summative File - Field definitions.pdf"
New_Jersey_Data_LONG_2015[multipleRecordFlag=="Y" & reportedSummativeScoreFlag=="",  VALID_CASE := "INVALID_CASE"]

setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, GRADE, ID)
sum(duplicated(New_Jersey_Data_LONG_2015[VALID_CASE != "INVALID_CASE"])) # 0 Valid and 30 duplicates invalidated in step above (1,560 when NA scale scores included).
# dups <- New_Jersey_Data_LONG_2015[unique(c(which(duplicated(New_Jersey_Data_LONG_2015))-1, which(duplicated(New_Jersey_Data_LONG_2015)))), ]
# setkeyv(dups, key(New_Jersey_Data_LONG_2015))

setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, ID)
# sum(duplicated(New_Jersey_Data_LONG_2015[VALID_CASE != "INVALID_CASE"])) # 3 cases - 2 students.  They are both 7th graders in 2014 data, so keep their 2015 8th grade scores
# dups <- New_Jersey_Data_LONG_2015[unique(c(which(duplicated(New_Jersey_Data_LONG_2015))-1, which(duplicated(New_Jersey_Data_LONG_2015)))), ][VALID_CASE != "INVALID_CASE"]
# dups[, gradeLevelWhenAssessed := as.numeric(gradeLevelWhenAssessed)]
# sum(dups$GRADE == dups$gradeLevelWhenAssessed, na.rm = T)
# dups[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
New_Jersey_Data_LONG_2015[intersect(c(which(duplicated(New_Jersey_Data_LONG_2015))-1, which(duplicated(New_Jersey_Data_LONG_2015))), which(GRADE=="7")), VALID_CASE := "INVALID_CASE"]


### Subset new long data and save the results

New_Jersey_Data_LONG_2015 <- New_Jersey_Data_LONG_2015[, c(intersect(names(New_Jersey_SGP@Data), names(New_Jersey_Data_LONG_2015)), "SCALE_SCORE_ACTUAL", "FIRST_NAME", "LAST_NAME"), with=FALSE]
setkeyv(New_Jersey_Data_LONG_2015, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))

save(New_Jersey_Data_LONG_2015, file="Data/New_Jersey_Data_LONG_2015.Rdata")
