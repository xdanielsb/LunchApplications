import cx_Oracle

username='apal'
password='admin123'
#conn = cx_Oracle.connect('apal/admin123@localhost/xe')
conn = cx_Oracle.connect(username,password,'localhost/xe')
cur = conn.cursor()
print("Database version:", conn.version)
# *********--------***********
# PRUEBA BIND INSERT (Consultas de enlace)

# conn = cx_Oracle.connect('apal/admin123@localhost/xe')
# cur = conn.cursor()

# rows = [ (1, "First" ), (2, "Second" ),
#          (3, "Third" ), (4, "Fourth" ),
#          (5, "Fifth" ), (6, "Sixth" ),
#          (6, "Duplicate" ),
#          (7, "Seventh" ) ]

# cur.executemany("insert into prueba_conn(id_proof, nombre) values (:1, :2)", rows, batcherrors = True)

# # Now query the results back

# cur2 = conn.cursor()
# cur2.execute('select * from prueba_conn')
# res = cur2.fetchall()
# print(res)
# *********--------***********

# *********--------***********
# PRUEBA BIND QUERIES (Consultas de enlace) (SELECT) 

# conn = cx_Oracle.connect('apal/admin123@localhost/xe')
# cur = conn.cursor()

# sql="select * from prueba_conn where id_proof = :id order by id_proof"

# print(conn.stmtcachesize)

# cur.execute(sql, id = 15)
# res = cur.fetchall()
# print(res)

# cur.execute(sql, id = 11)
# res = cur.fetchall()
# print(res)

# *********--------***********
# PRUEBA SELECT

# conn = cx_Oracle.connect('apal/admin123@localhost/xe')
# print("Database version:", conn.version)

# cur = conn.cursor()
# cur.execute("select * from PRUEBA_CONN where id_proof=11")
# #res = cur.fetchall()
# ans = [row for row in cur]
# print(ans)
    
# print("Select hecho")

# cur = conn.cursor(scrollable = True)

# cur.execute("select * from prueba_conn order by id_proof")
# cur.scroll(2, mode = "absolute")  # go to second row
# print(cur.fetchone())

# cur.scroll(-1)                    # go back one row
# print(cur.fetchone())

# cur.scroll(mode = "last")  # go to first row
# print(cur.fetchone())

# cur.close()
# conn.close()

# *********--------***********


# *********--------***********

# PRUEBA INSERT

# try:
#     #Se crea la conexion
#     conn = cx_Oracle.connect('apal/admin123@localhost/xe')
# except Exception as err:
#     print('Error mientras se creaba la conexion ',err)
# else:
#     print(conn.version)
#     try:
#         #Se crea el cursor
#         cur = conn.cursor()
#         sql_insert= """ 
#         INSERT INTO PRUEBA_CONN VALUES (:1,:2)
#         """
#         data = [(13,"funciona list insert 1"),(14,"funciona list insert 2"),(15,"funciona list insert 3")]
#         #cur.execute(sql_insert,[12,"funciona multiple insert"])
#         cur.executemany(sql_insert,data)
#     except Exception as err:
#         print (" ERROR mientras se insertaba el dato ",err)
#     else:
#         print('Insertado.')
#         #Con esto se guarda el dato insertado en la base de datos.
#         conn.commit()
# finally:
#     cur.close()
#     conn.close()

# *********--------***********




# #---------------------- COMENTS

# Consultas Utiles ORACLE

# *********--------***********

# PRUEBA CREATE

# conn = cx_Oracle.connect('apal/admin123@localhost/xe')
# print("Database version:", conn.version)

# cur = conn.cursor()

# sql_create = """
# CREATE TABLE PRUEBA_CONN(
#     id_proof number(2,0) not null,
#     nombre varchar2(15 byte) not null,
#     constraint id_proof_pk primary key (id_proof) enable
# )
# """
    
# cur.execute(sql_create)
# print("Tabla Creada")

# cur.close()
# conn.close()

# *********--------***********

# SELECT TABLE_NAME FROM USER_TABLES;  Tablas

 
# cur.execute(""SELECT * FROM estudiante"")
# print('Hecho el Select.')

# sql_insert= """ 
#        INSERT INTO asignatura(ID, NAME,CARRERA) VALUES (420,'Especiales','Sistemas')
#     """

# try:
#     for cols in cur:
#         print(cols)
#     cur.close()
#     conn.close()
# except Exception as e:
#     print(str(e)) 
