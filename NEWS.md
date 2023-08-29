# kobocruncher 0.2.6

 * Added shinyapp


# kobocruncher 0.2.4

 * Added template in word
 
 * Reviewed the ridl connection using  `edouard-legoupil/riddle` - package peer reviewed..
 
 * added a parameters in the plotting functions for lumping together under other
 
 * updated the tutorial to better explain the transition between exploration and presentation
 
 * updated superseeded `separate_rows` from {tidyr} with  `separate_longer_delim`   

 

# kobocruncher 0.2.0

 * Major re-factoring / simplification of the previous [koboloader package](https://unhcr.github.io/koboloadeR/docs/) - nurtured by Hisham Galal !! Standard Reports are now available as a basic Rmd template rather than a function that would write down the Rmd directly... 
 
 * Now using the [Fusen package](https://thinkr-open.github.io/fusen/index.html) to mainstream documentation and unit testing - see the dev folder to find out
 
 * Created systematic reprex examples for all functions within the package

 * Removed a lot of of unnecessary packages for the installation

 * Removed for the time being the shinyApp part -- will rework it later... hopefully with Golem!

 * Remove all packages component related to API parsing - fully rely on all RIDL API from Ahmadou Dickoa - the recommended practices is to avoid starting any analysis before data is documented on http://ridl.unhcr.org - more on the automation from Kobotoolbox to RIDL is here: https://im.unhcr.org/ridl/ 
 
```
remotes::install_github('dickoa/ridl') 
``` 
 
 * Remove all packages component related to API parsing - fully rely on all styling packages from Cedric Vidonne. For non-UNHCR users, it shuld not be complicated to fork those packages and adjust them to your own organisation brand style.
 
```
remotes::install_github('vidonne/unhcrdown')
remotes::install_github('vidonne/unhcrdesign')
remotes::install_github('vidonne/unhcrtemplate')
remotes::install_github('vidonne/unhcrtheme')
```


