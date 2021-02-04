from ..connection.pg_connection import query


class Estudiante:
    def get(self, iden):
        q = "select * from estudiante where identificacion = '{}'".format(iden)
        return query(q)[0]

    def get_by_email(self, email):
        q = "select * from estudiante where email = '{}'".format(email)
        print(q)
        ans = query(q)
        if len(ans) > 0:
            return ans[0]
        return ans
