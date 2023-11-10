# Geovisio - Solution d'auto-hébergement de photos de rue géolocalisées (à l'instar de Google Street View)

```console
docker exec -it geovisio-db sh -c "sed -i '/host all all all md5/d' /var/lib/postgresql/data/pg_hba.conf" \
	&& docker exec -it geovisio-db sh -c "sed -i '$ a\host    panoramax       geovisio        172.21.0.0/16           md5' /var/lib/postgresql/data/pg_hba.conf" \
	&& docker restart geovisio-db
```