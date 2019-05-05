#https://www.analyticsvidhya.com/blog/2019/04/8-useful-r-packages-data-science/

#----------
#DataExplorer
#install.packages("DataExplorer")
#https://www.kaggle.com/nulldata/rapid-automated-eda-for-any-dataset

library(DataExplorer)
data(iris)
plot_str(iris)
plot_missing(iris)
plot_histogram(iris)
plot_density(iris)
plot_correlation(iris)
plot_bar(iris)
plot_boxplot(iris, by = "Species")
plot_scatterplot(iris, by = "Petal.Length")

create_report(iris)
#alternativa je lahko paket dlookr ali RtutoR ali autoEDA
#https://cran.r-project.org/web/packages/dlookr/vignettes/EDA.html


#-------
#Esquisse za pripravo ggplot2 grafov
#install.packages("esquisse")
library(esquisse)
data(iris)
esquisse::esquisser() #helps in launching the add-in


#------------
#RAndom forest with MLR
#install.packages("mlr")
library(mlr)

# Load the dataset
data(iris)
# create task
task <- makeClassifTask(id = "iris", iris, target = "Species")

# create learner
learner <- makeLearner("classif.randomForest")

# build model and evaluate
holdout(learner, task)

# measure accuracy
holdout(learner, task, measures = acc)

#https://www.analyticsvidhya.com/blog/2016/08/practicing-machine-learning-techniques-in-r-with-mlr-package/
  

#--------------


