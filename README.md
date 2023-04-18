# {kobocruncher}
An organized workflow generating 'Rmd' files from an extended 'xlsform' questionnaire structure to facilitate survey data crunching. 

`{kobocruncher}` support organised data analysis workflow, to conduct data discovery and analysis for data collected through  [KoboToolbox](https://www.kobotoolbox.org/), [ODK](https://opendatakit.org/), [ONA](https://ona.io/home/) or any __[xlsform](http://xlsform.org)__ compliant data collection platform.

This package first builds on the capacity of [UNHCR Kobo server](http://kobo.unhcr.org) but it can also be used from any structured dataset. It comes as a companion tool to the [Integrated Framework for Household Survey](https://unhcr.github.io/Integrated-framework-household-survey).

## Tutorial 

`{kobocruncher}` aims at helping [humanitarian data analysts](https://humanitarian-user-group.github.io/) to focus in data interpretation by saving the time needed to quickly generate the graphs and charts required to discover insights from a dataset. It also ensure analysis __reproducibility__ through a separation of the analysis configuration and the analysis process. The package allows to account for sample weights and hierarchical dataset structure (both capacities that are not available through the default [reporting engine](http://support.kobotoolbox.org/articles/2847676-viewing-and-creating-custom-reports) or the [excel-analyzer](http://support.kobotoolbox.org/articles/592387-using-the-excel-analyzer)).  

Presentations / tutorials for a one day training workshop are accessible here:

  *  [00-Intro](tutorial/00-Intro.html)  
  *  [01-First Report](tutorial/01-First_Report.html)  
  *  [02-Relabeling](tutorial/02-Relabeling.html)  
  *  [03-Grouping Questions](tutorial/03-Grouping_Questions.html)  
  *  [04-Setting Crosstabulation](tutorial/04-Setting_Crosstabulation.html)  
  *  [05-Searching Asssociation](tutorial/05-Searching_Asssociation.html)  
  *  [06-Cleaning and Indicator Calculation](tutorial/06-Cleaning_and_Indicator_calculation.html)  
  *  [07-Weighting](tutorial/07-Weighting.html)   
  *  [08-Anonymising](tutorial/08-Anonymising.html)  
  *  [09-Publishing](tutorial/09-Publishing.html)  

## Install and configure authentication token

 If you are on Windows, you will first need to install [Rtools](https://cran.r-project.org/bin/windows/Rtools/) on the top of [R](https://cran.r-project.org/bin/windows/base/) and [Rstudio](https://posit.co/download/rstudio-desktop/) in order to install the package locally.

```{r}
install.packages("pak")

### Install Key unhcRverse packages in order to get the corporate style & brand
pak::pkg_install('vidonne/unhcrdown')
pak::pkg_install('vidonne/unhcrthemes')
pak::pkg_install('edouard-legoupil/riddle')
## Now get {kobocruncher}
pak::pkg_install("edouard-legoupil/kobocruncher")  
```  

The `{riddle}` package is used to ensure integration with UNHCR Data Repository](https://ridl.unhcr.org).
It requires you to add your __API token__ and store it for further use. 
The easiest way to do that is to store your API token in your `.Renviron` file which 
is automatically read by R on startup.

You can retrieve your `API TOKEN` in your [user page](https://ridl.unhcr.org/user/).

![api_token_img](https://raw.githubusercontent.com/Edouard-Legoupil/riddle/main/inst/token.png)

To use the package, you’ll need to store your RIDL API token in the `RIDL_API_TOKEN` environment variable. 
The easiest way to do that is by calling `usethis::edit_r_environ()` and adding the line
`RIDL_API_TOKEN=xxxxx` to the file before saving and restarting your R session.


## Contributing

Contributions to the packages are welcome. Please read first the [contribution guidelines](CONTRIBUTING.html), follow the [code of conduct](CODE_OF_CONDUCT.html) and use the [issue template](ISSUE_TEMPLATE.html).

## References and rational for the package

The package falls into the category of Automatic Data Exploration package (see an [extensive review here](https://github.com/mstaniak/autoEDA-resources)) and mostly act as a __wrapper__ for different specialized packages from the [tidyverse](https://www.tidyverse.org/) . 

Compare to those packages, `{kobocruncher}` provides:  

 * An integration of all the data processing stages, not only visualization

 * An approach where most of the exploration is documented in the original `xlsform` used to collect the data as UNHCR standard for Survey Data Collection is based on Kobotoolbox. This allows for [reproducible analysis](https://unhcr-americas.github.io/reproducibility/index.html)
 
 * Multiple notebook templates with standard charts designed to be interpretable by a non-technical audience

 * Relabeling functions and Questions grouping ability

 * Full integration with UNHCR Brand Style
