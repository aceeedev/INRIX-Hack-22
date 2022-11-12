import pandas as pd
import requests
from pprint import pprint
from datetime import datetime as dt
from credentials import *


class CredentialsManager:
    def __init__(self):
        self.ENDPOINT = "https://api.iq.inrix.com"
        parameters = {
            "appId": APP_ID,
            "hashToken": HASH_TOKEN
        }
        response = requests.get(url=self.ENDPOINT+"/auth/v1/appToken", params=parameters)
        response.raise_for_status()
        data = response.json()
        pprint(data)
        self.expiration_time = (pd.Timestamp(data["result"]["expiry"])).to_pydatetime().replace(tzinfo=None)
        # self.expiration_time = self.expiration_time.replace(tzinfo=None)
        print(self.expiration_time, type(self.expiration_time))
        self.hash_token = data["result"]["token"]
        self.app_id = APP_ID

    # Gets a new token if the last one has expired
    def set_token(self):
        response = requests.get(url=self.ENDPOINT+"/auth/v1/appToken")
        response.raise_for_status()
        data = response.json()
        pprint(data, data["result"]["expiry"])
        self.hash_token = data["result"]["token"]
        self.expiration_time = (pd.Timestamp(data["result"]["expiry"])).to_pydatetime().replace(tzinfo=None)

    # Checks if the api token has expired
    def check_time(self):
        now = dt.utcnow()
        print("here")
        print(now.tzinfo, self.expiration_time.tzinfo)
        if now >= self.expiration_time:
            self.set_token()
        else:
            print(f"All good. Check back at {self.expiration_time}.")

    def get_token(self):
        self.check_time()
        return [self.hash_token, self.expiration_time]








