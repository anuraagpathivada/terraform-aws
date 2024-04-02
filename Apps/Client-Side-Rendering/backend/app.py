from flask import Flask, jsonify
from flask_cors import CORS
from aws_wsgi import make_lambda_handler

app = Flask(__name__)
CORS(app)

@app.route('/api/hello')
def hello():
    return jsonify(message='Hello from Flask!')

@app.route('/api/world')
def world():
    return jsonify(message='World from Flask!')

@app.route('/health')
def health():
    return jsonify(status='UP')

# When Deploying into a Serverless (Lambda)
lambda_handler = make_lambda_handler(app)

# When wanting to deploy as a traditional webserver
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
