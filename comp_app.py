from flask import Flask, jsonify, abort, make_response, request, url_for
import sqlite3


OPEN = 1
CLOSE = 0


app = Flask(__name__)

conn = sqlite3.connect('devices.db')
cur = conn.cursor()


cur.execute('''
            CREATE TABLE IF NOT EXISTS devices(
            dev_id INTEGER PRIMARY KEY ASC,
            ip varchar(15) NOT NULL,
            status INTEGER NOT NULL,
            active BIT NOT NULL);
            ''')
conn.commit()

cur.execute('''
            SELECT name FROM sqlite_master WHERE type='table';
            ''')

print("Printing tables in 'devices.db':")
tabs = cur.fetchall()
for tab in tabs:
    print(tab[0])


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
    get_conn = sqlite3.connect('devices.db')
    get_cur = get_conn.cursor()

    get_cur.execute('''
              SELECT dev_id FROM devices;
              ''')
    dev_ids = get_cur.fetchall()
    if len(dev_ids) == 0:
        abort(404)

    get_conn.close()
    devs = []
    for id in dev_ids:
        devs.append(id[0])

    return jsonify({'devices': devs})
    # return jsonify({'devices': [make_public(device) for device in devices]})


@app.route('/skylux/api/status/<int:device_id>', methods=['GET'])
def get_status(device_id):
    get_stat_conn = sqlite3.connect('devices.db');
    stat_cur = get_stat_conn.cursor()

    stat_cur.execute('''
                    SELECT status FROM devices WHERE dev_id = {did};
                    '''.format(did=device_id))
    res_status = stat_cur.fetchall()

    get_stat_conn.close()

    if len(res_status) == 0:
        abort(404)

    status = res_status[0]

    return jsonify({'Skylight Status': status})


@app.route('/skylux/api/status/<int:dev_id>', methods=['PUT'])
def update_status(dev_id):
    device = [dev for dev in devices if dev['id'] == dev_id]
    put_conn = sqlite3.connect('devices.db')


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

