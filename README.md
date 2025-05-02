cefitds
================

CEFI THREDDS catalog navigation using R

# Requirements

### CRAN

- [R v4.1+](https://www.r-project.org/)

- [thredds](https://CRAN.R-project.org/package=thredds)

### Github

- [cefi](https://github.com/BigelowLab/cefi)

# Suggested

- [httr](https://CRAN.R-project.org/package=httr)

# Installation

    remotes::install_github("BigelowLab/cefitds")

# Usage

Retrieve DatasetNode objects for a specific region, product suite and
set of variables. Each object contains the URL for the NetCDF
connection.

``` r
suppressPackageStartupMessages({
  library(cefitds)
  library(tidync)
  library(dplyr)
})

datasets = query_cefi(region = "northwest_atlantic",
                        product = "hindcast",
                        period = "monthly",
                        vars = c("btm_o2", "btm_temp"))
datasets
```

    ## $`btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc`
    ## DatasetNode (R6): 
    ##   verbose: FALSE    tries: 3    namespace prefix: d1
    ##   url: Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/latest/btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   name: btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   dataSize: 321.1
    ##   date: 2025-05-02T06:20:16.934Z
    ## 
    ## $`btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc`
    ## DatasetNode (R6): 
    ##   verbose: FALSE    tries: 3    namespace prefix: d1
    ##   url: Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/latest/btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   name: btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   dataSize: 348.1
    ##   date: 2025-05-02T06:18:14.125Z
    ## 
    ## attr(,"class")
    ## [1] "cefi_dataset_nodes" "list"

Pull the URLs out.

``` r
r = node_extract_table(datasets) |>
  dplyr::glimpse()
```

    ## Rows: 2
    ## Columns: 15
    ## $ name               <chr> "btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199…
    ## $ dataSize           <dbl> 321.1, 348.1
    ## $ variable_name      <chr> "btm_o2", "btm_temp"
    ## $ region             <chr> "nwa", "nwa"
    ## $ subdomain          <chr> "full", "full"
    ## $ experiment_type    <chr> "hcast", "hcast"
    ## $ output_frequency   <chr> "monthly", "monthly"
    ## $ grid_type          <chr> "regrid", "regrid"
    ## $ release            <chr> "r20230520", "r20230520"
    ## $ start_date         <date> 1993-01-01, 1993-01-01
    ## $ end_date           <date> 2019-12-01, 2019-12-01
    ## $ ensemble_type      <lgl> NA, NA
    ## $ ensemble_info      <lgl> NA, NA
    ## $ initalization_date <lgl> NA, NA
    ## $ url                <chr> "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/re…

Now use the [tidync](https://CRAN.R-project.org/package=tidync) package
to open the connection.

``` r
tidync::tidync(r$url[1])
```

    ## 
    ## Data Source (1): btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc ...
    ## 
    ## Grids (4) <dimension family> : <associated variables> 
    ## 
    ## [1]   D1,D0,D2 : btm_o2    **ACTIVE GRID** ( 211654944  values per variable)
    ## [2]   D0       : lat
    ## [3]   D1       : lon
    ## [4]   D2       : time
    ## 
    ## Dimensions 3 (all active): 
    ##   
    ##   dim   name  length    min    max start count   dmin   dmax unlim coord_dim 
    ##   <chr> <chr>  <dbl>  <dbl>  <dbl> <int> <int>  <dbl>  <dbl> <lgl> <lgl>     
    ## 1 D0    lat      844   5.27   58.2     1   844   5.27   58.2 FALSE TRUE      
    ## 2 D1    lon      774 -98.4   -36.1     1   774 -98.4   -36.1 FALSE TRUE      
    ## 3 D2    time     324  15.5  9846.      1   324  15.5  9846.  FALSE TRUE
