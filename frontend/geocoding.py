import requests
import json
from urllib.parse import quote


def address_to_geocode(address: str):
    address = quote(address)

    geocoder = '{"address" = address}'
    geocoder_json = json.dumps(geocoder)

    # this is the sample google api format
    # https://maps.googleapis.com/maps/api/geocode/json?place_id=ChIJeRpOeF67j4AR9ydy_PIzPuM&key=YOUR_API_KEY

    url = 'https://maps.googleapis.com/maps/api/geocode/json?address={address}&key=AIzaSyBx-u8WoCZX45wKIgJnPs50T63t_4inkSk'.format(
        address=address)

    response = requests.get(url=url)
    response = response.json()
    
    # this reads location data from the json file
    # results[0] prints the first result, although there could be more
    print(response['results'][0]['geometry']['location']['lat'])
    print(response['results'][0]['geometry']['location']['lng'])
    # this is how many response
    print(len(response['results']))

    return response['results'][0]['geometry']['location']['lat'], response['results'][0]['geometry']['location']['lng']

print(address_to_geocode("santa clara university"))
