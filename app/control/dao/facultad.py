from ..connection import query


class Facultad:
    def get_all(self):
        q = "select id_facultad, nombre from facultad"
        return query(q)
