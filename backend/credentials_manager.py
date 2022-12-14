import pandas as pd
import requests
from datetime import datetime as dt
#from credentials import *
import os
from dotenv import load_dotenv
load_dotenv()

class CredentialsManager:
    def __init__(self):
        self.ENDPOINT = "https://api.iq.inrix.com"
        parameters = {
            "appId": os.environ.get("APP_ID"),
            "hashToken": os.environ.get("HASH_TOKEN")
        }
        response = requests.get(url=self.ENDPOINT+"/auth/v1/appToken", params=parameters)
        response.raise_for_status()
        data = response.json()
        self.expiration_time = (pd.Timestamp(data["result"]["expiry"])).to_pydatetime().replace(tzinfo=None)
        # self.expiration_time = self.expiration_time.replace(tzinfo=None)
        self.hash_token = data["result"]["token"]
        self.app_id = os.environ.get("APP_ID")

    # Gets a new token if the last one has expired
    def set_token(self):
        response = requests.get(url=self.ENDPOINT+"/auth/v1/appToken")
        response.raise_for_status()
        data = response.json()
        self.hash_token = data["result"]["token"]
        self.expiration_time = (pd.Timestamp(data["result"]["expiry"])).to_pydatetime().replace(tzinfo=None)

    # Checks if the api token has expired
    def check_time(self):
        now = dt.utcnow()
        if now >= self.expiration_time:
            self.set_token()
        else:
            print(f"All good. Check back at {self.expiration_time}.")

    def get_token(self):
        self.check_time()
        return [self.hash_token, self.expiration_time]








