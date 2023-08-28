install.packages(c("tidyverse","ggplot2"))
library(tidyverse)
library(ggplot2)
seoul_bike_sharing <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing.csv" 
#Task1
data <- read_csv(seoul_bike_sharing,"seoul_bike_sharing.csv")
typeof(data$)