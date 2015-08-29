#' Function importing data from the API of Danmarks Statistik. A wrapper around
#' httr.
#'
#' @param monthFrom A date string in the format of (%Y-%m-%d)
#' @param monthTo A date string in the format of (%Y-%m-%d)
#' @return A data frame of the requested data.
#'
#' @export
#'
importData <- function(monthFrom, monthTo) {

  monthFrom %<>% as.Date()
  monthTo %<>% as.Date()

  monthSeries <- seq(monthFrom, monthTo, by = "1 month") %>%
    format("%Y-%m") %>%
    gsub("-", "M", .) %>%
    paste(collapse = "%2C")

  path <- paste0("http://api.statbank.dk/v1/data/PRIS6/JSONSTAT?lang=en&valueP",
                 "resentation=Default&timeOrder=Ascending&VAREGR=*&ENHED=*&TID",
                 "=", monthSeries)

  statData <- path %>%
    GET() %>%
    content() %>%
    fromJSONstat() %>%
    `[[`(1) %>%
    transmute(commodityGroup = `commodity group` %>%
                gsub("^\\S*", "", .) %>%
                as.character(),
              unit = unit %>% as.character(),
              time = time %>%
                gsub("M", "-", .) %>%
                paste0("-01") %>%
                as.Date() %>%
                format("%Y-%m"),
              value = value)

  return(statData)
}
