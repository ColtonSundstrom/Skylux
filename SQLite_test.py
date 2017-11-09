import sqlite3
conn = sqlite3.connect('example.db')

cur = conn.cursor()
cur.execute('''
          CREATE TABLE person
          (id INTEGER PRIMARY KEY ASC, name varchar(250) NOT NULL)
          ''')
cur.execute('''
          CREATE TABLE address
          (id INTEGER PRIMARY KEY ASC, street_name varchar(250), street_number varchar(250),
           post_code varchar(250) NOT NULL, person_id INTEGER NOT NULL,
           FOREIGN KEY(person_id) REFERENCES person(id))
          ''')

cur.execute('''
          INSERT INTO person VALUES(1, 'pythoncentral')
          ''')
cur.execute('''
          INSERT INTO address VALUES(1, 'python road', '1', '00000', 1)
          ''')

conn.commit()

cur.execute('SELECT * FROM person')
print(cur.fetchall())

cur.execute('SELECT * FROM address')
print(cur.fetchall())

conn.close()