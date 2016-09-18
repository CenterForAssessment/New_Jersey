#####################################################################################
###                                                                               ###
###      SGP Configurations for 2015 Grade Level and EOCT Math subjects           ###
###                                                                               ###
#####################################################################################

MATHEMATICS_2015.config <- list(
	MATHEMATICS.2015 = list(
		sgp.content.areas=rep('MATHEMATICS', 6),
		sgp.panel.years=as.character(2010:2015),
		sgp.grade.sequences=list(c('3', '4'), c('3', '4', '5'), c('3', '4', '5', '6'), c('3', '4', '5', '6', '7'), c('3', '4', '5', '6', '7', '8'))),
 	ALGEBRA_I.2015 = list(
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'ALGEBRA_I'),
		sgp.panel.years=as.character(2009:2015),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', 'EOCT'), c('3', '4', '5', '6', '7', '8', 'EOCT')), # c('3', '4', '5', '6', 'EOCT'), # Sing D Mtx
		sgp.projection.grade.sequences=list("NO_PROJECTIONS", "NO_PROJECTIONS", "NO_PROJECTIONS")),
	ALGEBRA_I.2015 = list( # Skip Year
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'ALGEBRA_I'),
		sgp.panel.years=as.character(c(2008:2013, 2015)),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
		sgp.exclude.sequences = data.table(VALID_CASE = 'VALID_CASE', CONTENT_AREA='MATHEMATICS',
			YEAR='2014', GRADE='8'),
		sgp.projection.grade.sequences="NO_PROJECTIONS"),
#	 ALGEBRA_II.2015 = list( # Singular design matrix
# 		sgp.content.areas=c(rep('MATHEMATICS', 6), 'ALGEBRA_II'),
# 		sgp.panel.years=as.character(2009:2015),
# 		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
# 		sgp.projection.grade.sequences="NO_PROJECTIONS"),
	ALGEBRA_II.2015 = list( # Skip Year
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'ALGEBRA_II'),
		sgp.panel.years=as.character(c(2008:2013, 2015)),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
		sgp.exclude.sequences = data.table(VALID_CASE = 'VALID_CASE', CONTENT_AREA='MATHEMATICS',
			YEAR='2014', GRADE='8'),
		sgp.projection.grade.sequences="NO_PROJECTIONS"),
# 	GEOMETRY.2015 = list( # Singular design matrix
# 		sgp.content.areas=c(rep('MATHEMATICS', 5), 'GEOMETRY'),
# 		sgp.panel.years=as.character(2010:2015),
# 		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', 'EOCT')),
# 		sgp.projection.grade.sequences="NO_PROJECTIONS"),
	GEOMETRY.2015 = list(
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'GEOMETRY'),
		sgp.panel.years=as.character(2009:2015),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
		sgp.projection.grade.sequences="NO_PROJECTIONS"),
	GEOMETRY.2015 = list( # Skip Year
		sgp.content.areas=c(rep('MATHEMATICS', 6), 'GEOMETRY'),
		sgp.panel.years=as.character(c(2008:2013, 2015)),
		sgp.grade.sequences=list(c('3', '4', '5', '6', '7', '8', 'EOCT')),
		sgp.exclude.sequences = data.table(VALID_CASE = 'VALID_CASE', CONTENT_AREA='MATHEMATICS',
			YEAR='2014', GRADE='8'),
		sgp.projection.grade.sequences="NO_PROJECTIONS"
	)
)
