setClass("observationDate")
setAs("character","observationDate", function(from) as.Date(from, format="%d/%m/%Y"))

# Reads observations from input file where observation date is within a specified range
# and returns results as string connection
filteredObservationsCon <- function(fileName, dateFrom, dateTo, chunkSize = 10000) {
        inputFile <- file(fileName, "r")
        headers <- strsplit(readLines(inputFile, 1), ';')[[1]]
        rows <- vector()
        
        while (length(lines <- readLines(inputFile, n = chunkSize, warn = FALSE)) > 0) {
                lines <- Filter(f=function(line) {
                        sampleDate <- as(strsplit(line, ';')[[1]], 'observationDate')
                        sampleDate >= dateFrom && sampleDate <= dateTo
                }, lines)
                rows <- c(rows, lines)
        }
        
        close(inputFile)
        
        textConnection(rows)
}

# Reads observations from input file where observation date is within a specified range.
# If chunk size is specified, data is processed in chunks to reduce memory usage, 
# but with reduced performance
readObservations <- function(fileName, dateFrom, dateTo, chunkSize = 0) {
        dateFrom <- as.Date(dateFrom)
        dateTo <- as.Date(dateTo)
        
        if (chunkSize > 0) {
                con <- filteredObservationsCon(fileName, dateFrom, dateTo, chunkSize = 0)
        }
        else {
                con <- file(fileName, "r")
        }
        
        result <- read.csv(con, sep=';', na.strings=c("?"),
                 colClasses=c('observationDate', 'character', 'numeric', 'numeric',
                              'numeric', 'numeric', 'numeric', 'numeric', 'numeric'))
        
        if(isOpen(con)) {
                close(con)
        }
        
        result <- result[result$Date >= dateFrom & result$Date <= dateTo,]
        
        cbind(DateTime = as.POSIXct(paste(result$Date, result$Time), format="%Y-%m-%d %H:%M:%S"),
              result[,!(names(result) %in% c('Date', 'Time'))])
}