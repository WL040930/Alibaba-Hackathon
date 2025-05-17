from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({"message": "Welcome to the Flask API"})

@app.route('/api/test')
def test():
    return jsonify({"message": "API is working correctly"})

if __name__ == '__main__':
    app.run(debug=True)