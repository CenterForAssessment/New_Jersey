#####################################################################################
###                                                                               ###
###      SGP Configurations for 2015_2016 Grade Level and EOCT Math subjects      ###
###                                                                               ###
#####################################################################################

MATHEMATICS_2015_2016.config <- list(
	MATHEMATICS.2015_2016 = list(
		sgp.content.areas=rep("MATHEMATICS", 2),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(as.character(3:4), as.character(4:5), as.character(5:6), as.character(6:7), as.character(7:8)),
		sgp.projection.sequence = c("MATHEMATICS", "MATHEMATICS_INTGRT"))
)

ALGEBRA_I.2015_2016.config <- list(
	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=0), # 9th grade - CANONICAL

	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT")),
		sgp.norm.group.preference=1), # 7th & 8th grades

	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2),

	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3),

	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4),
	
	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5)
)

GEOMETRY.2015_2016.config <- list(
	GEOMETRY.2015_2016 = list( # Fall - Spring
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2015_2016.1", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_I", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=1),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT"), c("8", "EOCT")),
		sgp.norm.group.preference=2), # 7th, 8th & 9th grades

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_II", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5),

	GEOMETRY.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3", "GEOMETRY"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=6)
)

ALGEBRA_II.2015_2016.config <- list(
	ALGEBRA_II.2015_2016 = list( # Fall - Spring
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2015_2016.1", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("GEOMETRY", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=1),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")),
		sgp.norm.group.preference=2), # 8th & 9th grades

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_I", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=5),

	ALGEBRA_II.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_3", "ALGEBRA_II"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=6)
)

INTEGRATED_MATH_1.2015_2016.config <- list(
	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=0), # 9th grade - CANONICAL

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("6", "EOCT"), c("7", "EOCT")),
		sgp.norm.group.preference=1), # 7th & 8th grades

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_I", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=2),

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("GEOMETRY", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=3),

	INTEGRATED_MATH_1.2015_2016 = list(
		sgp.content.areas=c("ALGEBRA_II", "INTEGRATED_MATH_1"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=4)
)

INTEGRATED_MATH_2.2015_2016.config <- list(
	INTEGRATED_MATH_2.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0),

	INTEGRATED_MATH_2.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_2"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")),
		sgp.norm.group.preference=1) # 8th & 9th grades
)

INTEGRATED_MATH_3.2015_2016.config <- list(
	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_2", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=0),

	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("INTEGRATED_MATH_1", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("EOCT", "EOCT")),
		sgp.norm.group.preference=1),

	INTEGRATED_MATH_3.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "INTEGRATED_MATH_3"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("7", "EOCT"), c("8", "EOCT")),
		sgp.norm.group.preference=2) # 8th & 9th grades
)
