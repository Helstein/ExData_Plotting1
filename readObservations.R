
# Reads observations from input file where observation date is within a specified range.
# Data is readed in chunks to reduce memory usage
readObservations <- function(fileName, dateFrom, dateTo, chunkSize = 10000) {
        inputFile <- file(fileName, "r")
        dateFrom <- as.Date(dateFrom)
        dateTo <- as.Date(dateTo)
        headers <- strsplit(readLines(inputFile, 1), ';')[[1]]
        rows <- vector()
        setAs("character","observationDate", function(from) as.Date(from, format="%d/%m/%Y"))
        setAs("character","observationTime", function(from) strptime(from, "%H:%M:%S"))
        
        while (length(lines <- readLines(inputFile, n = chunkSize, warn = FALSE)) > 0) {
                lines <- Filter(f=function(line) {
                        sampleDate <- as(strsplit(line, ';')[[1]], 'observationDate')
                        sampleDate >= dateFrom && sampleDate <= dateTo
                }, lines)
                rows <- c(rows, lines)
        }
        
        close(inputFile)
        
        con <- textConnection(rows)
        result <- read.table(con, col.names=headers, sep=';', header=FALSE, 
                   colClasses=c('observationDate', 'observationTime', 'numeric', 'numeric',
                                'numeric', 'numeric', 'numeric', 'numeric', 'numeric'))
        close(con)
        result
}