import requests
import json

address = "address=24%20Sussex%20Drive%20Ottawa%20ON"

geocoder = '{"address" = address}'
geocoder_json = json.dumps(geocoder)

# https://maps.googleapis.com/maps/api/geocode/json?place_id=ChIJeRpOeF67j4AR9ydy_PIzPuM&key=YOUR_API_KEY

url = 'https://maps.googleapis.com/maps/api/geocode/json?' + address + '&key=AIzaSyBx-u8WoCZX45wKIgJnPs50T63t_4inkSk'

response = requests.get(url=url)
for item in response:
    print(response.longitude)