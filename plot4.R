source('readObservations.R')

if(!exists('observations')) {
        observations <- readObservations('household_power_consumption.txt', '2007-02-01', '2007-02-02')
}

png('plot4.png', width=480, height=480)
opar <- par() # Original parameters
par(mfrow=c(2, 2), cex=0.8)


plot(observations$DateTime, observations$Global_active_power, type='l',
     xlab=NA, ylab='Global Active Power')

plot(observations$DateTime, observations$Voltage, type='l',
     ylab = 'Voltage', xlab='datetime')

plot(observations$DateTime, observations$Sub_metering_1, type='l',
     ylab = 'Energy sub metering', xlab=NA, col="black")
lines(observations$DateTime, observations$Sub_metering_2, col="red")
lines(observations$DateTime, observations$Sub_metering_3, col="blue")
legend("topright", 
       legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       col = c("black", "red", "blue"),
       lty = c(1, 1), cex=0.75)

plot(observations$DateTime, observations$Global_reactive_power, type='l',
     xlab='datetime', ylab='Global_reactive_power')

dev.off()

par(opar)          # restore original settings