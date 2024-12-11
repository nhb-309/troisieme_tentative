url_wikipedia <- "https://fr.wikipedia.org/"
url_blanchett <- "wiki/Cate_Blanchett"
data_html <- paste0(url_wikipedia, url_blanchett) %>% read_html()
film_selector <- "#mw-content-text div ul:nth-of-type(3) li i a"
film_nodes <- data_html %>% html_nodes(film_selector) %>% html_attrs()
films <- tibble()
for(k in seq_along(film_nodes)) {
  film_node <- film_nodes[[k]]
  if("class" %in% names(film_node)) next # Absence de page dédiée
  if(film_node["title"] == "Galadriel") next # Mauvais lien
  films <- rbind(
    films,
    list(titre=film_node["title"], url=film_node["href"])
  )
}

films
films$imdb_addr=NA
films$film_id=NA

base_imdb_url='https://www.imdb.com/title/'
spec_imdb_url='/fullcredits/?ref_=tt_ov_st#cast'

cast_table=tibble('cast'=NA,'id'=NA)

    
for(k in 1:nrow(films)){
  # Depuis wikipedia, on récupère les liens vers les pages imdb
  indiv_url = paste0(url_wikipedia,films[k,'url'])

  selector='div ul li span li a' # sélecteur vers les liens du bas de la page
  liens=read_html(indiv_url) %>% html_nodes(selector) %>% html_attr('href') # on récupère tous 
  imdb_url = liens[which(str_detect(liens,'imdb')==T)] # parmi tous les liens sur la page wiki, on récupère celui vers imdb
  films[k,'imdb_addr']=imdb_url                        # on stocke ce lien 
  # On a besoin du film id attribué par imdb à chaque film
  film_id=imdb_url %>% str_split('id=')
  films[k,'film_id']=film_id[[1]][2]                             # on récupère l'id du film imdb
  cast_url = paste0(base_imdb_url,film_id[[1]][2],spec_imdb_url) # on recrée l'url de casting imdb
  
  
  full_table=read_html(cast_url) %>% html_node('table.cast_list') %>% html_table()
  vector_act = full_table[,2] %>% pull()
    
  
  # Gérer les noms dans le casting
    # 1. éliminer le reste des acteurs
    # 2. prévoir l'éventualité où il n'y aurait que des acteurs principaux. 
    i=which(vector_act == 'Rest of cast listed alphabetically:')
    if(is_empty(i)==F){
    
      vector_act=vector_act[1:(i-1)]    
    }
    vector_act
    
    local_table = tibble('cast'=vector_act,'id'=films[k,'film_id']) %>% 
      filter(cast!="")

    cast_table=rbind(cast_table,local_table)
}


# On fait un join (optionnel) pour compléter la première table
total_casting = films %>% 
  left_join(cast_table,by=c('film_id'='id'))

# Résultat table finale
total_casting %>% group_by(cast) %>% 
  summarise(count=n()) %>% 
  arrange(desc(count))


