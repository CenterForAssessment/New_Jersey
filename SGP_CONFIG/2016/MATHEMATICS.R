##################################################################################
###                                                                            ###
###  SGP Configurations for 2016 New Jersey Grade Level & EOCT Math subjects   ###
###                                                                            ###
##################################################################################

MATHEMATICS_2016.config <- list(
	MATHEMATICS.2016 = list(
		sgp.content.areas=rep("MATHEMATICS", 6),
		sgp.panel.years=as.character(2011:2016),
		sgp.grade.sequences=list(as.character(3:4), as.character(3:5), as.character(3:6), as.character(3:7), as.character(3:8)),
		sgp.projection.sequence = "MATHEMATICS")
)

ALGEBRA_I.2016.config <- list(
	ALGEBRA_I.2016 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 6), "ALGEBRA_I"),
		sgp.panel.years=as.character(2010:2016),
		sgp.grade.sequences=list(c(as.character(3:8), "EOCT")),
		sgp.norm.group.preference=0), # 9th grade - CANONICAL

	ALGEBRA_I.2016 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 5), "ALGEBRA_I"),
		sgp.panel.years=c(as.character(2011:2015), "2016"),
		sgp.grade.sequences=list(c(as.character(3:6), "EOCT"), c(as.character(3:7), "EOCT")),
		sgp.norm.group.preference=1) # 8th grade

#	ALGEBRA_I.2016 = list( ### 634 Cases
#		sgp.content.areas=c("GEOMETRY", "ALGEBRA_I"),
#		sgp.panel.years=c("2015", "2016"),
#		sgp.grade.sequences=list(c("EOCT", "EOCT")),
#		sgp.norm.group.preference=2),
)

GEOMETRY.2016.config <- list(
	GEOMETRY.2016 = list(
		sgp.content.areas=c(rep("MATHEMATICS", 6), "ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=as.character(2009:2016),
		sgp.grade.sequences=list(c(as.character(3:8), "EOCT", "EOCT")),
		sgp.norm.group.preference=0),

#	GEOMETRY.2016 = list( ### 926 Total Cases from Grade Level Math to Geometry
#		sgp.content.areas=c("MATHEMATICS", "GEOMETRY"),
#		sgp.panel.years=c("2015", "2016"),
#		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")),
#		sgp.norm.group.preference=2), # 7th, 8th & 9th grades

	GEOMETRY.2016 = list( ### 2397 Cases
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2015", "2016"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=1)
)

ALGEBRA_II.2016.config <- list(
	ALGEBRA_II.2016 = list(
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2015", "2016"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0),

#	ALGEBRA_II.2016 = list( ### Total of 138 Cases from Grade Level Math to Algebra II
#		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_II"),
#		sgp.panel.years=c("2015", "2016"),
#		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")),
#		sgp.norm.group.preference=2), # 8th & 9th grades

	ALGEBRA_II.2016 = list( ### 8.114 Cases
		sgp.content.areas=c(rep("MATHEMATICS", 5), "ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c(as.character(2010:2016)),
		sgp.grade.sequences=list(c(as.character(4:8), "EOCT", "EOCT")),
		sgp.norm.group.preference=1)
)
