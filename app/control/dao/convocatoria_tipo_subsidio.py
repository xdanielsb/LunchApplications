from ..connection.pg_connection import execute, query


class ConvocatoriaTipoSubsidio:
    def create(self, data):
        q = "insert into tipo_subsidio_convocatoria(id_convocatoria, id_tipo_subsidio, cantidad_de_almuerzos_ofertados) values ({}, {}, {})".format(
            data["id_convocatoria"],
            data["id_tipo_subsidio"],
            data["cantidad_de_almuerzos_ofertados"],
        )
        execute(q)

    def get(self, id_convocatoria):
        q = "select id_tipo_subsidio,cantidad_de_almuerzos_ofertados from tipo_subsidio_convocatoria where id_convocatoria={}".format(
            id_convocatoria
        )
        return query(q)

    def update(self, data):
        q = "update tipo_subsidio_convocatoria set  cantidad_de_almuerzos_ofertados={} where id_tipo_subsidio={} and id_convocatoria={}".format(
            data["cantidad_de_almuerzos_ofertados"],
            data["id_tipo_subsidio"],
            data["id_convocatoria"],
        )
        execute(q)
