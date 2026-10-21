-- ============================================================
-- ATIVIDADE: IN, NOT IN, EXISTS e VIEW
-- Projeto : TempControl - monitoramento de temperatura
-- Grupo   : [PREENCHER: nome dos integrantes]
-- Banco   : tempcontrol (MySQL)
--
-- Como executar: rode primeiro o Banco_de_dados.sql do projeto
-- e depois este arquivo inteiro (ele pode ser executado mais de
-- uma vez: os dados de teste são apagados e recriados no início).
-- ============================================================

USE tempcontrol;

-- ============================================================
-- 1. TABELAS ESCOLHIDAS E RELACIONAMENTOS
-- ============================================================
-- equipamentos (PK: equipamento_id)
--     Cada equipamento pertence a uma empresa (campo texto "empresa").
--
-- leituras_temperatura (PK: leitura_id)
--     FK equipamento_id -> equipamentos.equipamento_id
--     Relação 1:N (um equipamento tem várias leituras).
--
-- contatos (PK: id)
--     Mensagens enviadas pelo formulário do site. O campo "empresa"
--     é texto opcional (aceita NULL) e NÃO é chave estrangeira.
--     Ele se relaciona com equipamentos.empresa pelo NOME da empresa.
--
-- Perguntas que o sistema precisa responder:
--   P1. Quais equipamentos já tiveram leitura fora da faixa ideal?
--   P2. Quais equipamentos ainda não têm nenhuma leitura?
--   P3. Quais empresas monitoradas ainda não enviaram contato?
--   P4. Qual consulta serve de base para a tela de Monitoramento?

-- ============================================================
-- 2. DADOS DE TESTE
-- ============================================================
-- O banco original tem 200 equipamentos e todos possuem 20 leituras,
-- e os 5 contatos têm empresa preenchida. Por isso, criamos registros
-- extras (marcados com "(TESTE)") para mostrar casos SEM correspondência
-- e um contato com empresa NULL.

-- Limpeza (permite reexecutar o arquivo sem duplicar os testes).
-- As leituras de teste são apagadas junto, por ON DELETE CASCADE.
DELETE FROM equipamentos WHERE empresa LIKE '%(TESTE)';
DELETE FROM contatos     WHERE email   LIKE '%@teste.exemplo';

-- 4 equipamentos de teste:
--   3 SEM leituras e 1 COM leituras todas dentro da faixa
INSERT INTO equipamentos
    (nome, localizacao, tipo, empresa, temp_min, temp_max)
VALUES
    ('Câmara Fria 01',  'Setor de Panificação',   'Câmara Fria',  'Padaria Aurora (TESTE)',    0.00,   5.00),
    ('Freezer 01',      'Área de Estoque',        'Freezer',      'Padaria Aurora (TESTE)',  -22.00, -18.00),
    ('Refrigerador 01', 'Cozinha Principal',      'Refrigerador', 'Mercado Horizonte (TESTE)', 2.00,   8.00),
    ('Freezer 02',      'Centro de Distribuição', 'Freezer',      'Mercado Horizonte (TESTE)', -22.00, -18.00);

-- 3 leituras normais (dentro de -22 a -18) para o "Freezer 02" de teste
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em)
SELECT equipamento_id, -20.10, '2026-10-07 08:00:00'
FROM equipamentos
WHERE empresa = 'Mercado Horizonte (TESTE)' AND nome = 'Freezer 02';

INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em)
SELECT equipamento_id, -19.50, '2026-10-07 11:00:00'
FROM equipamentos
WHERE empresa = 'Mercado Horizonte (TESTE)' AND nome = 'Freezer 02';

INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em)
SELECT equipamento_id, -21.00, '2026-10-07 14:00:00'
FROM equipamentos
WHERE empresa = 'Mercado Horizonte (TESTE)' AND nome = 'Freezer 02';

-- 3 contatos de teste:
--   Ana   -> empresa que TEM equipamentos
--   Bruno -> empresa NULL (essencial para demonstrar o problema do NOT IN)
--   Carla -> empresa que NÃO tem equipamentos
INSERT INTO contatos (nome, email, telefone, empresa, mensagem)
VALUES
    ('Ana Teste',   'ana@teste.exemplo',   '(11) 90000-0001', 'Padaria Aurora (TESTE)',               'Contato de teste com empresa cadastrada.'),
    ('Bruno Teste', 'bruno@teste.exemplo', '(11) 90000-0002', NULL,                                   'Contato de teste sem empresa informada.'),
    ('Carla Teste', 'carla@teste.exemplo', NULL,              'Empresa Sem Equipamentos (TESTE)',     'Contato de teste de empresa sem equipamentos.');

-- Conferência dos dados de teste.
-- Resultado observado: 204 equipamentos (200 originais + 4 de teste)
--                      e 102 empresas (100 originais + 2 de teste).
SELECT COUNT(*) AS total_equipamentos, COUNT(DISTINCT empresa) AS total_empresas
FROM equipamentos;


-- ============================================================
-- 3. CONSULTA COM IN
-- ============================================================
-- PERGUNTA (P1): Quais equipamentos já registraram pelo menos uma
-- leitura fora da faixa ideal (temp_min a temp_max)?
--
-- EXPLICAÇÃO:
--  * A subconsulta entre parênteses devolve uma lista de
--    equipamento_id: os que têm alguma leitura abaixo do mínimo ou
--    acima do máximo da sua própria faixa.
--  * A subconsulta é independente: roda uma vez e produz a lista.
--  * O IN mantém, na consulta principal, só os equipamentos cujo
--    equipamento_id aparece nessa lista.
--  * O JOIN dentro da subconsulta é necessário porque temp_min e
--    temp_max ficam na tabela equipamentos, e não na de leituras.
SELECT
    e.equipamento_id,
    e.empresa,
    e.nome,
    e.tipo
FROM equipamentos e
WHERE e.equipamento_id IN (
    SELECT l.equipamento_id
    FROM leituras_temperatura l
    INNER JOIN equipamentos eq
        ON eq.equipamento_id = l.equipamento_id
    WHERE l.temperatura < eq.temp_min
       OR l.temperatura > eq.temp_max
)
ORDER BY e.empresa, e.nome;

-- RESULTADO OBSERVADO: 90 equipamentos. Primeiras linhas:
--   104 | Açougue Boa Vista S.A.        | Câmara Fria 01
--   103 | Açougue Boa Vista S.A.        | Refrigerador Industrial 01
--   200 | Açougue Campo Belo            | Freezer Industrial 02
--   ...
-- CONFERÊNCIA: o resultado atende à pergunta. Os equipamentos de teste
-- (ids 201 a 204) NÃO aparecem: três não têm leituras e o 204 só tem
-- leituras dentro da faixa. Um equipamento sem leituras nunca entra na
-- lista, pois nada foi registrado para ele.


-- ============================================================
-- 4. CONSULTA COM NOT IN (e o cuidado com NULL)
-- ============================================================
-- PERGUNTA (P2): Quais equipamentos ainda NÃO têm nenhuma leitura
-- de temperatura registrada?
--
-- EXPLICAÇÃO:
--  * A subconsulta lista todos os equipamento_id que possuem leitura.
--  * NOT IN devolve os equipamentos cujo id NÃO está nessa lista.
--  * "WHERE equipamento_id IS NOT NULL" é uma proteção: se a lista
--    tiver um único NULL, NOT IN não devolve nenhuma linha (veja 4.2).
--    Aqui a coluna é NOT NULL, mas manter o filtro deixa a consulta
--    segura caso a estrutura mude.
SELECT
    e.equipamento_id,
    e.empresa,
    e.nome
FROM equipamentos e
WHERE e.equipamento_id NOT IN (
    SELECT l.equipamento_id
    FROM leituras_temperatura l
    WHERE l.equipamento_id IS NOT NULL
)
ORDER BY e.equipamento_id;

-- RESULTADO OBSERVADO: 3 linhas
--   201 | Padaria Aurora (TESTE)    | Câmara Fria 01
--   202 | Padaria Aurora (TESTE)    | Freezer 01
--   203 | Mercado Horizonte (TESTE) | Refrigerador 01
-- CONFERÊNCIA: são exatamente os 3 equipamentos de teste criados sem
-- leituras. O "Freezer 02" de teste (204) não aparece porque tem 3.

-- ------------------------------------------------------------
-- 4.1 NOT IN - PERGUNTA (P3): Quais empresas monitoradas NUNCA
-- enviaram contato? (versão SEM tratar NULL: resultado errado)
-- ------------------------------------------------------------
-- A subconsulta devolve contatos.empresa, e essa coluna ACEITA NULL.
-- O contato "Bruno Teste" tem empresa NULL.
SELECT DISTINCT e.empresa
FROM equipamentos e
WHERE e.empresa NOT IN (
    SELECT c.empresa
    FROM contatos c
);

-- RESULTADO OBSERVADO: 0 linhas (VAZIO).
-- ANÁLISE DO RESULTADO VAZIO: aqui o vazio indica consulta incorreta,
-- e não que todas as empresas enviaram contato (só 6 de 102 enviaram).
-- Motivo: "empresa NOT IN (A, B, NULL)" equivale a
-- "empresa <> A AND empresa <> B AND empresa <> NULL". A última
-- comparação resulta em UNKNOWN (nem verdadeiro, nem falso), então a
-- condição nunca é verdadeira e nenhuma linha é devolvida.

-- ------------------------------------------------------------
-- 4.2 NOT IN - mesma pergunta, CORRIGIDA
-- ------------------------------------------------------------
-- Correção: excluir os NULL da subconsulta com IS NOT NULL.
SELECT DISTINCT e.empresa
FROM equipamentos e
WHERE e.empresa NOT IN (
    SELECT c.empresa
    FROM contatos c
    WHERE c.empresa IS NOT NULL
)
ORDER BY e.empresa;

-- RESULTADO OBSERVADO: 96 empresas. Primeiras linhas:
--   Açougue Alvorada S.A.
--   Açougue Boa Vista S.A.
--   Açougue Campo Belo
--   ...
-- CONFERÊNCIA: 102 empresas - 6 com contato = 96. O resultado está
-- coerente. A empresa "Empresa Sem Equipamentos (TESTE)" tem contato,
-- mas não tem equipamentos, e por isso não participa da conta.


-- ============================================================
-- 5. CONSULTA COM EXISTS
-- ============================================================
-- PERGUNTA (P1, a mesma do IN): Quais equipamentos já registraram
-- pelo menos uma leitura fora da faixa ideal?
--
-- EXPLICAÇÃO:
--  * A subconsulta é CORRELACIONADA: usa e.equipamento_id e as faixas
--    da consulta externa (l.equipamento_id = e.equipamento_id).
--    Esse é o vínculo entre a consulta principal e a subconsulta.
--  * Para cada equipamento, o MySQL testa se existe ao menos uma
--    leitura fora da faixa. EXISTS devolve verdadeiro ou falso e
--    ignora o conteúdo do SELECT (por isso SELECT 1).
--  * Como é só um teste de existência, o EXISTS pode parar na
--    primeira leitura fora da faixa que encontrar.
SELECT
    e.equipamento_id,
    e.empresa,
    e.nome,
    e.tipo
FROM equipamentos e
WHERE EXISTS (
    SELECT 1
    FROM leituras_temperatura l
    WHERE l.equipamento_id = e.equipamento_id
      AND (l.temperatura < e.temp_min OR l.temperatura > e.temp_max)
)
ORDER BY e.empresa, e.nome;

-- RESULTADO OBSERVADO: 90 equipamentos, as mesmas linhas do IN.

-- ------------------------------------------------------------
-- 5.1 COMPARAÇÃO IN x EXISTS
-- ------------------------------------------------------------
-- Conferência: as duas consultas devem devolver a mesma quantidade.
SELECT
    (SELECT COUNT(*)
     FROM equipamentos e
     WHERE e.equipamento_id IN (
         SELECT l.equipamento_id
         FROM leituras_temperatura l
         INNER JOIN equipamentos eq ON eq.equipamento_id = l.equipamento_id
         WHERE l.temperatura < eq.temp_min OR l.temperatura > eq.temp_max
     )) AS total_com_in,
    (SELECT COUNT(*)
     FROM equipamentos e
     WHERE EXISTS (
         SELECT 1
         FROM leituras_temperatura l
         WHERE l.equipamento_id = e.equipamento_id
           AND (l.temperatura < e.temp_min OR l.temperatura > e.temp_max)
     )) AS total_com_exists;

-- RESULTADO OBSERVADO: total_com_in = 90 | total_com_exists = 90.
-- EXPLICAÇÃO DA DIFERENÇA ENTRE AS DUAS:
--  * IN: primeiro monta a lista de ids que atendem à condição e depois
--    verifica se o id de cada equipamento pertence a ela. Compara VALORES.
--  * EXISTS: para cada equipamento, pergunta se há alguma leitura
--    relacionada que atenda à condição. Testa a EXISTÊNCIA de linhas.
--  * Neste caso, em que não há NULL na lista, as duas dão o mesmo
--    resultado. Com NULL, NOT IN e NOT EXISTS se comportam diferente.
--    É o caso das empresas sem contato, visto a seguir.

-- ------------------------------------------------------------
-- 5.2 EXISTS - PERGUNTA (P3, lado positivo): Quais empresas
-- monitoradas já enviaram pelo menos um contato?
-- ------------------------------------------------------------
-- O vínculo é feito pelo nome da empresa (c.empresa = e.empresa).
SELECT DISTINCT e.empresa
FROM equipamentos e
WHERE EXISTS (
    SELECT 1
    FROM contatos c
    WHERE c.empresa = e.empresa
)
ORDER BY e.empresa;

-- RESULTADO OBSERVADO: 6 empresas
--   Distribuidora Terra Fértil S.A.
--   Hortifruti Sabor Real Ltda.
--   Laticínios Pão Dourado
--   Mercado Nova Safra Ltda.
--   Padaria Aurora (TESTE)
--   Supermercado Sabor Real
-- CONFERÊNCIA: são as 5 empresas dos contatos originais mais a
-- "Padaria Aurora (TESTE)". Bruno (empresa NULL) e Carla (empresa sem
-- equipamentos) não geram linha, pois não casam com nenhum equipamento.

-- ------------------------------------------------------------
-- 5.3 NOT EXISTS - mesma pergunta do NOT IN (P3)
-- ------------------------------------------------------------
-- NOT EXISTS não sofre com NULL: a comparação c.empresa = e.empresa
-- com NULL nunca é verdadeira, então a linha com NULL é ignorada.
SELECT DISTINCT e.empresa
FROM equipamentos e
WHERE NOT EXISTS (
    SELECT 1
    FROM contatos c
    WHERE c.empresa = e.empresa
)
ORDER BY e.empresa;

-- RESULTADO OBSERVADO: 96 empresas, o mesmo resultado do NOT IN
-- corrigido (4.2). Já o NOT IN sem correção (4.1) devolveu 0 linhas.


-- ============================================================
-- 6. VIEW
-- ============================================================
-- PERGUNTA (P4): Qual é a situação atual de cada equipamento?
--
-- EXPLICAÇÃO:
--  * LEFT JOIN: mantém os equipamentos SEM leituras (um INNER JOIN
--    os esconderia). Reaproveita as ideias das consultas 3 e 4.
--  * COUNT(l.leitura_id) conta só leituras existentes (0 se não houver).
--  * SUM(condição) soma as leituras fora da faixa (em MySQL, TRUE vale 1).
--    COALESCE troca NULL por 0 para equipamentos sem leituras.
--  * NULLIF(..., 0) evita divisão por zero no percentual.
--  * CASE classifica: "Sem leituras", "Em alerta" ou "Normal".
CREATE OR REPLACE VIEW vw_situacao_equipamentos AS
SELECT
    e.equipamento_id,
    e.empresa,
    e.nome AS equipamento,
    e.tipo,
    e.temp_min,
    e.temp_max,
    COUNT(l.leitura_id) AS qtd_leituras,
    ROUND(AVG(l.temperatura), 2) AS temperatura_media,
    MAX(l.registrada_em) AS ultima_leitura,
    COALESCE(
        SUM(l.temperatura < e.temp_min OR l.temperatura > e.temp_max), 0
    ) AS leituras_fora,
    ROUND(
        100 * COALESCE(
            SUM(l.temperatura < e.temp_min OR l.temperatura > e.temp_max), 0
        ) / NULLIF(COUNT(l.leitura_id), 0),
        1
    ) AS percentual_fora,
    CASE
        WHEN COUNT(l.leitura_id) = 0 THEN 'Sem leituras'
        WHEN SUM(l.temperatura < e.temp_min OR l.temperatura > e.temp_max) > 0
            THEN 'Em alerta'
        ELSE 'Normal'
    END AS situacao
FROM equipamentos e
LEFT JOIN leituras_temperatura l
    ON l.equipamento_id = e.equipamento_id
GROUP BY
    e.equipamento_id, e.empresa, e.nome, e.tipo, e.temp_min, e.temp_max;

-- Conferência: quantos equipamentos há em cada situação?
SELECT situacao, COUNT(*) AS total
FROM vw_situacao_equipamentos
GROUP BY situacao;

-- RESULTADO OBSERVADO: Em alerta = 90 | Normal = 111 | Sem leituras = 3.
-- CONFERÊNCIA: 90 + 111 + 3 = 204 (total de equipamentos). Os 90 batem
-- com as consultas IN e EXISTS e os 3 batem com o NOT IN.


-- ============================================================
-- 7. CONSULTA À VIEW (com filtro e ordenação)
-- ============================================================
-- PERGUNTA: Quais freezers estão em alerta, começando pelos que têm
-- maior percentual de leituras fora da faixa?
--  * WHERE filtra a situação e o tipo (freezers e freezers industriais).
--  * ORDER BY mostra primeiro os casos mais graves; o empate é
--    resolvido pelo nome da empresa.
SELECT
    equipamento_id,
    empresa,
    equipamento,
    tipo,
    qtd_leituras,
    leituras_fora,
    percentual_fora,
    situacao
FROM vw_situacao_equipamentos
WHERE situacao = 'Em alerta'
  AND tipo LIKE 'Freezer%'
ORDER BY percentual_fora DESC, empresa
LIMIT 5;

-- RESULTADO OBSERVADO (32 freezers em alerta no total; os 5 primeiros):
--   148 | Hortifruti Pão Dourado       | Freezer 02            | 20 | 10 | 50.0
--    56 | Padaria Estrela do Sul S.A.  | Freezer 02            | 20 |  9 | 45.0
--    72 | Supermercado Alvorada & Cia  | Freezer Industrial 02 | 20 |  9 | 45.0
--    57 | Supermercado Mar Azul Ltda.  | Freezer 01            | 20 |  9 | 45.0
--    23 | Laticínios Nova Safra ME     | Freezer Industrial 01 | 20 |  8 | 40.0
-- CONFERÊNCIA: ordem decrescente de percentual; nos empates de 45,0%
-- as empresas aparecem em ordem alfabética.

-- Segunda consulta à VIEW: equipamentos que precisam de instalação ou
-- verificação do sensor (sem nenhuma leitura).
SELECT equipamento_id, empresa, equipamento, tipo, situacao
FROM vw_situacao_equipamentos
WHERE situacao = 'Sem leituras'
ORDER BY empresa, equipamento;

-- RESULTADO OBSERVADO: 3 linhas (ids 203, 201 e 202), os equipamentos
-- de teste sem leituras.


-- ============================================================
-- 8. USO DA VIEW NO PROJETO
-- ============================================================
-- Em qual tela ou relatório a VIEW poderia ser utilizada?
--   Na tela "Monitoramento" (consulta.html). Ela poderia alimentar a
--   tabela "Equipamentos monitorados", hoje montada por uma consulta
--   grande no app.py, e um novo filtro por situação (Normal, Em alerta
--   ou Sem leituras). Poderia também gerar um relatório de equipamentos
--   em alerta.
--
-- Qual informação ela oferece ao usuário?
--   Para cada equipamento: empresa, tipo, quantidade de leituras,
--   temperatura média, data da última leitura, quantas leituras
--   saíram da faixa ideal, o percentual disso e uma situação
--   já classificada (Normal, Em alerta ou Sem leituras).
--
-- Por que essa informação é útil no contexto do projeto?
--   O TempControl existe para evitar perdas por variação de
--   temperatura. A VIEW mostra de imediato quais equipamentos
--   merecem atenção e em que ordem. Ela também revela os que não
--   enviam leituras, o que pode indicar sensor desligado ou
--   equipamento mal cadastrado. Como a regra de classificação fica
--   num só lugar, a tela, os relatórios e o app.py usam o mesmo
--   critério e não precisam repetir a consulta.