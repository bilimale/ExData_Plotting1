#
# Plot 3
#

library(data.table)

#
# Get Assignment Data
#
getDataFromWeb <- function() {
  
  if( dir.exists("./assignment_exp") == FALSE ) {
    dir.create("./assignment_exp", showWarnings = TRUE, mode = "0777")
  }
  setwd("./assignment_exp")
  #if( dir.exists("DataSet") == TRUE) quit(status = 1)
  
  url <-  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "DataSet.zip")
  
  try(system("unzip -o DataSet.zip",intern = TRUE))
  
  return
}

#
# Subset the data required for processing
# Only need dataset from 2007-02-01 and 2007-02-02
#
subsetDataRequired <- function() {
  
  readConsump <- as.data.table(fread(as.character("./household_power_consumption.txt")))
  requireData <- readConsump[Date=="1/2/2007" | Date=="2/2/2007"]
  
  requireData
}

#
# Histogram and copy to png file
#
plotAndSave <- function(requireData, plotname) {
  dev.set(2)
  par(mfrow = c(1,1))
  plot(x = as.POSIXct(paste(as.Date(requireData$Date, "%d/%m/%Y"), requireData$Time), tz = "UCT"), 
       requireData$Sub_metering_1, type = "l", xlab = "", col = "Black", ylab = "Energy Sub Metering")
  points(x = as.POSIXct(paste(as.Date(requireData$Date, "%d/%m/%Y"), requireData$Time), tz = "UCT"), 
       requireData$Sub_metering_2, type = "l", xlab = "", col = "Red")
  points(x = as.POSIXct(paste(as.Date(requireData$Date, "%d/%m/%Y"), requireData$Time), tz = "UCT"), 
         requireData$Sub_metering_3, type = "l", xlab = "", col = "Blue")
  
  legend("topright", "topright", lty = 1 , col = c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  dev.copy(png, file = plotname) 
  dev.off()
}

getDataFromWeb()
requiredData <- subsetDataRequired()
plotAndSave(requireData, "plot3.png")
