list.files()

rg=read_csv('rolandgarros2013.csv') %>% 
  as_tibble()

rg %>% str()

# Demi finalistes
rg %>% 
  filter(Round==6) %>% 
  select(Player1,Player2)

rg %>% 
  mutate(total_ace = ACE.1+ACE.2) %>% 
  summarise(avg_aces=mean(total_ace))

rg %>% 
  mutate(total_ace = ACE.1+ACE.2) %>% 
  group_by(Round) %>% 
  summarise(avg_aces = mean(total_ace))

rg_joueurs=rg %>% 
  select(Player1,Player2) %>% 
  pivot_longer(c(Player1,Player2),names_to = 'players') %>% 
  select(value) 

rg_joueurs2=rg %>% 
  select(Player1,Player2,Result) %>% 
  pivot_longer(!Result,names_to = 'players') %>% 
  group_by(value) %>% 
  summarise(total_victoires=sum(Result))


list.files()

oa=read_csv('openaustralie2013.csv') %>% 
  as_tibble()

tennis=bind_rows(list(oa=oa,rg=rg),.id='id') %>% 
  as_tibble()

tennis %>% 
  group_by(id) %>% 
  summarise(n_match=n())

tennis %>% 
  group_by(id,Round) %>% 
  mutate(total_aces = ACE.1+ACE.2) %>% 
  summarise(avg_aces=mean(total_aces,na.rm=T)) %>%  
  pivot_wider(names_from = c(id),
              values_from = avg_aces)



