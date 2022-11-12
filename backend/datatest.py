
# Inrix Hack 2022
# Datatest.py this is our playground to mess aroudn with and
# try things before implementing them


from credentials import *
import datetime
INRIX_ENDPOINT = "https://api.iq.inrix.com"

params = {
    "appId": APP_ID,
    "hashToken": hashToken,
}

now = str(datetime.datetime.utcnow())

print(now[:len(now)-7])

# response = requests.get(url=)