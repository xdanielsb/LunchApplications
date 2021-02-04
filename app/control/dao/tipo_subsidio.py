from ..connection.pg_connection import query


class TipoSubsidio:
    def get_all(self):
        q = "select id_tipo_subsidio, nombre from tipo_subsidio"
        return query(q)
