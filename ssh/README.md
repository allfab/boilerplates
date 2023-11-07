# SSH

## Créer un **MOTD[^*]** personnalisé ou une bannière de connexion sous Linux

Autrefois, avant les interfaces graphiques, les administrateurs système laissaient un message aux utilisateurs en utilisant le fichier « MOTD » du message du jour.
L'option motd est toujours disponible sur la plupart des systèmes Linux modernes. Dans cet article, nous allons voir comment créer une jolie bannière de connexion personnalisée avec des illustrations ASCII et des informations système.


### Définition d'un MOTD de texte de base sous Linux

Vous pouvez facilement définir un message texte de base du jour en éditant le fichier /etc/motd. Tout texte que vous placez dans le fichier sera affiché lors de la connexion de n'importe quel utilisateur.

Exemple:

```
$ sudo vi /etc/motd
#######################################
# CECI EST UN MESSAGE DE TEST DANS /etc/motd #
#######################################
```

Désormais, lorsque quelqu'un se connectera via le terminal ou ssh, il verra le message.
```
$ ssh monadresseip
Mot de passe de user@monadresseip :
#######################################
# CECI EST UN MESSAGE DE TEST DANS /etc/motd #
#######################################
Dernière connexion : mardi 07 novembre 2023 11:44:58 à partir du 91.184.102.244
```

Cela devrait fonctionner sur n'importe quelle machine Unix ou Linux, quelle que soit la distribution.

### Script de connexion personnalisé dans le profil Etc

Une autre option, plus flexible, consiste à créer un script et à le placer dans le dossier /etc/profile.d/. Tout script de ce dossier s'exécutera lorsqu'un utilisateur se connectera. 

L'utilisation d'un script dans /etc/profile.d vous offre des possibilités presque illimitées. J'ai utilisé un générateur d'art ASCII pour créer le nom de mon serveurvia figurine et j'ai créé cette bannière de connexion :
![image](https://github.com/allfab/boilerplates/assets/1840185/9d8d7991-5caf-4c44-9db9-c6a32e9834d5)

J'ai ensuite ajouté les commandes lastlog et uptime pour me montrer des informations sur le serveur.

[^*]: Message of the Day - Message du jour