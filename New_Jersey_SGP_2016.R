####################################################################
###
### Code to update SGP analyses for New Jersey for 2016
###
####################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load data
load("Data/New_Jersey_Data_LONG_2016.Rdata")
load("Data/New_Jersey_SGP.Rdata")


####  Source Configurations

source("SGP_CONFIG/2016/ELA.R")
source("SGP_CONFIG/2016/MATHEMATICS.R")
NJ.config <- c(ELA_2016.config, MATHEMATICS_2016.config, ALGEBRA_I_2016.config, GEOMETRY_2016.config, ALGEBRA_II_2016.config)


### STEP 1: updateSGP for sgp.percentiles and sgp.percentiles.simex

New_Jersey_SGP <- updateSGP(
					New_Jersey_SGP,
					New_Jersey_Data_LONG_2016,
					state="NJ_ORIGINAL",
					sgp.config=NJ.config,
					steps=c("prepareSGP", "analyzeSGP"),
					sgp.percentiles=TRUE,
					sgp.projections=FALSE,
					sgp.projections.lagged=FALSE,
					sgp.percentiles.baseline=FALSE,
					sgp.projections.baseline=FALSE,
					sgp.projections.lagged.baseline=FALSE,
					calculate.simex=list(lambda=seq(0,2,0.5), simulation.iterations=10, csem.data.vnames="SCALE_SCORE_CSEM", extrapolation="linear", save.matrices=TRUE) else TRUE,
					save.intermediate.results=FALSE,
					parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(TAUS=24, SIMEX=24)))


### STEP 2: analyzeSGP for student growth projections

New_Jersey_SGP <- analyzeSGP(
					New_Jersey_SGP,
					state="NJ_ORIGINAL",
					sgp.config=NJ.config,
					sgp.percentiles=FALSE,
					sgp.projections=TRUE,
					sgp.projections.lagged=TRUE,
					sgp.percentiles.baseline=FALSE,
					sgp.projections.baseline=FALSE,
					sgp.projections.lagged.baseline=FALSE,
					parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(PROJECTIONS=10, LAGGED_PROJECTIONS=10)))


### STEP 3: combineSGP

New_Jersey_SGP <- combineSGP(
					New_Jersey_SGP,
					state="NJ_ORIGINAL",
					sgp.target.scale.scores=TRUE,
					sgp.config=NJ.config,
					parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(SGP_SCALE_SCORE_TARGETS=10)))


### STEP 4: summarizeSGP

New_Jersey_SGP <- summarizeSGP(
					New_Jersey_SGP,
					state="NJ_ORIGINAL",
					parallel.config=list(BACKEND="FOREACH", TYPE="doParallel", SNOW_TEST=TRUE, WORKERS=list(SUMMARY=20)))


### STEP 5: visualizeSGP

visualizeSGP(
	New_Jersey_SGP,
	state="NJ_ORIGINAL",
	sgPlot.content_areas = c("ELA", "MATHEMATICS"),
	gaPlot.content_areas = c("ELA", "MATHEMATICS"),
	sgPlot.demo.report=TRUE,
	parallel.config=list(BACKEND='FOREACH', TYPE="doParallel", WORKERS=list(GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")
