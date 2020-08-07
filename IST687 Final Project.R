################################################
# IST 387/687, Standard Homework Heading
#
# Student name: Eunmi Jeong
# Homework number: Final project
# Date due: 1 May
#
# Attribution statement: (choose the statements that are true)
# 2. I did this work with help from the book and the professor and these Internet sources: https://rstudio-pubs-static.s3.amazonaws.com/259095_2f8cb24b43284692a8af916bd447931d.html
# Get a clean test of homework code
dev.off() # Clear the graph window
cat('\014')  # Clear the console
rm(list=ls()) # Clear all user objects from the environment!!!
# Set working directory 
setwd("~/Desktop/SU IM DOC/'20 SPRING/Lecture/IST 687/Final project")

#Load a file
library(jsonlite)
data <- fromJSON("Spring2020-survey-02(1).json")
View(data)
#Cleaning data
library(tidyverse)
clean_data <- data
#change column names
colnames(clean_data) <- colnames(clean_data) %>% str_replace_all("\\.","_") 
#change row names
rownames(clean_data) <- NULL
View(clean_data) #10282 rows, 32columns
library(imputeTS)
#Explore data
str(clean_data) 
summary(clean_data)
#Filter data for flights which was not cancelled and save it to 'clean_data2'  
library(stringr)
clean_data2 <- clean_data %>% filter(str_trim(Flight_cancelled)=="No") 
View(clean_data2)
summary(clean_data2) #only 2 columns (Arrial_Delay_in_Minutes, Flight_time_in_minutes) have NA for flights which actually operated without cancellation
#Check columns which have NA
which(is.na(clean_data2$Arrival_Delay_in_Minutes)) #24 NA
which(is.na(clean_data2$Flight_time_in_minutes)) #24 NA
#Repace NA with columns in clean_data
#Replace NA in Arrival_Delay_in_Minutes
clean_data$Arrival_Delay_in_Minutes[which(is.na(clean_data$Arrival_Delay_in_Minutes))] = median(clean_data$Arrival_Delay_in_Minutes,na.rm = TRUE)
any(is.na(clean_data$Arrival_Delay_in_Minutes)) #replaced 
#Replace NA in Flight_time_in_minutes
clean_data <- clean_data %>% arrange(Flight_Distance) #Arrange Flight_Distance in ascending order
clean_data$Flight_time_in_minutes <- na_interpolation(clean_data$Flight_time_in_minutes) #Interpolate the NA between flights of similar Flight_Distance
any(is.na(clean_data$Flight_time_in_minutes)) #replaced
#Add columns
#Add 'c_score' column which represents customer's satisfaction score
clean_data <- clean_data %>% 
  mutate(c_score=ifelse(Likelihood_to_recommend>8, "Promotors", 
                        ifelse(Likelihood_to_recommend<7, "Detractors", "Passives")))
#Add 'age_group' column which represents the age group
clean_data <- clean_data %>% 
  mutate(age_group=ifelse(Age>60, "Senior", 
                         ifelse(Age<40, "Young", "Middle")))
#Add 'distance_group' column which categorizes flight distance
clean_data <- clean_data %>% 
  mutate(distance_group=ifelse(Flight_Distance>1500, "Long", 
                          ifelse(Flight_Distance<500, "Short", "Moderate")))
#Add 'c_period' column which represents the period that customers have used the airline
clean_data <- clean_data %>% 
  mutate(c_period=ifelse(Year_of_First_Flight>2010, "New", 
                        ifelse(Year_of_First_Flight<2009, "Old", "Moderate")))
#Add 'totalDelayMin' column which represents the sum of Arrival & Departure delay minutes
clean_data$totalDelayMin <- clean_data$Departure_Delay_in_Minutes + clean_data$Arrival_Delay_in_Minutes
#Check loyalty value distribution
hist(clean_data$Loyalty) #long right tail. clustered in -1 ~ -0.5
#Add 'Loyalty_class' column which represents the grade of customer loyalty 
clean_data <- clean_data %>% 
  mutate(Loyalty_class=ifelse(Loyalty>=0.5, "High", 
                         ifelse(Loyalty<=-0.5, "Low", "Moderate")))

#Text mining
#Promotors' comments
#option1-tm
library(tm)
data_promotors <- clean_data %>% filter(c_score=="Promotors")
comments_pos <- VectorSource(data_promotors$freeText)
words.corpus <- Corpus(comments_pos)
words.corpus
words.corpus <- tm_map(words.corpus, content_transformer(tolower))
words.corpus <- tm_map(words.corpus, removePunctuation)
words.corpus <- tm_map(words.corpus, removeNumbers)
words.corpus <- tm_map(words.corpus, removeWords, stopwords("english"))
tdm <- TermDocumentMatrix(words.corpus)
m <- as.matrix(tdm) 
wordCounts <- rowSums(m) 
wordCounts <- sort(wordCounts, decreasing=TRUE)
cloudFrame <- data.frame(word=names(wordCounts), freq=wordCounts) 
View(cloudFrame)
library(wordcloud)
wordcloud(cloudFrame$word, cloudFrame$freq)
wordcloud(names(wordCounts), wordCounts, min.freq = 10, max.words = 26, rot.per = 0.35, colors=brewer.pal(8, "Dark2"))
#option2-quanteda
library(quanteda)
intcorpus.p <- corpus(data_promotors$freeText)
paras.p <- corpus_reshape(intcorpus.p, to="paragraphs")
webfile_dtm.p <- dfm(paras.p, stem=TRUE, remove_punct=TRUE, remove=c(stopwords("english"),"flight", "southeast"))
webfile_dtm.p <- dfm_trim(webfile_dtm.p, min_termfreq=10)
textplot_wordcloud(webfile_dtm.p) 
#Detractors' comments
data_detractors <- clean_data %>% filter(c_score=="Detractors")
intcorpus <- corpus(data_detractors$freeText)
paras <- corpus_reshape(intcorpus, to="paragraphs")
webfile_dtm <- dfm(paras, stem=TRUE, remove_punct=TRUE, remove=c(stopwords("english"),"and","the","have", "flight", "southeast"))
webfile_dtm <- dfm_trim(webfile_dtm, min_termfreq=10)
textplot_wordcloud(webfile_dtm) 

#Summarize variables
#create histogram
#option1-manual work
hist(clean_data$Age) #skewed to customers in their 40-50's
hist(clean_data$Price_Sensitivity) #highly clustered on 1, low price sensitivity
hist(clean_data$Flights_Per_Year) #long right tail. clustered in 0-20
hist(clean_data$Total_Freq_Flyer_Accts) #long right tail. clustered in 0-2
hist(clean_data$Shopping_Amount_at_Airport) #long right tail. clustered in 0-50
hist(clean_data$Eating_and_Drinking_at_Airport) #long right tail. clustered in 0-100
hist(clean_data$Departure_Delay_in_Minutes) #long right tail. clustered in 0-50
hist(clean_data$Arrival_Delay_in_Minutes) #long right tail. clustered in 0-50
hist(clean_data$Flight_time_in_minutes) #long right tail. clustered in 40-100
hist(clean_data$Flight_Distance) #long right tail. clustered in 500
hist(clean_data$Likelihood_to_recommend) #long left tail. skewed to 7-10
#option2-create a new function
f.hist <- function(data) {
  for (i in colnames(data)){
    if (typeof(data[,i]) != 'character'){
      hist(data[,i], main = str_c(i), xlab = 'Range')
    }
  }
}
f.hist(clean_data)
#Compare the NPS of different variables 
library(ggplot2)
#NPS-Airline_status
table(clean_data$Airline_Status, clean_data$c_score)
status <- c("Blue", "Gold", "Platinum", "Silver")
Detractors <- c(2599, 180, 82, 144)
Passives <- c(2351, 218, 53, 714)
Promotors <- c(2038, 461, 185, 1231)
df_status <- data.frame(status, Detractors, Passives, Promotors)
df_status <- df_status %>% mutate(Total=Detractors+Passives+Promotors)
df_status <- df_status %>% mutate(NPS=(Promotors/Total)*100-(Detractors/Total)*100)
bar_status <- ggplot(df_status, aes(x=status, y=NPS, fill=NPS))+geom_col()
bar_status #Blue class-low NPS
#NPS-Age
df_age <- clean_data %>% 
  filter(!is.na(age_group)) %>%
  group_by(age_group) %>% 
  summarise(Total_a=n(), Promotors_a=length(c_score[c_score=="Promotors"]), Detractors_a=length(c_score[c_score=="Detractors"]), NPS_a=(Promotors_a/Total_a-Detractors_a/Total_a)*100) 
bar_age <- ggplot(df_age, aes(x=age_group, y=NPS_a, fill=NPS_a))+geom_col()
bar_age
#NPS-Gender
df_gender <- clean_data %>% 
  filter(!is.na(Gender)) %>% 
  group_by(Gender) %>% 
  summarise(Total_g=n(), Promotors_g=length(c_score[c_score=="Promotors"]), Detractors_g=length(c_score[c_score=="Detractors"]), NPS_g=(Promotors_g/Total_g-Detractors_g/Total_g)*100) 
bar_gender <- ggplot(df_gender, aes(x=Gender, y=NPS_g, fill=NPS_g))+geom_col()
bar_gender <- ggplot(df_gender, aes(x=Gender, y=NPS_g, fill=NPS_g))+geom_col(na.rm = TRUE)
bar_gender #Female-low NPS/ Male-high NPS
#NPS-c_period
df_period <- clean_data %>% 
  filter(!is.na(c_period)) %>% 
  group_by(c_period) %>% 
  summarise(Total_c=n(), Promotors_c=length(c_score[c_score=="Promotors"]), Detractors_c=length(c_score[c_score=="Detractors"]), NPS_c=(Promotors_c/Total_c-Detractors_c/Total_c)*100) 
bar_period <- ggplot(df_period, aes(x=c_period, y=NPS_c, fill=NPS_c))+geom_col()
bar_period #all good
#NPS-Type_of_Travel
df_traveltype <- clean_data %>% 
  filter(!is.na(Type_of_Travel)) %>% 
  group_by(Type_of_Travel) %>% 
  summarise(Total_t=n(), Promotors_t=length(c_score[c_score=="Promotors"]), Detractors_t=length(c_score[c_score=="Detractors"]), NPS_t=(Promotors_t/Total_t-Detractors_t/Total_t)*100) 
bar_traveltype <- ggplot(df_traveltype, aes(x=Type_of_Travel, y=NPS_t, fill=NPS_t))+geom_col()
bar_traveltype #personal-low NPS
#NPS-class
df_class <- clean_data %>% 
  filter(!is.na(Class)) %>% 
  group_by(Class) %>% 
  summarise(Total_cl=n(), Promotors_cl=length(c_score[c_score=="Promotors"]), Detractors_cl=length(c_score[c_score=="Detractors"]), NPS_cl=(Promotors_cl/Total_cl-Detractors_cl/Total_cl)*100) 
bar_class <- ggplot(df_class, aes(x=Class, y=NPS_cl, fill=NPS_cl))+geom_col()
bar_class #business-high NPS
#NPS-partner
df_partner <- clean_data %>% 
  filter(!is.na(Partner_Name)) %>% 
  group_by(Partner_Name) %>% 
  summarise(Total_p=n(), Promotors_p=length(c_score[c_score=="Promotors"]), Detractors_p=length(c_score[c_score=="Detractors"]), NPS_p=(Promotors_p/Total_p-Detractors_p/Total_p)*100) 
bar_partner <- ggplot(df_partner, aes(x=Partner_Name, y=NPS_p, fill=NPS_p))+geom_col()+theme(axis.text.x=element_text(angle=90))
bar_partner #FlyFast Airways-low NPS
#NPS-flight distance
df_distance <- clean_data %>% 
  filter(!is.na(distance_group)) %>% 
  group_by(distance_group) %>% 
  summarise(Total_d=n(), Promotors_d=length(c_score[c_score=="Promotors"]), Detractors_d=length(c_score[c_score=="Detractors"]), NPS_d=(Promotors_d/Total_d-Detractors_d/Total_d)*100) 
bar_distance <- ggplot(df_distance, aes(x=distance_group, y=NPS_d, fill=NPS_d))+geom_col()
bar_distance #long distance-high NPS

#Predictive modeling
#1. Linear modeling
#bivariate: Likelihood_to_recommend & Age
lm_age <- lm(Likelihood_to_recommend ~ Age, data = clean_data)
summary(lm_age)
age_scatter <- ggplot(clean_data) + aes(x=Age, y=Likelihood_to_recommend) + geom_point(aes(color=Likelihood_to_recommend)) + stat_smooth(method=lm, level=0.95)
age_scatter
#multivariate
lm_all<- lm(Likelihood_to_recommend ~ Age + Price_Sensitivity + Flights_Per_Year + Loyalty + Total_Freq_Flyer_Accts + Departure_Delay_in_Minutes + Arrival_Delay_in_Minutes + Flight_time_in_minutes+ Flight_Distance + Gender + Airline_Status + Type_of_Travel + Class, data= clean_data) 
summary(lm_all)
#Generalized linear model
clean_data <- clean_data %>% mutate(prob.rec = Likelihood_to_recommend/10)
lm_glm <- glm(prob.rec ~ Airline_Status + Type_of_Travel + Class + Gender, family=binomial, data= clean_data)
summary(lm_glm)
#2. Association Rules Mining
library(arules)
library(arulesViz)
rev_dataset <- clean_data[c('Destination_City', 'Origin_City', 'Airline_Status', 'Gender', 'Type_of_Travel', 'Class', 'Partner_Name', 'Origin_State', 'Destination_State', 'Flight_cancelled', 'age_group', 'c_score')]
str(rev_dataset)
data_x <- as(rev_dataset, "transactions")
data_x
inspect(data_x) #10282 rules
summary(data_x)
ruleset1 <- apriori(data_x, parameter=list(support=0.005,confidence=0.5),
                   appearance = list(default="lhs", rhs=("c_score=Detractors")))
inspectDT(ruleset1)
plot1 = ruleset1[quality(ruleset1)$confidence>0.7] 
plot(plot1,method = "paracoord")
ruleset2 <- apriori(data_x, parameter=list(support=0.005,confidence=0.5),
                   appearance = list(default="lhs", rhs=("c_score=Promotors")))
inspectDT(ruleset2)
#3. SVM
library(kernlab)
library(caret)
library(e1071)
svm_data <- clean_data %>% filter(c_score=="Promotors"|c_score=="Detractors")
str(svm_data)
any(is.na(svm_data$Airline_Status))
svm_data$Airline_Status <- as.factor(svm_data$Airline_Status)
svm_data$Airline_Status <- as.numeric(svm_data$Airline_Status)
any(is.na(svm_data$Type_of_Travel))
svm_data$Type_of_Travel <- as.factor(svm_data$Type_of_Travel)
svm_data$Type_of_Travel <- as.numeric(svm_data$Type_of_Travel)
any(is.na(svm_data$Class))
svm_data$Class <- as.factor(svm_data$Class)
svm_data$Class <- as.numeric(svm_data$Class)
svm_data$c_score <- as.factor(svm_data$c_score)
View(svm_data)
table(svm_data$c_score) #Detractors: 3005, Promotors: 3915
trainlist <- createDataPartition(svm_data$c_score, p=.65,list=FALSE)
traindata <- svm_data[trainlist,]
testdata <- svm_data[-trainlist,]
svm_train <- ksvm(c_score~Airline_Status+Type_of_Travel+Class, data=traindata, kernal="rbfdot", kpar="automatic", C=20, cross=3, prob.model = TRUE )
svm_train2 <- ksvm(c_score~Airline_Status+Type_of_Travel+Class, data=traindata, kernal="rbfdot", kpar="automatic", C=5, cross=3, prob.model = TRUE ) 
svm_train
svm_train2
svmPred <- predict(svm_train, testdata, type="votes")
length(svmPred)
comTable <- data.frame(testdata$c_score, svmPred[2,])
table(comTable) #error rate:399/2421=16%, prediction accuracy:100-16=84%

#Map Low Satisfaction Routes
library(ggplot2)
library(ggrepel)
#map_detractors
data_detractors <- data_detractors %>% arrange(Likelihood_to_recommend)
head(data_detractors,10)
data_detractors_2 <- data_detractors %>% head(10)
map_filter <- data_detractors_2 %>% filter(Flight_cancelled=="No")
usMap <- borders("state", colour="grey", fill="white")
map_detractors <- ggplot() + usMap +
  geom_curve(data=map_filter,
             aes(x=olong, y=olat, xend=dlong, yend=dlat),
             col="red",
             size=.5,
             curvature=0.2) +
  geom_point(data=map_filter,
             aes(x=olong, y=olat), 
             colour="blue",
             size=1.5) +
  geom_point(data=map_filter,
             aes(x=dlong, y=dlat), 
             colour="red") +
  ggtitle("Detractors flight route")
map_detractors
#map_promotors
data_promotors <- data_promotors %>% arrange(desc(Likelihood_to_recommend))
head(data_detractors,10)
data_promotors_2 <- data_promotors %>% head(10)
View(data_promotors_2) 
map_filter_2 <- data_promotors_2 %>% filter(Flight_cancelled=="No")
map_promotors <- ggplot() + usMap +
  geom_curve(data=map_filter_2,
             aes(x=olong, y=olat, xend=dlong, yend=dlat),
             col="blue",
             size=.5,
             curvature=0.2) +
  geom_point(data=map_filter_2,
             aes(x=olong, y=olat), 
             colour="blue",
             size=1.5) +
  geom_point(data=map_filter_2,
             aes(x=dlong, y=dlat), 
             colour="blue") +
  ggtitle("Promotors flight route")
map_promotors
#Worst partner airline
data_detractors %>% filter(Origin_State=="Texas"|Origin_State=="Georgia") %>% group_by(Partner_Name) %>% summarise(n()) 
#Best partner airline
data_promotors %>% group_by(Partner_Name) %>% summarise(n()) 
clean_data %>% group_by(Partner_Name) %>% summarise(n()) 
length(clean_data$Partner_Name)
#Spending pattern
clean_data %>% group_by(Gender) %>% summarise(sum_gender=sum(Shopping_Amount_at_Airport)) 
clean_data %>% group_by(Airline_Status) %>% summarise(sum_gender=sum(Shopping_Amount_at_Airport))
