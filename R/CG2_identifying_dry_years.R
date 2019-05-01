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

dryPeriods <- function(flowDf, yrWindow, dryFlowMin, dryFlowMax, totToggle) {
  
  # Figure out the minimum and maximum years
  minYr <- min(flowDf$Year)
  maxYr <- max(flowDf$Year)
  
  # Figure out the starting year to match the year window
  startYr <- minYr + yrWindow - 1
  
  # Create empty vector
  dryVector <- character(length = nrow(flowDf))
  dryVector <- NA
  
  # Toggle signifies if we're looking at total/cumulative flow (1) or annual (0)
  if (totToggle == 0) {
    # Run through loop of all applicable years where window will work
    for (i in startYr:maxYr) {
      # Determine if any of the years meet the described flow conditions
      if ((any(flowDf$Flow_AF[flowDf$Year<=i & flowDf$Year>(i-yrWindow)] > 
               dryFlowMin) &
           any(flowDf$Flow_AF[flowDf$Year<=i & flowDf$Year>(i-yrWindow)] <= 
               dryFlowMax)) == TRUE) {
        dryVector[which(flowDf$Year == i)[1]] <- "Dry"
      } else {dryVector[which(flowDf$Year == i)[1]] <- "Not Dry"}
    }
  } else {
    for (i in startYr:maxYr) {
      if (sum(flowDf$Flow_AF[flowDf$Year<=i & flowDf$Year>(i-yrWindow)]) > 
               dryFlowMax) {
        dryVector[which(flowDf$Year == i)[1]] <- "Not Dry"
      } else {dryVector[which(flowDf$Year == i)[1]] <- "Dry"}
    }
  }
  
  return(as.factor(dryVector))
}

# 1. in df, identify the dry periods defined so that for a window of k = 1, 2, 3, 4 year(s), the minimum of the annual flow in the windows is equal or lower than the minimum of the annual flow during the 2012-2016 drought
minAflow <- min(df$Flow_AF[df$Year>2011 & df$Year<2017])
df$Yr1 <- dryPeriods(df, 1, 0, minAflow, 0)
df$Yr2 <- dryPeriods(df, 2, 0, minAflow, 0)
df$Yr3 <- dryPeriods(df, 3, 0, minAflow, 0)
df$Yr4 <- dryPeriods(df, 4, 0, minAflow, 0)

# 2. plot four times series on the same graph for each of the case of 1. i.e. for k = 1, 2, 3, 4
library(reshape2)
meltDf <- melt(df, id = c("Year", "Flow_AF"))
colnames(meltDf) <- c("Year", "Flow_AF", "yw", "value")
p1 <- ggplot(meltDf, aes(x = Year, y = Flow_AF, color = value)) +
  geom_point() +
  facet_wrap(~yw)
print(p1)

# 3. in df, identify the dry years defined so that the annual flow of a dry year is comprised (inclusively )between the minimum and the maximum of the annual flow of the 2012-2016 drought
maxAflow <- max(df$Flow_AF[df$Year>2011 & df$Year<2017])
df$inclusive <- dryPeriods(df, 1, minAflow, maxAflow, 0)

# 4. plot the time series with the dry periods from 3.
p2 <- ggplot(df, aes(x = Year, y = Flow_AF, color = inclusive)) +
  geom_point()
print(p2)

# 5. in df, identify the dry periods so that in a 5-years window the cumulative flow is equal or lower to the cumulative flow during the 2012-2016 drought.
totFlow <- sum(df$Flow_AF[df$Year>2011 & df$Year<2017])
df$cumulative <- dryPeriods(df, 5, 0, totFlow, 1)

# 6. plot the time series with the dry periods from 5.
p3 <- ggplot(df, aes(x = Year, y = Flow_AF, color = cumulative)) +
  geom_point()
print(p3)