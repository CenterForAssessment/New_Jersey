################################################################################
###                                                                          ###
###  SGP Configurations code for New Jersey 2015 Grade Level ELA             ###
###                                                                          ###
################################################################################

ELA_2015.config <- list(
	ELA.2015 = list(
		sgp.content.areas=rep('ELA', 7),
		sgp.panel.years=as.character(2009:2015),
		sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('3', '4', '5', '6'), c('3', '4', '5', '6', '7'),
								 c('3', '4', '5', '6', '7', '8'), c('3', '4', '5', '6', '7', '8', '9'))),
	ELA.2015 = list( # Skip Year
		sgp.content.areas=rep('ELA', 7),
		sgp.panel.years=as.character(c(2008:2013, 2015)),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', '10')),
		sgp.exclude.sequences = data.table(VALID_CASE = 'VALID_CASE', CONTENT_AREA='ELA',
			YEAR='2014', GRADE='8'),
		sgp.projection.grade.sequences="NO_PROJECTIONS"
	)
)
