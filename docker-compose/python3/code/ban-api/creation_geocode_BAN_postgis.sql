-- creation fonction BAN postgis
-- Alain from pasq.fr
-- Date: 16 juil. 2023
-- Time: 11:19:49

-- Extension requise : plpython3u

-- DROP EXTENSION plpython3u;
-- CREATE EXTENSION plpython3u SCHEMA "pg_catalog";

-- accès à internet requis, adresse.gouv.fr

-- creation fonction de geocodage dans postgis
CREATE OR REPLACE FUNCTION public.geocode_api_ban(address text)
RETURNS geometry
AS $$
  import requests
  try:
    payload = {'q' : address}
    base_geocode = 'https://api-adresse.data.gouv.fr/search/'
    r = requests.get(base_geocode, params = payload)
    coords = r.json()['features'][0]['geometry']['coordinates']
    lon = coords[0]
    lat = coords[1]
    geom = f'POINT({lon} {lat})'
  except Exception as e:
    plpy.notice(f'address failed: {address}')
    geom = None
  return geom
$$
LANGUAGE 'plpython3u';

-- geocodage inverse
CREATE OR REPLACE FUNCTION public.geocode_reverse_api_ban(lon text,lat text)
RETURNS TEXT
AS $$
  import requests
  try:
    payload = {'lon':lon, 'lat':lat}
    base_geocode = 'https://api-adresse.data.gouv.fr/reverse/'
    r = requests.get(base_geocode, params = payload)
    ad = r.json()['features'][0]['properties']['label']
  except Exception as e:
    ad = 'erreur'
  return ad
$$
LANGUAGE 'plpython3u';



--SELECT public.geocode_api_ban('30 Avenue Général Leclerc 38200 Vienne');


-- SELECT * FROM pg_language WHERE lanname LIKE 'plpython3u';
-- SELECT lanpltrusted FROM pg_language WHERE lanname LIKE 'plpython3u';
-- UPDATE pg_language SET lanpltrusted = true WHERE lanname LIKE 'plpython3u';


-- SELECT geocode_reverse_api_ban('4.865758', '45.513213');
-- SRID:4326;POINT(4.865758 45.513213)
-- POINT(4.865758 45.513213)

--SELECT * 
--FROM information_schema.routines 
--WHERE routine_type='FUNCTION' 
  --AND specific_schema='public'
  --AND routine_name LIKE '%geocode_api_ban%';