### LIBRARIES ###
library(ggplot2)

### USER DEFINED FUNCTIONS ###
read_streamflow_data <- function(file = './data/sacramento-bendbridge-paleo.csv'){
	df <- read.csv(file, header = TRUE)
	return(df)
}

AF_to_M3 <- function(row) return(row * 1233.48)

plot_streamflow <- function(df, add_stats = FALSE){
	p <- ggplot(df, aes(x = Year, y = Flow_M3)) + geom_line(alpha = 0.6)
	if (add_stats){
		p <- p + geom_line(aes(y = mean.Flow_M3), col = "blue", lwd = 1.5)
		p <- p + geom_line(aes(y = median.Flow_M3), col = "red", lwd = 1.5)
	}
	print(p)
}

add_century <- function(df){
	df$century <- (df$Year - 1) %/% 100
	return(df)
}

add_stats <- function(df, l.fun = c("mean", "median", "sd")){
	l.century <- unique(df$century)
	cen_stats <- sapply(l.century, function(cen){
		.df <- df[df$century == cen, ]
		stats <- sapply(l.fun, function(fn){
			funs <- apply(.df, MARGIN = 2, FUN = fn)
			return(funs[3])
		})
	})
	cen_stats <- as.data.frame(t(cen_stats))
	cen_stats$century <- l.century
	df <- merge(df, cen_stats, by.y = "century")
	return(df)
}


### MAIN ###
df <- read_streamflow_data()

# TODO
# 1. add a column to the dataframe and convert the annual flow from acre-foot to cubic meters 
df$Flow_M3 <- AF_to_M3(df$Flow_AF)

# 2. plot the time series of the flow in cubic meters
plot_streamflow(df)

# 3. calculate the mean, median and standard deviation of the annual flow per calendar century (e.g. 901 - 1000, 1001 - 1100, ... 2001 - 2019)
df <- add_century(df)
df <- add_stats(df)

# (opt. add those three timeseries to the plot created in 2)
plot_streamflow(df, add_stats = TRUE)

# 4. re-order the data-frame so that the data are ordered by increasing mean flow
df <-  df[order(df$mean.Flow_M3), ]
print(df)