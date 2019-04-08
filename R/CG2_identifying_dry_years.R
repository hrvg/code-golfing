### LIBRARIES ###
library(ggplot2)

### USER DEFINED FUNCTIONS ###
read_streamflow_data <- function(file = './data/sacramento-bendbridge-paleo.csv'){
	df <- read.csv(file, header = TRUE)
	return(df)
}

### MAIN ###
df <- read_streamflow_data()


# TODO

# 1. in df, identify the dry periods defined so that for a window of k = 1, 2, 3, 4 year(s), the minimum of the annual flow in the windows is equal or lower than the minimum of the annual flow during the 2012-2016 drought

# 2. plot four times series on the same graph for each of the case of 1. i.e. for k = 1, 2, 3, 4

# 3. in df, identify the dry years defined so that the annual flow of a dry year is comprised (inclusively )between the minimum and the maximum of the annual flow of the 2012-2016 drought

# 4. plot the time series with the dry periods from 3.

# 5. in df, identify the dry periods so that in a 4-years window the cumulative flow is equal or lower to the cumulative flow during the 2012-2016 drought.

# 6. plot the time series with the dry periods from 5.