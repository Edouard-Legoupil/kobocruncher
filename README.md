# A2SIT

This is the repository for the Admin2 Severity Index Tool (A2SIT). The A2SIT is a Shiny web app built in R which allows users to upload data and build a severity index.

:warning: *The A2SIT is currently under development...* :construction:

## Installation

Although the final aim is to host the A2SIT online, the A2SIT app is encapsulated in an R package, so it can be installed and run locally (as long as you have R installed). To do this, run (in R:

```
remotes::install_github("UNHCR-Guatemala/A2SIT")
```

Note this requires the 'remotes' package.

The aim will be to keep a working version of the app in the main branch of this repo. Meanwhile, development will progress in branches which will be merged when relatively stable. Please keep in mind though that the development is in its early stages so also the main "working" version will likely contain bugs and is so far not formally tested.

## Running the app

To run the app locally, after installing the A2SIT package, run:

```
library(A2SIT)

run_app()
```

Note that an example data set can be found at the directory specified by `system.file("data_module-input.xlsx", package = "A2SIT")`, or you can download the file [here](https://github.com/UNHCR-Guatemala/A2SIT/raw/main/inst/data_module-input.xlsx).
