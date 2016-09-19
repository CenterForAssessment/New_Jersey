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
NJ.config <- c(ELA_2016.config, MATHEMATICS_2016.config)


### updateSGP

New_Jersey_SGP <- updateSGP(
			New_Jersey_SGP,
			New_Jersey_Data_LONG_2016,
			state="NJ_ORIGINAL",
			sgp.config=NJ.config,
			steps = c("analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"), #
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.target.scale.scores=TRUE,
			save.intermediate.results=FALSE,
			parallel.config=list(
				BACKEND="PARALLEL",
				WORKERS=list(
					PERCENTILES=5, PROJECTIONS=3, LAGGED_PROJECTIONS=3,
					SGP_SCALE_SCORE_TARGETS=3,
					SUMMARY=3)))

###  Produce 2016 visualizations

visualizeSGP(
	New_Jersey_SGP,
	sgPlot.content_areas = c("ELA", "MATHEMATICS"),
	gaPlot.content_areas = c("ELA", "MATHEMATICS"),
	sgPlot.demo.report=TRUE,
	parallel.config=list(
				BACKEND='FOREACH', TYPE="doParallel",
				WORKERS=list(GA_PLOTS=4, SG_PLOTS=1)))


### Save results

#save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")
