library("data.table")

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

yearlyTotalEmissions <- aggregate(NEI$Emissions, list(NEI$year), FUN=sum)
plot1_img_path = paste(image_prefix_path, "plot1.png", sep = "/")
png(plot1_img_path, width = 480, height = 480)

plot(
  yearlyTotalEmissions$Group.1,
  yearlyTotalEmissions$x,
  xlab = "Year",
  ylab = "Yearly Total PM2.5 Emissions (in Tons)",
  main= "Total PM2.5 Emissions over time for United States",
  pch=20,
  xaxt="n"
)

xTicks <- seq(1999, 2008, 3)
axis(side=1, at=xTicks)

fitLine <- c(yearlyTotalEmissions)
abline(lm(fitLine$x~fitLine$Group.1))

dev.off()
