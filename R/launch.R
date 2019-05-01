#' install_microbetrace
#'
#' @param branch Which branch of MicrobeTrace should we install?
#' @param force Should MicrobeTrace be re-installed if it's already installed?
#' @param useGit Should we attempt to use git to get MicrobeTrace?
#'
#' @return Boolean TRUE if successful, FALSE if not.
#' @export
#'
#' @examples
#' MicrobeTraceShiny::install_microbetrace()
install_microbetrace <- function(branch = 'master', force = FALSE, useGit = FALSE){
  if(useGit && Sys.which('git') == ''){
    warning("Cannot find git. Please set useGit = FALSE or install git and ensure it is available on your PATH.")
    return(FALSE)
  }
  appDir <- system.file(branch, package = "MicrobeTraceShiny")
  if(dir.exists(paste0(appDir, '/www'))){
    if(force){
      unlink(paste0(appDir, '/www'), recursive = TRUE)
    } else {
      warning("MicrobeTrace appears to already be installed! Use force = TRUE if you want to reinstall MicrobeTrace.")
      return(FALSE)
    }
  }
  if(useGit){
    system(paste('cd', appDir, '&& git clone --recurse-submodules https://github.com/CDCgov/MicrobeTrace.git www'))
    if(branch != 'master') system(paste0('cd ', appDir, '/www && git checkout -b ', branch, ' --track origin/', branch))
  } else {
    zipName <- paste0('MicrobeTrace-', branch, '.zip')
    utils::download.file(
      paste0('https://github.com/CDCgov/MicrobeTrace/archive/', branch, '.zip'),
      paste0(appDir, '/', zipName)
    )
    utils::unzip(paste0(appDir, '/', zipName), exdir = appDir)
    if(!file.rename(paste0(appDir, '/MicrobeTrace-', branch), paste0(appDir, '/www'))){
      warning("Failed to rename MicrobeTrace Directory. Was it downloaded correctly?")
      return(FALSE)
    }
  }
  return(TRUE)
}

#' launch_microbetrace
#'
#' @param branch Which branch of MicrobeTrace should we launch?
#' @param port On what port should the Shiny Server Launch?
#'
#' @return NULL
#' @export
#'
#' @examples
#' MicrobeTraceShiny::launch_microbetrace()
launch_microbetrace <- function(branch = 'master', port){
  appDir <- system.file(branch, package = "MicrobeTraceShiny")
  goForLaunch <- TRUE
  if(!dir.exists(paste0(appDir, '/www'))){
    warning("Cannot find MicrobeTrace! Attempting to install...", immediate. = TRUE)
    goForLaunch <- install_microbetrace(branch)
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
