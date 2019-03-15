### LIBRARIES ###
library(ggplot2)

### USER DEFINED FUNCTIONS ###
read_streamflow_data <- function(file = '../data/sacramento-bendbridge-paleo.csv'){
	df <- read.csv(file, header = TRUE)
	return(df)
}

### MAIN ###
df <- read_streamflow_data()


# TODO

# 1. add a column to the dataframe and convert the annual flow from acre-foot to cubic meters
df$flow_m3 <- df$Flow_AF / 35.314667 

# 2. plot the time series of the flow in cubic meters
# p <- ggplot(...)
p <- ggplot(df, aes(x = Year, y = flow_m3)) +
  geom_line() +
  ylab("Flow (m^3)")
#plot(p)

# 3. calculate the mean, median and standard deviation of the annual flow per 
# calendar century (e.g. 901 - 1000, 1001 - 1100, ... 2001 - 2019)
yStart <- 901 #min(df$Year)
yEnd <- max(df$Year)
c <- (yEnd - yStart) %/% 100 + 1
cDf <- data.frame(year=vector(mode = "numeric", length = c),
                  fMean=vector(mode = "numeric", length = c),
                  fMedian=vector(mode = "numeric", length = c),
                  fSd=vector(mode = "numeric", length = c))
a <- 0
for (i in seq(901,2001,100)) {
  a <- a + 1
  cDf$year[a] <- i + 49
  cDf$fMean[a] <- mean(df$flow_m3[df$Year >= i & df$Year < (i+100)])
  cDf$fMedian[a] <- median(df$flow_m3[df$Year >= i & df$Year < (i+100)])
  cDf$fSd[a] <- sd(df$flow_m3[df$Year >= i & df$Year < (i+100)])
}

# (opt. add those three timeseries to the plot created in 2)
p <- p + geom_line(data = cDf, aes(x = year, y = fMean, colour = "Mean")) +
  geom_line(data = cDf, aes(x = year, y = fMedian, colour = "Median")) +
  geom_line(data = cDf, aes(x = year, y = fSd, colour = "Standard"))
plot(p)

# 4. re-order the data-frame so that the data are ordered by increasing mean flow
dfno <- df[order(df$flow_m3),]