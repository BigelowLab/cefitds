as_cefi_catalog = function(x = query_cefi(as = "url")){
  if(!requireNamespace("cefi")){
    stop("please install the cefi package first from https://github.com/BigelowLab/cefi")
  }
  
  
  
}


# hindcast
# variable_name.region.subdomain.experiment_type.output_frequency.grid_type.rYYYYMMDD.YYYY0M-YYYY0M.nc
# Season and decadal forecast (re-forecast) 
# variable_name.region.subdomain.experiment_type.output_frequency.grid_type.rYYYYMMDD.ensemble_info.iYYYY0M
# Long-term projection 
# variable_name.region.subdomain.experiment_type.output_frequency.grid_type.rYYYYMMDD.picontrol/historical/proj_forcing.ensemble_info.YYYY0M-YYYY0M


#' Parse a cefi URL into a table
#' 
#' @export
#' @param x one or more URLs
#' @return table
parse_url = function(x = c("sfc_co3_sol_calc.nwa.full.hcast.monthly.raw.r20230520.199301-201912.nc", 
                           "eparag100.nwa.full.hcast.monthly.raw.r20230520.199301-201912.nc", 
                           "sfc_no3lim_lgp.nwa.full.hcast.monthly.raw.r20230520.199301-201912.nc", 
                           "sfc_nh4lim_lgp.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc", 
                           "hfevapds.nwa.full.hcast.monthly.raw.r20230520.199301-201912.nc")){
  
}