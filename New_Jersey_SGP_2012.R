####################################################################
###
### Code to update SGP analyses for New Jersey
###
####################################################################

### Load SGP Package

require(SGP)
options(error=recover)

### Load data

load("Data/New_Jersey_Data_LONG_2012.Rdata")
load("Data/Base_Files/New_Jersey_SGP.Rdata")


### Merge files

New_Jersey_SGP@Data <- as.data.table(rbind.fill(New_Jersey_Data_LONG_2012, New_Jersey_SGP@Data))


### prepareSGP

New_Jersey_SGP <- prepareSGP(New_Jersey_SGP)
save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")


### analyzeSGP

New_Jersey_SGP <- analyzeSGP(
		New_Jersey_SGP,
		years=2012,
		sgp.percentiles=TRUE,
		sgp.projections=TRUE,
		sgp.projections.lagged=TRUE,
		sgp.percentiles.baseline=TRUE,
		sgp.projections.baseline=TRUE,
		sgp.projections.lagged.baseline=TRUE,
		simulate.sgps=FALSE,
		parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=15, BASELINE_PERCENTILES=30, PROJECTIONS=10, LAGGED_PROJECTIONS=8, SUMMARY=30, GA_PLOTS=10, SG_PLOTS=1)))

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")

			
### combineSGP

New_Jersey_SGP <- combineSGP(New_Jersey_SGP)

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")


### summarizeSGP

New_Jersey_SGP <- summarizeSGP(New_Jersey_SGP, parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=10)))

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")

### visualizeSGP

visualizeSGP(New_Jersey_SGP, sgPlot.demo.report=TRUE)
