library("data.table")

data_prefix_path = "data"
image_prefix_path = "img"

if (!dir.exists(data_prefix_path)) {
  dir.create(data_prefix_path)
}

if (!dir.exists(image_prefix_path)) {
  dir.create(image_prefix_path)
}

file_path = paste(data_prefix_path, "household_power_consumption.txt", sep =
                    "/")
#Reads in data from file then subsets data for specified dates
powerDT <- data.table::fread(input = file_path
                             , na.strings="?"
)

# Prevents Scientific Notation
powerDT[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Making a POSIXct date capable of being filtered and graphed by time of day
powerDT[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates for 2007-02-01 and 2007-02-02
powerDT <- powerDT[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

plot2_img_path = paste(image_prefix_path, "plot2.png", sep = "/")
png(plot2_img_path, width=480, height=480)

## Plot 2
plot(x = powerDT[, dateTime]
     , y = powerDT[, Global_active_power]
     , type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()