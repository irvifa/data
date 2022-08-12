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

NEI_BC_LA <-
  filter(filtered_NEI, grepl("06037", fips) | grepl("24510", fips))
yearlyTotal_BC_LA <-
  aggregate(NEI_BC_LA$Emissions,
            list(NEI_BC_LA$year, NEI_BC_LA$fips),
            FUN = sum)
colnames(yearlyTotal_BC_LA) <- c("Year", "fips", "PM25")

plot6_img_path = paste(image_prefix_path, "plot6.png", sep = "/")
png(plot6_img_path, width = 480, height = 480)

p <-
  ggplot(data = yearlyTotal_BC_LA, aes(x = Year, y = PM25)) + geom_point(aes(color = fips), show.legend = FALSE) + facet_grid(fips ~ ., scale = "free_y") + geom_smooth(formula = y ~ x, method = "lm") + labs(title = "Comparing PM25 over Motorcycles.", subtitle =
                                                                                                                                                                                                                 "Baltimore (2410) and LA (06037)")
print(p)

dev.off()