source('readObservations.R')

if(!exists('observations')) {
        observations <- readObservations('household_power_consumption.txt', '2007-02-01', '2007-02-02')
}


png('plot1.png', width=480, height=480)

hist(observations$Global_active_power, 
     col="red", main="Global Active Power", 
     xlab ="Global Active Power (kilowatts)", ylab = "Frequency")

dev.off()