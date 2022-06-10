# kobocruncher
An organized workflow generating 'Rmd' files from an extended 'xlsform' questionnaire structure to facilitate survey data crunching. 

`kobocruncher` support organised data analysis workflow, to conduct data discovery and analysis for data collected through  [KoboToolbox](https://www.kobotoolbox.org/), [ODK](https://opendatakit.org/), [ONA](https://ona.io/home/) or any __[xlsform](http://xlsform.org)__ compliant data collection platform.

This package first builds on the capacity of [UNHCR Kobo server](http://kobo.unhcr.org) but it can also be used from any structured dataset. It comes as a companion tool to the [Integrated Framework for Household Survey](https://unhcr.github.io/Integrated-framework-household-survey).

`kobocruncher` aims at helping [humanitarian data analysts](https://humanitarian-user-group.github.io/) to focus in data interpretation by saving the time needed to quickly generate the graphs and charts required to discover insights from a dataset. It also ensure analysis __reproducibility__ through a separation of the analysis configuration and the analysis process. The package allows to account for sample weights and hierachical dataset structure (both capacities that are not available through the default [reporting engine](http://support.kobotoolbox.org/articles/2847676-viewing-and-creating-custom-reports) or the [excel-analyzer](http://support.kobotoolbox.org/articles/592387-using-the-excel-analyzer)). 

## Install

```{r}
install.packages("remotes")
### Install Key unhcRverse packages
remotes::install_github('dickoa/ridl') 
remotes::install_github('vidonne/unhcrdown')
remotes::install_github('vidonne/unhcrdesign')
remotes::install_github('vidonne/unhcrtemplate')
remotes::install_github('vidonne/unhcrtheme')
## Now get koboloadeR
remotes::install_github("Edouard-Legoupil/kobocruncher", Ncpus=4) 
```  

## Contributing

Contributions to the packages are welcome. Please read first the [contribution guidelines](CONTRIBUTING.html), follow the [code of conduct](CODE_OF_CONDUCT.html) and use the [issue template](ISSUE_TEMPLATE.html).
