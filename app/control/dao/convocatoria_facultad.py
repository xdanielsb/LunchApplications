from ..connection.pg_connection import execute, query


class ConvocatoriaFacultad:
    def create(self, data):
        q = "insert into convocatoria_facultad(id_convocatoria, id_facultad, cantidad_de_almuerzos) values({}, {}, {})".format(
            data["id_convocatoria"], data["id_facultad"], data["cantidad_de_almuerzos"]
        )
        execute(q)

    def get(self, id_convocatoria):
        q = "select id_facultad, cantidad_de_almuerzos from convocatoria_facultad where id_convocatoria={}".format(
            id_convocatoria
        )
        return query(q)

    def update(self, data):
        q = "update convocatoria_facultad set  cantidad_de_almuerzos={} where id_facultad={} and id_convocatoria={}".format(
            data["cantidad_de_almuerzos"], data["id_facultad"], data["id_convocatoria"]
        )
        execute(q)
