##wide to long
#-------

df_w <- data.frame( ID = c(1, 2, 3),
                    TimeStamp = c('12.05.2019 11:34', '12.05.2019 12:34', '12.05.2019 13:34'),
                    A = c(0, 1, 0),
                    B = c(3, 1, 0),
                    C = c(5, 3, 3)
                    )
#http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/

#reshape from (base)
reshape(df_w, 
        direction = "long",
        timevar = "Atribut", 
        v.names = "Vrednost",
        varying = 3:5,
        times = c('A','B','C'))


library(tidyr)
df_l <- tidyr::gather(df_w, 
              key = "Atribut",
              gathercols = c("A", "B", "C"),
              value = "Vrednost")
#v obratni smeri:
tidyr::spread(df_l, key="Atribut", value="Vrednost")


library(reshape2)
reshape2:: melt(df_w, 
                id_vars = c("ID", "TimeStamp"),
                measure.vars = c("A","B","C"),
                variable.name = "Atribut",
                value.name = "Vrednost")


#from excel over clipboard:
x <- read.table(file = "clipboard", sep = "\t", header=TRUE)

#to excel over cliboard:
write.table(df_l, "clipboard", sep="\t", dec=",", row.names=FALSE, col.names=TRUE)
