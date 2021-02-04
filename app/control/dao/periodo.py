from ..connection.pg_connection import execute, query


class Periodo:
    def get_all(self):
        q = "select id_periodo, nombre from periodo"
        return query(q)

    def get_active_period(self, fecha_actual):
        q = "select id_periodo, nombre from periodo where fecha_inicio<='{}' and fecha_fin>='{}'".format(
            fecha_actual, fecha_actual
        )
        return query(q)

    def create(self, id_periodo, fecha_inicio, fecha_fin):
        q = "insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin) values({},{},{})".format(
            id_periodo, fecha_inicio, fecha_fin
        )
        execute(q)
        
    
    # def create(self, periodoDTO):
    #     q = "insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin) values({},{},{})".format(
    #         periodoDTO.id_periodo, periodoDTO.fecha_inicio, periodoDTO.fecha_fin
    #     )
    #     execute(q)
    
    # def create(self, id_periodo, fecha_inicio, fecha_fin):
    #     periodoDTO=PeriodoDTO(id_periodo, fecha_inicio, fecha_fin)
    #     q = "insert into periodo(id_periodo, nombre, fecha_inicio, fecha_fin) values({},{},{})".format(
    #         periodoDTO.id_periodo, periodoDTO.fecha_inicio, periodoDTO.fecha_fin
    #     )
    #     execute(q)


    
    
