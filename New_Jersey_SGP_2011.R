####################################################################
###
### Code to update SGP analyses for New Jersey
###
####################################################################

### Load SGP Package

require(SGP)


### Load data

load("../Data/New_Jersey_Data_LONG_2011.Rdata")
load("../Data/Base_Files/New_Jersey_SGP.Rdata")


### Merge files

New_Jersey_SGP@Data <- as.data.table(rbind.fill(as.data.frame(New_Jersey_Data_LONG_2011), as.data.frame(New_Jersey_SGP@Data)))


### prepareSGP

New_Jersey_SGP <- prepareSGP(New_Jersey_SGP)

save(New_Jersey_SGP, file="../Data/New_Jersey_SGP.Rdata")

### analyzeSGP

New_Jersey_SGP <- analyzeSGP(New_Jersey_SGP,
		years=2011,
		simulate.sgps=FALSE)

save(New_Jersey_SGP, file="../Data/New_Jersey_SGP.Rdata")
			

### combineSGP

New_Jersey_SGP <- combineSGP(New_Jersey_SGP, 
			     years=2011)

save(New_Jersey_SGP, file="../Data/New_Jersey_SGP.Rdata")


### summarizeSGP

New_Jersey_SGP <- summarizeSGP(New_Jersey_SGP)

### visualizeSGP

visualizeSGP(New_Jersey_SGP, sgPlot.demo.report=TRUE)
