#weighted prices of each day since -- to --
library(tidyverse)
library(anytime)
library(highcharter)
library(xts)
library(htmlwidgets)
library(webshot)

dataset <- read.csv('D:/R scripts/script_061120_Bitcoin_Data/Bitcoin Historical Data/bitstampUSD_1-min_data_2012-01-01_to_2020-09-14.csv')

#
df <- as.data.frame(dataset)
df2 <- df[!is.na(df$Weighted_Price),]
df2$Date <- anydate(df2$Timestamp)
df2 <- df2[, -c(1)]
df2 <- df2[c(8,1:7)]
df3 <- df2 %>%
  group_by(Date) %>%
  slice_tail(c(1, n())) %>%
  ungroup()
glimpse(df2)
df4 <- df3[-c(1), -c(2:7)]
df5 <- xts(df4[,-1], order.by = df4$Date)

#Plot
p <- highchart(type = 'stock') %>%
  hc_add_series(df5$Weighted_Price, name = 'USD') %>%
  hc_tooltip(useHTML = TRUE) %>%
  hc_title(text = 'Bitcoin historical price', 
           style = list(fontWeight = 'bold', fontSize = '20px'),
           align = 'left') %>%
  hc_subtitle(text = 'Period from January 2012 to September 2020',
              style = list(fontWeight = 'bold', fontSize = '15px'),
              align = 'left') %>%
  hc_credits(enabled = TRUE, text = 'Map by Antonela Tamagnini
             <br> Source: © bitcoincharts.com') %>%
  hc_add_theme(hc_theme_bloom())
p
saveWidget(widget = p, file = "plot.html")
webshot(url = 'plot.html', file = 'plot.png')
