### LIBRARIES ###
library(ggplot2)
library(dplyr)

### USER DEFINED FUNCTIONS ###
read_streamflow_data <- function(file = './data/sacramento-bendbridge-paleo.csv'){
	df <- read.csv(file, header = TRUE)
	return(df)
}


#+++++++++++++++++++++++++
# Function to calculate the mean, median, and and the standard deviation
# for each group
#+++++++++++++++++++++++++
# data : a data frame
# varname : the name of a column containing the variable
#to be summariezed
# groupnames : vector of column names to be used as
# grouping variables


data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      median = median(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  return(data_sum)
}

### MAIN ###
setwd("~/R_code/Golf/data")
df <- read_streamflow_data()

df<- read.csv('sacramento-bendbridge-paleo.csv', sep = ",", header = TRUE)

# TODO

# 1. add a column to the dataframe and convert the annual flow from acre-foot to cubic meters 
df<- df %>%
  mutate(Flow_CM = Flow_AF * 1233.48) 

# 2. plot the time series of the flow in cubic meters
p <- ggplot(df, aes(Year, Flow_CM)) + 
  geom_point()
p

# 3. calculate the mean, median and standard deviation of the annual flow per calendar century (e.g. 901 - 1000, 1001 - 1100, ... 2001 - 2019)
df <- df %>%
  mutate(Century = ifelse(Year > 899 & Year < 1001, 10,
                          ifelse(Year > 1000 & Year < 1101, 11, 
                                 ifelse(Year > 1100 & Year < 1201, 12,
                                        ifelse(Year > 1200 & Year < 1301, 13,
                                               ifelse(Year > 1300 & Year < 1401, 14,
                                                      ifelse(Year > 1400 & Year < 1501, 15,
                                                             ifelse(Year > 1500 & Year < 1601, 16,
                                                                    ifelse(Year > 1600 & Year < 1701, 17,
                                                                           ifelse(Year > 1700 & Year < 1801, 18,
                                                                                  ifelse(Year > 1800 & Year < 1901, 19,
                                                                                         ifelse(Year > 1900 & Year < 2001, 20,
                                                                                                ifelse(Year > 2000 & Year < 2101, 21, NA
                                                                                                       )))))))))))))


df_summary <- data_summary(df, varname = "Flow_CM",
                           groupnames = c("Century"))


# (opt. add those three timeseries to the plot created in 2)

a <- ggplot() + 
  geom_point(df, aes(Year, Flow_CM)) + 
  geom_point(df_summary, aes(Century, median)) # not working?


a <- ggplot(df_summary, aes(x = Century, y = mean)) + 
  geom_point() +
  geom_errorbar(aes(ymin = mean-sd, ymax = mean+sd), width = .5,
                position=position_dodge(10))
a

  
# 4. re-order the data-frame so that the data are ordered by increasing mean flow
df_summary <- df_summary[order(df_summary$mean),]






