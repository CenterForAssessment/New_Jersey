################################################################################
###
### Create New Jersey Data LONG for 2015
###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load 2015 raw PARCC data

NJ_ELA <- fread("Data/Base_Files/NJ_PARCC_2014_2015_ELA.csv", sep="|", colClasses=rep("character", 37)) # Stopped reading at empty line 773712 but text exists afterwards (discarded): (773710 row(s) affected)
NJ_MATH<- fread("Data/Base_Files/NJ_PARCC_2014_2015_MATHEMATICS.csv", sep="|", colClasses=rep("character", 37)) # ... (discarded): (745646 row(s) affected)

New_Jersey_Data_LONG_2015 <- rbindlist(list(NJ_ELA, NJ_MATH))

###
###		Tidy up data
###

####  Rename variables
setnames(New_Jersey_Data_LONG_2015, names(New_Jersey_Data_LONG_2015), gsub(" |/", "", names(New_Jersey_Data_LONG_2015)))	

setnames(New_Jersey_Data_LONG_2015, 
				 c("esID", "SSID", "IRTTheta", "SummativeScaleScore", "SummativeCSEM", "Subject", "GradeLevelWhenAssessed", "SummativePerformanceLevel",
				 	"ResponsibleSchoolInstitutionIdentifier", "ResponsibleSchoolInstitutionName", "ResponsibleDistrictIdentifier", "ResponsibleDistrictName", "ResponsibleCountyName",
				 	"SpecialEducationClassification", "TitleIIILimitedEnglishProficientParticipationStatus", "EconomicallyDisadvantaged"),
				 c("ID", "Student.ID..SSID.", "SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM", "CONTENT_AREA", "GRADE", "ACHIEVEMENT_LEVEL",
				 	"SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME", "County.Name",
				 	"Special.Education..SE.", "Current.LEP", "Economically.Disadvantaged"))

####  YEAR
New_Jersey_Data_LONG_2015[, YEAR := '2015']
New_Jersey_Data_LONG_2015[, 1 := NULL] # "AssessmentYear" -- doesn't work with name for some reason (?!?)

####  CONTENT_AREA / "subject"
New_Jersey_Data_LONG_2015[, CONTENT_AREA := toupper(gsub(" ", "_", CONTENT_AREA))]
New_Jersey_Data_LONG_2015[which(CONTENT_AREA == "ENGLISH_LANGUAGE_ARTS/LITERACY"), CONTENT_AREA := "ELA"]

#### GRADE
New_Jersey_Data_LONG_2015[, GRADE := as.character(as.numeric(GRADE))]
New_Jersey_Data_LONG_2015[which(!CONTENT_AREA %in% c("ELA", "MATHEMATICS")), GRADE := "EOCT"]

####  ACH LEVEL / "Summative Performance Level"
New_Jersey_Data_LONG_2015[, ACHIEVEMENT_LEVEL := paste("Level", ACHIEVEMENT_LEVEL)]

####  Demographic Variables
New_Jersey_Data_LONG_2015[, Race.Ethnicity.Combined := as.character(NA)] 
New_Jersey_Data_LONG_2015[which(HispanicorLatinoEthnicity=="Y"), Race.Ethnicity.Combined := "Hispanic"] 
New_Jersey_Data_LONG_2015[which(AmericanIndianorAlaskaNative=="Y"), Race.Ethnicity.Combined := "Native American"] 
New_Jersey_Data_LONG_2015[which(Asian=="Y"), Race.Ethnicity.Combined := "Asian"] 
New_Jersey_Data_LONG_2015[which(BlackorAfricanAmerican=="Y"), Race.Ethnicity.Combined := "Black"] 
New_Jersey_Data_LONG_2015[which(NativeHawaiianorOtherPacificIslander=="Y"), Race.Ethnicity.Combined := "Pacific Islander"] 
New_Jersey_Data_LONG_2015[which(White=="Y"), Race.Ethnicity.Combined := "White"] 
New_Jersey_Data_LONG_2015[which(TwoorMoreRaces=="Y"), Race.Ethnicity.Combined := "Two or More Races"] 
New_Jersey_Data_LONG_2015[which(is.na(Race.Ethnicity.Combined)), Race.Ethnicity.Combined := "Other"] 

New_Jersey_Data_LONG_2015[, 
		c("HispanicorLatinoEthnicity", "AmericanIndianorAlaskaNative", "Asian", "BlackorAfricanAmerican", "NativeHawaiianorOtherPacificIslander", "White", "TwoorMoreRaces") := NULL]

New_Jersey_Data_LONG_2015[,Gender:=as.factor(Gender)]
setattr(New_Jersey_Data_LONG_2015$Gender, "levels", c("Female", "Male"))

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

####  District and School ID and Names
New_Jersey_Data_LONG_2015[,DISTRICT_NAME:=as.factor(DISTRICT_NAME)]
setattr(New_Jersey_Data_LONG_2015$DISTRICT_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2015$DISTRICT_NAME), capwords))

New_Jersey_Data_LONG_2015[,SCHOOL_NAME:=as.factor(SCHOOL_NAME)]
setattr(New_Jersey_Data_LONG_2015$SCHOOL_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2015$SCHOOL_NAME), capwords))


### ENROLLMENT_STATUS
New_Jersey_Data_LONG_2015[,STATE_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
New_Jersey_Data_LONG_2015[,DISTRICT_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
New_Jersey_Data_LONG_2015[,SCHOOL_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled School: No", "Enrolled School: Yes"))]


####  Set SCALE_SCORE to numeric and only include non-NA scores in long data
New_Jersey_Data_LONG_2015[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
New_Jersey_Data_LONG_2015[,SCALE_SCORE_ACTUAL:=as.numeric(SCALE_SCORE_ACTUAL)]
New_Jersey_Data_LONG_2015 <- New_Jersey_Data_LONG_2015[!is.na(SCALE_SCORE)]

###
###		Indentify Valid Cases
###

New_Jersey_Data_LONG_2015[, VALID_CASE := "VALID_CASE"]

####  Invalidate Cases with missing IDs - Not and issue with esIDs
# New_Jersey_Data_LONG_2015[which(ID==""), VALID_CASE := "INVALID_CASE"]

setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, GRADE, ID)
# sum(duplicated(New_Jersey_Data_LONG_2015[VALID_CASE != "INVALID_CASE"])) # 16 duplicates with valid SSIDs -- all have same SSID and esID, so appear valid - take the highest score
# dups <- data.table(New_Jersey_Data_LONG_2015[unique(c(which(duplicated(New_Jersey_Data_LONG_2015))-1, which(duplicated(New_Jersey_Data_LONG_2015)))), ], key=key(New_Jersey_Data_LONG_2015))
setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, GRADE, ID)
New_Jersey_Data_LONG_2015[which(duplicated(New_Jersey_Data_LONG_2015))-1, VALID_CASE := "INVALID_CASE"]


#  Still 5 kids with duplicates if Grade ignored -- take highest score and hope for the best ...
setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, ID, SCALE_SCORE)
setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, ID)
New_Jersey_Data_LONG_2015[which(duplicated(New_Jersey_Data_LONG_2015))-1, VALID_CASE := "INVALID_CASE"]


### Subset new long data and save the results -- only keep variables already included in New_Jersey_SGP@Data

load("Data/New_Jersey_SGP.Rdata")

New_Jersey_Data_LONG_2015 <- New_Jersey_Data_LONG_2015[, c(intersect(names(New_Jersey_SGP@Data), names(New_Jersey_Data_LONG_2015)), "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM"), with=FALSE]
setkeyv(New_Jersey_Data_LONG_2015, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))

save(New_Jersey_Data_LONG_2015, file="Data/New_Jersey_Data_LONG_2015.Rdata")
