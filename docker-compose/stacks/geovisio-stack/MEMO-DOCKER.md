# GEOVISIO DB CONNECTION
docker exec -it geovisio-db sh -c "sed -i '/host all all all md5/d' /var/lib/postgresql/data/pg_hba.conf"
docker exec -it geovisio-db sh -c "sed -i '$ a\host    panoramax       geovisio        172.21.0.0/16           md5' /var/lib/postgresql/data/pg_hba.conf"

# GEOVISIO CLI

docker exec -it geovisio-cli sh -c "geovisio login --help"
docker exec -it geovisio-cli sh -c "geovisio login --api-url http://geovisio-api:5000"


docker exec -it geovisio-cli sh -c "geovisio upload --api-url http://geovisio-api:5000 20231107-rush/"
docker exec -it geovisio-cli sh -c "geovisio upload --api-url http://geovisio-api:5000 20231115-rush/"

docker exec -it geovisio-cli sh -c "geovisio collection-status --wait --location http://geovisio-api:5000/api/collections/5b78536a-4a11-4c27-96cd-607cb3fbbe9e"


## Lancez la commande de versement d’images sur le dossier choisi


# GENERATE SECRET
openssl rand -base64 32
openssl rand -base64 64

# RUN SHELL
docker compose exec gvs-cli sh

# GEOVISIO COMMAND
geovisio --help

## Login - Authentification
This will generate credentials, and ask the user to visit a page to associate those credentials to the user's account.
The credentials will be stored in /root/.config/geovisio/config.toml

geovisio login --help

geovisio login --api-url https://panoramax.ign.fr


## Lancez la commande de versement d’images sur le dossier choisi
geovisio upload --api-url https://panoramax.ign.fr/ /app/images/360
## Si on se trouve dans le dossier photos
geovisio upload --api-url https://panoramax.ign.fr/ .

## Avancement du traitement photos
geovisio collection-status --wait --location https://panoramax.ign.fr/api/collections/<votre_id_de_collection>


geovisio upload --api-url https://panoramax.ign.fr/ 360/20231107-rush/
geovisio collection-status --wait --location https://panoramax.ign.fr/api/collections/56cb1dd0-ce38-4c44-b5fc-de8823804048
https://panoramax.ign.fr/api/collections/56cb1dd0-ce38-4c44-b5fc-de8823804048

geopic-tag-reader --help

geopic-tag-reader read --image 360/20231107-rush/GSAC0039.JPG

geovisio upload --api-url http://172.21.0.7:5000 20231107-rush/
geovisio upload --api-url http://geovision-api:5000 20231107-rush/
geovisio collection-status --wait --location http://172.21.0.7:5000/api/collections/f3a309db-be6b-41f7-9a1e-00ce883ed60b

geovisio upload --api-url https://panoramax.ign.fr/ 360/20231107-rush/