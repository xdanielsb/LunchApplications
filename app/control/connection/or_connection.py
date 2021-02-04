import cx_Oracle
from absConnect import AbsConnect
from flask import g
    
class OracleConn(AbsConnect):
        
    def get_db(self,username=None, password=None):
        """Opens a new database connection if there is none yet for the
        current application context.
            """
        err = None
        try:
            if not hasattr(g, "dbconn"):
                # g.dbconn = psycopg2.connect(
                #     host="localhost",
                #     database="apoyo_alimentario",
                #     user=username if (username is not None) else g.user["username"],
                #     password=password if (password is not None) else g.user["password"],
                # )
                g.dbconn  = cx_Oracle.connect(
                    username if (username is not None) else g.user["username"],
                    password if (password is not None) else g.user["password"],
                    'localhost/xe')
        except Exception as ex:
            err = str(ex)
            print(err)
        return err
    
    def query(self,query):
        if not hasattr(g, "dbconn"):
            self.get_db()
        conn = g.dbconn
        cur = conn.cursor()
        cur.execute(query)
        res = cur.fetchmany(numRows = 25)
        ans = [row for row in res]
        cur.close()
        return ans
    
    def execute(self,statement):
        if not hasattr(g, "dbconn"):
            self.get_db()
        conn = g.dbconn
        cur = conn.cursor()
        cur.execute(statement)
        conn.commit()
        cur.close()
        
        
    # def get_db(self,username=None, password=None):
    #     self.username=username
    #     self.password=password
    #     print("Tengo la base de datos")
    #     print("usuario: ",username)
    #     print("password: ",password)
    #     print("host: ",self.host)
       
if __name__ == "__main__":
    conn = cx_Oracle.connect('','','@localhost/xe')
