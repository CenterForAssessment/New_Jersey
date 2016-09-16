################################################################################
###
### Create New Jersey Data LONG for 2016
###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load 2016 raw PARCC data

NJ_ELA <- fread("Data/Base_Files/PARCC Data Extract for NCIEA 15-16 SY_ELA_count=832735.csv", sep="|", colClasses=rep("character", 37))
NJ_MATH<- fread("Data/Base_Files/PARCC Data Extract for NCIEA 15-16 SY_Math related_count=811079.csv", sep="|", colClasses=rep("character", 37))

New_Jersey_Data_LONG_2016 <- rbindlist(list(NJ_ELA, NJ_MATH))

###
###		Tidy up data
###

####  Rename variables

setnames(New_Jersey_Data_LONG_2016, names(New_Jersey_Data_LONG_2016), gsub(" |/", "", names(New_Jersey_Data_LONG_2016)))

setnames(New_Jersey_Data_LONG_2016,
				 c("SSID", "IRTTheta", "TestScaleScore", "TestCSEMProbableRange", "Subject", "GradeLevelWhenAssessed", "TestPerformanceLevel",
				 	"ResponsibleSchoolCode", "ResponsibleSchoolName", "ResponsibleDistrictCode", "ResponsibleDistrictName", "ResponsibleCountyName",
				 	"SpecialEducationClassification", "TitleIIILimitedEnglishProficientParticipationStatus", "EconomicallyDisadvantaged"),
				 c("ID", "SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM", "CONTENT_AREA", "GRADE", "ACHIEVEMENT_LEVEL",
				 	"SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME", "County_Name",
				 	"Special_Education__SE_", "Current_LEP", "Economically_Disadvantaged"))


##  YEAR

New_Jersey_Data_LONG_2016[, YEAR := '2016']
New_Jersey_Data_LONG_2016[, 1 := NULL] # "AssessmentYear" -- doesn't work with name for some reason (?!?)

##  CONTENT_AREA / "subject"

New_Jersey_Data_LONG_2016[, CONTENT_AREA := toupper(gsub(" ", "_", CONTENT_AREA))]
New_Jersey_Data_LONG_2016[which(CONTENT_AREA == "ENGLISH_LANGUAGE_ARTS/LITERACY"), CONTENT_AREA := "ELA"]

#### GRADE

New_Jersey_Data_LONG_2016[, GRADE := as.character(as.numeric(GRADE))]
New_Jersey_Data_LONG_2016[which(!CONTENT_AREA %in% c("ELA", "MATHEMATICS")), GRADE := "EOCT"]

####  ACH LEVEL / "Summative Performance Level"

New_Jersey_Data_LONG_2016[, ACHIEVEMENT_LEVEL := paste("Level", ACHIEVEMENT_LEVEL)]

####  Demographic Variables

New_Jersey_Data_LONG_2016[, Race_Ethnicity_Combined := as.character(NA)]
New_Jersey_Data_LONG_2016[which(HispanicorLatinoEthnicity=="Y"), Race_Ethnicity_Combined := "Hispanic"]
New_Jersey_Data_LONG_2016[which(AmericanIndianorAlaskaNative=="Y"), Race_Ethnicity_Combined := "Native American"]
New_Jersey_Data_LONG_2016[which(Asian=="Y"), Race_Ethnicity_Combined := "Asian"]
New_Jersey_Data_LONG_2016[which(BlackorAfricanAmerican=="Y"), Race_Ethnicity_Combined := "Black"]
New_Jersey_Data_LONG_2016[which(NativeHawaiianorOtherPacificIslander=="Y"), Race_Ethnicity_Combined := "Pacific Islander"]
New_Jersey_Data_LONG_2016[which(White=="Y"), Race_Ethnicity_Combined := "White"]
New_Jersey_Data_LONG_2016[which(TwoorMoreRaces=="Y"), Race_Ethnicity_Combined := "Two or More Races"]
New_Jersey_Data_LONG_2016[which(is.na(Race_Ethnicity_Combined)), Race_Ethnicity_Combined := "Other"]

New_Jersey_Data_LONG_2016[,
		c("HispanicorLatinoEthnicity", "AmericanIndianorAlaskaNative", "Asian", "BlackorAfricanAmerican", "NativeHawaiianorOtherPacificIslander", "White", "TwoorMoreRaces") := NULL]

New_Jersey_Data_LONG_2016[,Gender:=as.factor(Gender)]
setattr(New_Jersey_Data_LONG_2016$Gender, "levels", c("Female", "Male"))

New_Jersey_Data_LONG_2016[Special_Education__SE_ == "", Special_Education__SE_ := as.character(NA)]

New_Jersey_Data_LONG_2016[Current_LEP == "", Current_LEP := as.character(NA)]
New_Jersey_Data_LONG_2016[,Current_LEP:=factor(Current_LEP)]
setattr(New_Jersey_Data_LONG_2016$Current_LEP, "levels", c("No", "Yes"))
New_Jersey_Data_LONG_2016[,Current_LEP:=as.character(Current_LEP)]

New_Jersey_Data_LONG_2016[Economically_Disadvantaged=="", Economically_Disadvantaged:=as.character(NA)]
New_Jersey_Data_LONG_2016[,Economically_Disadvantaged:=factor(Economically_Disadvantaged)]
setattr(New_Jersey_Data_LONG_2016$Economically_Disadvantaged, "levels", c("Economically Disadvantaged: No", "Economically Disadvantaged: Yes"))
New_Jersey_Data_LONG_2016[,Economically_Disadvantaged:=as.character(Economically_Disadvantaged)]

New_Jersey_Data_LONG_2016[Migrant == "", Migrant := as.character(NA)]
New_Jersey_Data_LONG_2016[,Migrant:=factor(Migrant)]
setattr(New_Jersey_Data_LONG_2016$Migrant, "levels", c("Migrant: No", "Migrant: Yes"))
New_Jersey_Data_LONG_2016[,Migrant:=as.character(Migrant)]

##  District and School Names

New_Jersey_Data_LONG_2016[,DISTRICT_NAME:=as.factor(DISTRICT_NAME)]
setattr(New_Jersey_Data_LONG_2016$DISTRICT_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2016$DISTRICT_NAME), capwords))

New_Jersey_Data_LONG_2016[,SCHOOL_NAME:=as.factor(SCHOOL_NAME)]
setattr(New_Jersey_Data_LONG_2016$SCHOOL_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2016$SCHOOL_NAME), capwords))

## ENROLLMENT_STATUS

New_Jersey_Data_LONG_2016[,STATE_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))]
New_Jersey_Data_LONG_2016[,DISTRICT_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled District: No", "Enrolled District: Yes"))]
New_Jersey_Data_LONG_2016[,SCHOOL_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled School: No", "Enrolled School: Yes"))]

####  Set SCALE_SCORE to numeric and only include non-NA scores in long data

New_Jersey_Data_LONG_2016[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
New_Jersey_Data_LONG_2016[,SCALE_SCORE_ACTUAL:=as.numeric(SCALE_SCORE_ACTUAL)]
New_Jersey_Data_LONG_2016[,SCALE_SCORE_CSEM:=as.numeric(SCALE_SCORE_CSEM)]

###
###		Indentify Valid Cases
###

New_Jersey_Data_LONG_2016[, VALID_CASE := "VALID_CASE"]

###  Invalidate Cases with missing IDs - Not and issue with esIDs

New_Jersey_Data_LONG_2016[which(ID==""), VALID_CASE := "INVALID_CASE"]

###  Invalidate Grades not used:

New_Jersey_Data_LONG_2016[!GRADE %in% 3:11 & CONTENT_AREA=="ELA", VALID_CASE := "INVALID_CASE"]
New_Jersey_Data_LONG_2016[!GRADE %in% 3:8 & CONTENT_AREA == "MATHEMATICS", VALID_CASE := "INVALID_CASE"]

###  Invalidate Content Areas with too few students to analyze

New_Jersey_Data_LONG_2016[which(CONTENT_AREA %in% c("INTEGRATED_MATHEMATICS_I", "INTEGRATED_MATHEMATICS_II", "INTEGRATED_MATHEMATICS_III")), VALID_CASE := "INVALID_CASE"]

setkey(New_Jersey_Data_LONG_2016, VALID_CASE, CONTENT_AREA, ID, GRADE, SCALE_SCORE)
setkey(New_Jersey_Data_LONG_2016, VALID_CASE, CONTENT_AREA, ID)
New_Jersey_Data_LONG_2016[which(duplicated(New_Jersey_Data_LONG_2016, by=key(New_Jersey_Data_LONG_2016)))-1, VALID_CASE := "INVALID_CASE"]


### Save results

save(New_Jersey_Data_LONG_2016, file="Data/New_Jersey_Data_LONG_2016.Rdata")
