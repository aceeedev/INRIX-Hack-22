import requests
from urllib.parse import quote


def address_to_geocode(address: str) -> list:
    # address = quote(address)

    # geocoder = '{"address" = address}'
    # geocoder_json = json.dumps(geocoder)

    # this is the sample google api format
    # https://maps.googleapis.com/maps/api/geocode/json?place_id=ChIJeRpOeF67j4AR9ydy_PIzPuM&key=YOUR_API_KEY

    # url = 'https://maps.googleapis.com/maps/api/geocode/json?address={address}&key=AIzaSyBx-u8WoCZX45wKIgJnPs50T63t_4inkSk'.format(
    #     address=address)

    url = 'https://maps.googleapis.com/maps/api/geocode/json'
    payload = {'address': address, 'key': 'AIzaSyBx-u8WoCZX45wKIgJnPs50T63t_4inkSk'}

    response = requests.get(url=url, params=payload)
    response = response.json()
    
    # this reads location data from the json file
    # results[0] prints the first result, although there could be more
    # print(response['results'][0]['geometry']['location']['lat'])
    # print(response['results'][0]['geometry']['location']['lng'])
    # this is how many response
    # len(response['results'])

    return response['results'][0]['geometry']['location']['lat'], response['results'][0]['geometry']['location']['lng']

print(address_to_geocode("santa clara university"))

# [lat, lang]
def geocode_to_address(geocode: list) -> str:
    # convert geocode into a single string
    geocode = str(geocode[0]) + ',' + str(geocode[1])
    # print(geocode)

    url = 'https://maps.googleapis.com/maps/api/geocode/json'
    payload = {'latlng': geocode, 'key': 'AIzaSyBx-u8WoCZX45wKIgJnPs50T63t_4inkSk'}

    response = requests.get(url=url, params=payload)
    response = response.json()

    # print(response)
    # print('\n\n\n')
    # print(response['results'][0]['formatted_address'])
    return response['results'][0]['formatted_address']

print(geocode_to_address([37.3496418, -121.9389875]))