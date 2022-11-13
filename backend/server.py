from flask import Flask, request, jsonify
from credentials_manager import CredentialsManager
from twilio.rest import Client
from twilio.rest import TwilioException
from credentials import TWILIO_TOKEN, TWILIO_ACCOUNT_SID, SEND_NUMBER

# Create flask app object
app = Flask(__name__)


@app.route("/")
def placeholder():
    return "<h1>Hi This is our Api for the Inrix Hack</h1>"


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
    client = Client(TWILIO_ACCOUNT_SID, TWILIO_TOKEN)
    if not phone_number or not client_message:
        return jsonify({
            "message": "parameter error"
        }), 400

    try:
        message = client.messages.create(
            to=phone_number,
            from_=SEND_NUMBER,
            body=client_message)

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


if __name__ == "__main__":
    app.run(debug=True)

# show this change
