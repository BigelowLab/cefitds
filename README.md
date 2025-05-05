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

## Query the THREDDS catalog

``` r
suppressPackageStartupMessages({
  library(cefitds)
  library(tidync)
  library(dplyr)
})

nodes = query_cefi(region = "northwest_atlantic",
                   product = "hindcast",
                   period = "monthly",
                   vars = c("btm_o2", "btm_temp"))
nodes
```

    ## $`btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc`
    ## DatasetNode (R6): 
    ##   verbose: FALSE    tries: 3    namespace prefix: d1
    ##   url: Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/latest/btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   name: btm_o2.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   dataSize: 321.1
    ##   date: 2025-05-03T06:29:23.704Z
    ## 
    ## $`btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc`
    ## DatasetNode (R6): 
    ##   verbose: FALSE    tries: 3    namespace prefix: d1
    ##   url: Projects/CEFI/regional_mom6/cefi_portal/northwest_atlantic/full_domain/hindcast/monthly/regrid/latest/btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   name: btm_temp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc
    ##   dataSize: 348.1
    ##   date: 2025-05-03T06:29:16.916Z
    ## 
    ## attr(,"class")
    ## [1] "cefi_dataset_nodes" "list"

#### As a table

You can transform the above to be a simpler table.

``` r
table = query_cefi(region = "northwest_atlantic",
                   product = "hindcast",
                   period = "monthly",
                   vars = c("btm_o2", "btm_temp"),
                   as = "table")
dplyr::glimpse(table)
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

#### As a CEFI catalog

Or perhaps more useful as catalog CEFI records.

``` r
catalog = query_cefi(region = "northwest_atlantic",
                   product = "hindcast",
                   period = "monthly",
                   vars = c("btm_o2", "btm_temp"),
                   as = "catalog")
dplyr::glimpse(catalog)
```

    ## Rows: 2
    ## Columns: 24
    ## $ cefi_filename         <chr> "btm_o2.nwa.full.hcast.monthly.regrid.r20230520.…
    ## $ cefi_variable         <chr> "btm_o2", "btm_temp"
    ## $ cefi_long_name        <chr> "Bottom Oxygen", "Bottom Temperature"
    ## $ cefi_unit             <chr> "mol kg-1", "deg C"
    ## $ cefi_output_frequency <chr> "monthly", "monthly"
    ## $ cefi_grid_type        <chr> "regrid", "regrid"
    ## $ cefi_rel_path         <chr> "cefi_portal/northwest_atlantic/full_domain/hind…
    ## $ cefi_ori_filename     <chr> "ocean_cobalt_btm.199301-201912.btm_o2.nc", "oce…
    ## $ cefi_archive_version  <chr> "/archive/acr/fre/NWA/2023_04/NWA12_COBALT_2023_…
    ## $ cefi_run_xml          <chr> "N/A", "N/A"
    ## $ cefi_region           <chr> "nwa", "nwa"
    ## $ cefi_subdomain        <chr> "full", "full"
    ## $ cefi_experiment_type  <chr> "hindcast", "hindcast"
    ## $ cefi_experiment_name  <chr> "nwa12_cobalt", "nwa12_cobalt"
    ## $ cefi_release          <chr> "r20230520", "r20230520"
    ## $ cefi_date_range       <chr> "199301-201912", "199301-201912"
    ## $ cefi_init_date        <chr> "N/A", "N/A"
    ## $ cefi_ensemble_info    <chr> "N/A", "N/A"
    ## $ cefi_forcing          <chr> "N/A", "N/A"
    ## $ cefi_data_doi         <chr> "10.5281/zenodo.7893386", "10.5281/zenodo.789338…
    ## $ cefi_paper_doi        <chr> "10.5194/gmd-16-6943-2023", "10.5194/gmd-16-6943…
    ## $ cefi_aux              <chr> "Postprocessed Data : regrid to regular grid", "…
    ## $ cefi_ori_category     <chr> "ocean_cobalt_btm", "ocean_cobalt_btm"
    ## $ cefi_opendap          <chr> "http://psl.noaa.gov/thredds/dodsC/Projects/CEFI…

It is this latter you can use to access data. Below we show how to open
the dataset, but to do more see the documentation for the [cefi R
package](https://github.com/BigelowLab/cefi).

``` r
x = cefi::cefi_open(dplyr::slice(catalog, 1))
x
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
