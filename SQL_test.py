import pymysql
import pymysql.cursors

password = 'ThisIsALongP4ssW0rd!!!'

db_connection = pymysql.connect(host='localhost', user='colton', password=password, db='test')

cur = db_connection.cursor()

cur.execute("INSERT INTO info (name, major, number) VALUES ('Pat', 'EDU', 3605811747);")

cur.commit()

cur.execute("SELECT * FROM info;")

for row in cur:
    print(row)

cur.close()
db_connection.close()