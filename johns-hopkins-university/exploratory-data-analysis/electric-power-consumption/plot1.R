#Reads in data from file then subsets data for specified dates

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
powerDT <- data.table::fread(input = file_path
                             , na.strings = "?")

# Prevents histogram from printing in scientific notation
powerDT[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Change Date Column to Date Type
powerDT[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# Filter Dates for 2007-02-01 and 2007-02-02
powerDT <- powerDT[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

plot1_img_path = paste(image_prefix_path, "plot1.png", sep = "/")
png(plot1_img_path, width = 480, height = 480)

## Plot 1
hist(
  powerDT[, Global_active_power],
  main = "Global Active Power",
  xlab = "Global Active Power (kilowatts)",
  ylab = "Frequency",
  col = "Red"
)

dev.off()