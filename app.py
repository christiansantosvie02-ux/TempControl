
import os
import re

from dotenv import load_dotenv
import mysql.connector
from mysql.connector import Error
from flask import Flask, render_template, request

load_dotenv()

app = Flask(__name__)

DB_CONFIG = {
    "host": os.getenv("MYSQL_HOST", "localhost"),
    "port": int(os.getenv("MYSQL_PORT", "3306")),
    "user": os.getenv("MYSQL_USER", "root"),
    "password": os.getenv("MYSQL_PASSWORD", "senai105"),
    "database": os.getenv("MYSQL_DATABASE", "tempcontrol"),
}


def conectar_banco():
    """Abre uma conexão com o MySQL."""
    return mysql.connector.connect(**DB_CONFIG)


def validar_email(email):
    """Valida o formato do e-mail."""
    padrao = r"^[^@\s]+@[^@\s]+\.[^@\s]+$"
    return bool(re.match(padrao, email))


@app.route("/")
def inicio():
    return render_template("index.html")


@app.route("/contato", methods=["GET", "POST"])
def contato():

    form = {
        "nome": "",
        "email": "",
        "telefone": "",
        "empresa": "",
        "mensagem": "",
    }

    if request.method == "POST":

        form["nome"] = request.form.get("nome", "").strip()
        form["email"] = request.form.get("email", "").strip()
        form["telefone"] = request.form.get("telefone", "").strip()
        form["empresa"] = request.form.get("empresa", "").strip()
        form["mensagem"] = request.form.get("mensagem", "").strip()

        if not form["nome"] or not form["email"] or not form["mensagem"]:
            return render_template(
                "contato.html",
                sucesso=False,
                erro="Preencha todos os campos obrigatórios.",
                form=form,
            )

        if not validar_email(form["email"]):
            return render_template(
                "contato.html",
                sucesso=False,
                erro="Digite um endereço de e-mail válido.",
                form=form,
            )

        # Limite do nome
        if len(form["nome"]) > 120:
            return render_template(
                "contato.html",
                sucesso=False,
                erro="O nome deve ter no máximo 120 caracteres.",
                form=form,
            )

        if len(form["mensagem"]) > 2000:
            return render_template(
                "contato.html",
                sucesso=False,
                erro="A mensagem deve ter no máximo 2.000 caracteres.",
                form=form,
            )

        conexao = None
        cursor = None

        try:

            conexao = conectar_banco()

            if not conexao.is_connected():
                raise Exception("Não foi possível conectar ao MySQL.")

            cursor = conexao.cursor()

            sql = """
                INSERT INTO contatos
                    (nome, email, telefone, empresa, mensagem)
                VALUES
                    (%s, %s, %s, %s, %s)
            """

            valores = (
                form["nome"],
                form["email"],
                form["telefone"] if form["telefone"] else None,
                form["empresa"] if form["empresa"] else None,
                form["mensagem"],
            )

            cursor.execute(sql, valores)

            conexao.commit()

            print("====================================")
            print("CONTATO SALVO COM SUCESSO!")
            print("Nome:", form["nome"])
            print("E-mail:", form["email"])
            print("Telefone:", form["telefone"])
            print("Empresa:", form["empresa"])
            print("Mensagem:", form["mensagem"])
            print("ID:", cursor.lastrowid)
            print("====================================")

            form_limpo = {
                "nome": "",
                "email": "",
                "telefone": "",
                "empresa": "",
                "mensagem": "",
            }

            return render_template(
                "contato.html",
                sucesso=True,
                erro=None,
                form=form_limpo,
            )

        except mysql.connector.Error as e:

            if conexao:
                conexao.rollback()

            print("====================================")
            print("ERRO DO MYSQL:")
            print(e)
            print("====================================")

            return render_template(
                "contato.html",
                sucesso=False,
                erro=f"Erro ao salvar no banco de dados: {e}",
                form=form,
            )

        except Exception as e:

            if conexao:
                conexao.rollback()

            print("====================================")
            print("ERRO:")
            print(e)
            print("====================================")

            return render_template(
                "contato.html",
                sucesso=False,
                erro=f"Erro interno: {e}",
                form=form,
            )

        finally:

            if cursor:
                cursor.close()

            if conexao and conexao.is_connected():
                conexao.close()

    return render_template(
        "contato.html",
        sucesso=False,
        erro=None,
        form=form,
    )


if __name__ == "__main__":
    app.run(debug=True)
