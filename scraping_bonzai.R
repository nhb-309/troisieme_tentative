library(rvest)
library(stringr)
library(tidyverse)
url='https://umizenbonsai.com/shop/bonsai/coniferes/'

response=read_html(url)

selector_prix='article ul li div ul li.price-wrap'
selector_nom='article ul li div ul li h2 a'

liens=response %>% html_nodes(selector_nom) %>% html_attr('href') 
noms=response %>% html_nodes(selector_nom) %>% html_text(trim = T)

res = tibble('nom'=noms,'lien'=liens,'price'=NA,'réduc'=NA)

k=1

for(k in 1:nrow(res)){
  sub_url = res[k,'lien']
  sub_response = read_html(sub_url[[1]])
  selector_price = 'div p span bdi'
  
  local=sub_response %>% html_nodes(selector_price) %>% html_text(trim=T) 
  
  if(length(local)>1){
    res[k,'price']=local[length(local)]
    res[k,'réduc']='yes'
  }else{
    res[k,'price']=local
    res[k,'réduc']='no'
  }
  
}

res
