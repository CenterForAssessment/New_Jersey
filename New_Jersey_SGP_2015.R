####################################################################
###
### Code to update SGP analyses for New Jersey for 2015
###
####################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load data

load("Data/New_Jersey_Data_LONG_2015.Rdata")
load("Data/New_Jersey_SGP.Rdata")

####  Source Configurations

source("SGP_CONFIG/2015/ELA.R")
source("SGP_CONFIG/2015/MATHEMATICS.R")
NJ.config <- c(ELA_2015.config, MATHEMATICS_2015.config)


### updateSGP

New_Jersey_SGP <- updateSGP(
			New_Jersey_SGP,
			New_Jersey_Data_LONG_2015,
			sgp.config=NJ.config,
			steps = c("analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"), #
			sgp.percentiles.baseline = FALSE,
			sgp.projections.baseline = FALSE,
			sgp.projections.lagged.baseline = FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.target.scale.scores=TRUE,
			# outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"),
			save.intermediate.results=FALSE,
			parallel.config=list(
				# BACKEND='FOREACH', TYPE="doParallel",
				BACKEND="PARALLEL",
				WORKERS=list(
					PERCENTILES=10, PROJECTIONS=8, LAGGED_PROJECTIONS=8,
					SGP_SCALE_SCORE_TARGETS=8,
					SUMMARY=12)))

###  Produce 2015 visualizations

visualizeSGP(
	New_Jersey_SGP,
	# plot.types="studentGrowthPlot", #c("bubblePlot",
	sgPlot.content_areas = c("ELA", "MATHEMATICS"),
	gaPlot.content_areas = c("ELA", "MATHEMATICS"),
	sgPlot.demo.report=TRUE,
	parallel.config=list(
				BACKEND='FOREACH', TYPE="doParallel",
				WORKERS=list(GA_PLOTS=12, SG_PLOTS=1)))


### Save results

Summary <- New_Jersey_SGP@Summary
New_Jersey_SGP@Summary <- NULL

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")
save(Summary, file="Data/New_Jersey_SGP_Summary_2015.Rdata")
