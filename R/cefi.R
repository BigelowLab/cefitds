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



#' Match a cefi_dataset_table to a CEFI_catalog table
#' 
#' @export
#' @param x a cefi_dataset_table object
#' @return a CEFI_catalog matching the rows of `x`
match_catalog_table = function(x = node_extract_table()){
  
  x |>
    dplyr::group_by(.data$region, .data$experiment_type) |>
    dplyr::group_map(
      function(tbl, key){
       y = cefi::read_catalog(uri = cefi::catalog_uri(region = key$region,
                                                xcast = key$experiment_type))
       dplyr::slice(y, match(basename(x$url), basename(y$cefi_opendap)))
      }
    ) |> 
    dplyr::bind_rows()
}
