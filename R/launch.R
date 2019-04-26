#' install_microbetrace
#'
#' @param dev Should the MicrobeTrace dev branch be installed?
#' @param force Should MicrobeTrace be re-installed if it's already installed?
#' @param useGit Should we attempt to use git to get MicrobeTrace?
#'
#' @return Boolean TRUE if successful, FALSE if not.
#' @export
#'
#' @examples
#' MicrobeTraceShiny::install_microbetrace()
install_microbetrace <- function(dev = FALSE, force = FALSE, useGit = FALSE){
  if(useGit && Sys.which('git') == ''){
    warning("Cannot find git. Please set useGit = FALSE or install git and ensure it is available on your PATH.")
    return(FALSE)
  }
  env <- ifelse(dev, "dev", "master")
  appDir <- system.file(env, package = "MicrobeTraceShiny")
  if(file.exists(paste0(appDir, '/www/node_modules'))){
    if(force){
      unlink(paste0(appDir, '/www/'), recursive = TRUE)
    } else {
      warning("MicrobeTrace appears to already be installed! Use force = TRUE if you want to reinstall MicrobeTrace.")
      return(FALSE)
    }
  }
  if(useGit){
    system(paste('cd', appDir, '&& git clone --recurse-submodules https://github.com/CDCgov/MicrobeTrace.git www'))
    if(dev) system(paste0('cd ', appDir, '/www && git checkout -b dev --track origin/dev'))
  } else {
    zipName <- paste0('MicrobeTrace-', env, '.zip')
    utils::download.file(
      paste0('https://github.com/CDCgov/MicrobeTrace/archive/', env, '.zip'),
      paste0(appDir, '/', zipName)
    )
    utils::unzip(paste0(appDir, '/', zipName), exdir = appDir)
    if(!file.rename(paste0(appDir, '/MicrobeTrace-', env), paste0(appDir, '/www'))){
      warning("Failed to rename MicrobeTrace Directory. Was it downloaded correctly?")
      return(FALSE)
    }
  }
  return(TRUE)
}

#' launch_microbetrace
#'
#' @param dev Should we launch the dev Version of MicrobeTrace?
#' @param port On what port should the Shiny Server Launch?
#'
#' @return NULL
#' @export
#'
#' @examples
#' MicrobeTraceShiny::launch_microbetrace()
launch_microbetrace <- function(dev = FALSE, port){
  env <- ifelse(dev, "dev", "master")
  appDir <- system.file(env, package = "MicrobeTraceShiny")
  goForLaunch <- TRUE
  if(!file.exists(paste0(appDir, '/www'))){
    warning("Cannot find MicrobeTrace! Attempting to install...", immediate. = TRUE)
    goForLaunch <- install_microbetrace(dev)
  }
  if(!goForLaunch){
    warning('Could not launch MicrobeTrace!', immediate. = TRUE)
    return()
  }
  if(missing(port)){
    shiny::runApp(appDir = appDir, launch.browser = TRUE)
  } else {
    shiny::runApp(appDir = appDir, launch.browser = TRUE, port = port)
  }
}
