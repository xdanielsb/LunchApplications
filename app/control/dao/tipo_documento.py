from ..connection.pg_connection import query


class TipoDocumento:
    def get_all(self):
        q = "select id_tipo_documento,obligatorio, nombre from tipo_documento"
        return query(q)
