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

#' A wrapper around httr::GET, providing the base url for Danmarks Statistik and
#' and sends a GET request based on the given inputs.
#'
#' @param call A string with inputs. One of c("subjects", "tables", "tableinfo",
#' "data") for retrieving subjects, tables, table meta data and data
#' respectively.
#' @param subjects A vector of strings providing specific subjects of interest.
#' @param tables A vector of strings providing specific tables.
#' @param variables A list containing various variables of interest
#'
#' @return A data frame of the desired data.
#'
#' @export
#'
danStatGET <- function(call, subject = NULL, table = NULL, variables = NULL) {

  path <- paste0("http://api.statbank.dk/v1/",
                 call,
                 "?lang=en&format",
                 if (!is.null(subject)) subject,
                 if (call == "subjects" | call == "tables") "JSON")

  data <- path %>%
    GET() %>%
    content(as = "text")

  return(data)
}

#' Function importing the various subjects from Danmarks Statistik.
#'
#' @return A vector containing the subjects
#'
#' @export
#'
importSubjects <- function() {
  danStatGET("subjects") %>%
    fromJSON()
}

#' Function importing the various tables from Danmarks statistik.
#'
#' @param subject A string with a subject from the subjects list.
#'
#' @return A vector of strings containing the table names.
#'
#' @export
#'
importTables <- function(subject) {
  danStatGET("tables", subject = subject) %>%
    fromJSON()
}
