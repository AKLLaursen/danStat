#' Function providing plots for the various data available from Danmarks
#' statistik
#'
#' @return A plot element
#'
#' @export
#'
plotData <- function(inputFrame, unit, commodityGroup) {

  inputFrame %<>% filter(unit = unit,
                         commodityGroup = commodityGroup)
}
