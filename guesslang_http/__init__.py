__version__ = '0.1.0'

from guesslang import Guess
from flask import Flask
from flask import request
import base64

guess = Guess()
app = Flask(__name__)

@app.route("/classify", methods=['POST'])
def classify():
    json = request.get_json()
    snippet = json['snippet']
    base64_decoded = base64.b64decode(snippet)
    return { "language": guess.language_name(base64_decoded) }
