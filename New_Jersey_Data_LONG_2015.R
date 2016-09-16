################################################################################
###
### Create New Jersey Data LONG for 2015
###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load 2015 raw PARCC data

NJ_ELA <- fread("Data/Base_Files/PARCC Data Extract for NCIEA 14-15 SY_ELA_count=773710_repull.csv", sep="|", colClasses=rep("character", 37)) # Stopped reading at empty line 773712 but text exists afterwards (discarded): (773710 row(s) affected)
NJ_MATH<- fread("Data/Base_Files/PARCC Data Extract for NCIEA 14-15 SY_Math related_count=745646_repull.csv", sep="|", colClasses=rep("character", 37)) # ... (discarded): (745646 row(s) affected)

New_Jersey_Data_LONG_2015 <- rbindlist(list(NJ_ELA, NJ_MATH))

###
###		Tidy up data
###

####  Rename variables
setnames(New_Jersey_Data_LONG_2015, names(New_Jersey_Data_LONG_2015), gsub(" |/", "", names(New_Jersey_Data_LONG_2015)))	

setnames(New_Jersey_Data_LONG_2015, 
				 c("SSID", "IRTTheta", "SummativeScaleScore", "SummativeCSEM", "Subject", "GradeLevelWhenAssessed", "SummativePerformanceLevel",
				 	"ResponsibleSchoolInstitutionIdentifier", "ResponsibleSchoolInstitutionName", "ResponsibleDistrictIdentifier", "ResponsibleDistrictName", "ResponsibleCountyName",
				 	"SpecialEducationClassification", "TitleIIILimitedEnglishProficientParticipationStatus", "EconomicallyDisadvantaged"),
				 c("ID", "SCALE_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM", "CONTENT_AREA", "GRADE", "ACHIEVEMENT_LEVEL",
				 	"SCHOOL_NUMBER", "SCHOOL_NAME", "DISTRICT_NUMBER", "DISTRICT_NAME", "County_Name",
				 	"Special_Education__SE_", "Current_LEP", "Economically_Disadvantaged"))

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
New_Jersey_Data_LONG_2015[, Race_Ethnicity_Combined := as.character(NA)] 
New_Jersey_Data_LONG_2015[which(HispanicorLatinoEthnicity=="Y"), Race_Ethnicity_Combined := "Hispanic"] 
New_Jersey_Data_LONG_2015[which(AmericanIndianorAlaskaNative=="Y"), Race_Ethnicity_Combined := "Native American"] 
New_Jersey_Data_LONG_2015[which(Asian=="Y"), Race_Ethnicity_Combined := "Asian"] 
New_Jersey_Data_LONG_2015[which(BlackorAfricanAmerican=="Y"), Race_Ethnicity_Combined := "Black"] 
New_Jersey_Data_LONG_2015[which(NativeHawaiianorOtherPacificIslander=="Y"), Race_Ethnicity_Combined := "Pacific Islander"] 
New_Jersey_Data_LONG_2015[which(White=="Y"), Race_Ethnicity_Combined := "White"] 
New_Jersey_Data_LONG_2015[which(TwoorMoreRaces=="Y"), Race_Ethnicity_Combined := "Two or More Races"] 
New_Jersey_Data_LONG_2015[which(is.na(Race_Ethnicity_Combined)), Race_Ethnicity_Combined := "Other"] 

New_Jersey_Data_LONG_2015[, 
		c("HispanicorLatinoEthnicity", "AmericanIndianorAlaskaNative", "Asian", "BlackorAfricanAmerican", "NativeHawaiianorOtherPacificIslander", "White", "TwoorMoreRaces") := NULL]

New_Jersey_Data_LONG_2015[,Gender:=as.factor(Gender)]
setattr(New_Jersey_Data_LONG_2015$Gender, "levels", c("Female", "Male"))

New_Jersey_Data_LONG_2015[Special_Education__SE_ == "", Special_Education__SE_ := as.character(NA)]

New_Jersey_Data_LONG_2015[Current_LEP == "", Current_LEP := as.character(NA)]
New_Jersey_Data_LONG_2015[,Current_LEP:=factor(Current_LEP)]
setattr(New_Jersey_Data_LONG_2015$Current_LEP, "levels", c("No", "Yes"))
New_Jersey_Data_LONG_2015[,Current_LEP:=as.character(Current_LEP)]

New_Jersey_Data_LONG_2015[Economically_Disadvantaged=="", Economically_Disadvantaged:=as.character(NA)]
New_Jersey_Data_LONG_2015[,Economically_Disadvantaged:=factor(Economically_Disadvantaged)]
setattr(New_Jersey_Data_LONG_2015$Economically_Disadvantaged, "levels", c("Economically Disadvantaged: No", "Economically Disadvantaged: Yes"))
New_Jersey_Data_LONG_2015[,Economically_Disadvantaged:=as.character(Economically_Disadvantaged)]

New_Jersey_Data_LONG_2015[Migrant == "", Migrant := as.character(NA)]
New_Jersey_Data_LONG_2015[,Migrant:=factor(Migrant)]
setattr(New_Jersey_Data_LONG_2015$Migrant, "levels", c("Migrant: No", "Migrant: Yes"))
New_Jersey_Data_LONG_2015[,Migrant:=as.character(Migrant)]

####  District and School Names
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
New_Jersey_Data_LONG_2015[,SCALE_SCORE_CSEM:=as.numeric(SCALE_SCORE_CSEM)]
New_Jersey_Data_LONG_2015 <- New_Jersey_Data_LONG_2015[!is.na(SCALE_SCORE)]

###
###		Indentify Valid Cases
###

New_Jersey_Data_LONG_2015[, VALID_CASE := "VALID_CASE"]

###  Invalidate Cases with missing IDs - Not and issue with esIDs
New_Jersey_Data_LONG_2015[which(ID==""), VALID_CASE := "INVALID_CASE"]

###  Invalidate Grades not used:
New_Jersey_Data_LONG_2015[which(GRADE %in% c(NA,1,2,12)), VALID_CASE := "INVALID_CASE"] #  11th grade ELA not used, but leave it Valid just in case.
New_Jersey_Data_LONG_2015[which(GRADE %in% 9:11 & CONTENT_AREA == "MATHEMATICS"), VALID_CASE := "INVALID_CASE"]

###  Invalidate Content Areas with too few students to analyze
New_Jersey_Data_LONG_2015[which(CONTENT_AREA %in% c("INTEGRATED_MATHEMATICS_I", "INTEGRATED_MATHEMATICS_II", "INTEGRATED_MATHEMATICS_III")), VALID_CASE := "INVALID_CASE"]

setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, GRADE, ID, SCALE_SCORE)
setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, GRADE, ID)
# sum(duplicated(New_Jersey_Data_LONG_2015[VALID_CASE != "INVALID_CASE"], by=key(New_Jersey_Data_LONG_2015))) # 10 duplicates with valid SSIDs -- all have same SSID and esID, so appear valid - take the highest score
# dups <- data.table(New_Jersey_Data_LONG_2015[unique(c(which(duplicated(New_Jersey_Data_LONG_2015, by=key(New_Jsersey_Data_LONG_2015)))-1, which(duplicated(New_Jersey_Data_LONG_2015)))), ], key=key(New_Jersey_Data_LONG_2015))
New_Jersey_Data_LONG_2015[which(duplicated(New_Jersey_Data_LONG_2015, by=key(New_Jersey_Data_LONG_2015)))-1, VALID_CASE := "INVALID_CASE"]


#  Still 3 kids with duplicates if Grade ignored -- take highest score again ...
setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, ID, SCALE_SCORE)
setkey(New_Jersey_Data_LONG_2015, VALID_CASE, CONTENT_AREA, ID)
New_Jersey_Data_LONG_2015[which(duplicated(New_Jersey_Data_LONG_2015, by=key(New_Jersey_Data_LONG_2015)))-1, VALID_CASE := "INVALID_CASE"]

### Subset new long data and save the results -- only keep variables already included in New_Jersey_SGP@Data

load("Data/New_Jersey_SGP.Rdata")

setnames(New_Jersey_SGP@Data, gsub("[.]", "_", names(New_Jersey_SGP@Data)))

New_Jersey_Data_LONG_2015 <- New_Jersey_Data_LONG_2015[, c(intersect(names(New_Jersey_SGP@Data), names(New_Jersey_Data_LONG_2015)), "esID", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM"), with=FALSE]
setkeyv(New_Jersey_Data_LONG_2015, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))

save(New_Jersey_Data_LONG_2015, file="Data/New_Jersey_Data_LONG_2015.Rdata")


###
###		Clean and prep 2014 New Jersey SGP object using SSID as ID
###

###  Set Data Names and @Names to new convention
New_Jersey_SGP@Names <-  read.csv("/media/Data/Dropbox/Github_Repos/Packages/SGPstateData/variable_name_lookup/NJ_Variable_Name_Lookup.csv", colClasses=c(rep("character",4), "logical"))
SGPstateData[["NJ"]][["Variable_Name_Lookup"]] <- read.csv("/media/Data/Dropbox/Github_Repos/Packages/SGPstateData/variable_name_lookup/NJ_Variable_Name_Lookup.csv", colClasses=c(rep("character",4), "logical"))

setnames(New_Jersey_SGP@Data, gsub("[.]", "_", names(New_Jersey_SGP@Data)))

###  Switch ID and 

id.lookup <- unique(New_Jersey_Data_LONG_2015[, list(ID, esID, YEAR, VALID_CASE)])[!is.na(esID) & ID != "" & VALID_CASE=="VALID_CASE"]
id.lookup <- id.lookup[, list(ID, esID)]
setnames(id.lookup, c("ID", "esID"), c("SSID", "ID"))
setkey(New_Jersey_SGP@Data, ID)
setkey(id.lookup, ID)
New_Jersey_SGP@Data <- id.lookup[New_Jersey_SGP@Data]

table(is.na(New_Jersey_SGP@Data$Student_ID__SSID_), New_Jersey_SGP@Data$YEAR)
New_Jersey_SGP@Data[which(is.na(Student_ID__SSID_)), Student_ID__SSID_ := SSID]
New_Jersey_SGP@Data[, SSID := NULL]
table(is.na(New_Jersey_SGP@Data$Student_ID__SSID_), New_Jersey_SGP@Data$YEAR)

setnames(New_Jersey_SGP@Data, c("Student_ID__SSID_", "ID"), c("ID", "esID"))

###  Invalidate NA SSIDs and duplicates
New_Jersey_SGP@Data[which(is.na(ID)), VALID_CASE := "INVALID_CASE"]
New_Jersey_SGP@Data[which(ID=="NULL"), VALID_CASE := "INVALID_CASE"]

#  All duplicates (4 and 12 respectively below) are from 2013 and have different esID values.  Different kids?
setkey(New_Jersey_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID, SCALE_SCORE)
setkey(New_Jersey_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
# sum(duplicated(New_Jersey_SGP@Data["VALID_CASE"]))
# dups <- data.table(New_Jersey_SGP@Data[unique(c(which(duplicated(New_Jersey_SGP@Data))-1, which(duplicated(New_Jersey_SGP@Data)))), ], key=key(New_Jersey_SGP@Data))
New_Jersey_SGP@Data[which(duplicated(New_Jersey_SGP@Data))-1, VALID_CASE := "INVALID_CASE"]

setkey(New_Jersey_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID, SCALE_SCORE)
setkey(New_Jersey_SGP@Data, VALID_CASE, CONTENT_AREA, YEAR, ID)
New_Jersey_SGP@Data[which(duplicated(New_Jersey_SGP@Data))-1, VALID_CASE := "INVALID_CASE"]

setkeyv(New_Jersey_SGP@Data, SGP:::getKey(New_Jersey_SGP))



save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")
