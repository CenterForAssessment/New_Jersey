#######
# 2015
#######

load("/Users/avi/Dropbox/SGP/New_Jersey/Data/New_Jersey_SGP.Rdata")
load("/Users/avi/Dropbox (CenterforAssessment)/SGP/New_Jersey/Data/New_Jersey_SGP_Summary_2015.Rdata")

New_Jersey_SGP@Summary <- Summary

#   my.tmp.split <- strsplit(as.character(New_Jersey_SGP@Data$SGP_NORM_GROUP), "; ")
# 	lp <- sapply(my.tmp.split, function(x) rev(x)[2])
New_Jersey_SGP@Data$First_Prior <- as.character(NA)
New_Jersey_SGP@Data[, First_Prior := sapply(strsplit(as.character(New_Jersey_SGP@Data$SGP_NORM_GROUP), "; "), function(x) rev(x)[2])]


setwd("/Users/avi/Dropbox/Github_Repos/Documentation/New_Jersey/SGP_Reports/2015")

###  Clean up the GoFit Plot directories

# gof <- "/Users/avi/Dropbox/Github_Repos/Documentation/New_Jersey/SGP_Reports/img/Goodness_of_Fit"
# tmp_files <- grep("2014", list.files(gof), value = TRUE)
# tmp_files <- grep("2015", list.files(gof), value = TRUE)
# 
# for (k in tmp_files) {
# 	tmp_rm <- grep(".pdf", list.files(paste(gof, k, sep="/")), value = TRUE)
# 	if (length(tmp_rm) > 0) unlink(paste(gof, k, tmp_rm, sep="/"))
# }


library(SGPreports)
use.data.table()

renderMultiDocument(rmd_input = "New_Jersey_SGP_Report_2015.Rmd",
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE, 
										#cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_A_2015.Rmd",
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)#,
										# cleanup_aux_files = FALSE)

renderMultiDocument(rmd_input = "Appendix_B.Rmd",
										output_format = c("HTML", "PDF"), #, "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE,
										# self_contained = FALSE,
										# cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_C_2015.Rmd",
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										# cleanup_aux_files = FALSE)
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)#,
