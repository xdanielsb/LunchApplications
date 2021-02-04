from ..connection.pg_connection import execute, query
#from ..connection.or_connection import OracleConn
#from ..connection.absConnect import AbsConnect

class Solicitud:
    def create(self, data):
        q = "insert into solicitud(id_solicitud, id_estudiante, id_convocatoria, estrato) values ({}, {}, {}, {})".format(
            data["id_solicitud"],
            data["id_estudiante"],
            data["id_convocatoria"],
            data["estrato"],
        )
        #or_conn=OracleConn()    
        #or_conn.execute(q)
        execute(q)

    def get_estado(self, id_solicitud):
        q = "select id_estado_solicitud from solicitud where id_solicitud = {}".format(
            id_solicitud
        )
        return query(q)[0][0]

    def update_estado(self, id_solicitud, id_new_estado):
        q = "update solicitud set id_estado_solicitud ={} where id_solicitud ={}".format(
            id_new_estado, id_solicitud
        )
        execute(q)

    def get_current(self, data):
        q = "select * from solicitud where id_convocatoria={} and id_estudiante={}".format(
            data["id_convocatoria"], data["id_estudiante"]
        )
        ans = query(q)
        if len(ans) == 0:
            return None
        return ans[0]

    def get_all2(self):
        # also return the student id
        q = "select s.id_estudiante as id_estudiante, id_solicitud, e.identificacion, ultima_actualizacion, estado, id_convocatoria from solicitud as s, estado_solicitud as es, estudiante as e where s.id_estado_solicitud = es.id_estado_solicitud and s.id_estudiante=e.id_estudiante"
        return query(q)

    def get_all(self):
        q = "select id_solicitud, e.identificacion, ultima_actualizacion, estado, id_convocatoria from solicitud as s, estado_solicitud as es, estudiante as e where s.id_estado_solicitud = es.id_estado_solicitud and s.id_estudiante=e.id_estudiante"
        return query(q)

    def get_next_id(self):
        q = "select nextval(pg_get_serial_sequence('solicitud', 'id_solicitud')) as id_solicitud"
        return query(q)[0][0]
