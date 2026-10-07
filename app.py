import os
import re

from dotenv import load_dotenv
import mysql.connector
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

LIMITE_EQUIPAMENTOS = 200   # linhas na tabela de resultados
LIMITE_EMPRESAS = 100       # cartões de empresas pesquisadas
QTD_RECOMENDADAS = 6        # empresas recomendadas


def conectar_banco():
    return mysql.connector.connect(**DB_CONFIG)


def validar_email(email):
    padrao = r"^[^@\s]+@[^@\s]+\.[^@\s]+$"
    return bool(re.match(padrao, email))


def escapar_like(texto):
    return (
        texto
        .replace("\\", "\\\\")
        .replace("%", "\\%")
        .replace("_", "\\_")
    )


def buscar_registros(sql, parametros=None):
    """Executa um SELECT e devolve os registros como dicionários."""

    conexao = None
    cursor = None

    try:
        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)
        cursor.execute(sql, parametros or [])
        return cursor.fetchall()

    finally:
        if cursor:
            cursor.close()

        if conexao and conexao.is_connected():
            conexao.close()


@app.template_filter("temp")
def formatar_temperatura(valor):
    """-20.5 -> '-20,50' (padrão brasileiro)."""
    if valor is None:
        return "—"
    return f"{float(valor):.2f}".replace(".", ",")


@app.template_filter("percentual")
def formatar_percentual(valor):
    if valor is None:
        return "—"
    return f"{float(valor):.1f}".replace(".", ",")


@app.template_filter("data_br")
def formatar_data(valor):
    if not valor:
        return "—"
    return valor.strftime("%d/%m/%Y %H:%M")


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
                form["telefone"] or None,
                form["empresa"] or None,
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


# ----------------------------------------------------------------------
# Consulta / Monitoramento
# ----------------------------------------------------------------------

def montar_filtros_equipamentos(empresa="", equipamento="", tipo=""):
    """Devolve (' WHERE ...', [parâmetros]) para a tabela `equipamentos` (alias e)."""

    condicoes = []
    parametros = []

    if empresa:
        condicoes.append("e.empresa LIKE %s")
        parametros.append("%" + escapar_like(empresa) + "%")

    if equipamento:
        condicoes.append("e.nome LIKE %s")
        parametros.append("%" + escapar_like(equipamento) + "%")

    if tipo:
        condicoes.append("e.tipo LIKE %s")
        parametros.append("%" + escapar_like(tipo) + "%")

    if condicoes:
        return " WHERE " + " AND ".join(condicoes), parametros

    return "", parametros


def buscar_resumo():
    """Totais gerais exibidos nos cartões do topo."""

    sql = """
        SELECT
            (SELECT COUNT(DISTINCT empresa) FROM equipamentos)
                AS total_empresas,
            (SELECT COUNT(*) FROM equipamentos)
                AS total_equipamentos,
            (SELECT COUNT(*) FROM leituras_temperatura)
                AS total_leituras,
            (SELECT ROUND(AVG(temperatura), 2) FROM leituras_temperatura)
                AS temperatura_media
    """

    return buscar_registros(sql)[0]


def buscar_equipamentos(where, parametros):
    """Uma linha por equipamento, com média e última leitura."""

    sql = f"""
        SELECT
            e.equipamento_id,
            e.empresa,
            e.nome AS equipamento,
            e.localizacao,
            e.tipo,
            e.temp_min,
            e.temp_max,
            COUNT(l.leitura_id) AS quantidade_leituras,
            ROUND(AVG(l.temperatura), 2) AS temperatura_media,
            MAX(l.registrada_em) AS ultima_leitura,
            (
                SELECT l2.temperatura
                FROM leituras_temperatura l2
                WHERE l2.equipamento_id = e.equipamento_id
                ORDER BY l2.registrada_em DESC, l2.leitura_id DESC
                LIMIT 1
            ) AS ultima_temperatura
        FROM equipamentos e
        LEFT JOIN leituras_temperatura l
            ON l.equipamento_id = e.equipamento_id
        {where}
        GROUP BY e.equipamento_id
        ORDER BY e.empresa, e.nome
        LIMIT %s
    """

    return buscar_registros(sql, parametros + [LIMITE_EQUIPAMENTOS])


def buscar_empresas(where, parametros):
    """Uma linha por empresa pesquisada, com a média das temperaturas."""

    sql = f"""
        SELECT
            e.empresa,
            COUNT(DISTINCT e.equipamento_id) AS quantidade_equipamentos,
            COUNT(l.leitura_id) AS quantidade_leituras,
            ROUND(AVG(l.temperatura), 2) AS temperatura_media,
            ROUND(
                100 * SUM(l.temperatura BETWEEN e.temp_min AND e.temp_max)
                / NULLIF(COUNT(l.leitura_id), 0),
                1
            ) AS conformidade
        FROM equipamentos e
        LEFT JOIN leituras_temperatura l
            ON l.equipamento_id = e.equipamento_id
        {where}
        GROUP BY e.empresa
        ORDER BY e.empresa
        LIMIT %s
    """

    return buscar_registros(sql, parametros + [LIMITE_EMPRESAS])


def buscar_recomendadas():
    """
    Empresas recomendadas = as que mantêm a temperatura dentro da faixa
    ideal de seus equipamentos (maior % de leituras conformes). Em caso
    de empate, vence quem fica mais perto do centro da faixa.
    """

    sql = """
        SELECT
            e.empresa,
            COUNT(DISTINCT e.equipamento_id) AS quantidade_equipamentos,
            COUNT(l.leitura_id) AS quantidade_leituras,
            ROUND(AVG(l.temperatura), 2) AS temperatura_media,
            ROUND(
                100 * SUM(l.temperatura BETWEEN e.temp_min AND e.temp_max)
                / COUNT(l.leitura_id),
                1
            ) AS conformidade,
            AVG(
                ABS(l.temperatura - (e.temp_min + e.temp_max) / 2)
                / ((e.temp_max - e.temp_min) / 2)
            ) AS desvio_relativo
        FROM equipamentos e
        INNER JOIN leituras_temperatura l
            ON l.equipamento_id = e.equipamento_id
        GROUP BY e.empresa
        ORDER BY conformidade DESC, desvio_relativo ASC, e.empresa ASC
        LIMIT %s
    """

    return buscar_registros(sql, [QTD_RECOMENDADAS])


@app.route("/consulta", methods=["GET", "POST"])
def consultar():

    # aceita GET (links e formulário) e POST
    dados = request.values

    filtros = {
        "empresa": dados.get("empresa", "").strip(),
        "equipamento": dados.get("equipamento", "").strip(),
        "tipo": dados.get("tipo", "").strip(),
    }

    # houve pesquisa quando o formulário foi enviado (mesmo com campos vazios)
    buscou = (
        request.method == "POST"
        or any(campo in dados for campo in filtros)
    )

    contexto = {
        "filtros": filtros,
        "buscou": buscou,
        "resumo": None,
        "empresas": None,
        "resultados": None,
        "recomendadas": [],
        "erro": None,
    }

    try:
        contexto["resumo"] = buscar_resumo()
        contexto["recomendadas"] = buscar_recomendadas()

        if buscou:
            where, parametros = montar_filtros_equipamentos(**filtros)
            contexto["empresas"] = buscar_empresas(where, parametros)
            contexto["resultados"] = buscar_equipamentos(where, parametros)

    except mysql.connector.Error as e:
        print("====================================")
        print("ERRO DO MYSQL NA CONSULTA:")
        print(e)
        print("====================================")
        contexto["erro"] = (
            "Não foi possível consultar os registros. Tente novamente."
        )

    except Exception as e:
        print("====================================")
        print("ERRO NA CONSULTA:")
        print(e)
        print("====================================")
        contexto["erro"] = "Ocorreu um erro ao realizar a consulta."

    return render_template("consulta.html", **contexto)


if __name__ == "__main__":
    app.run(debug=True)