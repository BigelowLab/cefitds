#' Parse a cefi URL into a table
#' 
#' @export
#' @param x one or more URLs
#' @return table
parse_url = function(x = c("btm_htotal.nwa.full.hcast.daily.raw.r20230520.199301-201912.nc", 
                           "phycos.nwa.full.hcast.daily.regrid.r20230520.199301-201912.nc", 
                           "intppdiat.nwa.full.hcast.monthly.raw.r20230520.199301-201912.nc", 
                           "ffetot_btm.nwa.full.hcast.monthly.regrid.r20230520.199301-201912.nc")){
  cefi::parse_url(x)
}