% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kobo_anonymise.R
\name{kobo_anonymise}
\alias{kobo_anonymise}
\title{Assess Statistical disclosure risk based on an intrusions scenario}
\usage{
kobo_anonymise(datalist, dico)
}
\arguments{
\item{datalist}{An object of the "datalist" class as defined in kobocruncher}

\item{dico}{An object of the "kobodico" class format as defined in kobocruncher}
}
\description{
When personal data is being collected, performing basic de-identification (i.e. removal of direct identifiers) and assessing risk of re-identification (i.e. using indirect identifiers to re-identify individuals) is a key sep to perform in order to be able to share the data with multiple analyst.

The initial step consist in defining potential intrusion scenario.
This suppose to document the anonymise cell for each variable

\tabular{rrrrrr}{
\strong{Type}    \tab \strong{Description}  \cr
----------------\tab----------- \cr
\strong{Direct_identifier}     \tab	Can be directly used to identify an individual. E.g. Name, Address, Date of birth, Telephone number, GPS location \cr
\strong{Quasi_identifier}     \tab	Can be used to identify individuals when it is joined with other information. E.g. Age, Salary, Next of kin, School name, Place of work \cr
\strong{Sensitive_information}  \tab & Community identifiable information	Might not identify an individual but could put an individual or group at risk. E.g. Gender, Ethnicity, Religious belief
}

Direct identifiers will be automatically removed from the data.
The function will perform the measurement of various statistical disclosure risk measurement
for the selected quasi_identifier and sensitive_information.
}
\examples{
# dico <- kobo_dico( xlsformpath = system.file("sample_xlsform.xlsx", package = "kobocruncher") )
# datalist <- kobo_data(datapath = system.file("data.xlsx", package = "kobocruncher") )
# 
# kobo_anonymise(datalist = datalist,
#                    dico = dico,
#                 indicatoradd = indicatoradd   )


 
}
