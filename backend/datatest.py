
# Inrix Hack 2022
# Datatest.py this is our playground to mess aroudn with and
# try things before implementing them
# Currently this code works to call the twilio sms service

import requests


ENDPOINT = "http://127.0.0.1:5000"

# You must provide a valid phone number is the format below
# and a non-empty message
parameters = {
    "number": "+19492805537",
    "message": "Hi Lucas my brotha"
}

response = requests.get(url=ENDPOINT+"/sendmessage", params=parameters)
response.raise_for_status()
print(response.json())