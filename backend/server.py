from flask import Flask
from credentials_manager import CredentialsManager

# Create flask app object
app = Flask(__name__)


@app.route("/")
def placeholder():
    return "<h1>Hi This is our Api for the Inrix Hack</h1>"


# decorator includes route and the method that the function supports
@app.route("/auth", methods=["Get"])
def test_api():
    credential_manager = CredentialsManager()
    login_data = credential_manager.get_token()
    return {
        "token": login_data[0],
        "expiry": login_data[1]
    }




if __name__ == "__main__":
    app.run(debug=True)

# show this change
