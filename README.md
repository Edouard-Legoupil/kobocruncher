# kobocruncher
An organized workflow generating 'Rmd' files from an extended 'xlsform' questionnaire structure to facilitate survey data crunching. 

`kobocruncher` support organised data analysis workflow, to conduct data discovery and analysis for data collected through  [KoboToolbox](https://www.kobotoolbox.org/), [ODK](https://opendatakit.org/), [ONA](https://ona.io/home/) or any __[xlsform](http://xlsform.org)__ compliant data collection platform.

This package first builds on the capacity of [UNHCR Kobo server](http://kobo.unhcr.org) but it can also be used from any structured dataset. It comes as a companion tool to the [Integrated Framework for Household Survey](https://unhcr.github.io/Integrated-framework-household-survey).

## Tutorial 

`kobocruncher` aims at helping [humanitarian data analysts](https://humanitarian-user-group.github.io/) to focus in data interpretation by saving the time needed to quickly generate the graphs and charts required to discover insights from a dataset. It also ensure analysis __reproducibility__ through a separation of the analysis configuration and the analysis process. The package allows to account for sample weights and hierarchical dataset structure (both capacities that are not available through the default [reporting engine](http://support.kobotoolbox.org/articles/2847676-viewing-and-creating-custom-reports) or the [excel-analyzer](http://support.kobotoolbox.org/articles/592387-using-the-excel-analyzer)).  

Presentations / tutorials for a one day training workshop are accessible here:

  *  [00-Intro](tutorial/00-Intro.html)  
  *  [01-First Report](tutorial/01-First_Report.html)  
  *  [02-Relabeling](tutorial/02-Relabeling.html)  
  *  [03-Grouping Questions](tutorial/03-Grouping_Questions.html)  
  *  [04-Setting Crosstabulation](tutorial/04-Setting_Crosstabulation.html)  
  *  [05-Searching Asssociation](tutorial/05-Searching_Asssociation.html)  
  *  [06-Cleaning and Indicator Calculation](tutorial/06-Cleaning_and_Indicator_calculation.html)  
  *  [07-Anonymising](tutorial/07-Anonymising.html)  
  *  [08-Weighting](tutorial/08-Weighting.html)   
  *  [09-Publishing](tutorial/09-Publishing.html)  

## Install

```{r}
install.packages("devtools")
### Install Key unhcRverse packages in order to get the corporate style & brand
devtools::install_github('vidonne/unhcrdown')
devtools::install_github('vidonne/unhcrthemes')
devtools::install_github('galalH/riddle')
## Now get kobocruncher
devtools::install_github("edouard-legoupil/kobocruncher")  
```  

## Contributing

Contributions to the packages are welcome. Please read first the [contribution guidelines](CONTRIBUTING.html), follow the [code of conduct](CODE_OF_CONDUCT.html) and use the [issue template](ISSUE_TEMPLATE.html).

## References and rational for the package

The package falls into the category of Automatic Data Exploration package (see an [extensive review here](https://github.com/mstaniak/autoEDA-resources)) and mostly act as a __wrapper__ for different specialized packages from the [tidyverse](https://www.tidyverse.org/) . 

Compare to those packages, `kobocruncher` provides:  

 * An integration of all the data processing stages, not only visualization

 * An approach where most of the exploration is documented in the original `xlsform` used to collect the data as UNHCR standard for Survey Data Collection is based on Kobotoolbox. This allows for [reproducible analysis](https://unhcr-americas.github.io/reproducibility/index.html)
 
 * Multiple notebook templates with standard charts designed to be interpretable by a non-technical audience

 * Relabeling functions and Questions grouping ability

 * Full integration with UNHCR Brand Style
