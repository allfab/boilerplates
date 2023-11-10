# `geovisio-cli : command-line client`

GeoVisio command-line client (v0.3.3)

**Usage** :

```console
$ geovisio [OPTIONS] COMMAND [ARGS]...
```

**Exemple** :
```console
$ docker exec -it geovisio-cli sh -c "geovisio login --help"
```

**Options** :

* `--version` : Afficher la version du client de ligne de commande GeoVisio et quitte
* `--install-completion` : Fin de l'installation pour le shell actuel
* `--show-completion` : Afficher la complétion du shell actuel, pour le copier ou personnaliser l'installation
* `--help` : Affichez ce message et quittez

**Commands** :

* `collection-status` : Imprimer l'état d'une collection
* `login` : Authentifiez-vous dans l'instance donnée
* `test-process` : (Pour tester) Génère un fichier TOML
* `upload` : Traite et envoie une séquence donnée sur l'instance

## `geovisio collection-status`

Imprimer l'état d'une collection.

Soit un --location doit être fourni, avec l'URL complète de l'emplacement de la collection
ou seulement le --id combiné avec le --api-url

**Usage** :

```console
$ geovisio collection-status [OPTIONS]
```

**Options** :

* `--id TEXT`: Identifiant de la collection
* `--api-url TEXT`: URL du point de terminaison GeoVisio
* `--location TEXT`: URL complète de la collection
* `--wait / --no-wait`: attendez que toutes les images soient prêtes [par défaut : sans attente] - [default: no-wait]
* `--disable-cert-check / --enable-cert-check`: Désactivez les vérifications des certificats SSL lors du téléchargement. Cela ne doit pas être utilisé, sauf si vous savez vraiment ce que vous faites [default: enable-cert-check]
* `--help`: Affichez ce message et quittez

## `geovisio login`

Authentifiez-vous sur l'instance donnée et enregistrez les informations d'identification dans un fichier de configuration.

Cela générera des informations d'identification et demandera à l'utilisateur de visiter une page pour associer ces informations d'identification au compte de l'utilisateur.

Les informations d'identification seront stockées dans /home/a_user/.config/geovisio/config.toml

> Avant de faire cette opération, il est nécessaire de créer un utilisteur sur notre instance Geovisio afin de l'associer/identifier en tant qu'utilisateur ayant droit de lancer des lignes de commande d'import de photos sur notre instance.
>
> Pour ce faire, se rendre sur [http://localhost:3000/](http://localhost:3000/)

**Usage** :

```console
$ geovisio login [OPTIONS]
```

**Options** :

* `--api-url TEXT`: URL du point de terminaison GeoVisio  [requis]
* `--disable-cert-check / --enable-cert-check`: Désactivez les vérifications des certificats SSL lors du téléchargement. Cela ne doit pas être utilisé, sauf si vous savez vraiment ce que vous faites [default: enable-cert-check]
* `--help`: Affichez ce message et quittez.

**Lier notre console CLI à notre instance Docker** :

```console
$ docker exec -it geovisio-cli sh -c "geovisio login --api-url http://geovisio-api:5000"
```

```console
🔐 Your computer is not yet authorized against GeoVisio API http://geovisio-api:5000. To authenticate, please either go to the URL below, or scan the QR code below.
http://geovisio-api:5000/api/auth/tokens/eea19460-966e-49f8-9738-f4165bedf60e/claim
                                             
                                             
    █▀▀▀▀▀█ ██  ▀▀▀  ▄▀▄▄▄▄ █▄  ▀ █▀▀▀▀▀█    
    █ ███ █ ▀▀▄▄ ▀███▄ ▀▄█  ▄█▀ ▄ █ ███ █    
    █ ▀▀▀ █ ▀ █▀█▄▄▄ █ ▀▀▀▄▄█▀▀   █ ▀▀▀ █    
    ▀▀▀▀▀▀▀ ▀ ▀ ▀ █▄█ ▀▄█ █ █▄█▄█ ▀▀▀▀▀▀▀    
    █ ▄▀▀█▀██▄██▀▄▀ ▀▀█▄█ ▀▄▄ ▄▄▀█  █ ██▀    
    ██▄▄▄▀▀█▄ ▄█▀ ▄▄ █▄▄█▀ ▀▀ █▀█ █▀█ ▄▄█    
     ▄▄█▄▀▀▀█▀ ██ ▄▄█▄▄▀▀ ▄█▄  ▄█ ▀▀▄▄ ▄▀    
    ▀ ▀▄ ▄▀▄▀▀█    █ ▀ ▀  ▄ █▀▀▀▄▀▀▄███▄█    
    ▄ ▄▄▄█▀ ▄  █ ▀▄ ▄ ▄▄   ▀▀▀█▄█▀▀▀  ▀▀▀    
      ▄██ ▀▀▄ ▀▀▄▀ ▀▄  ▀▀▀▀▀ ██▀█▄  ▀ ▀ █    
    █ ▄▀█ ▀▄▀█▀▀ ▀▄▄█▀▄█▀ ▄█▄▄██▀█▀██ ▄      
    █▄   █▀▀██▄▀▀████▄▀ ▄▀▀██ ███▄▀█▄▀▄ █    
    ▄▀▄█▀█▀ █▄  ▀ ▄██▄▄▀▀▄ ██ ▀█  ▀█▄▄  ▀    
    █▀▀▄█▄▀ ▄█▄▄ █▄▀▄▀▀▀ ▀▀ █▀ ▀ ▀▀▀▄▀██▀    
    ▀ ▀  ▀▀▀▄▀██▄█ ▄▀ ▄▄▄ ▄ ▄▀█▄█▀▀▀█ ▀█▀    
    █▀▀▀▀▀█ █▄█▀█▀███▀▄█▄ ▀▀ ▄ ▄█ ▀ █▀ ▄█    
    █ ███ █ ███▄▀▀ ▄▀▀▄█ ▄▄▄▄▄ ████▀▀█▄██    
    █ ▀▀▀ █  █▄██▀█▀██  ▄ ▀▀▄▀▀▀▀▀▄▄█▀█▄█    
    ▀▀▀▀▀▀▀ ▀     ▀▀▀  ▀▀  ▀  ▀▀▀ ▀     ▀    
```

Sur le navigateur de notre PC/Serveur hôte, copiez l'URL obtenue `http://geovisio-api:5000/api/auth/tokens/eea19460-966e-49f8-9738-f4165bedf60e/claim` et changez le nom d'hôte (hostname) Docker `geovisio-api` par `localhost`, cela donne : `http://localhost-api:5000/api/auth/tokens/eea19460-966e-49f8-9738-f4165bedf60e/claim`

## `geovisio test-process`

(For testing) Generates a TOML file with metadata used for upload

**Usage**:

```console
$ geovisio test-process [OPTIONS] PATH
```

**Arguments**:

* `PATH`: Local path to your sequence folder  [required]

**Options**:

* `--title TEXT`: Collection title. If not provided, the title will be the directory name.
* `--sort-method [filename-asc|filename-desc|time-asc|time-desc]`: Strategy used for sorting your pictures. Either by filename or EXIF time, in ascending or descending order.  [default: time-asc]
* `--split-distance INTEGER`: Maximum distance between two pictures to be considered in the same sequence (in meters).  [default: 100]
* `--split-time INTEGER`: Maximum time interval between two pictures to be considered in the same sequence (in seconds).  [default: 60]
* `--duplicate-distance FLOAT`: Maximum distance between two pictures to be considered as duplicates (in meters).  [default: 1]
* `--duplicate-rotation INTEGER`: Maximum angle of rotation for two too-close-pictures to be considered as duplicates (in degrees).  [default: 30]
* `--help`: Show this message and exit.

## `geovisio upload`

Processes and sends a given sequence on your GeoVisio API

**Usage**:

```console
$ geovisio upload [OPTIONS] PATH
```

**Arguments**:

* `PATH`: Local path to your sequence folder  [required]

**Options**:

* `--api-url TEXT`: GeoVisio endpoint URL  [required]
* `--wait / --no-wait`: Wait for all pictures to be ready  [default: no-wait]
* `--is-blurred / --is-not-blurred`: Define if sequence is already blurred or not  [default: is-not-blurred]
* `--title TEXT`: Collection title. If not provided, the title will be the directory name.
* `--token TEXT`: GeoVisio token if the geovisio instance needs it.

If none is provided and the geovisio instance requires it, the token will be asked during run.
Note: is is advised to wait for prompt without using this variable.
* `--sort-method [filename-asc|filename-desc|time-asc|time-desc]`: Strategy used for sorting your pictures. Either by filename or EXIF time, in ascending or descending order.  [default: time-asc]
* `--split-distance INTEGER`: Maximum distance between two pictures to be considered in the same sequence (in meters).  [default: 100]
* `--split-time INTEGER`: Maximum time interval between two pictures to be considered in the same sequence (in seconds).  [default: 60]
* `--duplicate-distance FLOAT`: Maximum distance between two pictures to be considered as duplicates (in meters).  [default: 1]
* `--duplicate-rotation INTEGER`: Maximum angle of rotation for two too-close-pictures to be considered as duplicates (in degrees).  [default: 30]
* `--picture-upload-timeout FLOAT`: Timeout time to receive the first byte of the response for each picture upload (in seconds)  [default: 60.0]
* `--disable-cert-check / --enable-cert-check`: Disable SSL certificates checks while uploading. This should not be used, unless if you -really- know what you are doing.  [default: enable-cert-check]
* `--help`: Show this message and exit.
