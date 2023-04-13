#' Analyse indicators
#'
#' Takes a coin and outputs an analysis of indicators. The objective is to look
#' for any "statistically-problematic" indicators, based on:
#'
#' - data availability
#' - high proportion of repeated data values
#' - outliers as defined by skew and kurtosis
#' - collinearity within first aggregation level (category)
#' - negative correlation within first aggregation level (category)
#'
#' The output can be viewed in R or as an interactive data frame.
#' Uses Spearman rank correlation to deal with skewed distributions.
#' Operates on the Raw data set.
#'
#' The output is a coin with the results attached. This is so that on export, the
#' results will also be exported easily.
#'
#' @param coin The coin
#'
#' @return coin Updated coin with analysis tables
#'
#' @importFrom COINr get_stats get_corr_flags is.coin
#'
#' @export
f_analyse_indicators <- function(coin){

  stopifnot(is.coin(coin))

  # Settings ----

  dat_avail_thresh <- 0.66
  skew_thresh <- 2
  kurt_thresh <- 3.5
  same_thresh <- 0.5
  collin_thresh <- 0.9
  neg_corr_thresh <- -0.4

  # Univariate stats ----

  df_stats <- COINr::get_stats(
    coin, dset = "Raw",
    t_skew = skew_thresh,
    t_kurt = kurt_thresh,
    t_avail = dat_avail_thresh,
    out2 = "df")

  # prep df for display
  df_disp <- df_stats[c("iCode", "Frc.Avail", "Frc.Same")]
  # add skew and kurt
  df_disp$SkewKurt <- paste0(signif(df_stats$Skew, 3)," / ", signif(df_stats$Kurt, 3))

  # we find which iCodes are flagged for which things
  # prep a df
  df_flag <- data.frame(iCode = df_disp$iCode)

  # in the flag df TRUE means it is flagged as having a problem
  df_flag$Frc.Avail <- df_stats$Flag.Avail == "LOW"
  df_flag$Frc.Same <- df_stats$Frc.Same > 0.5
  df_flag$SkewKurt <- df_stats$Flag.SkewKurt == "OUT"

  # Bivariate (correlations) ----

  df_collinear <- COINr::get_corr_flags(
    coin, dset = "Raw",
    cor_thresh = collin_thresh,
    thresh_type = "high",
    grouplev = 2,
    cortype = "spearman",
    use_directions = TRUE)

  df_flag$Collinear <- df_flag$iCode %in% c(df_collinear$Ind1, df_collinear$Ind2)

  df_negcorr <- COINr::get_corr_flags(
    coin, dset = "Raw",
    cor_thresh = neg_corr_thresh,
    thresh_type = "low",
    grouplev = 2,
    cortype = "spearman",
    use_directions = TRUE)

  df_flag$NegCorr <- df_flag$iCode %in% c(df_negcorr$Ind1, df_negcorr$Ind2)

  # Tidy and output ----

  # assemble a big table for viewing (to probably adjust yet)
  df_disp <- df_disp[match(df_flag$iCode, df_disp$iCode), ]

  # add correlation entries

  pairs_colin <- f_gather_correlations(df_collinear)
  df_disp$Collinear <- pairs_colin[match(df_disp$iCode, names(pairs_colin))]

  pairs_neg <- f_gather_correlations(df_negcorr)
  df_disp$NegCorr <- pairs_neg[match(df_disp$iCode, names(pairs_neg))]

  # status column (will be changed if indicators are added/removed)
  df_disp$Status <- "In"
  df_flag$Status <- FALSE

  # add outputs to coin
  coin$Analysis$Raw <- list(
    FlaggedStats = df_disp,
    Flags = df_flag
  )

  coin

}

# Helper function for indicator analysis
f_gather_correlations <- function(X){

  Xpairs <- data.frame(v1 = c(X$Ind1, X$Ind2),
                       v2 = c(X$Ind2, X$Ind1))

  Xpairs <- Xpairs[order(Xpairs$v1, Xpairs$v2), ]

  tapply(Xpairs$v2, Xpairs$v1, paste0, collapse = ", ")

}

# either a coin input, or else a list with Xd and Xh data frames in that order
f_display_indicator_analysis <- function(coin, filter_to_flagged = TRUE){

  if(is.coin(coin)){
    Xd <- coin$Analysis$Raw$FlaggedStats
    Xh <- coin$Analysis$Raw$Flags
  } else if (is.list(coin)){
    Xd <- coin[[1]]
    Xh <- coin[[2]]
  }

  if(is.null(Xd) || is.null(Xh)){
    abort("Indicator analysis not found in coin. Run f_analyse_indicators() first.")
  }

  if(filter_to_flagged){
    l <- filter_to_flagged(Xd, Xh)
    Xd <- l$Flags
    Xh <- l$FlaggedStats
  }

  f_highlight_DT(Xd, Xh)

}

# this is used in the function above and in shiny server for row selection
# input is either 2 dfs or else Xd can be a list with 2dfs in it.
filter_to_flagged <- function(Xd, Xh){

  if(!is.data.frame(Xd)){
    Xh <- Xd$Flags
    Xd <- Xd$FlaggedStats
  }

  # only include rows with at least one flag
  include_rows <- rowSums( Xh[!(names(Xh) %in% c("iCode", "Status"))] ) > 0

  Xd <- Xd[include_rows, ]
  Xh <- Xh[include_rows, ]

  list(Flags = Xd, FlaggedStats = Xh)
}

# Generic function for creating an interactive table with input df `Xd`, and
# with cells highlighted by an equivalently sized logical df `Xh`.
#
# This is used for displaying the output of `f_analyse_indicators()`.
#
f_highlight_DT <- function(Xd, Xh, table_caption = NULL, highlight_colour = "#ffc266"){

  stopifnot(identical(dim(Xd), dim(Xh)))

  ncol_display <- ncol(Xd)

  Xh_numeric <- lapply(Xh, function(x){
    if(is.logical(x)){
      as.numeric(x)
    } else {
      x
    }
  }) |> as.data.frame()

  X <- cbind(Xd, Xh_numeric)

  styles <- c("white", highlight_colour)

  DT::datatable(
    X,
    rownames = FALSE,
    caption = table_caption,
    selection = "single",
    options = list(
      columnDefs = list(
        list(
          visible=FALSE,
          targets=ncol_display:(ncol(X)-1)
        )
      )
    )
  ) |>
    DT::formatStyle(
      columns = 1:ncol_display,
      valueColumns = (ncol_display + 1):ncol(X),
      backgroundColor = DT::styleEqual(c(0,1), styles))

}

# Removes indicators as specified by a character vector of indicator
# codes in `remove_indicators`. After removal, any results are regenerated
# (updated).
#
# The original data is always preserved so indicators can be restored.
# Analysis tables are not currently re-run so this has to be done separately.
#
f_remove_indicators <- function(coin, remove_indicators = NULL){

  # extract analysis
  ind_analysis <- coin$Analysis$Raw
  analysis_exists <- !is.null(ind_analysis)

  coin <- COINr::change_ind(coin, drop = remove_indicators, regen = TRUE)

  if(analysis_exists){
    # edit and replace analysis
    ind_analysis$FlaggedStats$Status[
      ind_analysis$FlaggedStats$iCode %in% remove_indicators] <- "OUT"
    ind_analysis$Flags$Status[
      ind_analysis$Flags$iCode %in% remove_indicators] <- TRUE

    coin$Analysis$Raw <- ind_analysis
  }

  if(!is.null(coin$Data$Aggregated)){
    coin <- f_generate_results(coin)
  }

  coin

}

# As `f_remove_indicators()` but adds indicators back in. Obviously only
# indicators that were originally present in the input data can be added.
#
f_add_indicators <- function(coin, add_indicators = NULL){

  # extract analysis
  ind_analysis <- coin$Analysis$Raw
  analysis_exists <- !is.null(ind_analysis)

  coin <- COINr::change_ind(coin, add = add_indicators, regen = TRUE)

  if(analysis_exists){
    # edit and replace analysis
    ind_analysis$FlaggedStats$Status[
      ind_analysis$FlaggedStats$iCode %in% add_indicators] <- "In"
    ind_analysis$Flags$Status[
      ind_analysis$Flags$iCode %in% add_indicators] <- FALSE

    coin$Analysis$Raw <- ind_analysis
  }

  if(!is.null(coin$Data$Aggregated)){
    coin <- f_generate_results(coin)
  }

  coin

}

# # Resets adding/removal of indicators so that ALL indicators that were input
# # with input data are included.
# #
# f_reset_indicators <- function(coin){
#
#   # extract analysis
#   ind_analysis <- coin$Analysis$Raw
#   analysis_exists <- !is.null(ind_analysis)
#
#   coin$Log$new_coin$exclude <- NULL
#
#   coin <- Regen(coin)
#
#   if(analysis_exists){
#     # edit and replace analysis
#     ind_analysis$FlaggedStats$Status <- "In"
#     ind_analysis$Flags$Status <- FALSE
#
#     coin$Analysis$Raw <- ind_analysis
#   }
#
#   coin
#
# }
