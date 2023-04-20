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

get_inclusion_status <- function(l_analysis, isel){
  l_analysis$FlaggedStats$Status[l_analysis$FlaggedStats$iCode == isel]
}

get_indicator_info <- function(coin_full, coin, isel){

  df_stats <- coin$Analysis$Raw$Stats
  isel_row <- df_stats$iCode == isel

  ind_status <- get_inclusion_status(coin$Analysis$Raw, isel)
  stat_string <- paste0("<b>Status:</b> ", ind_status)

  cat_string <- paste0("<b>Category:</b> ", get_parent(coin, isel, 2))
  dim_string <- paste0("<b>Dimension:</b> ", get_parent(coin_full, isel, 3))

  xmin <- df_stats$Min[isel_row]
  xmax <- df_stats$Max[isel_row]
  minmax_string <- paste0("<b>Min/max:</b> ", xmin, "/", xmax)

  n_avail <- df_stats$N.Avail[isel_row]
  prc_avail <- df_stats$Frc.Avail[isel_row]*100
  avail_string <- paste0("<b>Availabilty:</b> ", n_avail, " obs (", prc_avail, "%)")


  paste0(cat_string, "<br>", dim_string, "<br>", stat_string, "<br>",
         minmax_string, "<br>", avail_string)

}
