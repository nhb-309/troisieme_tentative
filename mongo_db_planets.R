library(tidyverse)
library(jsonlite)
library(mongolite)

path = 'L:/R DATA/data/'
setwd(path)
list.files()

m=mongo('planets')
m$count()

if(m$count()>0) {m$drop()}
m$import(file('planets.json',open='r'))
m$find() %>% tibble() %>% head()
m$find() %>% tibble() %>% str()

m$find(
  query='{
    "$and":[{"climate": "arid"},{"gravity": "standard"}]}',
  fields='{"_id":false,"name":true}')

m$find(
  query='{"rotation_period":"25"}',
  fields='{"_id":false,"name":true,"rotation_period":true}'
)


m$find(
  query='{"rotation_period":"25"}',
  fields='{"_id":false,"name":true,"rotation_period":true,"orbital_period":true,"diameter":true}'
)


m$find(
  query='{"rotation_period":"25"}',
  fields='{"_id":false,"name":true,"rotation_period":true,"orbital_period":true,"diameter":true}',
  sort='{"diameter":1}'
)

if(m$count()>0) {m$drop()}
m$import(file('planets.json',open='r')) 

x=m$find() %>% 
  as.data.frame() %>% 
  mutate(rotation_period = as.numeric(rotation_period),
         orbital_period = as.numeric(orbital_period),
         diameter = as.numeric(diameter),
         surface_water = as.numeric(surface_water),
         population = as.numeric(population),
         terrain = str_split(terrain,pattern = ', '),
         climate = str_split(climate,pattern = ', ')
         ) %>% 
  select(-c(films,gravity,residents,created,edited,url))

if(m$count()>0) {m$drop()}

m$insert(x)
m$find()
m$find(
  fields='{"_id":false,"name":true,"diameter":true,"rotation_period":true}',
  sort='{"diameter":-1}'
)

m$find(
  query='{
  "name":{"$regex":"^T"}
  }'
)


m$find(
  query = 
    '{ 
    "$and": [
      {"terrain":{"$in":["mountains"]}},
      {"diameter": {"$gt":10000}}
    ]}',
  fields = '{"_id":false,"name":true,"diameter":true,"terrain":true}'
)

m$remove(
  query=
    '{"name":"unknown"}'
)

m$count()

m$aggregate('[
            {"$match": {"terrain": "glaciers"}}, 
            { "$group" : 
                {"_id":null, "diameter":{"$avg":"$diameter"},"population":{"$avg":"$population"}
            }}]')






