# BACK END FUNCTIONS FOR DATA INPUT

#' Data input
#'
#' Reads a formatted Excel file found at `file_path` and outputs a constructed coin.
#'
#' On reading the Excel file, this function does the following:
#'
#' - Data is split into data and metadata and tidied
#' - Metadata is merged with hard-coded index structure
#' - Any indicators with no data at all are removed
#' - Any resulting aggregation groups with no "children" are removed
#' - A coin is assembled using COINr and this is the function output
#'
#' If indicators/groups are removed, a message is sent to the console.
#'
#' The Excel file is required to be in a fairly strict format: an example is given at
#' `inst/data_module-input.xlsx`. This template is still a work in progress
#' and can be modified in the app phase following further feedback.
#'
#' @param file_path path to the excel file where we have the raw data
#'
#' @return coin-class object
#'
#' @export
f_data_input <- function(file_path){

  # Settings ----

  # anchor points in spreadsheet
  idata_topleft <- c(5, 1)
  imeta_topleft <- c(1, 3)
  imeta_botleft <- c(5, 3)

  # col names to look for
  ucode_name <- "admin2Pcode"
  uname_name <- "Name"


  # Read in data ----

  iData <- readxl::read_excel(
    path = file_path, sheet = "Data",
    range = readxl::cell_limits(ul = idata_topleft, lr = c(NA, NA))
  )
  iMeta <- readxl::read_excel(
    path = file_path, sheet = "Data",
    range = readxl::cell_limits(ul = imeta_topleft,
                                lr = c(imeta_botleft[1], NA)),
    col_names = FALSE
  ) |> suppressMessages()

  # Tidy iData ----

  names(iData)[names(iData) == ucode_name] <- "uCode"
  names(iData)[names(iData) == uname_name] <- "uName"


  # Tidy and merge metadata ----

  # tidy existing
  iMeta <- as.data.frame(t(iMeta))
  names(iMeta) <- c("Weight", "Direction", "Parent", "iName", "iCode")
  iMeta$Weight <- as.numeric(iMeta$Weight)
  iMeta$Direction <- as.numeric(iMeta$Direction)
  row.names(iMeta) <- NULL

  # add cols (ready for merge)
  iMeta$Level <- 1
  iMeta$Type <- "Indicator"

  # merge with aggregate levels
  iMeta_aggs <- readRDS("./inst/iMeta_aggs.RDS")
  iMeta <- rbind(iMeta, iMeta_aggs)


  # Further tidying ----

  # remove indicators with no data

  i_nodata <- names(iData)[colSums(!is.na(iData)) == 0]
  iData <- iData[!(names(iData) %in% i_nodata)]
  iMeta <- iMeta[!(iMeta$iCode %in% i_nodata), ]

  if(length(i_nodata) > 0){
    message("Removed indicators with no data points: ",
            paste0(i_nodata, collapse = ", "))
  }

  # remove any second-level groups with no children

  no_children_1 <- iMeta$iCode[iMeta$Level == 2 & !(iMeta$iCode %in% iMeta$Parent)]
  iMeta <- iMeta[!(iMeta$iCode %in% no_children_1), ]

  if(length(no_children_1) > 0){
    message("Removed categories containing no indicators: ",
            paste0(no_children_1, collapse = ", "))
  }

  # remove any third-level groups with no children

  no_children_2 <- iMeta$iCode[iMeta$Level == 3 & !(iMeta$iCode %in% iMeta$Parent)]
  iMeta <- iMeta[!(iMeta$iCode %in% no_children_1), ]

  if(length(no_children_2) > 0){
    message("Removed dimensions containing no categories: ", no_children_2,
            paste0(no_children_2, collapse = ", "))
  }


  # Build coin and output ----

  COINr::new_coin(iData, iMeta, quietly = TRUE,
                  level_names = c("Indicator", "Category", "Dimension", "Index"))

}

#' Print Coin
#'
#' This is a print-style text output function for summarising the contents of the coin.
#'
#' It is intended to be used immediately on loading data, to show the user what they have
#' input, so they can check for any unexpected things.
#'
#' @param coin The coin
#'
#' @return A coin
#'
#'
#' @export
f_print_coin <- function(coin){

  cat("----------\n")
  cat("Your data:\n")
  cat("----------\n")
  # Input
  # Units
  firstunits <- paste0(utils::head(coin$Data$Raw$uCode, 3), collapse = ", ")
  if(length(coin$Data$Raw$uCode)>3){
    firstunits <- paste0(firstunits, ", ...")
  }

  # Indicators
  iCodes <- coin$Meta$Ind$iCode[coin$Meta$Ind$Type == "Indicator"]
  firstinds <- paste0(utils::head(iCodes, 3), collapse = ", ")
  if(length(iCodes)>3){
    firstinds <- paste0(firstinds, ", ...")
  }

  cat("Input:\n")
  cat("  Units: ", nrow(coin$Data$Raw), " (", firstunits, ")\n", sep = "")
  cat(paste0("  Indicators: ", length(iCodes), " (", firstinds, ")\n\n"))

  # Structure
  fwk <- coin$Meta$Lineage

  cat("Structure:\n")

  for(ii in 1:ncol(fwk)){

    codes <- unique(fwk[[ii]])
    nuniq <- length(codes)
    first3 <- utils::head(codes, 3)
    if(length(codes)>3){
      first3 <- paste0(first3, collapse = ", ")
      first3 <- paste0(first3, ", ...")
    } else {
      first3 <- paste0(first3, collapse = ", ")
    }

    # colnames are level names
    levnames <- colnames(fwk)
    # check if auto-generated, if so we don't additionally print.
    if(levnames[1] == "Level_1"){
      levnames <- NULL
    }

    if(ii==1){
      cat(paste0("  Level ", ii, " ", levnames[ii], ": ", nuniq, " indicators (", first3,") \n"))
    } else {
      cat(paste0("  Level ", ii, " ", levnames[ii], ": ", nuniq, " groups (", first3,") \n"))
    }

  }
  cat("\n")

}
