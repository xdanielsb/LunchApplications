from ..connection.pg_connection import execute, query


class DocumentoSolicitud:
    def create(self, data):
        q = "insert into documento_solicitud(id_solicitud, id_tipo_documento, url) values({}, {}, '{}')".format(
            data["id_solicitud"], data["id_tipo_documento"], data["url"]
        )
        return execute(q)

    def get(self, id_solicitud):
        q = "select ds.id_tipo_documento, td.nombre, url, id_estado_documento, comentarios, id_puntaje_tipo_documento from documento_solicitud as ds, tipo_documento as  td  where ds.id_tipo_documento = td.id_tipo_documento and id_solicitud={}".format(
            id_solicitud
        )
        return query(q)

    def update(self, data):
        q = "update documento_solicitud set  comentarios='{}', id_puntaje_tipo_documento={}, id_estado_documento={} where id_solicitud={} and id_tipo_documento={}".format(
            data["comentarios"],
            data["id_puntaje_tipo_documento"],
            data["id_estado_documento"],
            data["id_solicitud"],
            data["id_tipo_documento"],
        )
        print(q)
        execute(q)
