### LIBRARIES ###
library(ggplot2)
library(reshape2)

### USER DEFINED FUNCTIONS ###
read_streamflow_data <- function(file = './data/sacramento-bendbridge-paleo.csv'){
	df <- read.csv(file, header = TRUE)
	return(df)
}

######### FUNCTIONS #########
get_ind_drought <- function(start = 2012, end = 2016, data = df, column = "Year") which(data[[column]] %in% start:end)
get_dry <- function(data = df, column = "Flow_AF", start = 2012, end = 2016, window_len = 2, range = FALSE, cumulative = FALSE){
	dry <- rep("wet", nrow(data))
	if (!range){
		if (!cumulative){
			rollmin <- zoo::rollapplyr(data[[column]], width = window_len, FUN = min)
			ind <- which(rollmin <= min(data[[column]][get_ind_drought()]))
			dry[ind] <- "dry"			
		} else {
			rollsum <- zoo::rollapplyr(data[[column]], width = window_len, FUN = sum)
			ind <- which(rollsum <= sum(data[[column]][get_ind_drought()]))
			dry[ind] <- "dry"			
		}
	} else {
		ind <- which(data[[column]] + min(data[[column]][get_ind_drought()]) <= max(data[[column]][get_ind_drought()]))
		dry[ind] <- "dry"
	}
	return(dry)
}


### MAIN ###
df <- read_streamflow_data()

# TODO

# 1. in df, identify the dry periods defined so that for a window of k = 1, 2, 3, 4 year(s), the minimum of the annual flow in the windows is equal or lower than the minimum of the annual flow during the 2012-2016 drought
for (w in 1:4) df[[paste0("dry", w)]] <- get_dry(window_len = w)

# 2. plot four times series on the same graph for each of the case of 1. i.e. for k = 1, 2, 3, 4
melted <- melt(df, id.vars = c("Year", "Flow_AF"))	
p2 <- ggplot(melted, aes(x = Year, y = Flow_AF, group = value, color = value)) + geom_point(cex = .5) + facet_grid(variable ~ .)
print(p2)

# 3. in df, identify the dry years defined so that the annual flow of a dry year is comprised (inclusively )between the minimum and the maximum of the annual flow of the 2012-2016 drought
df$dry_range <- get_dry(range = TRUE)

# 4. plot the time series with the dry periods from 3.
p4 <- ggplot(df, aes(x = Year, y = Flow_AF, group = dry_range, color = dry_range)) + geom_point(cex = .5)
print(p4)

# 5. in df, identify the dry periods so that in a 5-years window the cumulative flow is equal or lower to the cumulative flow during the 2012-2016 drought.
df$dry_cumulative <- get_dry(window_len = 5, cumulative = TRUE)

# 6. plot the time series with the dry periods from 5.
p6 <- ggplot(df, aes(x = Year, y = Flow_AF, group = dry_cumulative, color = dry_cumulative)) + geom_point(cex = .5)
print(p6)