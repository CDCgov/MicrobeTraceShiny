#' install_microbetrace
#'
#' @param dev
#'
#' @return NULL
#' @export
#'
#' @examples
#' MicrobeTraceShiny::install_microbetrace()
install_microbetrace <- function(dev = FALSE){
  env <- ifelse(dev, "dev", "prod")
  appDir <- system.file(env, package = "MicrobeTraceShiny")
  if(Sys.which('git') == '') throw("Cannot find git. Please install git and ensure it is available on your PATH.")
  system(paste('cd', appDir, '&& git clone --recurse-submodules https://github.com/CDCgov/MicrobeTrace.git www'))
  if(dev) system(paste0('cd ', appDir, '/www && git checkout -b dev --track origin/dev'))
  if(Sys.which('npm') == '') throw("Cannot find npm. Please install NodeJS and ensure it is available on your PATH.")
  system(paste0('cd ', appDir, '/www && npm install'))
}

#' launch_microbetrace
#'
#' @param dev
#'
#' @return NULL
#' @export
#'
#' @examples
#' MicrobeTraceShiny::launch_microbetrace()
launch_microbetrace <- function(dev = FALSE){
  env <- ifelse(dev, "dev", "prod")
  appDir <- system.file(env, package = "MicrobeTraceShiny")
  if(!file.exists(paste0(appDir, '/www'))) install_microbetrace(dev)
  shiny::runApp(appDir = appDir, launch.browser = TRUE)
}
