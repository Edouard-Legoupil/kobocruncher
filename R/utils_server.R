# UTILITY FUNCTIONS FOR SERVER

# check for indicator analysis
# returns TRUE if analysis is present
analysis_exists <- function(coin){
  !is.null(coin$Analysis$Raw$FlaggedStats)
}

get_parent <- function(coin, iCode, at_level = 2, as_name = TRUE){
  pCode <- coin$Meta$Lineage[[at_level]][coin$Meta$Lineage[[1]] == iCode]
  if(as_name){
    COINr::icodes_to_inames(coin, pCode)
  } else {
    pCode
  }
}
