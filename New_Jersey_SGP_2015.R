####################################################################
###
### Code to update SGP analyses for New Jersey for 2015
###
####################################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/New_Jersey_Data_LONG_2015.Rdata")
load("Data/New_Jersey_SGP.Rdata")

### updateSGP

New_Jersey_SGP <- updateSGP(
			New_Jersey_SGP, 
			New_Jersey_Data_LONG_2015,
			steps = c("analyzeSGP", "combineSGP", "summarizeSGP", "visualizeSGP", "outputSGP"),
			content_areas = c("ELA", "MATHEMATICS"),
			grades=3:8,
			sgp.percentiles.baseline = FALSE,
			sgp.projections.baseline = FALSE,
			sgp.projections.lagged.baseline = FALSE,
			save.intermediate.results=FALSE, 
			goodness.of.fit.print=FALSE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10, BASELINE_PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=10, SUMMARY=10, GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")
