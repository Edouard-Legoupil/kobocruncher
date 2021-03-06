# WARNING - Generated by {fusen} from /dev/flat_dev.Rmd: do not edit by hand

#' @title Get Interpretation hint for a specific variable
#' @param dico An object of the "kobodico" class format as defined in kobocruncher
#' @param x variable
#' @export

#' @examples
#' dico <- kobo_dico( xlsformpath = system.file("sample_xlsform.xlsx", package = "kobocruncher") )
#' 
#' label_varhint(dico = dico, 
#'               x ="profile.country")
label_varhint <- function(dico, x) {
  as.data.frame(dico[1]) |>
    dplyr::filter(name == x) |>
    dplyr::pull(hint)
}

