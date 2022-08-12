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

filtered_SCC <- SCC %>% filter(grepl("Comb", SCC.Level.One)) %>% filter(grepl("[Cc]oal", SCC.Level.Three)) %>% filter(grepl("[Cc]oal", SCC.Level.Four))

filtered_NEI <- filter(NEI, NEI$SCC%in%filtered_SCC$SCC)
yearlyTotal <- aggregate(filtered_NEI$Emissions, list(filtered_NEI$year), FUN=sum)
colnames(yearlyTotal) <- c("Year", "PM25")
plot4_img_path = paste(image_prefix_path, "plot4.png", sep = "/")
png(plot4_img_path, width = 480, height = 480)

p <- ggplot(data=yearlyTotal, aes(x=Year, y=PM25)) + geom_point() + geom_smooth(formula= y ~ x, method="lm") + labs(title="PM25 in the US for Coal Combustion Sources")

print(p)
dev.off()