from ..connection.pg_connection import execute, query
from .beneficiario import Beneficiario


class Convocatoria:
    def get_current_active(self, fecha_actual):
        q = "select * from convocatoria where fecha_abierta <= '{}' and fecha_cerrada >= '{}'".format(
            fecha_actual, fecha_actual
        )
        ans = query(q)
        if len(ans) == 0:
            return None
        return ans[0]

    def exist(self, id_convocatoria):
        q = "select count(*) from convocatoria where id_convocatoria = {}".format(
            id_convocatoria
        )
        ans = query(q)[0]
        return ans[0] != 0

    def create(self, data):
        q = "insert into convocatoria(id_convocatoria, fecha_creacion, fecha_abierta, fecha_cerrada, fecha_publicacion_resultados, id_periodo) values ({}, '{}', '{}', '{}', '{}', {})".format(
            data["id_convocatoria"],
            data["fecha_creacion"],
            data["fecha_abierta"],
            data["fecha_cerrada"],
            data["fecha_publicacion_resultados"],
            data["id_periodo"],
        )
        execute(q)

    def update(self, data):
        q = "update convocatoria set  fecha_abierta='{}' , fecha_cerrada='{}' , fecha_publicacion_resultados='{}', id_periodo={} where id_convocatoria={}".format(
            data["fecha_abierta"],
            data["fecha_cerrada"],
            data["fecha_publicacion_resultados"],
            data["id_periodo"],
            data["id_convocatoria"],
        )
        execute(q)

    def get(self, id_convocatoria):
        q = "select * from convocatoria where id_convocatoria={}".format(
            id_convocatoria
        )
        return query(q)

    def lunch_facs_equal_lunch_types(self, id_convocatoria):
        # verify the sum of tipo_subsidio_convocatoria is the same of convocatoria_facultad
        q1 = query(
            "select sum(cantidad_de_almuerzos_ofertados) from tipo_subsidio_convocatoria where id_convocatoria={}".format(
                id_convocatoria
            )
        )
        q2 = query(
            "select sum(cantidad_de_almuerzos) from convocatoria_facultad where id_convocatoria={}".format(
                id_convocatoria
            )
        )
        return q1[0][0] == q2[0][0]

    def compute_results(self, id_convocatoria):
        execute("call compute_scores_in_convocatory({})".format(id_convocatoria))

    def generar_beneficiarios(self, id_convocatoria):
        self.compute_results(id_convocatoria)
        # get the best solicitudes(id_solicitud, id_facultad) from best to worst for a given convocatoria (order by puntaje desc)
        q1 = query(
            "select id_solicitud, id_facultad from solicitud as s, estudiante as e, proyecto_curricular as p  where id_convocatoria = {} and s.id_estudiante=e.id_estudiante and p.id_proyecto_curricular=e.id_proyecto_curricular order by puntaje desc".format(
                id_convocatoria
            )
        )
        # get the tipo_subsidios from the best to worst for a given convocatoria (order by porcentaje_subsidiado desc)
        q2 = query(
            "select * from tipo_subsidio as ts, tipo_subsidio_convocatoria as tsc where ts.id_tipo_subsidio=tsc.id_tipo_subsidio and id_convocatoria={} order by porcentaje_subsidiado desc".format(
                id_convocatoria
            )
        )
        # get the number of lunches per convocatoria and tipo subsidio
        q3 = dict(
            query(
                "select id_tipo_subsidio, cantidad_de_almuerzos_ofertados from tipo_subsidio_convocatoria where id_convocatoria={}".format(
                    id_convocatoria
                )
            )
        )
        # get the number of lunche per convocatoria and facultad
        q4 = dict(
            query(
                "select id_facultad, cantidad_de_almuerzos from convocatoria_facultad where id_convocatoria={}".format(
                    id_convocatoria
                )
            )
        )

        print(q1, type(q1[0]))
        print(q2)
        print(q3)
        print(q4)
        # here we go!, gimme luck !
        for id_solicitud, id_facultad in q1:
            if len(q2) > 0:  # is there any lunches left to assign?
                # find the tipo subsidio to assign, from best to worst
                tipo_subsidio_to_assign = q2[0]["id_tipo_subsidio"]
                while len(q2) and q3[tipo_subsidio_to_assign] == 0:
                    q2.pop(0)
                    if len(q2):
                        tipo_subsidio_to_assign = q2[0]["id_tipo_subsidio"]
                if q3[tipo_subsidio_to_assign] == 0:
                    break

                if q4[id_facultad] > 0:  # there are places left in that fac
                    # we have a winner
                    data = {
                        "id_tipo_subsidio": tipo_subsidio_to_assign,
                        "id_solicitud": id_solicitud,
                    }
                    Beneficiario().create(data)
                    q4[id_facultad] = (
                        q4[id_facultad] - 1
                    )  # decrease the places in that fact
                    q3[tipo_subsidio_to_assign] = q3[tipo_subsidio_to_assign] - 1
                    if q3[tipo_subsidio_to_assign] == 0:
                        q2.pop(0)  # remove the first

    def get_results(self, id_convocatoria):
        q = "select * from (select id_tipo_subsidio, identificacion, nombre1,  apellido1  puntaje, id_proyecto_curricular  from (select id_estudiante,puntaje,id_tipo_subsidio from solicitud as s left join beneficiario as b on b.id_solicitud=s.id_solicitud where id_convocatoria = {}) as res, estudiante as e where res.id_estudiante = e.id_estudiante) as res2 left join tipo_subsidio as ts2 on res2.id_tipo_subsidio= ts2.id_tipo_subsidio".format(
            id_convocatoria
        )
        return query(q)

    def delete(self, id_convocatoria):
        q = "delete from convocatoria where id_convocatoria={}".format(id_convocatoria)
        execute(q)

    def get_all(self):
        q = "select c.id_convocatoria,c.fecha_creacion, c.fecha_abierta, c.fecha_cerrada, c.fecha_publicacion_resultados, p.nombre from convocatoria as c, periodo as p  where p.id_periodo = c.id_periodo"
        return query(q)

    def get_next_id(self):
        q = "select nextval(pg_get_serial_sequence('convocatoria', 'id_convocatoria')) as id_convocatoria"
        return query(q)[0][0]
