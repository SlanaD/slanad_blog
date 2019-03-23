
#https://bbc.github.io/rcookbook/
library(ggplot2)
library(gridExtra)

MojaTema <- function () 
{
    #names(pdfFonts()) #prikaze seznam fontov na razpolago.
    font <- "sans"
    ggplot2::theme(
        plot.title = ggplot2::element_text(family = font, size = 28, face = "bold", color = "#222222"), 
        plot.subtitle = ggplot2::element_text(family = font, size = 22, margin = ggplot2::margin(9, 0, 9, 0)), 
        plot.caption = ggplot2::element_blank(),
        legend.position = "top", legend.text.align = 0, 
        legend.background = ggplot2::element_blank(),
        legend.title = ggplot2::element_blank(), 
        legend.key = ggplot2::element_blank(),
        legend.text = ggplot2::element_text(family = font, size = 18, color = "#222222"), axis.title = ggplot2::element_blank(),
        axis.text = ggplot2::element_text(family = font, size = 18, color = "#222222"), 
        axis.text.x = ggplot2::element_text(margin = ggplot2::margin(5, b = 10)), 
        axis.ticks = ggplot2::element_blank(),
        axis.line = ggplot2::element_blank(), 
        panel.grid.minor = ggplot2::element_blank(),
        panel.grid.major.y = ggplot2::element_line(color = "#cbcbcb"),
        panel.grid.major.x = ggplot2::element_blank(), 
        panel.background = ggplot2::element_blank(),
        strip.background = ggplot2::element_rect(fill = "white"),
        strip.text = ggplot2::element_text(size = 22, hjust = 0)) }


data("economics")

head(economics)

p1 <- ggplot(data = economics, aes(x=date, y=pce)) + 
  geom_point() +
  labs(title="Naslov",
       subtitle = "Podnaslov")


p2 <- ggplot(data = economics, aes(x=date, y=pce)) + 
  geom_point() +
  MojaTema() +
  labs(title="Naslov",
       subtitle = "Podnaslov")

gridExtra::grid.arrange(p1, p2, nrow=1)



##----------------------------------------

#http://r.iresmi.net/2019/02/13/generate-multiple-language-version-plots/"
# Mauna Loa atmospheric CO2 change
# multi language plot for Wikipedia

library(tidyverse)
# Required packages
library(tidyverse)
library(gridExtra)
library(scales)
library(lubridate)

# Data --------------------------------------------------------------------

# http://scrippsco2.ucsd.edu/data/atmospheric_co2/primary_mlo_co2_record
# used during US gov shutdown
co2ml <- read_csv("http://scrippsco2.ucsd.edu/assets/data/atmospheric/stations/in_situ_co2/monthly/monthly_in_situ_co2_mlo.csv",
                  col_names = c("year", "month", "xls_date", "decimal",
                                "co2", "co2_seas_adj", "fit", "fit_seas_adj",
                                "co2_filled", "co2_filled_seas_adj"),
                  col_types = "iiiddddddd",
                  skip = 57,
                  na = "-99.99",
                  comment = "\"") %>% 
  group_by(year) %>% 
  mutate(year_mean = mean(co2_filled, na.rm = TRUE),
         delta = co2_filled - year_mean,
         vdate = ymd(paste0("2015-", month, "-01")))

# Generate the plot for each language -------------------------------------
vsebina = list(
  title = expression(paste("Monthly mean ", CO[2], " concentration ")),
  caption = paste("Data : R. F. Keeling, S. J. Walker, S. C. Piper and A. F. Bollenbacher\nScripps CO2 Program (http://scrippsco2.ucsd.edu). Accessed ", Sys.Date()),
  x = "Year",
  y = expression(paste(CO[2], " fraction in dry air (", mu, "mol/mol)")),
  x2 = "Month",
  y2 = expression(atop(paste(CO[2], " fraction in dry air (", mu, "mol/mol)"), "Departure from yearly average")),
  title2 = "Seasonal variation")

  current <- vsebina
  
  # main plot
  p1 <- ggplot(co2ml, aes(decimal, co2_filled)) + 	
    geom_line(color = "pink") +
    geom_point(color = "red", size = 0.6) +
    stat_smooth(span = 0.1) +
    scale_x_continuous(breaks = pretty_breaks()) +
    scale_y_continuous(breaks = pretty_breaks(4), minor_breaks = pretty_breaks(8)) +
    labs(
      x = current$x,
      y = current$y,
      title = current$title,
      subtitle = paste("Mauna Loa", min(co2ml$year), "-", max(co2ml$year)),
      caption = current$caption) +
    theme_bw() +
    theme(plot.caption = element_text(size = 7))
  
  # inset plot
  p2 <- ggplot(co2ml, aes(vdate, delta)) +
    geom_hline(yintercept = 0) +
    stat_smooth(span = 0.4, se = FALSE) +
    stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 0.3) + 
    scale_x_date(breaks = pretty_breaks(4), minor_breaks = pretty_breaks(12), labels = date_format("%b")) +
    labs(
      x = current$x2,
      y = current$y2,
      title = current$title2) +
    theme_bw()
  
  # merge the plots and export in SVG
  p1 + annotation_custom(grob = ggplotGrob(p2), xmin = 1957, xmax = 1991, ymin = 361, ymax = 412)
  
  #ggsave(file = paste("co2_mauna_loa", l, Sys.Date(), "wp.svg", sep = "_"), width = 20, height = 20, units = "cm", device = svg)
  
}

