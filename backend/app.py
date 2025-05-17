from flask import Flask, jsonify
from flask_cors import CORS
from extract_image_info.receipt_utils import receipt_utils

app = Flask(__name__)
CORS(app)  # This will allow all domains by default

app.register_blueprint(receipt_utils, url_prefix='/api')

@app.route('/')
def home():
    return jsonify({"message": "Welcome to the Flask API"})

@app.route('/api/test')
def test():
    return jsonify({"message": "API is working correctly"})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
