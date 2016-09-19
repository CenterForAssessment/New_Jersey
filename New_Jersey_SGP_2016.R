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


####  Custom Analysis Configurations
ELA_2016.config <- list(
	ELA.2016 = list(
		sgp.content.areas=rep('ELA', 7),
		sgp.panel.years=as.character(2009:2016),
		sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('3', '4', '5', '6'), c('3', '4', '5', '6', '7'),
								 c('3', '4', '5', '6', '7', '8'), c('3', '4', '5', '6', '7', '8', '9'))),
	ELA.2016 = list( # Skip Year
		sgp.content.areas=rep('ELA', 7),
		sgp.panel.years=as.character(c(2008:2013, 2016)),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', '10')),
		sgp.exclude.sequences = data.table(VALID_CASE = 'VALID_CASE', CONTENT_AREA='ELA', 
			YEAR='2014', GRADE='8'),
		sgp.projection.grade.sequences="NO_PROJECTIONS"))

MATHEMATICS_2016.config <- list(
	MATHEMATICS.2016 = list(
		sgp.content.areas=rep('MATHEMATICS', 6),
		sgp.panel.years=as.character(2010:2016),
		sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('3', '4', '5', '6'), c('3', '4', '5', '6', '7'), c('3', '4', '5', '6', '7', '8'))),
 	ALGEBRA_I.2016 = list(
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'ALGEBRA_I'),
		sgp.panel.years=as.character(2009:2016),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', 'EOCT'), c('3', '4', '5', '6', '7', '8', 'EOCT')), # c('3', '4', '5', '6', 'EOCT'), # Sing D Mtx
		sgp.projection.grade.sequences=list("NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS")),
	ALGEBRA_I.2016 = list( # Skip Year
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'ALGEBRA_I'),
		sgp.panel.years=as.character(c(2008:2013, 2016)),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
		sgp.exclude.sequences = data.table(VALID_CASE = 'VALID_CASE', CONTENT_AREA='MATHEMATICS', 
			YEAR='2014', GRADE='8'),
		sgp.projection.grade.sequences="NO_PROJECTIONS"),
	# ALGEBRA_II.2016 = list( # Singular design matrix
	# 	sgp.content.areas=c(rep('MATHEMATICS', 6), 'ALGEBRA_II'),
	# 	sgp.panel.years=as.character(2009:2016),
	# 	sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
	# 	sgp.projection.grade.sequences="NO_PROJECTIONS"),
	ALGEBRA_II.2016 = list( # Skip Year
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'ALGEBRA_II'),
		sgp.panel.years=as.character(c(2008:2013, 2016)),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
		sgp.exclude.sequences = data.table(VALID_CASE = 'VALID_CASE', CONTENT_AREA='MATHEMATICS', 
			YEAR='2014', GRADE='8'),
		sgp.projection.grade.sequences="NO_PROJECTIONS"),
	# GEOMETRY.2016 = list( # Singular design matrix
	# 	sgp.content.areas=c(rep('MATHEMATICS', 5), 'GEOMETRY'),
	# 	sgp.panel.years=as.character(2010:2016),
	# 	sgp.grade.sequences=list(c('3', '4', '5', '6', '7', 'EOCT')),
	# 	sgp.projection.grade.sequences="NO_PROJECTIONS"),
	GEOMETRY.2016 = list(
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'GEOMETRY'),
		sgp.panel.years=as.character(2009:2016),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
		sgp.projection.grade.sequences="NO_PROJECTIONS"),
	GEOMETRY.2016 = list( # Skip Year
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'GEOMETRY'),
		sgp.panel.years=as.character(c(2008:2013, 2016)),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
		sgp.exclude.sequences = data.table(VALID_CASE = 'VALID_CASE', CONTENT_AREA='MATHEMATICS', 
			YEAR='2014', GRADE='8'),
		sgp.projection.grade.sequences="NO_PROJECTIONS"))

NJ.config <- c(ELA_2016.config, MATHEMATICS_2016.config)


### updateSGP

New_Jersey_SGP <- updateSGP(
			New_Jersey_SGP, 
			New_Jersey_Data_LONG_2016,
			sgp.config=NJ.config,
			steps = c("analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"), #
			sgp.percentiles.baseline = FALSE,
			sgp.projections.baseline = FALSE,
			sgp.projections.lagged.baseline = FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.target.scale.scores=TRUE,			
			save.intermediate.results=FALSE,
			parallel.config=list(
				BACKEND="PARALLEL", 
				WORKERS=list(
					PERCENTILES=10, PROJECTIONS=8, LAGGED_PROJECTIONS=8,
					SGP_SCALE_SCORE_TARGETS=8,
					SUMMARY=12)))

###  Produce 2016 visualizations

visualizeSGP(
	New_Jersey_SGP,
	sgPlot.content_areas = c("ELA", "MATHEMATICS"),
	gaPlot.content_areas = c("ELA", "MATHEMATICS"),
	sgPlot.demo.report=TRUE,
	parallel.config=list(
				BACKEND='FOREACH', TYPE="doParallel",
				WORKERS=list(GA_PLOTS=12, SG_PLOTS=1)))


### Save results

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")
