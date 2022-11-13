from flask import Flask, request, jsonify
from credentials_manager import CredentialsManager
from twilio.rest import Client
from twilio.rest import TwilioException
from credentials import TWILIO_TOKEN, TWILIO_ACCOUNT_SID, SEND_NUMBER
from PolygonParse import DrivePolygon
from geocoding import address_to_geocode
import os

# Create flask app object
app = Flask(__name__)


@app.route("/")
def placeholder():
    return f"<h1>Hi This is our Api for the Inrix Hack</h1> \
    <p>{CredentialsManager().get_token()[0]}</p> \
    "


# decorator includes route and the method that the function supports
@app.route("/auth", methods=["Get"])
def test_api():
    if request.method == "GET":
        credential_manager = CredentialsManager()
        login_data = credential_manager.get_token()
        return {
            "token": login_data[0],
            "expiry": login_data[1]
        }


# Twilio Message Functionality
@app.route("/sendmessage")
def send_message():
    phone_number = request.args.get("number")
    client_message = request.args.get("message")
    client = Client(os.environ.get("TWILIO_SID"), os.environ.get("TWILIO_TOKEN"))
    if not phone_number or not client_message:
        return jsonify({
            "message": "parameter error"
        }), 400

    try:
        message = client.messages.create(
            to=phone_number,
            from_=os.environ.get("TWILIO_PHONE_NUMBER"),
            body=client_message)

        print("here")
        if message.status == "queued":
            return {
                "message": client_message,
                "message_code": "Message sent successfully."
            }, 200
        return {
            "code": 500,
            "message": "Server error. Likely an invalid phone number."
        }, 500
    except TwilioException:
        return {
            "code": 500,
            "message": "Server error. Likely an invalid phone number."
        }, 500

@app.route("/checkdistance")
def check_distance():
    my_lon = request.args.get("my_lon")
    my_lat = request.args.get("my_lat")
    time_thresh = request.args.get("time_thresh")
    lon = request.args.get("lon")
    lat = request.args.get("lat")
    #return jsonify({"a": my_lon, "b":my_lat, "c": time_thresh, "d":lon, "e":lat}), 200

    my_coord = (my_lon, my_lat)
    target_coord = (lat, lon)
    dpoly = DrivePolygon(time_thresh, target_coord)
    valid = dpoly.check(my_coord)

    return jsonify({"inside": valid, "coords": dpoly.coords}), 200

@app.route("/getcoordinates")
def get_coords():
    address = request.args.get("address")
    lat, lon = address_to_geocode(address)
    return jsonify({"lat": lat, "lon": lon}), 200


if __name__ == "__main__":
    app.run(host = "0.0.0.0", threaded = True, debug=True)


# show this change
