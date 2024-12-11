library(mongolite)


# nécessaire d'avoir un serveur mongodb a disposition. 
# si on veut le faire chez soi il faut avoir une machine avec le serveur dessus.

# CRUD ----

m = mongo('ma_collection',
          url='mongodb://user:password@host:path?options')


# vérifier combien de documents sont contenus dans la collection
m$count()

# s'il y a des documents --> on vide tout. 
# syntaxe --> m + $ + la fonction qu'on veut utiliser
if(m$count() > 0) m$drop()

# étapes du CRUD
# fonction insert qui permet d'insérer des document au format json

## C  CREATE  ----
m$insert(fromJSON("https://ringdb.com/api/public/cards"))
m$insert(list(name="Luke", outlier = T)) # il n'y a pas de schéma on peut insérer ce qu'on veut. 
# attention à ne pas tout mélanger. 

## R  RETRIEVE ----
m$find()
m$find(query='{"type_name":"Contract"}')
m$find(
  query='{"type_name":"Contract"}'  # FILTRAGE
  fields='{"name":true,"illustrator":true}' # SELECTION toutes les clés sont à false par défaut sauf l'id. 
)

      # Sous forme de tibble:
tibble(
  m$find(
    query='{"type_name":"Contract"}'  # FILTRAGE
    fields='{"name":true,"illustrator":true}' # SELECTION toutes les clés sont à false par défaut sauf l'id. 
  )
)

        # Opérateurs de recherche
m$find(
  query='{"outlier":{"$exists":true}}
  }'
)

query='{"attack":{"$gte":4}}'
query='{"name":{"$regex":"^Z"}}'

        # Valeurs distinctes

m$distinct(key="type_name")
m$distinct(key="illustrator",
           query='{"pack_name":"The Hunt for Gollum"}')


        # Tri
m$find(
  query='{"threat":"{"$exists":true}}',
  sort='')
  
## U  UPDATE - Modification ----
# operateur $set mais ne modifie qu'un seul document: le premier qu'il trouve

# pour modifier tous les documents il faut ajouter multiple=TRUE


## D   DELETE - Suppression ----

m$drop()
m$remove() # plus subtile



# PIPELINE AGREGATION ----
# utiliser les agrégateurs côté serveur. 







