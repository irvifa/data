# Read environment variable,
# we put configuration such as the url for dataset through .Renviron
readRenviron(paste(getwd(), ".Renviron", sep = "/"))

# Get dataset_url from the enironment variable.
data_url = Sys.getenv("dataset_url")
data_prefix_path = "data"

# Create directory if not exist.
if (!dir.exists(data_prefix_path)) {
  dr.create(data_prefix_path)
}

local_data_path = paste(data_prefix_path, "data.zip", sep="/")
# Download dataset from provided url
download.file(data_url, local_data_path)

# Unzip dataset to dedicated directory.
unzip(local_data_path, exdir = data_prefix_path)
