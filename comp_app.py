from flask import Flask, jsonify, abort, make_response, request, url_for

app = Flask(__name__)

OPEN = 1
CLOSE = 0

devices = [
    {
        'id': 1,
        'status': 0
    },
    {
        'id': 2,
        'status': 1
    }
]

@app.route('/skylux/api/devices', methods=['GET'])
def get_devices():
    return jsonify({'devices': [make_public(device) for device in devices]})

@app.route('/skylux/api/status/<int:device_id>', methods=['GET'])
def get_status(device_id):
    device = [device for device in devices if device['id'] == device_id]
    if len(device) == 0:
        abort(404)
    return jsonify({'Skylight Status': device[0]['status']})


@app.route('/skylux/api/status/<int:dev_id>', methods=['PUT'])
def update_status(dev_id):
    device = [dev for dev in devices if dev['id'] == dev_id]

    if len(device) == 0:
        abort(404)
    if not request.json:
        abort(400)

    if not 'status' in request.json and not isinstance(request.json['status'], str):
        abort(400)

    device[0]['status'] = request.json.get('status', device[0]['status'])

    return jsonify({'Skylux': make_public(device[0])})

def make_public(device):
    new_dev = {}
    for field in device:
        if field == 'id':
            new_dev['uri'] = url_for('get_devices', task_id=device['id'], _external=True)
        else:
            new_dev[field] = device[field]

    return new_dev


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    app.run(debug = True)

