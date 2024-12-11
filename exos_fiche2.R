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
Joueur = 'Roger Federer'

victoires = function(Joueur){
  return(
  rg %>% 
    filter(
      (Player1 == Joueur & Result == 1) |
        (Player2 == Joueur & Result == 0)) %>% 
    nrow())
  }
  
victoires(Joueur)
x=rg %>% 
  rowwise() %>% 
  mutate(victoires = victoires(Player1))



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
  summarise(avg_aces=mean(total_aces,na.rm=T)) %>% 
  pivot_wider(names_from = c(id),
              values_from = avg_aces)

oa_joueurs2=tennis %>% 
  select(id,Player1,Player2,Result) %>% 
  pivot_longer(!c(id,Result)) %>% 
  group_by(id,value) %>% 
  summarise(total_win_oa = sum(Result)) %>% 
  filter(id=='oa') %>% 
  ungroup() %>% 
  select(value,total_win_oa)

rg_joueurs2 
oa_joueurs2 

rg_joueurs2 %>% 
  left_join(oa_joueurs2,by='value')
rg_joueurs2 %>% 
  inner_join(oa_joueurs2,by='value')
rg_joueurs2 %>% 
  full_join(oa_joueurs2,by='value')




rg_victoires=function(joueur){
  return(
    rg %>% filter(
      (Player1 == joueur &  Result == 1) |
        (Player2 == joueur & Result == 0)) %>% 
      nrow()
    
  )
}

rg_victoires("Rafael Nadal")

rg_joueurs
colnames(rg_joueurs)=c('Joueur','total_rg_win')


rg_joueurs %>% 
  rowwise() %>% 
  mutate(Victoires=rg_victoires(Joueur))




