####################################################################
###
### Code to update SGP analyses for New Jersey for 2014
###
####################################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/New_Jersey_Data_LONG_2014.Rdata")
load("Data/New_Jersey_SGP.Rdata")


### updateSGP

New_Jersey_SGP <- updateSGP(
			New_Jersey_SGP, 
			New_Jersey_Data_LONG_2014, 
			save.intermediate.results=TRUE, 
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10, BASELINE_PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=10, SUMMARY=10, GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(New_Jersey_SGP, file="Data/New_Jersey_SGP.Rdata")
