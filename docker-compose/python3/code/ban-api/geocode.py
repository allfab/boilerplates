import requests
address = '30, Avenue Général Leclerc, 38200 VIENNE'
try:
    payload = {'q' : address}
    base_geocode = 'https://api-adresse.data.gouv.fr/search/'
    r = requests.get(base_geocode, params = payload)
    coords = r.json()['features'][0]['geometry']['coordinates']
    lon = coords[0]
    lat = coords[1]
    geom = f'POINT({lon} {lat})'
    print(geom)
except Exception as err:
    print(f"Unexpected {err=}, {type(err)=}")