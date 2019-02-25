

#Original pc-Axis datoteka aka px je v ANSI kondiranju. Seveda na oknih popolna zmeda s sumniki.
#najprej nalozim datoteko v originalnem formatiranju - na sreco je vecina datotek majhnih - all in memomry
px <- readLines(con = file("0701031S.px"), encoding = "ANSI_X3.4-1986", skipNul = TRUE)
#zapises v LATIN1 in se resis sumnikov in podobnega
cat(px, file = file("temp.px", "w", encoding="LATIN1"), sep = "\n")

#sedaj pa lahko uporabis paket pxR. Problem v paketu dela funcija a <- scan(filename, what = "character", sep = "\n", quiet = TRUE, fileEncoding = encoding)
#paket je githubu in ce se komu ljubi: fork in popravek v tej funciji
library(pxR)
pxo <- read.px("temp.px")
pxd <- as.data.frame(pxo)

#Sedaj pa izvozis nice tidy data v excel, ce zelis.
library(writexl)
writexl::write_xlsx(pxd, path = "tempPX.xlsx")

#pocistim
rm(list=c("pxd","pxo", "px"))
