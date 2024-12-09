# tidyverse

# Plusieurs packages
# - tibble
# - dplyr 
# - readr : pour lire des fichiers plats. 
# - ggplot2 : 
# - tidyr : réorganisation des données

# - forcats
# - lubridate
# - stringr
# - purrr
# - DBI
# - readxl
# - rvest
# tidyverse --> avec tidyverse, R s'adapte à l'objet manipulé, ce sont des fonctions génériques 
# ex: print s'adapte pour afficher des matrices, des data.frames...
# sinon on peut utiliser la fonction print.default()

# 0. répertoire ----
path = 'L:/R DATA/data/'
setwd(path)
# 1. package readr ----
library(readr)
read_csv()
read_tsv()
read_delim()

tbl = read_csv('piscines.csv')
tbl %>% head()

filter(tbl,Latitude < -27.5)
select(tbl,Address)
filter(tbl,!grepl("Road", Address))
slice() # permet de filtrer sur des numéros de ligne. 
select(tbl, ends_with('tude'))
select(tbl, matches('L.*tude'))
mutate(tbl, variable_1 = Longitude + 3)

arrange(tbl, desc(Latitude))

tribble(
  ~nom, ~age, ~taille,~region,~gender,~isParent,
  "joe",21,162,'Iowa','M','Y',
  "rob",23,193,'Michigan','M','N',
  "mary",31,183,'Delaware','M','N',
  "kyle",32,163,'Iowa','M','N') %>% 
  summarise(states=n_distinct(region))

library(hflights)

hflights=as_tibble(hflights)
hflights %>% head()
x=hflights %>% 
  group_by(DayOfWeek) %>% 
  summarise(airtime_avg = mean(AirTime,na.rm=T),
            airtime_n = n())
x$airtime_n %>% sum() 

# 2. Exercice1 - Iris ----
dim(iris)

iris %>% 
  select(Petal.Width,Species)

iris %>% 
  filter(Species %in% c('virginica', 'versicolor'))

iris %>% 
  filter(Species == "setosa") %>% 
  summarise(count_setosa = n())

iris %>% 
  filter(Species == "versicolor") %>% 
  summarise(avg_Petal_Width_versicolor=mean(Petal.Width))

iris %>% 
  mutate(Sum.Width = Petal.Width+Sepal.Width)

iris %>% 
  group_by(Species) %>% 
  summarise(avg_sepal_len = mean(Sepal.Length),
            sd_sepal_len = var(Sepal.Length))

# 3. Exercice2 - hflights

library(hflights)

hflights %>% 
  select(ends_with('Time'))

hflights %>% 
  select(Dest,Distance,TaxiIn,TaxiOut)

hflights %>% 
  mutate(ActualGroundTime = ActualElapsedTime-AirTime )

hflights %>% 
  mutate(speed = Distance/AirTime) %>% 
  arrange(desc(speed))

hflights %>% 
  filter(Dest == 'JFK') %>% 
  summarise(count_JFK_dest = n())

hflights %>% 
  summarise(count = n(),
            distinct_dest = n_distinct(Dest),
            distinct_carr = n_distinct(UniqueCarrier))

hflights %>% 
  filter(UniqueCarrier == 'AA') %>%
  summarise(count = n(),
            isCancelled = sum(Cancelled),
            avg_del = mean(DepDelay,na.rm=T))

hflights %>% 
  group_by(UniqueCarrier) %>% 
  summarise(count_flights = n(),
            avg_airtime = mean(AirTime,na.rm=T))

