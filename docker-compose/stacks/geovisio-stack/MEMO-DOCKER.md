# RUN SHELL
docker compose exec gvs-cli sh

# GEOVISIO COMMAND
geovisio --help

## Login - Authentification
This will generate credentials, and ask the user to visit a page to associate those credentials to the user's account.
The credentials will be stored in /root/.config/geovisio/config.toml

geovisio login --help

geovisio login --api-url https://panoramax.ign.fr/


## Lancez la commande de versement d’images sur le dossier choisi
geovisio upload --api-url https://panoramax.ign.fr/ /app/images/360
## Si on se trouve dans le dossier photos
geovisio upload --api-url https://panoramax.ign.fr/ .

## Avancement du traitement photos
geovisio collection-status --wait --location https://panoramax.ign.fr/api/collections/<votre_id_de_collection>