################################################################################
###
### Create New Jersey Data LONG for 2014
###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load data

New_Jersey_Data_ELA <- fread("Data/Base_Files/NJASK_2013_2014_ELA.csv", colClasses=rep("character", 26))
New_Jersey_Data_MATH <- fread("Data/Base_Files/NJASK_2013_2014_MATH.csv", colClasses=rep("character", 26))


### Combine ELA and MATH

New_Jersey_Data_LONG_2014 <- rbindlist(list(New_Jersey_Data_ELA, New_Jersey_Data_MATH))
setkey(New_Jersey_Data_LONG_2014, esID, SSID)

###  Load in corrected esIDs - 10/9/14

esid <- fread("Data/Missing_SGP_2014.txt", colClasses=rep("character", 3))
setnames(esid, c("esID_1314", "SID_1314"), c("esID", "SSID"))
setkey(esid, esID, SSID)
esid <- esid[!duplicated(esid)] # 2 kids with duplicate rows

New_Jersey_Data_LONG_2014 <- merge(New_Jersey_Data_LONG_2014, esid, all.x=TRUE)
# New_Jersey_Data_LONG_2014[esID==esID_1213] # 11 kids with same esID and esID_1213 -> all have different grade levels
New_Jersey_Data_LONG_2014[which(!is.na(esID_1213)), esID := esID_1213]
New_Jersey_Data_LONG_2014[, esID_1213 := NULL]

### Tidy up data

tmp.variable.names <- c("ID", "Student.ID..SSID.", "YEAR", "Testing.Program", "CONTENT_AREA", "GRADE", "DISTRICT_NUMBER", "School.Code", "County.Name",
	"DISTRICT_NAME", "SCHOOL_NAME", "DFG", "Gender", "Race.Ethnicity.Combined","Title.I.LAL", "Title.I.Math", "Special.Education..SE.", "General.ED", "Former.LEP",
	"Current.LEP", "Time.in.District.Less.Than.1.Year", "Economically.Disadvantaged", "Migrant", "Homeless", "SCALE_SCORE", "ACHIEVEMENT_LEVEL")   
setnames(New_Jersey_Data_LONG_2014, tmp.variable.names)

New_Jersey_Data_LONG_2014[CONTENT_AREA=="Math",CONTENT_AREA:="MATHEMATICS"]

New_Jersey_Data_LONG_2014[,GRADE:=as.character(as.numeric(GRADE))]

New_Jersey_Data_LONG_2014[,County.Name:=as.factor(County.Name)]
setattr(New_Jersey_Data_LONG_2014$County.Name, "levels", sapply(levels(New_Jersey_Data_LONG_2014$County.Name), capwords))

New_Jersey_Data_LONG_2014[,DISTRICT_NAME:=as.factor(DISTRICT_NAME)]
setattr(New_Jersey_Data_LONG_2014$DISTRICT_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2014$DISTRICT_NAME), capwords))

New_Jersey_Data_LONG_2014[,SCHOOL_NAME:=as.factor(SCHOOL_NAME)]
setattr(New_Jersey_Data_LONG_2014$SCHOOL_NAME, "levels", sapply(levels(New_Jersey_Data_LONG_2014$SCHOOL_NAME), capwords))

New_Jersey_Data_LONG_2014[,DFG:=as.factor(DFG)]

New_Jersey_Data_LONG_2014[Gender=="", Gender:=as.character(NA)]
New_Jersey_Data_LONG_2014[,Gender:=as.factor(Gender)]
setattr(New_Jersey_Data_LONG_2014$Gender, "levels", c("Female", "Male"))

New_Jersey_Data_LONG_2014[,Race.Ethnicity.Combined:=as.factor(Race.Ethnicity.Combined)]
setattr(New_Jersey_Data_LONG_2014$Race.Ethnicity.Combined, "levels", c("Asian", "Black", "Hispanic", "Native American", "Other", "Pacific Islander", "White"))

New_Jersey_Data_LONG_2014[,Special.Education..SE.:=as.factor(Special.Education..SE.)]

New_Jersey_Data_LONG_2014[,General.ED:=as.factor(General.ED)]
setattr(New_Jersey_Data_LONG_2014$General.ED, "levels", c("General Education: No", "General Education: Yes"))

New_Jersey_Data_LONG_2014[Current.LEP=="", Current.LEP:=as.character(NA)]
New_Jersey_Data_LONG_2014[,Current.LEP:=factor(Current.LEP)]
setattr(New_Jersey_Data_LONG_2014$Current.LEP, "levels", c("Less than 1 Year", "1 Year", "2 Years", "3 Years", "Yes"))

New_Jersey_Data_LONG_2014[,Time.in.District.Less.Than.1.Year:=factor(Time.in.District.Less.Than.1.Year)]
setattr(New_Jersey_Data_LONG_2014$Time.in.District.Less.Than.1.Year, "levels", c("Time in District Less than 1 Year: No", "Time in District Less than 1 Year: Yes"))

New_Jersey_Data_LONG_2014[,Economically.Disadvantaged:=factor(Economically.Disadvantaged)]
setattr(New_Jersey_Data_LONG_2014$Economically.Disadvantaged, "levels", c("Economically Disadvantaged: Yes", "Economically Disadvantaged: No", "Economically Disadvantaged: Yes"))
New_Jersey_Data_LONG_2014[,Economically.Disadvantaged:=factor(as.character(Economically.Disadvantaged))]

New_Jersey_Data_LONG_2014[,Migrant:=as.factor(Migrant)]
setattr(New_Jersey_Data_LONG_2014$Migrant, "levels", c("Migrant: No", "Migrant: Yes"))

New_Jersey_Data_LONG_2014[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

New_Jersey_Data_LONG_2014[ACHIEVEMENT_LEVEL=="", ACHIEVEMENT_LEVEL:=as.character(NA)]
New_Jersey_Data_LONG_2014[,ACHIEVEMENT_LEVEL:=factor(ACHIEVEMENT_LEVEL, levels=c("Partially Proficient", "Proficient", "Advanced Proficient"), ordered=TRUE)]

New_Jersey_Data_LONG_2014[,Title.I.LAL:=NULL]
New_Jersey_Data_LONG_2014[,Title.I.Math:=NULL]
New_Jersey_Data_LONG_2014[,Homeless:=NULL]
New_Jersey_Data_LONG_2014[,Former.LEP:=NULL]
New_Jersey_Data_LONG_2014[,Testing.Program:=NULL]

New_Jersey_Data_LONG_2014$SCHOOL_NUMBER <- paste(New_Jersey_Data_LONG_2014$DISTRICT_NUMBER, New_Jersey_Data_LONG_2014$School.Code, sep="")

### Indentify Valid Cases

New_Jersey_Data_LONG_2014[,VALID_CASE:="VALID_CASE"]
setkeyv(New_Jersey_Data_LONG_2014, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))

###  Inspect the dublicates first to see what's going on.

dups <- New_Jersey_Data_LONG_2014[unique(New_Jersey_Data_LONG_2014[duplicated(New_Jersey_Data_LONG_2014, by=key(New_Jersey_Data_LONG_2014)), c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"), with=FALSE])]

### Invalidate lowest score for duplicates.

setkeyv(New_Jersey_Data_LONG_2014, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "SCALE_SCORE"))
setkeyv(New_Jersey_Data_LONG_2014, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
New_Jersey_Data_LONG_2014[which(duplicated(New_Jersey_Data_LONG_2014, by=key(New_Jersey_Data_LONG_2014)))-1, VALID_CASE:="INVALID_CASE"]


### ENROLLMENT_STATUS

New_Jersey_Data_LONG_2014[,STATE_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled State: Yes", "Enrolled State: No"))]
New_Jersey_Data_LONG_2014[,DISTRICT_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled District: Yes", "Enrolled District: No"))]
New_Jersey_Data_LONG_2014[,SCHOOL_ENROLLMENT_STATUS:=factor(1, levels=0:1, labels=c("Enrolled School: Yes", "Enrolled School: No"))]

### Save the results

setkeyv(New_Jersey_Data_LONG_2014, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
save(New_Jersey_Data_LONG_2014, file="Data/New_Jersey_Data_LONG_2014.Rdata")
