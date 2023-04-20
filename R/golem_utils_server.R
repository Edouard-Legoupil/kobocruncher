# UTILITY FUNCTIONS FOR SERVER
#'  check for indicator analysis
#'
#'
#' @param coin The coin
#'
#' @return TRUE if analysis is present
#'
#' @noRd
analysis_exists <- function(coin){
  !is.null(coin$Analysis$Raw$FlaggedStats)
}


#' get_parent
#'
#'
#'
#' @param coin The coin
#' @param iCode  iCode
#' @param at_level 2
#' @param as_name  boolean
#'
#' @return pcode
#'
#' @importFrom COINr icodes_to_inames
#'
#' @noRd
get_parent <- function(coin,
                       iCode,
                       at_level = 2,
                       as_name = TRUE){
  pCode <- coin$Meta$Lineage[[at_level]][coin$Meta$Lineage[[1]] == iCode]
  if(as_name){
    COINr::icodes_to_inames(coin, pCode)
  } else {
    pCode
  }
}
