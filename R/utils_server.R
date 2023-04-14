# UTILITY FUNCTIONS FOR SERVER

# check for indicator analysis
# returns TRUE if analysis is present
analysis_exists <- function(coin){
  !is.null(coin$Analysis$Raw$FlaggedStats)
}
