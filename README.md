cefitds
================

CEFI THREDDS catalog navigation using R

# Requirments

    + [R v4.1+](https://www.r-project.org/)
    + [thredds](https://CRAN.R-project.org/package=thredds)

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
})

datasets = cefi_catalog(region = "northwest_atlantic",
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
    ##   date: 2025-04-29T06:26:37.658Z
    ## 
    ## $`btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc`
    ## DatasetNode (R6): 
    ##   verbose: FALSE    tries: 3    namespace prefix: d1
    ##   url: Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/latest/btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   name: btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   dataSize: 348.1
    ##   date: 2025-04-29T06:26:27.754Z

Pull the URLs out.

``` r
urls = extract_url(datasets)
urls
```

    ##                                                                                                                                             btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc 
    ##   "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/latest/btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc" 
    ##                                                                                                                                           btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc 
    ## "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/latest/btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc"

Now use the [cefi]() package to open the connection.

``` r
tidync::tidync(urls[1])
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
