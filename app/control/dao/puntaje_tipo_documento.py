from collections import defaultdict

from ..connection.pg_connection import query


class PuntajeTipoDocumento:
    def get_all(self):
        q = "select nombre, id_tipo_documento, puntaje, id_puntaje_tipo_documento from puntaje_tipo_documento order by puntaje"
        res = defaultdict(list)
        for nombre, id_tipo_documento, puntaje, id_puntaje_tipo_documento in query(q):
            res[id_tipo_documento].append(
                [nombre, id_tipo_documento, puntaje, id_puntaje_tipo_documento]
            )
        print(res)
        return res
