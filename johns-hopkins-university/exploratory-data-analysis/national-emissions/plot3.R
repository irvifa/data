library("data.table")
library("ggplot2")

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
# Subset NEI data by Baltimore
NEI_BC <- subset(NEI, fips == "24510")
yearlyTotal <-
  aggregate(NEI_BC$Emissions, list(NEI_BC$year, NEI_BC$type), FUN = sum)
colnames(yearlyTotal) <- c("Year", "Type", "PM25")

plot3_img_path = paste(image_prefix_path, "plot3.png", sep = "/")
png(plot3_img_path, width = 480, height = 480)

p <-
  ggplot(data = yearlyTotal, aes(x = Year, y = PM25)) + geom_point(aes(color = Type), show.legend = FALSE) + facet_grid(Type ~ ., scales = "free_y") + geom_smooth(formula = y ~ x, method = "lm") + labs(title = "PM2.5 Over Time by Type", subtitle = "nonRoad, NonPoint, OnRoad Decreasing, Point Increasing")

print(p)
dev.off()
