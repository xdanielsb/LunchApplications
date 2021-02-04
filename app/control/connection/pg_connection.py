import psycopg2
import psycopg2.extras
from flask import g


def get_db(username=None, password=None):
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    err = None
    try:
        if not hasattr(g, "dbconn"):
            g.dbconn = psycopg2.connect(
                host="localhost",
                database="apoyo_alimentario",
                user=username if (username is not None) else g.user["username"],
                password=password if (password is not None) else g.user["password"],
            )
    except Exception as ex:
        err = str(ex)
        print(err)
    return err


def query(query):
    if not hasattr(g, "dbconn"):
        get_db()
    conn = g.dbconn
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(query)
    ans = [row for row in cur]
    cur.close()
    return ans


def execute(statement):
    if not hasattr(g, "dbconn"):
        get_db()
    conn = g.dbconn
    cur = conn.cursor()
    cur.execute(statement)
    conn.commit()
    cur.close()


if __name__ == "__main__":
    conn = psycopg2.connect(
         host="localhost", database="apoyo_alimentario", user="", password=""
    )
