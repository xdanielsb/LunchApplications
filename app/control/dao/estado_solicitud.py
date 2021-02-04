from ..connection.pg_connection import query


class EstadoSolicitud:
    def get_all(self):
        q = "select id_estado_solicitud, estado from estado_solicitud"
        return query(q)
