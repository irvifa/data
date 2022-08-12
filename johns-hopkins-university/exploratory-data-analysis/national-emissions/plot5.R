library("data.table")
library("ggplot2")
library("dplyr")

data_prefix_path = "data"
image_prefix_path = "img"

if (!dir.exists(data_prefix_path)) {
  dir.create(data_prefix_path)
}

if (!dir.exists(image_prefix_path)) {
  dir.create(image_prefix_path)
}

scc_file_path = paste(data_prefix_path, "Source_Classification_Code.rds", sep =
                        "/")
nei_file_path = paste(data_prefix_path, "summarySCC_PM25.rds", sep =
                        "/")
SCC <- data.table::as.data.table(x = readRDS(file = scc_file_path))
NEI <- data.table::as.data.table(x = readRDS(file = nei_file_path))

filtered_SCC <-
  filter(
    SCC,
    grepl("Vehicles", SCC.Level.Three) |
      grepl("Motorcycles", SCC.Level.Three) |
      grepl("Trucks", SCC.Level.Three)
  )
filtered_NEI <- filter(NEI, NEI$SCC %in% filtered_SCC$SCC)

NEI_BC <- subset(filtered_NEI, fips == "24510")
yearlyTotal <-
  aggregate(NEI_BC$Emissions, list(NEI_BC$year), FUN = sum)
colnames(yearlyTotal) <- c('Year', "PM25")


plot5_img_path = paste(image_prefix_path, "plot5.png", sep = "/")
png(plot5_img_path, width = 480, height = 480)

p <-
  ggplot(data = yearlyTotal, aes(x = Year, y = PM25)) + geom_point() + geom_smooth(formula = y ~ x, method =
                                                                                     "lm") + labs(title = "PM25 in baltimore City for Motorcycle")

print(p)

dev.off()