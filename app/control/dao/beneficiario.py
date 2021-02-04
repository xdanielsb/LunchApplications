from ..connection.pg_connection import query, execute


class Beneficiario:
    def get_all(self):
        q = "select * from beneficiario"
        return query(q)

    def create(self, data):
        q = "insert into beneficiario (id_tipo_subsidio, id_solicitud) values({},{})".format(
            data["id_tipo_subsidio"], data["id_solicitud"]
        )
        execute(q)

    def delete_all(self):
        q = "delete from beneficiario"
        execute(q)
