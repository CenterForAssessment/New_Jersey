##########################################################################################
###                                                                                    ###
###       Convert SGP analysis configurations to SGP_NORM_GROUP preference table       ###
###                                                                                    ###
##########################################################################################

### Load packages

require("data.table")
options(error=recover)

### utility function

configToSGPNormGroup <- function(sgp.config) {
	if ("sgp.norm.group.preference" %in% names(sgp.config)) {
		tmp.data.all <- data.table()
		for (g in 1:length(sgp.config$sgp.grade.sequences)) {
			l <- length(sgp.config$sgp.grade.sequences[[g]])
			tmp.norm.group <- tmp.norm.group.baseline <- paste(tail(sgp.config$sgp.panel.years, l), paste(tail(sgp.config$sgp.content.areas, l), unlist(sgp.config$sgp.grade.sequences[[g]]), sep="_"), sep="/") 
			
			tmp.data <- data.table(
				SGP_NORM_GROUP=paste(tmp.norm.group, collapse="; "), 
				# SGP_NORM_GROUP_BASELINE=paste(tmp.norm.group.baseline, collapse="; "),
				PREFERENCE= sgp.config$sgp.norm.group.preference*100)
			
			if (length(tmp.norm.group) > 2) {
				if ("sgp.exact.grade.progression" %in% names(sgp.config)) {
					if(sgp.config$sgp.exact.grade.progression[[g]]) tmp.all.prog <- FALSE else tmp.all.prog <- TRUE
				} else tmp.all.prog <- TRUE
				if (tmp.all.prog) {
					for (n in 1:(length(tmp.norm.group)-2)) {
						tmp.data <- rbind(tmp.data, data.table(
							SGP_NORM_GROUP=paste(tail(tmp.norm.group, -n), collapse="; "), 
							# SGP_NORM_GROUP_BASELINE=paste(tmp.norm.group.baseline, collapse="; "),
							PREFERENCE= (sgp.config$sgp.norm.group.preference*100)+n))
					}
				}
			}
			tmp.data.all <- rbind(tmp.data.all, tmp.data)
		}
		return(unique(tmp.data.all))
	} else {
		return(NULL)
	}
}

### Load 2016 EOCT Configurations

source("2016/MATHEMATICS.R")


###  Compile annual configuration lists

NJ_EOCT_2016.config <- c(ALGEBRA_I_2016.config, GEOMETRY_2016.config, ALGEBRA_II_2016.config)


### Create configToNormGroup data.frame

tmp.configToNormGroup <- lapply(NJ_EOCT_2016.config, configToSGPNormGroup)
NJ_SGP_Norm_Group_Preference_2016 <- data.table(
					YEAR="2016", rbindlist(tmp.configToNormGroup))

NJ_SGP_Norm_Group_Preference <- rbind(
			NJ_SGP_Norm_Group_Preference_2016
			)

NJ_SGP_Norm_Group_Preference$SGP_NORM_GROUP <- as.factor(NJ_SGP_Norm_Group_Preference$SGP_NORM_GROUP)


### Save result

setkey(NJ_SGP_Norm_Group_Preference, YEAR, SGP_NORM_GROUP)
save(NJ_SGP_Norm_Group_Preference, file="NJ_SGP_Norm_Group_Preference.Rdata")
