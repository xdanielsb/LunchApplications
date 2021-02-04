from ..connection.pg_connection import query


class EstadoDocumento:
    def get_all(self):
        q = "select id_estado_documento, nombre from estado_documento"
        return query(q)
