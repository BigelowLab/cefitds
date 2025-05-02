
#' Browse a catalog page if interactive
#' 
#' @export
#' @param x a CatalogNode object
#' @param as chr one of "xml" or "html"
#' @return NULL invisibly
browse <- function(x = cefi_top(), as = c("xml", "html")){
  if (tolower(as[1]) == "xml"){
    x$browse()
  } else {
    if (!requireNamespace("httr")) stop("Please install the 'httr' package")
    httr::BROWSE(sub("xml", "html", x$url, fixed = TRUE))
  }
  invisible(NULL)
}

#' Retrieve the top level URI
#' 
#' @export
#' @param ext chr the extension to use (".xml" or ".html")
#' @return URI of the top level catalog
top_uri <- function(ext = c(".xml", ".html")[1]){
  uri = "https://psl.noaa.gov/thredds/catalog/Projects/CEFI/regional_mom6/cefi_portal/catalog"

  paste0(uri,ext)
}


#' Get the cefi top level catalog
#' 
#' @export
#' @param uri chr, the URI of the top level catalog
#' @return TopCatalog object
cefi_top <- function(uri = top_uri()){
  thredds::get_catalog(uri)
}

#' Get a TopCatalog for a specific region
#' 
#' @export
#' @param region chr one of "arctic", "great_lakes", "northeast_pacific" 
#'   "northwest_atlantic" or "pacific_islands"
#' @param domain chr, the name of the dataset catalog to retrieve
#'   from the regional catalog set to NULL or NA to skip
#' @param ... other arguments for `cefi_top()`
#' @return a TopCatalog object or possubly NULL if there is some error
cefi_region <- function(region = "northwest_atlantic", 
                        domain = "full_domain",
                        ...){
  
  reg = if (tolower(region[1]) %in% names(cefi::CEFI_REGIONS)){
    cefi::CEFI_REGIONS[[tolower(region[1])]]
  } else {
    tolower(region[1])
  }
  
  top = cefi_top(...)
  if (is.null(top)){
    warning("top catalog not available:", top_uri())
    return(NULL)
  }
  top = top$get_catalogs()[[reg]]
  
  if (!is_nullna(domain) && !is.null(top)){
    top = top$get_catalogs()[[domain[1]]]
  }
  
  top
}

#' Retrieve a CEFI data catalog
#' 
#' @export
#' @param region chr the name of the region
#' @param domain chr or NULL, the name of the domain (default is "full_domain")
#' @param product chr or NULL, the name of the product
#' @param period chr or NULL, the product period (default = "monthly")
#' @param format chr or NULL, one of "raw" or "regrid" (default)
#' @param what chr or NULL, the suite to retrieve, generally "latest"
#' @param vars chr or NULL, that short_name variables of interest
#' @param as chr one of "node", "table" (default)
#' @param ... other arguments for `cefi_top()`
#' @return a CatalogNode or a `cefi_dataset_nodes` class list of DatasetNode objects
query_cefi = function(region = "northwest_atlantic",
                      domain = "full_domain",
                      product = c("decadal_forecast", "hindcast", 
                                  "long_term_projection",
                                  "seasonal_forecast", 
                                  "seasonal_forecast_initialization", 
                                  "seasonal_reforecast")[2],
                      period = c("daily", "monthly", "yearly")[2],
                      format = c("raw", "regrid")[2],
                      what = "latest",
                      vars = c("btm_o2", "btm_temp"),
                      as = c("node", "table"),
                      ...){
  
  top = cefi_region(region[1], domain = domain[1], ...)
  if (!is.null(top) && !is_nullna(product[[1]])){
    top = top$get_catalogs()[[product[1]]]
    if (!is.null(top) && !is_nullna(period)) {
      top = top$get_catalogs()[[period[1]]]
      if (!is.null(top) && !is_nullna(format)){
        top = top$get_catalogs()[[format[1]]]
        if (!is.null(top) && !is_nullna(what)){
          top = top$get_catalogs()[[what[[1]]]]
          if (!is.null(top) && !is_nullna(vars)){
            # this swithes the output from TopCatalog to 
            # list of DatasetNode objects - me no like but ok
            top = select_datasets(top, vars = vars)
            class(top) = c("cefi_dataset_nodes", class(top))
          }
        }
      }
    }
  }
  top
}

#' Filter the datasets for ones starting with the specified
#' variable names
#' 
#' @export
#' @param x TopCatalog with datasets
#' @param vars chr one or more `short_name` variable names
#' @return list of one or more DatasetNode object
select_datasets = function(x = query_cefi(),
                            vars = c("btm_o2", "btm_temp")){
  
  if(!inherits(x, "CatalogNode")){
    stop("input 'x' must be CatalogNode class object")
  }

  xx = x$get_datasets()
  if(!is.null(xx)){
    ix = mgrepl(utils::glob2rx(paste0(vars, "*")), names(xx))
    xx = xx[ix]
  }
  xx
}

#' Given one or more DatasetNode objects, extract the URLs
#' 
#' @export
#' @param x a list of one or more DatasetNodes
#' @param stub chr, the base URL stub ofr opendap service
#' @return character vector of URLs for NetCDF resources
node_extract_url <- function(x = query_cefi(),
                        stub = "http://psl.noaa.gov/thredds/dodsC"){
  if (!inherits(x, "cefi_dataset_nodes")) stop("inout must inherit 'cefi_dataset_nodes'")
  sapply(x, function(x) file.path(stub, x$url))
}

#' Given one or more DatasetNode objects, extract a table
#' 
#' @export
#' @param x a list of one or more DatasetNodes
#' @param stub chr, the base URL stub ofr opendap service
#' @return a table of class "cefi_dataset_table"
node_extract_table <- function(x = query_cefi(),
                             stub = "http://psl.noaa.gov/thredds/dodsC"){
  if (!inherits(x, "cefi_dataset_nodes")) stop("input must inherit 'cefi_dataset_nodes'")
  r = sapply(x, function(x) file.path(stub, x$url)) |>
    parse_url() |>
    dplyr::mutate(
      name = sapply(x, function(x) x$name),
      dataSize = sapply(x, function(x) x$dataSize),
      .before = 1)
  class(r) <- c("cefi_dataset_table", class(r))
  r
}


