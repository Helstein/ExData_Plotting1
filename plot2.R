source('readObservations.R')

if(!exists('observations')) {
        observations <- readObservations('household_power_consumption.txt', '2007-02-01', '2007-02-02')
}


png('plot2.png', width=480, height=480)

plot(observations$DateTime, observations$Global_active_power, type='l',
     ylab = 'Global Active Power (kilowatts)', xlab=NA)

dev.off()