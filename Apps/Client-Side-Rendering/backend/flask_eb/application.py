from flask import Flask, jsonify

application = app = Flask(__name__)

@application.route('/api/hello')
def hello():
    return jsonify(message='Hello from Flask!')

@application.route('/api/world')
def world():
    return jsonify(message='World from Flask!')

@application.route('/health')
def health():
    return jsonify(status='UP')

# When wanting to deploy as a elastic bean stalk
if __name__ == '__main__':
    application.run()