library(tidyverse)
library(gridExtra)
#library(reshape2)

#vzorčni testni podatki
#"date","pce","pop","psavert","uempmed","unemploy"

df <- data.frame(datum = economics$date,
                 populacija = economics$pop, 
                 nezaposleni = economics$unemploy,
                 stringsAsFactors=FALSE) 
df <- subset(df, datum > "2014-07-01")
#df.long <- reshape2::melt(df, id = "datum", measure = c("populacija", "nezaposleni"))

#grafi
#theme_set(theme_gray())


## LOESS
p2e <- ggplot(data=df, aes(x=datum, y=populacija) ) +
  geom_point() +
  geom_smooth(method = "loess") #loess


##Linija
p1a <- ggplot(data=df, aes(x=datum, y=populacija )) +
  geom_point() +
  geom_smooth(method = lm, se = F) +
  theme(axis.text.x=element_blank()) + xlab("LIN")

#ggplot(data=df.long, aes(x=datum, y=value, color=variable )) +
#  geom_point() +
#  geom_smooth(method = "lm", se = F)


## kvadratna povezava
p1b <- ggplot(data=df, aes(x=datum, y=nezaposleni )) +
  geom_point() +
  geom_smooth(method = lm, formula = y ~ x + I(x^2), se = T) +
  theme(axis.text.x=element_blank())  + xlab("KVAD")

#ggplot(data=df, aes(x=datum, y=nezaposleni )) +
#  geom_point() +
#  geom_smooth(method = lm, formula = y ~ poly(x, 2), se = T) +
#  geom_smooth(method = lm, se = F, color = "red", size = 0.5) +

## Spline
p1c <- ggplot(data=df, aes(x=datum, y=nezaposleni) ) +
  geom_point() + 
  geom_smooth(method = lm, formula = y ~ splines::bs(x, 3), se = TRUE) +
  theme(axis.text.x=element_blank()) + xlab("SPLINE")


gridExtra::grid.arrange(p1a, p1b, p1c, nrow=1)

p1 <- ggplot(data=df, aes(x=datum, y=nezaposleni )) +
  geom_point() +
  geom_smooth(method = lm, formula = y ~ poly(x, 2), se = T) +
  geom_smooth(method = lm, se = F, color = "#CD3333", size = 1) +
  xlab("LIN. in KVAD.")

p2 <- ggplot(data=df, aes(x=datum, y=nezaposleni) ) +
  geom_point() + 
  geom_smooth(method = lm, formula = y ~ splines::bs(x, 3), se = TRUE) +
  xlab("SPLINE") + ylab("")

gridExtra::grid.arrange(p1, p2, nrow=1)

##MA
###https://www.datascience.com/blog/introduction-to-forecasting-with-arima-in-r-learn-data-science-tutorials

library(forecast)
library(tseries)

nz <- ts(df$nezaposleni)
df$nz <- tsclean(nz)
df$ma <- ma(df$nz, order = 3) #moving average 3monts

p1 <- ggplot() +
  geom_point(data=df, aes(x=datum, y=nz)) +
  geom_line(data=df, aes(x=datum, y=ma), color="#1C86EE", size = 2) +
  ylab("nezaposleni") +
  xlab("MA")

p2 <- ggplot() +
  geom_point(data=df, aes(x=datum, y=nz)) +
  geom_smooth(data=df, aes(x=datum, y=nz), method = "loess", se=F) +
  ylab("") +
  xlab("LOESS")

gridExtra::grid.arrange(p1, p2, nrow=1)

#https://newonlinecourses.science.psu.edu/stat510/node/70/
  

