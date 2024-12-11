url='https://www.esportsearnings.com/history/2024/games/151-starcraft-ii/'


response=read_html(url)

selector='table.detail_list_table'
table=response %>% html_node(selector) %>% html_table(header=T)  

table
 
trim_pct = function(col){
  table[,6]
  
  str_replace_all(table[,6],"[%]","")
    
  as.numeric()
}



trim_currency=function(col){
  x=str_replace_all(col,"[,$]","") %>% 
    as.numeric() 
  return(x)
}  
  
trim_currency(table$`Total (Year)`)  

apply(table[,c(4:5,7)],2,trim_currency)



