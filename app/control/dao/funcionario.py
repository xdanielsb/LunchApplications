from ..connection.pg_connection import query


class Funcionario:
    def get(self, iden):
        q = "select * from funcionario where identificacion = '{}'".format(iden)
        return query(q)[0]

    def get_by_email(self, email):
        q = "select * from funcionario where email = '{}'".format(email)
        return query(q)[0]
