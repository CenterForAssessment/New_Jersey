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

### updateSGP

####  Custom Analysis Configurations
ELA_2015.config <- list(
	ELA.2015 = list(
		sgp.content.areas=rep('ELA', 6),
		sgp.panel.years=as.character(2010:2015),
		sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('3', '4', '5', '6'), c('3', '4', '5', '6', '7'), c('3', '4', '5', '6', '7', '8'))))

MATHEMATICS_2015.config <- list(
	MATHEMATICS.2015 = list(
		sgp.content.areas=rep('MATHEMATICS', 6),
		sgp.panel.years=as.character(2010:2015),
		sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('3', '4', '5', '6'), c('3', '4', '5', '6', '7'), c('3', '4', '5', '6', '7', '8'))),
    ALGEBRA_I.2015 = list(
		sgp.content.areas=c(rep('MATHEMATICS', 5), 'ALGEBRA_I'),
		sgp.panel.years=as.character(2010:2015),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8')), # MAY NEED TO CHANGE GRADE LEVEL BACK TO EOCT ???
		sgp.projection.grade.sequences="NO_PROJECTIONS"))

NJ.config <- c(ELA_2015.config, MATHEMATICS_2015.config)

New_Jersey_SGP <- updateSGP(
			New_Jersey_SGP, 
			New_Jersey_Data_LONG_2015,
			sgp.config=NJ.config,
			steps = c("analyzeSGP", "combineSGP", "summarizeSGP", "visualizeSGP"), #, "outputSGP"
			sgp.percentiles.baseline = FALSE,
			sgp.projections.baseline = FALSE,
			sgp.projections.lagged.baseline = FALSE,
			save.intermediate.results=FALSE,
			sgp.target.scale.scores=TRUE,			
			goodness.of.fit.print=FALSE,
			parallel.config=list(
				BACKEND="PARALLEL", 
				WORKERS=list(
					PERCENTILES=20, PROJECTIONS=20, LAGGED_PROJECTIONS=20, 
					SGP_SCALE_SCORE_TARGETS=20, 
					SUMMARY=20, 
					GA_PLOTS=20, SG_PLOTS=1)))


### Save results

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")
