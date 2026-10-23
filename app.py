
import os
import re
import unicodedata

from dotenv import load_dotenv
import mysql.connector
from flask import Flask, render_template, request


# Carrega as configurações do arquivo .env
load_dotenv()

app = Flask(__name__)


# Configuração da conexão com o MySQL
DB_CONFIG = {
    "host": os.getenv("MYSQL_HOST", "localhost"),
    "port": int(os.getenv("MYSQL_PORT", "3306")),
    "user": os.getenv("MYSQL_USER", "root"),
    "password": os.getenv("MYSQL_PASSWORD", "senai105"),
    "database": os.getenv("MYSQL_DATABASE", "tempcontrol"),
}


# Limites de resultados
LIMITE_EQUIPAMENTOS = 200
LIMITE_EMPRESAS = 100
QTD_RECOMENDADAS = 6


# ============================================================
# CONEXÃO COM O BANCO DE DADOS
# ============================================================

def conectar_banco():
    """Abre uma conexão com o MySQL."""
    return mysql.connector.connect(**DB_CONFIG)


def validar_email(email):
    """Verifica se o formato do e-mail é válido."""
    padrao = r"^[^@\s]+@[^@\s]+\.[^@\s]+$"
    return bool(re.match(padrao, email))


def escapar_like(texto):
    """Escapa caracteres especiais usados em pesquisas LIKE."""
    return (
        texto
        .replace("\\", "\\\\")
        .replace("%", "\\%")
        .replace("_", "\\_")
    )


def buscar_registros(sql, parametros=None):
    """Executa um SELECT e devolve os resultados como dicionários."""

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


# ============================================================
# FILTROS DE FORMATAÇÃO PARA OS TEMPLATES HTML
# ============================================================

@app.template_filter("temp")
def formatar_temperatura(valor):
    """Formata temperaturas com duas casas decimais."""
    if valor is None:
        return "—"

    return f"{float(valor):.2f}".replace(".", ",")


@app.template_filter("percentual")
def formatar_percentual(valor):
    """Formata percentuais com uma casa decimal."""
    if valor is None:
        return "—"

    return f"{float(valor):.1f}".replace(".", ",")


@app.template_filter("data_br")
def formatar_data(valor):
    """Formata datas no padrão brasileiro."""
    if not valor:
        return "—"

    return valor.strftime("%d/%m/%Y %H:%M")


# ============================================================
# PÁGINA INICIAL
# ============================================================

@app.route("/")
def inicio():
    return render_template("index.html")


# ============================================================
# FORMULÁRIO DE CONTATO
# ============================================================

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

        # Recebe os dados enviados pelo formulário
        form["nome"] = request.form.get("nome", "").strip()
        form["email"] = request.form.get("email", "").strip()
        form["telefone"] = request.form.get("telefone", "").strip()
        form["empresa"] = request.form.get("empresa", "").strip()
        form["mensagem"] = request.form.get("mensagem", "").strip()

        # Verifica os campos obrigatórios
        if not form["nome"] or not form["email"] or not form["mensagem"]:
            return render_template(
                "contato.html",
                sucesso=False,
                erro="Preencha todos os campos obrigatórios.",
                form=form,
            )

        # Valida o formato do e-mail
        if not validar_email(form["email"]):
            return render_template(
                "contato.html",
                sucesso=False,
                erro="Digite um endereço de e-mail válido.",
                form=form,
            )

        # Valida o tamanho do nome
        if len(form["nome"]) > 120:
            return render_template(
                "contato.html",
                sucesso=False,
                erro="O nome deve ter no máximo 120 caracteres.",
                form=form,
            )

        # Valida o tamanho da mensagem
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

            print("Contato salvo com sucesso!")
            print("ID:", cursor.lastrowid)

            # Limpa o formulário após salvar
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

            if conexao and conexao.is_connected():
                conexao.rollback()

            # O detalhe técnico fica no terminal
            print("ERRO DO MYSQL AO SALVAR CONTATO:", e)

            return render_template(
                "contato.html",
                sucesso=False,
                erro=(
                    "Não foi possível salvar o contato. "
                    "Verifique a conexão e tente novamente."
                ),
                form=form,
            )

        except Exception as e:

            if conexao and conexao.is_connected():
                conexao.rollback()

            print("ERRO AO PROCESSAR CONTATO:", e)

            return render_template(
                "contato.html",
                sucesso=False,
                erro=(
                    "Ocorreu um erro interno ao processar "
                    "o contato. Tente novamente."
                ),
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


# ============================================================
# CONSULTA E MONITORAMENTO
# ============================================================

def montar_filtros_equipamentos(
    empresa="",
    equipamento="",
    tipo=""
):
    """Monta os filtros da consulta de equipamentos."""

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


# ============================================================
# RESUMO GERAL
# ============================================================

def buscar_resumo():
    """Busca os totais apresentados no topo da página."""

    sql = """
        SELECT
            (
                SELECT COUNT(DISTINCT empresa)
                FROM equipamentos
            ) AS total_empresas,

            (
                SELECT COUNT(*)
                FROM equipamentos
            ) AS total_equipamentos,

            (
                SELECT COUNT(*)
                FROM leituras_temperatura
            ) AS total_leituras,

            (
                SELECT ROUND(AVG(temperatura), 2)
                FROM leituras_temperatura
            ) AS temperatura_media
    """

    registros = buscar_registros(sql)

    return registros[0]


# ============================================================
# LISTA DE EQUIPAMENTOS
# ============================================================

def buscar_equipamentos(where, parametros):
    """Busca equipamentos, médias e últimas temperaturas."""

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

            ROUND(AVG(l.temperatura), 2)
                AS temperatura_media,

            MAX(l.registrada_em)
                AS ultima_leitura,

            (
                SELECT l2.temperatura
                FROM leituras_temperatura l2
                WHERE l2.equipamento_id = e.equipamento_id
                ORDER BY
                    l2.registrada_em DESC,
                    l2.leitura_id DESC
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

    return buscar_registros(
        sql,
        parametros + [LIMITE_EQUIPAMENTOS]
    )


# ============================================================
# RESUMO DAS EMPRESAS
# ============================================================

def buscar_empresas(where, parametros):
    """Calcula indicadores de temperatura por empresa."""

    sql = f"""
        SELECT
            e.empresa,

            COUNT(DISTINCT e.equipamento_id)
                AS quantidade_equipamentos,

            COUNT(l.leitura_id)
                AS quantidade_leituras,

            ROUND(AVG(l.temperatura), 2)
                AS temperatura_media,

            ROUND(
                100 * SUM(
                    l.temperatura BETWEEN e.temp_min AND e.temp_max
                ) / NULLIF(COUNT(l.leitura_id), 0),
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

    return buscar_registros(
        sql,
        parametros + [LIMITE_EMPRESAS]
    )


# ============================================================
# EMPRESAS RECOMENDADAS
# ============================================================

def buscar_recomendadas():
    """
    Prioriza empresas com maior percentual de leituras
    dentro da faixa de temperatura permitida.
    """

    sql = """
        SELECT
            e.empresa,

            COUNT(DISTINCT e.equipamento_id)
                AS quantidade_equipamentos,

            COUNT(l.leitura_id)
                AS quantidade_leituras,

            ROUND(AVG(l.temperatura), 2)
                AS temperatura_media,

            ROUND(
                100 * SUM(
                    l.temperatura BETWEEN e.temp_min AND e.temp_max
                ) / NULLIF(COUNT(l.leitura_id), 0),
                1
            ) AS conformidade,

            AVG(
                ABS(
                    l.temperatura - (e.temp_min + e.temp_max) / 2
                ) / NULLIF(
                    (e.temp_max - e.temp_min) / 2,
                    0
                )
            ) AS desvio_relativo

        FROM equipamentos e

        INNER JOIN leituras_temperatura l
            ON l.equipamento_id = e.equipamento_id

        GROUP BY e.empresa

        ORDER BY
            conformidade DESC,
            desvio_relativo ASC,
            e.empresa ASC

        LIMIT %s
    """

    return buscar_registros(sql, [QTD_RECOMENDADAS])


# ============================================================
# ROTA DA TELA DE CONSULTA
# ============================================================

@app.route("/consulta", methods=["GET", "POST"])
def consultar():

    # Aceita dados enviados por GET ou POST
    dados = request.values

    filtros = {
        "empresa": dados.get("empresa", "").strip(),
        "equipamento": dados.get("equipamento", "").strip(),
        "tipo": dados.get("tipo", "").strip(),
    }

    # Identifica se o usuário realizou uma pesquisa
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
        # Indicadores gerais
        contexto["resumo"] = buscar_resumo()

        # Empresas recomendadas
        contexto["recomendadas"] = buscar_recomendadas()

        # Executa as consultas filtradas somente após uma pesquisa
        if buscou:
            where, parametros = montar_filtros_equipamentos(
                **filtros
            )

            contexto["empresas"] = buscar_empresas(
                where,
                parametros
            )

            contexto["resultados"] = buscar_equipamentos(
                where,
                parametros
            )

    except mysql.connector.Error as e:
        print("ERRO DO MYSQL NA CONSULTA:", e)

        contexto["erro"] = (
            "Não foi possível consultar os registros. "
            "Verifique o banco de dados e tente novamente."
        )

    except Exception as e:
        print("ERRO INESPERADO NA CONSULTA:", e)

        contexto["erro"] = (
            "Ocorreu um erro ao realizar a consulta."
        )

    return render_template("consulta.html", **contexto)



# ============================================================
# PÁGINA DE CLIENTES
# Exibe 50% das empresas cadastradas na tabela empresas.
# ============================================================

@app.route("/clientes")
def clientes():
    empresas = []
    erro_clientes = None

    try:
        # O banco de dados fornecido contém 100 empresas fictícias.
        # A página exibe metade delas, sem inventar informações oficiais.
        empresas = buscar_registros(
            "SELECT empresa_id, nome, descricao FROM empresas "
            "ORDER BY empresa_id ASC LIMIT %s",
            [50],
        )
        for empresa in empresas:
            nome = empresa["nome"]
            if nome == "Supermercado Sabor Real":
                empresa["imagem"] = "supermercado-sabor-real.jpg"
            elif nome == "Laticínios Pão Dourado":
                empresa["imagem"] = "laticinios-pao-dourado.webp"
            else:
                nome_ascii = unicodedata.normalize("NFKD", nome).encode("ascii", "ignore").decode("ascii").lower()
                empresa["imagem"] = re.sub(r"[^a-z0-9]+", "-", nome_ascii).strip("-") + ".svg"
    except mysql.connector.Error as e:
        print("ERRO DO MYSQL NA PÁGINA DE CLIENTES:", e)
        erro_clientes = (
            "Não foi possível carregar as empresas. Confirme se o arquivo "
            "TempControl_empresas_descricoes.sql foi importado no banco tempcontrol."
        )

    return render_template(
        "clientes.html", empresas=empresas, erro_clientes=erro_clientes
    )


# ============================================================
# INICIALIZAÇÃO DO SISTEMA
# ============================================================

if __name__ == "__main__":
    app.run(debug=True)