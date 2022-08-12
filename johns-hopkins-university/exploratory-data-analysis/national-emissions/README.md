## National Emissions

### Description
Additional information about the variables, data and transformations used in the course project for the Johns Hopkins Exploratory Data Analysis course.

### Source Data
Data + Description can be found here [EPA National Emissions Inventory web site](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)

## Dataset Description

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.

```
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
```

- fips: A five-digit number (represented as a string) indicating the U.S. county
- SCC: The name of the source as indicated by a digit string (see source code classification table)
- Pollutant: A string indicating the pollutant
- Emissions: Amount of PM2.5 emitted, in tons
- type: The type of source (point, non-point, on-road, or non-road)
- year: The year of emissions recorded


## Running the code
- All parameters provided within the `.Renviron`
- Run the `get_data.R` script.
- Run the `plot1.R` to get plot1 image.
- Run the `plot2.R` to get plot2 image.
- Run the `plot3.R` to get plot3 image.
- Run the `plot4.R` to get plot4 image.
- Run the `plot5.R` to get plot4 image.
- Run the `plot6.R` to get plot4 image.
- All of the images will be available under `img` directory.
