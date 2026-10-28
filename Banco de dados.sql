-- ============================================================
-- BANCO DE DADOS TEMPCONTROL
-- 100 empresas fictícias | 200 equipamentos | 4.000 leituras
-- ============================================================

CREATE DATABASE IF NOT EXISTS tempcontrol
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tempcontrol;

SET NAMES utf8mb4;


-- ============================================================
-- LIMPEZA DAS TABELAS DO PROJETO
-- ============================================================

DROP TABLE IF EXISTS leituras_temperatura;
DROP TABLE IF EXISTS equipamentos;
DROP TABLE IF EXISTS contatos;


-- ============================================================
-- TABELA DE CONTATOS
-- ============================================================

CREATE TABLE contatos (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL,
    telefone VARCHAR(30) NULL,
    empresa VARCHAR(160) NULL,
    mensagem VARCHAR(2000) NOT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    INDEX idx_contatos_email (email),
    INDEX idx_contatos_empresa (empresa),
    INDEX idx_contatos_criado_em (criado_em)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- TABELA DE EQUIPAMENTOS
-- temp_min / temp_max = faixa ideal de temperatura do equipamento
-- (usada para calcular a conformidade e recomendar empresas)
-- ============================================================

CREATE TABLE equipamentos (
    equipamento_id INT UNSIGNED NOT NULL AUTO_INCREMENT,

    nome VARCHAR(100) NOT NULL,
    localizacao VARCHAR(150) NOT NULL,
    tipo VARCHAR(80) NOT NULL,
    empresa VARCHAR(160) NOT NULL,
    temp_min DECIMAL(5,2) NOT NULL,
    temp_max DECIMAL(5,2) NOT NULL,

    PRIMARY KEY (equipamento_id),

    INDEX idx_equipamentos_empresa (empresa),
    INDEX idx_equipamentos_nome (nome),
    INDEX idx_equipamentos_tipo (tipo)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- TABELA DE LEITURAS DE TEMPERATURA
-- ============================================================

CREATE TABLE leituras_temperatura (
    leitura_id INT UNSIGNED NOT NULL AUTO_INCREMENT,

    equipamento_id INT UNSIGNED NOT NULL,
    temperatura DECIMAL(5,2) NOT NULL,
    registrada_em DATETIME NOT NULL,

    PRIMARY KEY (leitura_id),

    INDEX idx_leituras_equipamento (equipamento_id),
    INDEX idx_leituras_data (registrada_em),

    CONSTRAINT fk_leituras_equipamentos
        FOREIGN KEY (equipamento_id)
        REFERENCES equipamentos(equipamento_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- 100 EMPRESAS FICTÍCIAS (2 equipamentos cada = 200 equipamentos)
-- ============================================================

INSERT INTO equipamentos
    (nome, localizacao, tipo, empresa, temp_min, temp_max)
VALUES
    ('Freezer Industrial 02', 'Centro de Distribuição', 'Freezer Industrial', 'Laticínios Pão Dourado', -25.00, -18.00),
    ('Refrigerador Industrial 02', 'Câmara Refrigerada', 'Refrigerador Industrial', 'Laticínios Pão Dourado', 2.00, 8.00),
    ('Refrigerador Industrial 02', 'Câmara de Congelados', 'Refrigerador Industrial', 'Mercado Nova Safra Ltda.', 2.00, 8.00),
    ('Freezer Industrial 02', 'Centro de Distribuição', 'Freezer Industrial', 'Mercado Nova Safra Ltda.', -25.00, -18.00),
    ('Refrigerador 03', 'Cozinha Principal', 'Refrigerador', 'Supermercado Sabor Real', 2.00, 8.00),
    ('Câmara Fria 02', 'Setor de Laticínios', 'Câmara Fria', 'Supermercado Sabor Real', 0.00, 5.00),
    ('Câmara Fria 01', 'Setor de Laticínios', 'Câmara Fria', 'Distribuidora Terra Fértil S.A.', 0.00, 5.00),
    ('Refrigerador Industrial 01', 'Setor de Carnes', 'Refrigerador Industrial', 'Distribuidora Terra Fértil S.A.', 2.00, 8.00),
    ('Câmara Fria 02', 'Setor de Carnes', 'Câmara Fria', 'Hortifruti Sabor Real Ltda.', 0.00, 5.00),
    ('Freezer Industrial 02', 'Centro de Distribuição', 'Freezer Industrial', 'Hortifruti Sabor Real Ltda.', -25.00, -18.00),
    ('Câmara Fria 01', 'Setor de Panificação', 'Câmara Fria', 'Mercado Terra Fértil Ltda.', 0.00, 5.00),
    ('Refrigerador Industrial 03', 'Cozinha Industrial', 'Refrigerador Industrial', 'Mercado Terra Fértil Ltda.', 2.00, 8.00),
    ('Refrigerador 02', 'Doca de Recebimento', 'Refrigerador', 'Padaria Pão Dourado', 2.00, 8.00),
    ('Freezer 03', 'Câmara de Resfriamento', 'Freezer', 'Padaria Pão Dourado', -22.00, -18.00),
    ('Freezer Industrial 02', 'Doca de Recebimento', 'Freezer Industrial', 'Distribuidora Campo Belo S.A.', -25.00, -18.00),
    ('Refrigerador Industrial 02', 'Balcão Refrigerado', 'Refrigerador Industrial', 'Distribuidora Campo Belo S.A.', 2.00, 8.00),
    ('Freezer Industrial 03', 'Área de Estoque', 'Freezer Industrial', 'Empório Alvorada Ltda.', -25.00, -18.00),
    ('Câmara Fria 02', 'Área de Estoque', 'Câmara Fria', 'Empório Alvorada Ltda.', 0.00, 5.00),
    ('Freezer 02', 'Cozinha Industrial', 'Freezer', 'Frigorífico Pão Dourado ME', -22.00, -18.00),
    ('Refrigerador Industrial 02', 'Câmara de Resfriamento', 'Refrigerador Industrial', 'Frigorífico Pão Dourado ME', 2.00, 8.00),
    ('Freezer Industrial 02', 'Área de Armazenamento', 'Freezer Industrial', 'Frigorífico Mar Azul Ltda.', -25.00, -18.00),
    ('Refrigerador 02', 'Setor de Laticínios', 'Refrigerador', 'Frigorífico Mar Azul Ltda.', 2.00, 8.00),
    ('Freezer Industrial 01', 'Centro de Distribuição', 'Freezer Industrial', 'Laticínios Nova Safra ME', -25.00, -18.00),
    ('Refrigerador 02', 'Área de Armazenamento', 'Refrigerador', 'Laticínios Nova Safra ME', 2.00, 8.00),
    ('Câmara Fria 02', 'Balcão Refrigerado', 'Câmara Fria', 'Açougue Alvorada S.A.', 0.00, 5.00),
    ('Refrigerador 03', 'Área de Estoque', 'Refrigerador', 'Açougue Alvorada S.A.', 2.00, 8.00),
    ('Freezer 03', 'Cozinha Industrial', 'Freezer', 'Supermercado Boa Vista S.A.', -22.00, -18.00),
    ('Refrigerador 02', 'Câmara de Congelados', 'Refrigerador', 'Supermercado Boa Vista S.A.', 2.00, 8.00),
    ('Freezer 01', 'Cozinha Industrial', 'Freezer', 'Restaurante Boa Vista', -22.00, -18.00),
    ('Freezer Industrial 02', 'Setor de Carnes', 'Freezer Industrial', 'Restaurante Boa Vista', -25.00, -18.00),
    ('Freezer Industrial 02', 'Área de Armazenamento', 'Freezer Industrial', 'Restaurante Estrela do Sul & Cia', -25.00, -18.00),
    ('Freezer 02', 'Área de Armazenamento', 'Freezer', 'Restaurante Estrela do Sul & Cia', -22.00, -18.00),
    ('Refrigerador 03', 'Setor de Carnes', 'Refrigerador', 'Frigorífico Alvorada ME', 2.00, 8.00),
    ('Freezer 03', 'Setor de Carnes', 'Freezer', 'Frigorífico Alvorada ME', -22.00, -18.00),
    ('Câmara Fria 03', 'Setor de Laticínios', 'Câmara Fria', 'Laticínios Sabor Real ME', 0.00, 5.00),
    ('Refrigerador 03', 'Área de Estoque', 'Refrigerador', 'Laticínios Sabor Real ME', 2.00, 8.00),
    ('Refrigerador Industrial 02', 'Balcão Refrigerado', 'Refrigerador Industrial', 'Distribuidora Alvorada & Cia', 2.00, 8.00),
    ('Câmara Fria 02', 'Área de Armazenamento', 'Câmara Fria', 'Distribuidora Alvorada & Cia', 0.00, 5.00),
    ('Freezer Industrial 02', 'Setor de Laticínios', 'Freezer Industrial', 'Frigorífico Vale Verde', -25.00, -18.00),
    ('Refrigerador Industrial 02', 'Área de Estoque', 'Refrigerador Industrial', 'Frigorífico Vale Verde', 2.00, 8.00),
    ('Refrigerador Industrial 02', 'Câmara Refrigerada', 'Refrigerador Industrial', 'Frigorífico Sabor Real ME', 2.00, 8.00),
    ('Refrigerador 03', 'Setor de Hortifruti', 'Refrigerador', 'Frigorífico Sabor Real ME', 2.00, 8.00),
    ('Freezer 02', 'Setor de Carnes', 'Freezer', 'Empório Sabor Real Ltda.', -22.00, -18.00),
    ('Freezer Industrial 03', 'Câmara de Resfriamento', 'Freezer Industrial', 'Empório Sabor Real Ltda.', -25.00, -18.00),
    ('Refrigerador Industrial 01', 'Doca de Recebimento', 'Refrigerador Industrial', 'Frigorífico Campo Belo Ltda.', 2.00, 8.00),
    ('Refrigerador 01', 'Setor de Laticínios', 'Refrigerador', 'Frigorífico Campo Belo Ltda.', 2.00, 8.00),
    ('Refrigerador 02', 'Câmara de Congelados', 'Refrigerador', 'Restaurante Mar Azul Ltda.', 2.00, 8.00),
    ('Freezer Industrial 01', 'Setor de Panificação', 'Freezer Industrial', 'Restaurante Mar Azul Ltda.', -25.00, -18.00),
    ('Freezer Industrial 03', 'Câmara de Resfriamento', 'Freezer Industrial', 'Restaurante Terra Fértil ME', -25.00, -18.00),
    ('Refrigerador 02', 'Câmara Refrigerada', 'Refrigerador', 'Restaurante Terra Fértil ME', 2.00, 8.00),
    ('Freezer Industrial 03', 'Área de Estoque', 'Freezer Industrial', 'Hortifruti Alvorada', -25.00, -18.00),
    ('Refrigerador 01', 'Setor de Hortifruti', 'Refrigerador', 'Hortifruti Alvorada', 2.00, 8.00),
    ('Refrigerador 03', 'Doca de Recebimento', 'Refrigerador', 'Supermercado Nova Safra & Cia', 2.00, 8.00),
    ('Câmara Fria 01', 'Câmara de Congelados', 'Câmara Fria', 'Supermercado Nova Safra & Cia', 0.00, 5.00),
    ('Refrigerador Industrial 03', 'Câmara Refrigerada', 'Refrigerador Industrial', 'Padaria Estrela do Sul S.A.', 2.00, 8.00),
    ('Freezer 02', 'Centro de Distribuição', 'Freezer', 'Padaria Estrela do Sul S.A.', -22.00, -18.00),
    ('Freezer 01', 'Setor de Laticínios', 'Freezer', 'Supermercado Mar Azul Ltda.', -22.00, -18.00),
    ('Refrigerador Industrial 03', 'Área de Estoque', 'Refrigerador Industrial', 'Supermercado Mar Azul Ltda.', 2.00, 8.00),
    ('Freezer 01', 'Setor de Carnes', 'Freezer', 'Padaria Alvorada S.A.', -22.00, -18.00),
    ('Refrigerador 01', 'Câmara de Congelados', 'Refrigerador', 'Padaria Alvorada S.A.', 2.00, 8.00),
    ('Refrigerador 03', 'Setor de Panificação', 'Refrigerador', 'Distribuidora Boa Vista S.A.', 2.00, 8.00),
    ('Freezer Industrial 01', 'Setor de Panificação', 'Freezer Industrial', 'Distribuidora Boa Vista S.A.', -25.00, -18.00),
    ('Refrigerador Industrial 03', 'Área de Armazenamento', 'Refrigerador Industrial', 'Distribuidora Sabor Real S.A.', 2.00, 8.00),
    ('Freezer Industrial 01', 'Centro de Distribuição', 'Freezer Industrial', 'Distribuidora Sabor Real S.A.', -25.00, -18.00),
    ('Refrigerador Industrial 01', 'Setor de Panificação', 'Refrigerador Industrial', 'Frigorífico Estrela do Sul', 2.00, 8.00),
    ('Câmara Fria 03', 'Cozinha Principal', 'Câmara Fria', 'Frigorífico Estrela do Sul', 0.00, 5.00),
    ('Refrigerador 01', 'Câmara Refrigerada', 'Refrigerador', 'Hortifruti Mar Azul Ltda.', 2.00, 8.00),
    ('Refrigerador Industrial 01', 'Cozinha Principal', 'Refrigerador Industrial', 'Hortifruti Mar Azul Ltda.', 2.00, 8.00),
    ('Freezer Industrial 01', 'Câmara de Resfriamento', 'Freezer Industrial', 'Empório Campo Belo S.A.', -25.00, -18.00),
    ('Refrigerador Industrial 01', 'Cozinha Principal', 'Refrigerador Industrial', 'Empório Campo Belo S.A.', 2.00, 8.00),
    ('Câmara Fria 03', 'Setor de Hortifruti', 'Câmara Fria', 'Supermercado Alvorada & Cia', 0.00, 5.00),
    ('Freezer Industrial 02', 'Cozinha Industrial', 'Freezer Industrial', 'Supermercado Alvorada & Cia', -25.00, -18.00),
    ('Freezer 03', 'Centro de Distribuição', 'Freezer', 'Hortifruti Campo Belo S.A.', -22.00, -18.00),
    ('Freezer Industrial 03', 'Centro de Distribuição', 'Freezer Industrial', 'Hortifruti Campo Belo S.A.', -25.00, -18.00),
    ('Freezer 03', 'Cozinha Industrial', 'Freezer', 'Açougue Terra Fértil', -22.00, -18.00),
    ('Freezer Industrial 01', 'Centro de Distribuição', 'Freezer Industrial', 'Açougue Terra Fértil', -25.00, -18.00),
    ('Freezer 01', 'Câmara de Congelados', 'Freezer', 'Restaurante Nova Safra Ltda.', -22.00, -18.00),
    ('Câmara Fria 02', 'Setor de Hortifruti', 'Câmara Fria', 'Restaurante Nova Safra Ltda.', 0.00, 5.00),
    ('Câmara Fria 01', 'Centro de Distribuição', 'Câmara Fria', 'Mercado Campo Belo Ltda.', 0.00, 5.00),
    ('Refrigerador 02', 'Setor de Hortifruti', 'Refrigerador', 'Mercado Campo Belo Ltda.', 2.00, 8.00),
    ('Refrigerador Industrial 03', 'Doca de Recebimento', 'Refrigerador Industrial', 'Laticínios Boa Vista S.A.', 2.00, 8.00),
    ('Freezer Industrial 01', 'Área de Armazenamento', 'Freezer Industrial', 'Laticínios Boa Vista S.A.', -25.00, -18.00),
    ('Câmara Fria 03', 'Área de Estoque', 'Câmara Fria', 'Laticínios Campo Belo', 0.00, 5.00),
    ('Refrigerador 01', 'Balcão Refrigerado', 'Refrigerador', 'Laticínios Campo Belo', 2.00, 8.00),
    ('Freezer 01', 'Setor de Laticínios', 'Freezer', 'Padaria Sabor Real S.A.', -22.00, -18.00),
    ('Câmara Fria 02', 'Balcão Refrigerado', 'Câmara Fria', 'Padaria Sabor Real S.A.', 0.00, 5.00),
    ('Refrigerador 02', 'Doca de Recebimento', 'Refrigerador', 'Frigorífico Nova Safra', 2.00, 8.00),
    ('Refrigerador Industrial 02', 'Setor de Panificação', 'Refrigerador Industrial', 'Frigorífico Nova Safra', 2.00, 8.00),
    ('Refrigerador 02', 'Câmara Refrigerada', 'Refrigerador', 'Empório Boa Vista Ltda.', 2.00, 8.00),
    ('Freezer Industrial 01', 'Doca de Recebimento', 'Freezer Industrial', 'Empório Boa Vista Ltda.', -25.00, -18.00),
    ('Refrigerador Industrial 01', 'Setor de Laticínios', 'Refrigerador Industrial', 'Distribuidora Mar Azul', 2.00, 8.00),
    ('Refrigerador 03', 'Cozinha Industrial', 'Refrigerador', 'Distribuidora Mar Azul', 2.00, 8.00),
    ('Refrigerador Industrial 02', 'Setor de Carnes', 'Refrigerador Industrial', 'Açougue Vale Verde', 2.00, 8.00),
    ('Refrigerador 03', 'Centro de Distribuição', 'Refrigerador', 'Açougue Vale Verde', 2.00, 8.00),
    ('Refrigerador Industrial 01', 'Cozinha Industrial', 'Refrigerador Industrial', 'Padaria Terra Fértil ME', 2.00, 8.00),
    ('Refrigerador 02', 'Setor de Panificação', 'Refrigerador', 'Padaria Terra Fértil ME', 2.00, 8.00),
    ('Refrigerador 01', 'Setor de Laticínios', 'Refrigerador', 'Mercado Vale Verde', 2.00, 8.00),
    ('Freezer 01', 'Setor de Hortifruti', 'Freezer', 'Mercado Vale Verde', -22.00, -18.00),
    ('Câmara Fria 03', 'Câmara de Congelados', 'Câmara Fria', 'Mercado Mar Azul S.A.', 0.00, 5.00),
    ('Refrigerador Industrial 02', 'Centro de Distribuição', 'Refrigerador Industrial', 'Mercado Mar Azul S.A.', 2.00, 8.00),
    ('Refrigerador 03', 'Cozinha Principal', 'Refrigerador', 'Laticínios Mar Azul', 2.00, 8.00),
    ('Refrigerador Industrial 01', 'Doca de Recebimento', 'Refrigerador Industrial', 'Laticínios Mar Azul', 2.00, 8.00),
    ('Refrigerador Industrial 01', 'Setor de Hortifruti', 'Refrigerador Industrial', 'Açougue Boa Vista S.A.', 2.00, 8.00),
    ('Câmara Fria 01', 'Câmara de Resfriamento', 'Câmara Fria', 'Açougue Boa Vista S.A.', 0.00, 5.00),
    ('Refrigerador 03', 'Setor de Carnes', 'Refrigerador', 'Empório Vale Verde & Cia', 2.00, 8.00),
    ('Refrigerador Industrial 03', 'Câmara Refrigerada', 'Refrigerador Industrial', 'Empório Vale Verde & Cia', 2.00, 8.00),
    ('Freezer Industrial 03', 'Centro de Distribuição', 'Freezer Industrial', 'Laticínios Estrela do Sul & Cia', -25.00, -18.00),
    ('Câmara Fria 01', 'Câmara de Resfriamento', 'Câmara Fria', 'Laticínios Estrela do Sul & Cia', 0.00, 5.00),
    ('Freezer 02', 'Cozinha Industrial', 'Freezer', 'Açougue Mar Azul & Cia', -22.00, -18.00),
    ('Freezer Industrial 03', 'Área de Estoque', 'Freezer Industrial', 'Açougue Mar Azul & Cia', -25.00, -18.00),
    ('Freezer Industrial 01', 'Área de Estoque', 'Freezer Industrial', 'Supermercado Campo Belo & Cia', -25.00, -18.00),
    ('Refrigerador 02', 'Câmara de Resfriamento', 'Refrigerador', 'Supermercado Campo Belo & Cia', 2.00, 8.00),
    ('Câmara Fria 03', 'Setor de Panificação', 'Câmara Fria', 'Padaria Mar Azul Ltda.', 0.00, 5.00),
    ('Freezer Industrial 02', 'Área de Estoque', 'Freezer Industrial', 'Padaria Mar Azul Ltda.', -25.00, -18.00),
    ('Câmara Fria 03', 'Setor de Carnes', 'Câmara Fria', 'Empório Mar Azul & Cia', 0.00, 5.00),
    ('Refrigerador 02', 'Doca de Recebimento', 'Refrigerador', 'Empório Mar Azul & Cia', 2.00, 8.00),
    ('Freezer Industrial 03', 'Cozinha Principal', 'Freezer Industrial', 'Hortifruti Boa Vista', -25.00, -18.00),
    ('Câmara Fria 02', 'Câmara Refrigerada', 'Câmara Fria', 'Hortifruti Boa Vista', 0.00, 5.00),
    ('Refrigerador Industrial 01', 'Cozinha Principal', 'Refrigerador Industrial', 'Mercado Pão Dourado', 2.00, 8.00),
    ('Câmara Fria 02', 'Setor de Panificação', 'Câmara Fria', 'Mercado Pão Dourado', 0.00, 5.00),
    ('Refrigerador Industrial 01', 'Câmara Refrigerada', 'Refrigerador Industrial', 'Açougue Sabor Real Ltda.', 2.00, 8.00),
    ('Freezer Industrial 02', 'Área de Armazenamento', 'Freezer Industrial', 'Açougue Sabor Real Ltda.', -25.00, -18.00),
    ('Câmara Fria 02', 'Setor de Panificação', 'Câmara Fria', 'Hortifruti Vale Verde S.A.', 0.00, 5.00),
    ('Freezer Industrial 01', 'Área de Armazenamento', 'Freezer Industrial', 'Hortifruti Vale Verde S.A.', -25.00, -18.00),
    ('Refrigerador Industrial 02', 'Setor de Panificação', 'Refrigerador Industrial', 'Padaria Vale Verde & Cia', 2.00, 8.00),
    ('Freezer Industrial 01', 'Centro de Distribuição', 'Freezer Industrial', 'Padaria Vale Verde & Cia', -25.00, -18.00),
    ('Refrigerador 02', 'Doca de Recebimento', 'Refrigerador', 'Supermercado Vale Verde Ltda.', 2.00, 8.00),
    ('Câmara Fria 01', 'Câmara de Congelados', 'Câmara Fria', 'Supermercado Vale Verde Ltda.', 0.00, 5.00),
    ('Câmara Fria 03', 'Câmara de Resfriamento', 'Câmara Fria', 'Supermercado Pão Dourado Ltda.', 0.00, 5.00),
    ('Freezer 01', 'Setor de Hortifruti', 'Freezer', 'Supermercado Pão Dourado Ltda.', -22.00, -18.00),
    ('Freezer 03', 'Área de Armazenamento', 'Freezer', 'Empório Estrela do Sul ME', -22.00, -18.00),
    ('Freezer Industrial 01', 'Câmara de Resfriamento', 'Freezer Industrial', 'Empório Estrela do Sul ME', -25.00, -18.00),
    ('Freezer Industrial 02', 'Área de Armazenamento', 'Freezer Industrial', 'Hortifruti Terra Fértil Ltda.', -25.00, -18.00),
    ('Refrigerador Industrial 03', 'Cozinha Principal', 'Refrigerador Industrial', 'Hortifruti Terra Fértil Ltda.', 2.00, 8.00),
    ('Câmara Fria 01', 'Cozinha Industrial', 'Câmara Fria', 'Restaurante Campo Belo', 0.00, 5.00),
    ('Freezer Industrial 01', 'Doca de Recebimento', 'Freezer Industrial', 'Restaurante Campo Belo', -25.00, -18.00),
    ('Câmara Fria 02', 'Área de Estoque', 'Câmara Fria', 'Distribuidora Pão Dourado', 0.00, 5.00),
    ('Refrigerador Industrial 02', 'Câmara Refrigerada', 'Refrigerador Industrial', 'Distribuidora Pão Dourado', 2.00, 8.00),
    ('Câmara Fria 02', 'Balcão Refrigerado', 'Câmara Fria', 'Restaurante Sabor Real S.A.', 0.00, 5.00),
    ('Refrigerador 02', 'Cozinha Principal', 'Refrigerador', 'Restaurante Sabor Real S.A.', 2.00, 8.00),
    ('Câmara Fria 01', 'Setor de Carnes', 'Câmara Fria', 'Frigorífico Terra Fértil Ltda.', 0.00, 5.00),
    ('Refrigerador 02', 'Câmara de Resfriamento', 'Refrigerador', 'Frigorífico Terra Fértil Ltda.', 2.00, 8.00),
    ('Refrigerador 01', 'Doca de Recebimento', 'Refrigerador', 'Laticínios Vale Verde & Cia', 2.00, 8.00),
    ('Freezer Industrial 01', 'Setor de Laticínios', 'Freezer Industrial', 'Laticínios Vale Verde & Cia', -25.00, -18.00),
    ('Câmara Fria 02', 'Setor de Carnes', 'Câmara Fria', 'Hortifruti Estrela do Sul ME', 0.00, 5.00),
    ('Refrigerador 03', 'Setor de Laticínios', 'Refrigerador', 'Hortifruti Estrela do Sul ME', 2.00, 8.00),
    ('Câmara Fria 02', 'Cozinha Principal', 'Câmara Fria', 'Hortifruti Pão Dourado', 0.00, 5.00),
    ('Freezer 02', 'Cozinha Industrial', 'Freezer', 'Hortifruti Pão Dourado', -22.00, -18.00),
    ('Câmara Fria 03', 'Área de Armazenamento', 'Câmara Fria', 'Mercado Estrela do Sul & Cia', 0.00, 5.00),
    ('Freezer 03', 'Câmara de Congelados', 'Freezer', 'Mercado Estrela do Sul & Cia', -22.00, -18.00),
    ('Freezer Industrial 01', 'Câmara Refrigerada', 'Freezer Industrial', 'Mercado Alvorada', -25.00, -18.00),
    ('Refrigerador 01', 'Setor de Hortifruti', 'Refrigerador', 'Mercado Alvorada', 2.00, 8.00),
    ('Freezer 02', 'Área de Estoque', 'Freezer', 'Supermercado Estrela do Sul ME', -22.00, -18.00),
    ('Câmara Fria 02', 'Área de Estoque', 'Câmara Fria', 'Supermercado Estrela do Sul ME', 0.00, 5.00),
    ('Câmara Fria 03', 'Setor de Carnes', 'Câmara Fria', 'Padaria Nova Safra & Cia', 0.00, 5.00),
    ('Freezer 01', 'Setor de Carnes', 'Freezer', 'Padaria Nova Safra & Cia', -22.00, -18.00),
    ('Freezer Industrial 03', 'Área de Estoque', 'Freezer Industrial', 'Restaurante Alvorada & Cia', -25.00, -18.00),
    ('Freezer 03', 'Cozinha Industrial', 'Freezer', 'Restaurante Alvorada & Cia', -22.00, -18.00),
    ('Freezer Industrial 01', 'Cozinha Industrial', 'Freezer Industrial', 'Açougue Nova Safra ME', -25.00, -18.00),
    ('Câmara Fria 01', 'Centro de Distribuição', 'Câmara Fria', 'Açougue Nova Safra ME', 0.00, 5.00),
    ('Câmara Fria 02', 'Balcão Refrigerado', 'Câmara Fria', 'Padaria Campo Belo', 0.00, 5.00),
    ('Refrigerador Industrial 01', 'Doca de Recebimento', 'Refrigerador Industrial', 'Padaria Campo Belo', 2.00, 8.00),
    ('Câmara Fria 03', 'Área de Estoque', 'Câmara Fria', 'Empório Terra Fértil & Cia', 0.00, 5.00),
    ('Refrigerador 01', 'Balcão Refrigerado', 'Refrigerador', 'Empório Terra Fértil & Cia', 2.00, 8.00),
    ('Refrigerador 02', 'Setor de Laticínios', 'Refrigerador', 'Empório Nova Safra', 2.00, 8.00),
    ('Refrigerador Industrial 01', 'Setor de Hortifruti', 'Refrigerador Industrial', 'Empório Nova Safra', 2.00, 8.00),
    ('Refrigerador Industrial 02', 'Área de Estoque', 'Refrigerador Industrial', 'Padaria Boa Vista ME', 2.00, 8.00),
    ('Refrigerador 01', 'Área de Armazenamento', 'Refrigerador', 'Padaria Boa Vista ME', 2.00, 8.00),
    ('Freezer 02', 'Setor de Laticínios', 'Freezer', 'Empório Pão Dourado S.A.', -22.00, -18.00),
    ('Freezer Industrial 02', 'Setor de Laticínios', 'Freezer Industrial', 'Empório Pão Dourado S.A.', -25.00, -18.00),
    ('Refrigerador 01', 'Câmara de Congelados', 'Refrigerador', 'Distribuidora Vale Verde ME', 2.00, 8.00),
    ('Freezer Industrial 01', 'Área de Armazenamento', 'Freezer Industrial', 'Distribuidora Vale Verde ME', -25.00, -18.00),
    ('Câmara Fria 01', 'Câmara de Resfriamento', 'Câmara Fria', 'Distribuidora Nova Safra ME', 0.00, 5.00),
    ('Freezer 03', 'Cozinha Principal', 'Freezer', 'Distribuidora Nova Safra ME', -22.00, -18.00),
    ('Câmara Fria 02', 'Setor de Hortifruti', 'Câmara Fria', 'Mercado Sabor Real ME', 0.00, 5.00),
    ('Refrigerador 01', 'Câmara de Resfriamento', 'Refrigerador', 'Mercado Sabor Real ME', 2.00, 8.00),
    ('Refrigerador 02', 'Câmara Refrigerada', 'Refrigerador', 'Hortifruti Nova Safra & Cia', 2.00, 8.00),
    ('Freezer Industrial 02', 'Setor de Laticínios', 'Freezer Industrial', 'Hortifruti Nova Safra & Cia', -25.00, -18.00),
    ('Câmara Fria 03', 'Setor de Panificação', 'Câmara Fria', 'Mercado Boa Vista ME', 0.00, 5.00),
    ('Freezer Industrial 02', 'Câmara de Resfriamento', 'Freezer Industrial', 'Mercado Boa Vista ME', -25.00, -18.00),
    ('Freezer Industrial 01', 'Cozinha Industrial', 'Freezer Industrial', 'Laticínios Terra Fértil ME', -25.00, -18.00),
    ('Refrigerador 01', 'Setor de Hortifruti', 'Refrigerador', 'Laticínios Terra Fértil ME', 2.00, 8.00),
    ('Refrigerador Industrial 01', 'Doca de Recebimento', 'Refrigerador Industrial', 'Restaurante Vale Verde', 2.00, 8.00),
    ('Freezer Industrial 02', 'Câmara Refrigerada', 'Freezer Industrial', 'Restaurante Vale Verde', -25.00, -18.00),
    ('Freezer 02', 'Cozinha Principal', 'Freezer', 'Açougue Estrela do Sul Ltda.', -22.00, -18.00),
    ('Refrigerador Industrial 03', 'Área de Armazenamento', 'Refrigerador Industrial', 'Açougue Estrela do Sul Ltda.', 2.00, 8.00),
    ('Refrigerador Industrial 03', 'Setor de Hortifruti', 'Refrigerador Industrial', 'Supermercado Terra Fértil', 2.00, 8.00),
    ('Freezer 02', 'Cozinha Industrial', 'Freezer', 'Supermercado Terra Fértil', -22.00, -18.00),
    ('Refrigerador 02', 'Câmara de Congelados', 'Refrigerador', 'Laticínios Alvorada', 2.00, 8.00),
    ('Refrigerador Industrial 01', 'Cozinha Industrial', 'Refrigerador Industrial', 'Laticínios Alvorada', 2.00, 8.00),
    ('Refrigerador Industrial 03', 'Setor de Laticínios', 'Refrigerador Industrial', 'Frigorífico Boa Vista ME', 2.00, 8.00),
    ('Refrigerador 02', 'Setor de Panificação', 'Refrigerador', 'Frigorífico Boa Vista ME', 2.00, 8.00),
    ('Refrigerador 02', 'Balcão Refrigerado', 'Refrigerador', 'Distribuidora Estrela do Sul ME', 2.00, 8.00),
    ('Freezer 03', 'Centro de Distribuição', 'Freezer', 'Distribuidora Estrela do Sul ME', -22.00, -18.00),
    ('Freezer 01', 'Centro de Distribuição', 'Freezer', 'Açougue Pão Dourado ME', -22.00, -18.00),
    ('Refrigerador Industrial 01', 'Câmara Refrigerada', 'Refrigerador Industrial', 'Açougue Pão Dourado ME', 2.00, 8.00),
    ('Refrigerador 03', 'Setor de Carnes', 'Refrigerador', 'Restaurante Pão Dourado', 2.00, 8.00),
    ('Refrigerador Industrial 03', 'Setor de Panificação', 'Refrigerador Industrial', 'Restaurante Pão Dourado', 2.00, 8.00),
    ('Câmara Fria 02', 'Doca de Recebimento', 'Câmara Fria', 'Açougue Campo Belo', 0.00, 5.00),
    ('Freezer Industrial 02', 'Setor de Hortifruti', 'Freezer Industrial', 'Açougue Campo Belo', -25.00, -18.00);


-- ============================================================
-- 4.000 LEITURAS FICTÍCIAS
-- 20 leituras para cada um dos 200 equipamentos (a cada 3 horas)
-- ============================================================

-- Laticínios Pão Dourado | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (1, -21.80, '2026-10-04 08:00:00'),
    (1, -23.55, '2026-10-04 11:00:00'),
    (1, -23.55, '2026-10-04 14:00:00'),
    (1, -19.48, '2026-10-04 17:00:00'),
    (1, -22.43, '2026-10-04 20:00:00'),
    (1, -22.10, '2026-10-04 23:00:00'),
    (1, -21.85, '2026-10-05 02:00:00'),
    (1, -23.37, '2026-10-05 05:00:00'),
    (1, -23.56, '2026-10-05 08:00:00'),
    (1, -21.46, '2026-10-05 11:00:00'),
    (1, -22.34, '2026-10-05 14:00:00'),
    (1, -20.30, '2026-10-05 17:00:00'),
    (1, -23.42, '2026-10-05 20:00:00'),
    (1, -21.42, '2026-10-05 23:00:00'),
    (1, -19.48, '2026-10-06 02:00:00'),
    (1, -21.30, '2026-10-06 05:00:00'),
    (1, -22.75, '2026-10-06 08:00:00'),
    (1, -16.34, '2026-10-06 11:00:00'),
    (1, -20.35, '2026-10-06 14:00:00'),
    (1, -19.63, '2026-10-06 17:00:00');

-- Laticínios Pão Dourado | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (2, 5.96, '2026-10-04 08:00:00'),
    (2, 4.23, '2026-10-04 11:00:00'),
    (2, 3.92, '2026-10-04 14:00:00'),
    (2, 5.29, '2026-10-04 17:00:00'),
    (2, 5.49, '2026-10-04 20:00:00'),
    (2, 3.29, '2026-10-04 23:00:00'),
    (2, 3.90, '2026-10-05 02:00:00'),
    (2, 4.85, '2026-10-05 05:00:00'),
    (2, 6.28, '2026-10-05 08:00:00'),
    (2, 6.77, '2026-10-05 11:00:00'),
    (2, 5.19, '2026-10-05 14:00:00'),
    (2, 4.81, '2026-10-05 17:00:00'),
    (2, 3.88, '2026-10-05 20:00:00'),
    (2, 5.36, '2026-10-05 23:00:00'),
    (2, 6.30, '2026-10-06 02:00:00'),
    (2, 3.50, '2026-10-06 05:00:00'),
    (2, 6.22, '2026-10-06 08:00:00'),
    (2, 3.70, '2026-10-06 11:00:00'),
    (2, 3.83, '2026-10-06 14:00:00'),
    (2, 5.09, '2026-10-06 17:00:00');

-- Mercado Nova Safra Ltda. | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (3, 4.81, '2026-10-04 08:00:00'),
    (3, 4.03, '2026-10-04 11:00:00'),
    (3, 5.19, '2026-10-04 14:00:00'),
    (3, 4.72, '2026-10-04 17:00:00'),
    (3, 5.64, '2026-10-04 20:00:00'),
    (3, 3.21, '2026-10-04 23:00:00'),
    (3, 3.26, '2026-10-05 02:00:00'),
    (3, 4.38, '2026-10-05 05:00:00'),
    (3, 4.00, '2026-10-05 08:00:00'),
    (3, 6.32, '2026-10-05 11:00:00'),
    (3, 4.55, '2026-10-05 14:00:00'),
    (3, 3.61, '2026-10-05 17:00:00'),
    (3, 5.70, '2026-10-05 20:00:00'),
    (3, 6.23, '2026-10-05 23:00:00'),
    (3, 5.97, '2026-10-06 02:00:00'),
    (3, 5.47, '2026-10-06 05:00:00'),
    (3, 5.61, '2026-10-06 08:00:00'),
    (3, 4.30, '2026-10-06 11:00:00'),
    (3, 6.07, '2026-10-06 14:00:00'),
    (3, 5.87, '2026-10-06 17:00:00');

-- Mercado Nova Safra Ltda. | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (4, -19.92, '2026-10-04 08:00:00'),
    (4, -21.23, '2026-10-04 11:00:00'),
    (4, -22.24, '2026-10-04 14:00:00'),
    (4, -22.46, '2026-10-04 17:00:00'),
    (4, -21.69, '2026-10-04 20:00:00'),
    (4, -23.30, '2026-10-04 23:00:00'),
    (4, -22.74, '2026-10-05 02:00:00'),
    (4, -19.53, '2026-10-05 05:00:00'),
    (4, -20.28, '2026-10-05 08:00:00'),
    (4, -20.97, '2026-10-05 11:00:00'),
    (4, -21.94, '2026-10-05 14:00:00'),
    (4, -21.37, '2026-10-05 17:00:00'),
    (4, -23.48, '2026-10-05 20:00:00'),
    (4, -21.47, '2026-10-05 23:00:00'),
    (4, -19.68, '2026-10-06 02:00:00'),
    (4, -20.86, '2026-10-06 05:00:00'),
    (4, -22.83, '2026-10-06 08:00:00'),
    (4, -21.14, '2026-10-06 11:00:00'),
    (4, -22.54, '2026-10-06 14:00:00'),
    (4, -21.14, '2026-10-06 17:00:00');

-- Supermercado Sabor Real | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (5, 4.94, '2026-10-04 08:00:00'),
    (5, 5.14, '2026-10-04 11:00:00'),
    (5, 5.24, '2026-10-04 14:00:00'),
    (5, 5.38, '2026-10-04 17:00:00'),
    (5, 5.17, '2026-10-04 20:00:00'),
    (5, 5.95, '2026-10-04 23:00:00'),
    (5, 5.40, '2026-10-05 02:00:00'),
    (5, 5.25, '2026-10-05 05:00:00'),
    (5, 4.89, '2026-10-05 08:00:00'),
    (5, 5.91, '2026-10-05 11:00:00'),
    (5, 5.81, '2026-10-05 14:00:00'),
    (5, 4.74, '2026-10-05 17:00:00'),
    (5, 4.16, '2026-10-05 20:00:00'),
    (5, 4.26, '2026-10-05 23:00:00'),
    (5, 5.55, '2026-10-06 02:00:00'),
    (5, 5.26, '2026-10-06 05:00:00'),
    (5, 5.94, '2026-10-06 08:00:00'),
    (5, 5.89, '2026-10-06 11:00:00'),
    (5, 5.15, '2026-10-06 14:00:00'),
    (5, 4.88, '2026-10-06 17:00:00');

-- Supermercado Sabor Real | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (6, 1.71, '2026-10-04 08:00:00'),
    (6, 2.07, '2026-10-04 11:00:00'),
    (6, 3.13, '2026-10-04 14:00:00'),
    (6, 1.98, '2026-10-04 17:00:00'),
    (6, 3.33, '2026-10-04 20:00:00'),
    (6, 2.64, '2026-10-04 23:00:00'),
    (6, 1.93, '2026-10-05 02:00:00'),
    (6, 1.84, '2026-10-05 05:00:00'),
    (6, 2.72, '2026-10-05 08:00:00'),
    (6, 1.72, '2026-10-05 11:00:00'),
    (6, 3.25, '2026-10-05 14:00:00'),
    (6, 2.92, '2026-10-05 17:00:00'),
    (6, 2.10, '2026-10-05 20:00:00'),
    (6, 2.20, '2026-10-05 23:00:00'),
    (6, 2.77, '2026-10-06 02:00:00'),
    (6, 2.81, '2026-10-06 05:00:00'),
    (6, 2.88, '2026-10-06 08:00:00'),
    (6, 3.30, '2026-10-06 11:00:00'),
    (6, 2.62, '2026-10-06 14:00:00'),
    (6, 3.06, '2026-10-06 17:00:00');

-- Distribuidora Terra Fértil S.A. | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (7, 3.31, '2026-10-04 08:00:00'),
    (7, 2.87, '2026-10-04 11:00:00'),
    (7, 2.09, '2026-10-04 14:00:00'),
    (7, 2.19, '2026-10-04 17:00:00'),
    (7, 3.06, '2026-10-04 20:00:00'),
    (7, 2.14, '2026-10-04 23:00:00'),
    (7, 2.76, '2026-10-05 02:00:00'),
    (7, 3.26, '2026-10-05 05:00:00'),
    (7, 2.44, '2026-10-05 08:00:00'),
    (7, 2.85, '2026-10-05 11:00:00'),
    (7, 1.67, '2026-10-05 14:00:00'),
    (7, 2.25, '2026-10-05 17:00:00'),
    (7, 2.06, '2026-10-05 20:00:00'),
    (7, 1.68, '2026-10-05 23:00:00'),
    (7, 1.76, '2026-10-06 02:00:00'),
    (7, 1.97, '2026-10-06 05:00:00'),
    (7, 3.11, '2026-10-06 08:00:00'),
    (7, 2.91, '2026-10-06 11:00:00'),
    (7, 2.01, '2026-10-06 14:00:00'),
    (7, 2.67, '2026-10-06 17:00:00');

-- Distribuidora Terra Fértil S.A. | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (8, 4.69, '2026-10-04 08:00:00'),
    (8, 5.93, '2026-10-04 11:00:00'),
    (8, 5.05, '2026-10-04 14:00:00'),
    (8, 4.44, '2026-10-04 17:00:00'),
    (8, 4.36, '2026-10-04 20:00:00'),
    (8, 5.30, '2026-10-04 23:00:00'),
    (8, 4.38, '2026-10-05 02:00:00'),
    (8, 5.28, '2026-10-05 05:00:00'),
    (8, 4.16, '2026-10-05 08:00:00'),
    (8, 4.35, '2026-10-05 11:00:00'),
    (8, 4.73, '2026-10-05 14:00:00'),
    (8, 5.02, '2026-10-05 17:00:00'),
    (8, 4.89, '2026-10-05 20:00:00'),
    (8, 4.12, '2026-10-05 23:00:00'),
    (8, 5.79, '2026-10-06 02:00:00'),
    (8, 5.61, '2026-10-06 05:00:00'),
    (8, 4.38, '2026-10-06 08:00:00'),
    (8, 4.82, '2026-10-06 11:00:00'),
    (8, 5.37, '2026-10-06 14:00:00'),
    (8, 4.05, '2026-10-06 17:00:00');

-- Hortifruti Sabor Real Ltda. | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (9, 1.54, '2026-10-04 08:00:00'),
    (9, 2.90, '2026-10-04 11:00:00'),
    (9, 1.88, '2026-10-04 14:00:00'),
    (9, 2.06, '2026-10-04 17:00:00'),
    (9, 3.40, '2026-10-04 20:00:00'),
    (9, 1.17, '2026-10-04 23:00:00'),
    (9, 3.67, '2026-10-05 02:00:00'),
    (9, 3.10, '2026-10-05 05:00:00'),
    (9, 2.48, '2026-10-05 08:00:00'),
    (9, 3.70, '2026-10-05 11:00:00'),
    (9, 2.60, '2026-10-05 14:00:00'),
    (9, 2.92, '2026-10-05 17:00:00'),
    (9, 3.21, '2026-10-05 20:00:00'),
    (9, 3.28, '2026-10-05 23:00:00'),
    (9, 2.03, '2026-10-06 02:00:00'),
    (9, 3.96, '2026-10-06 05:00:00'),
    (9, 1.72, '2026-10-06 08:00:00'),
    (9, 2.35, '2026-10-06 11:00:00'),
    (9, 2.79, '2026-10-06 14:00:00'),
    (9, 2.02, '2026-10-06 17:00:00');

-- Hortifruti Sabor Real Ltda. | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (10, -22.86, '2026-10-04 08:00:00'),
    (10, -20.46, '2026-10-04 11:00:00'),
    (10, -19.71, '2026-10-04 14:00:00'),
    (10, -22.08, '2026-10-04 17:00:00'),
    (10, -21.90, '2026-10-04 20:00:00'),
    (10, -22.01, '2026-10-04 23:00:00'),
    (10, -22.63, '2026-10-05 02:00:00'),
    (10, -22.62, '2026-10-05 05:00:00'),
    (10, -21.03, '2026-10-05 08:00:00'),
    (10, -23.09, '2026-10-05 11:00:00'),
    (10, -21.70, '2026-10-05 14:00:00'),
    (10, -20.01, '2026-10-05 17:00:00'),
    (10, -22.28, '2026-10-05 20:00:00'),
    (10, -20.28, '2026-10-05 23:00:00'),
    (10, -20.46, '2026-10-06 02:00:00'),
    (10, -20.67, '2026-10-06 05:00:00'),
    (10, -19.62, '2026-10-06 08:00:00'),
    (10, -20.38, '2026-10-06 11:00:00'),
    (10, -20.43, '2026-10-06 14:00:00'),
    (10, -19.44, '2026-10-06 17:00:00');

-- Mercado Terra Fértil Ltda. | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (11, 1.97, '2026-10-04 08:00:00'),
    (11, 3.03, '2026-10-04 11:00:00'),
    (11, 1.41, '2026-10-04 14:00:00'),
    (11, 1.93, '2026-10-04 17:00:00'),
    (11, 2.31, '2026-10-04 20:00:00'),
    (11, 3.52, '2026-10-04 23:00:00'),
    (11, 3.28, '2026-10-05 02:00:00'),
    (11, 3.99, '2026-10-05 05:00:00'),
    (11, 1.28, '2026-10-05 08:00:00'),
    (11, 3.34, '2026-10-05 11:00:00'),
    (11, 3.05, '2026-10-05 14:00:00'),
    (11, 2.36, '2026-10-05 17:00:00'),
    (11, 2.11, '2026-10-05 20:00:00'),
    (11, 1.24, '2026-10-05 23:00:00'),
    (11, 1.20, '2026-10-06 02:00:00'),
    (11, 3.79, '2026-10-06 05:00:00'),
    (11, 3.90, '2026-10-06 08:00:00'),
    (11, 1.19, '2026-10-06 11:00:00'),
    (11, 2.23, '2026-10-06 14:00:00'),
    (11, 2.73, '2026-10-06 17:00:00');

-- Mercado Terra Fértil Ltda. | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (12, 3.74, '2026-10-04 08:00:00'),
    (12, 3.96, '2026-10-04 11:00:00'),
    (12, 6.55, '2026-10-04 14:00:00'),
    (12, 6.77, '2026-10-04 17:00:00'),
    (12, 3.40, '2026-10-04 20:00:00'),
    (12, 5.92, '2026-10-04 23:00:00'),
    (12, 4.16, '2026-10-05 02:00:00'),
    (12, 4.27, '2026-10-05 05:00:00'),
    (12, 5.97, '2026-10-05 08:00:00'),
    (12, 3.77, '2026-10-05 11:00:00'),
    (12, 5.66, '2026-10-05 14:00:00'),
    (12, 3.37, '2026-10-05 17:00:00'),
    (12, 3.46, '2026-10-05 20:00:00'),
    (12, 6.54, '2026-10-05 23:00:00'),
    (12, 4.82, '2026-10-06 02:00:00'),
    (12, 4.38, '2026-10-06 05:00:00'),
    (12, 6.38, '2026-10-06 08:00:00'),
    (12, 3.36, '2026-10-06 11:00:00'),
    (12, 6.34, '2026-10-06 14:00:00'),
    (12, 9.49, '2026-10-06 17:00:00');

-- Padaria Pão Dourado | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (13, 4.12, '2026-10-04 08:00:00'),
    (13, 4.47, '2026-10-04 11:00:00'),
    (13, 4.67, '2026-10-04 14:00:00'),
    (13, 4.49, '2026-10-04 17:00:00'),
    (13, 4.13, '2026-10-04 20:00:00'),
    (13, 5.70, '2026-10-04 23:00:00'),
    (13, 5.12, '2026-10-05 02:00:00'),
    (13, 5.36, '2026-10-05 05:00:00'),
    (13, 5.41, '2026-10-05 08:00:00'),
    (13, 4.57, '2026-10-05 11:00:00'),
    (13, 4.05, '2026-10-05 14:00:00'),
    (13, 5.20, '2026-10-05 17:00:00'),
    (13, 4.91, '2026-10-05 20:00:00'),
    (13, 4.49, '2026-10-05 23:00:00'),
    (13, 4.64, '2026-10-06 02:00:00'),
    (13, 5.44, '2026-10-06 05:00:00'),
    (13, 4.94, '2026-10-06 08:00:00'),
    (13, 5.53, '2026-10-06 11:00:00'),
    (13, 5.40, '2026-10-06 14:00:00'),
    (13, 4.35, '2026-10-06 17:00:00');

-- Padaria Pão Dourado | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (14, -20.62, '2026-10-04 08:00:00'),
    (14, -20.09, '2026-10-04 11:00:00'),
    (14, -19.93, '2026-10-04 14:00:00'),
    (14, -20.09, '2026-10-04 17:00:00'),
    (14, -20.52, '2026-10-04 20:00:00'),
    (14, -20.63, '2026-10-04 23:00:00'),
    (14, -20.04, '2026-10-05 02:00:00'),
    (14, -20.61, '2026-10-05 05:00:00'),
    (14, -19.67, '2026-10-05 08:00:00'),
    (14, -20.65, '2026-10-05 11:00:00'),
    (14, -19.69, '2026-10-05 14:00:00'),
    (14, -20.55, '2026-10-05 17:00:00'),
    (14, -20.29, '2026-10-05 20:00:00'),
    (14, -19.60, '2026-10-05 23:00:00'),
    (14, -20.11, '2026-10-06 02:00:00'),
    (14, -19.73, '2026-10-06 05:00:00'),
    (14, -20.00, '2026-10-06 08:00:00'),
    (14, -20.39, '2026-10-06 11:00:00'),
    (14, -19.96, '2026-10-06 14:00:00'),
    (14, -19.47, '2026-10-06 17:00:00');

-- Distribuidora Campo Belo S.A. | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (15, -19.16, '2026-10-04 08:00:00'),
    (15, -23.96, '2026-10-04 11:00:00'),
    (15, -21.77, '2026-10-04 14:00:00'),
    (15, -23.70, '2026-10-04 17:00:00'),
    (15, -21.64, '2026-10-04 20:00:00'),
    (15, -23.58, '2026-10-04 23:00:00'),
    (15, -15.30, '2026-10-05 02:00:00'),
    (15, -16.62, '2026-10-05 05:00:00'),
    (15, -21.59, '2026-10-05 08:00:00'),
    (15, -21.23, '2026-10-05 11:00:00'),
    (15, -15.55, '2026-10-05 14:00:00'),
    (15, -20.06, '2026-10-05 17:00:00'),
    (15, -16.32, '2026-10-05 20:00:00'),
    (15, -22.84, '2026-10-05 23:00:00'),
    (15, -21.01, '2026-10-06 02:00:00'),
    (15, -15.33, '2026-10-06 05:00:00'),
    (15, -22.99, '2026-10-06 08:00:00'),
    (15, -21.97, '2026-10-06 11:00:00'),
    (15, -23.88, '2026-10-06 14:00:00'),
    (15, -21.95, '2026-10-06 17:00:00');

-- Distribuidora Campo Belo S.A. | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (16, 7.22, '2026-10-04 08:00:00'),
    (16, 4.85, '2026-10-04 11:00:00'),
    (16, 9.71, '2026-10-04 14:00:00'),
    (16, 4.28, '2026-10-04 17:00:00'),
    (16, 9.68, '2026-10-04 20:00:00'),
    (16, 5.69, '2026-10-04 23:00:00'),
    (16, 6.37, '2026-10-05 02:00:00'),
    (16, 5.91, '2026-10-05 05:00:00'),
    (16, 4.06, '2026-10-05 08:00:00'),
    (16, 5.93, '2026-10-05 11:00:00'),
    (16, 5.53, '2026-10-05 14:00:00'),
    (16, 3.29, '2026-10-05 17:00:00'),
    (16, 6.63, '2026-10-05 20:00:00'),
    (16, 4.35, '2026-10-05 23:00:00'),
    (16, 1.15, '2026-10-06 02:00:00'),
    (16, 5.19, '2026-10-06 05:00:00'),
    (16, 5.43, '2026-10-06 08:00:00'),
    (16, 1.57, '2026-10-06 11:00:00'),
    (16, 6.48, '2026-10-06 14:00:00'),
    (16, 4.13, '2026-10-06 17:00:00');

-- Empório Alvorada Ltda. | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (17, -23.24, '2026-10-04 08:00:00'),
    (17, -21.13, '2026-10-04 11:00:00'),
    (17, -23.27, '2026-10-04 14:00:00'),
    (17, -21.04, '2026-10-04 17:00:00'),
    (17, -20.35, '2026-10-04 20:00:00'),
    (17, -22.73, '2026-10-04 23:00:00'),
    (17, -21.06, '2026-10-05 02:00:00'),
    (17, -23.06, '2026-10-05 05:00:00'),
    (17, -19.68, '2026-10-05 08:00:00'),
    (17, -21.13, '2026-10-05 11:00:00'),
    (17, -23.24, '2026-10-05 14:00:00'),
    (17, -20.86, '2026-10-05 17:00:00'),
    (17, -23.33, '2026-10-05 20:00:00'),
    (17, -22.96, '2026-10-05 23:00:00'),
    (17, -20.56, '2026-10-06 02:00:00'),
    (17, -23.48, '2026-10-06 05:00:00'),
    (17, -23.33, '2026-10-06 08:00:00'),
    (17, -20.65, '2026-10-06 11:00:00'),
    (17, -22.32, '2026-10-06 14:00:00'),
    (17, -19.85, '2026-10-06 17:00:00');

-- Empório Alvorada Ltda. | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (18, 1.55, '2026-10-04 08:00:00'),
    (18, 3.57, '2026-10-04 11:00:00'),
    (18, 3.36, '2026-10-04 14:00:00'),
    (18, 2.59, '2026-10-04 17:00:00'),
    (18, 2.96, '2026-10-04 20:00:00'),
    (18, 1.69, '2026-10-04 23:00:00'),
    (18, 3.71, '2026-10-05 02:00:00'),
    (18, 1.01, '2026-10-05 05:00:00'),
    (18, 2.85, '2026-10-05 08:00:00'),
    (18, 1.88, '2026-10-05 11:00:00'),
    (18, 1.30, '2026-10-05 14:00:00'),
    (18, 1.69, '2026-10-05 17:00:00'),
    (18, 2.73, '2026-10-05 20:00:00'),
    (18, 2.77, '2026-10-05 23:00:00'),
    (18, 2.83, '2026-10-06 02:00:00'),
    (18, 1.88, '2026-10-06 05:00:00'),
    (18, 3.33, '2026-10-06 08:00:00'),
    (18, 3.79, '2026-10-06 11:00:00'),
    (18, 1.81, '2026-10-06 14:00:00'),
    (18, 2.20, '2026-10-06 17:00:00');

-- Frigorífico Pão Dourado ME | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (19, -20.29, '2026-10-04 08:00:00'),
    (19, -20.06, '2026-10-04 11:00:00'),
    (19, -20.92, '2026-10-04 14:00:00'),
    (19, -19.69, '2026-10-04 17:00:00'),
    (19, -19.69, '2026-10-04 20:00:00'),
    (19, -19.27, '2026-10-04 23:00:00'),
    (19, -19.46, '2026-10-05 02:00:00'),
    (19, -19.19, '2026-10-05 05:00:00'),
    (19, -20.27, '2026-10-05 08:00:00'),
    (19, -20.30, '2026-10-05 11:00:00'),
    (19, -19.66, '2026-10-05 14:00:00'),
    (19, -19.60, '2026-10-05 17:00:00'),
    (19, -20.66, '2026-10-05 20:00:00'),
    (19, -19.32, '2026-10-05 23:00:00'),
    (19, -19.41, '2026-10-06 02:00:00'),
    (19, -19.29, '2026-10-06 05:00:00'),
    (19, -17.11, '2026-10-06 08:00:00'),
    (19, -19.40, '2026-10-06 11:00:00'),
    (19, -19.28, '2026-10-06 14:00:00'),
    (19, -19.53, '2026-10-06 17:00:00');

-- Frigorífico Pão Dourado ME | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (20, 4.53, '2026-10-04 08:00:00'),
    (20, 5.37, '2026-10-04 11:00:00'),
    (20, 6.69, '2026-10-04 14:00:00'),
    (20, 4.89, '2026-10-04 17:00:00'),
    (20, 5.63, '2026-10-04 20:00:00'),
    (20, 6.38, '2026-10-04 23:00:00'),
    (20, 4.87, '2026-10-05 02:00:00'),
    (20, 4.30, '2026-10-05 05:00:00'),
    (20, 5.41, '2026-10-05 08:00:00'),
    (20, 6.57, '2026-10-05 11:00:00'),
    (20, 10.50, '2026-10-05 14:00:00'),
    (20, 5.06, '2026-10-05 17:00:00'),
    (20, 3.54, '2026-10-05 20:00:00'),
    (20, 5.84, '2026-10-05 23:00:00'),
    (20, 4.87, '2026-10-06 02:00:00'),
    (20, 5.07, '2026-10-06 05:00:00'),
    (20, 5.81, '2026-10-06 08:00:00'),
    (20, 6.41, '2026-10-06 11:00:00'),
    (20, 4.71, '2026-10-06 14:00:00'),
    (20, 3.58, '2026-10-06 17:00:00');

-- Frigorífico Mar Azul Ltda. | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (21, -20.56, '2026-10-04 08:00:00'),
    (21, -22.35, '2026-10-04 11:00:00'),
    (21, -20.56, '2026-10-04 14:00:00'),
    (21, -22.25, '2026-10-04 17:00:00'),
    (21, -21.58, '2026-10-04 20:00:00'),
    (21, -21.71, '2026-10-04 23:00:00'),
    (21, -21.64, '2026-10-05 02:00:00'),
    (21, -21.52, '2026-10-05 05:00:00'),
    (21, -20.36, '2026-10-05 08:00:00'),
    (21, -22.08, '2026-10-05 11:00:00'),
    (21, -20.35, '2026-10-05 14:00:00'),
    (21, -21.79, '2026-10-05 17:00:00'),
    (21, -21.51, '2026-10-05 20:00:00'),
    (21, -20.77, '2026-10-05 23:00:00'),
    (21, -21.04, '2026-10-06 02:00:00'),
    (21, -21.66, '2026-10-06 05:00:00'),
    (21, -21.81, '2026-10-06 08:00:00'),
    (21, -22.69, '2026-10-06 11:00:00'),
    (21, -21.10, '2026-10-06 14:00:00'),
    (21, -22.25, '2026-10-06 17:00:00');

-- Frigorífico Mar Azul Ltda. | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (22, 4.11, '2026-10-04 08:00:00'),
    (22, 4.64, '2026-10-04 11:00:00'),
    (22, 5.39, '2026-10-04 14:00:00'),
    (22, 4.49, '2026-10-04 17:00:00'),
    (22, 5.93, '2026-10-04 20:00:00'),
    (22, 4.09, '2026-10-04 23:00:00'),
    (22, 4.12, '2026-10-05 02:00:00'),
    (22, 4.03, '2026-10-05 05:00:00'),
    (22, 5.39, '2026-10-05 08:00:00'),
    (22, 4.45, '2026-10-05 11:00:00'),
    (22, 4.86, '2026-10-05 14:00:00'),
    (22, 5.49, '2026-10-05 17:00:00'),
    (22, 5.60, '2026-10-05 20:00:00'),
    (22, 5.35, '2026-10-05 23:00:00'),
    (22, 5.94, '2026-10-06 02:00:00'),
    (22, 5.05, '2026-10-06 05:00:00'),
    (22, 5.69, '2026-10-06 08:00:00'),
    (22, 4.63, '2026-10-06 11:00:00'),
    (22, 5.46, '2026-10-06 14:00:00'),
    (22, 5.13, '2026-10-06 17:00:00');

-- Laticínios Nova Safra ME | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (23, -21.35, '2026-10-04 08:00:00'),
    (23, -25.50, '2026-10-04 11:00:00'),
    (23, -26.71, '2026-10-04 14:00:00'),
    (23, -16.99, '2026-10-04 17:00:00'),
    (23, -17.51, '2026-10-04 20:00:00'),
    (23, -15.97, '2026-10-04 23:00:00'),
    (23, -17.29, '2026-10-05 02:00:00'),
    (23, -19.76, '2026-10-05 05:00:00'),
    (23, -25.67, '2026-10-05 08:00:00'),
    (23, -21.46, '2026-10-05 11:00:00'),
    (23, -18.87, '2026-10-05 14:00:00'),
    (23, -22.29, '2026-10-05 17:00:00'),
    (23, -20.56, '2026-10-05 20:00:00'),
    (23, -19.85, '2026-10-05 23:00:00'),
    (23, -24.05, '2026-10-06 02:00:00'),
    (23, -22.15, '2026-10-06 05:00:00'),
    (23, -22.48, '2026-10-06 08:00:00'),
    (23, -23.02, '2026-10-06 11:00:00'),
    (23, -21.13, '2026-10-06 14:00:00'),
    (23, -16.25, '2026-10-06 17:00:00');

-- Laticínios Nova Safra ME | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (24, 6.03, '2026-10-04 08:00:00'),
    (24, 4.98, '2026-10-04 11:00:00'),
    (24, 9.84, '2026-10-04 14:00:00'),
    (24, 2.64, '2026-10-04 17:00:00'),
    (24, 1.39, '2026-10-04 20:00:00'),
    (24, -0.97, '2026-10-04 23:00:00'),
    (24, 6.78, '2026-10-05 02:00:00'),
    (24, 6.10, '2026-10-05 05:00:00'),
    (24, 10.58, '2026-10-05 08:00:00'),
    (24, 1.48, '2026-10-05 11:00:00'),
    (24, 3.42, '2026-10-05 14:00:00'),
    (24, 9.30, '2026-10-05 17:00:00'),
    (24, 7.22, '2026-10-05 20:00:00'),
    (24, 5.36, '2026-10-05 23:00:00'),
    (24, 3.42, '2026-10-06 02:00:00'),
    (24, 5.51, '2026-10-06 05:00:00'),
    (24, 6.58, '2026-10-06 08:00:00'),
    (24, 7.06, '2026-10-06 11:00:00'),
    (24, 5.41, '2026-10-06 14:00:00'),
    (24, 4.11, '2026-10-06 17:00:00');

-- Açougue Alvorada S.A. | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (25, 2.03, '2026-10-04 08:00:00'),
    (25, 2.85, '2026-10-04 11:00:00'),
    (25, 2.73, '2026-10-04 14:00:00'),
    (25, 2.27, '2026-10-04 17:00:00'),
    (25, 1.69, '2026-10-04 20:00:00'),
    (25, 1.70, '2026-10-04 23:00:00'),
    (25, 2.28, '2026-10-05 02:00:00'),
    (25, 2.68, '2026-10-05 05:00:00'),
    (25, 2.24, '2026-10-05 08:00:00'),
    (25, 2.21, '2026-10-05 11:00:00'),
    (25, 3.01, '2026-10-05 14:00:00'),
    (25, 3.05, '2026-10-05 17:00:00'),
    (25, 2.65, '2026-10-05 20:00:00'),
    (25, 3.18, '2026-10-05 23:00:00'),
    (25, 2.52, '2026-10-06 02:00:00'),
    (25, 1.74, '2026-10-06 05:00:00'),
    (25, 2.00, '2026-10-06 08:00:00'),
    (25, 3.05, '2026-10-06 11:00:00'),
    (25, 1.74, '2026-10-06 14:00:00'),
    (25, 2.48, '2026-10-06 17:00:00');

-- Açougue Alvorada S.A. | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (26, 4.87, '2026-10-04 08:00:00'),
    (26, 5.05, '2026-10-04 11:00:00'),
    (26, 5.99, '2026-10-04 14:00:00'),
    (26, 4.03, '2026-10-04 17:00:00'),
    (26, 4.46, '2026-10-04 20:00:00'),
    (26, 5.81, '2026-10-04 23:00:00'),
    (26, 4.81, '2026-10-05 02:00:00'),
    (26, 5.37, '2026-10-05 05:00:00'),
    (26, 4.17, '2026-10-05 08:00:00'),
    (26, 5.78, '2026-10-05 11:00:00'),
    (26, 5.44, '2026-10-05 14:00:00'),
    (26, 5.92, '2026-10-05 17:00:00'),
    (26, 4.22, '2026-10-05 20:00:00'),
    (26, 4.01, '2026-10-05 23:00:00'),
    (26, 4.77, '2026-10-06 02:00:00'),
    (26, 4.78, '2026-10-06 05:00:00'),
    (26, 4.29, '2026-10-06 08:00:00'),
    (26, 4.06, '2026-10-06 11:00:00'),
    (26, 4.83, '2026-10-06 14:00:00'),
    (26, 5.09, '2026-10-06 17:00:00');

-- Supermercado Boa Vista S.A. | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (27, -19.52, '2026-10-04 08:00:00'),
    (27, -19.84, '2026-10-04 11:00:00'),
    (27, -15.90, '2026-10-04 14:00:00'),
    (27, -20.89, '2026-10-04 17:00:00'),
    (27, -21.57, '2026-10-04 20:00:00'),
    (27, -20.85, '2026-10-04 23:00:00'),
    (27, -19.18, '2026-10-05 02:00:00'),
    (27, -18.96, '2026-10-05 05:00:00'),
    (27, -20.39, '2026-10-05 08:00:00'),
    (27, -15.28, '2026-10-05 11:00:00'),
    (27, -20.50, '2026-10-05 14:00:00'),
    (27, -21.43, '2026-10-05 17:00:00'),
    (27, -20.67, '2026-10-05 20:00:00'),
    (27, -19.85, '2026-10-05 23:00:00'),
    (27, -20.75, '2026-10-06 02:00:00'),
    (27, -21.38, '2026-10-06 05:00:00'),
    (27, -15.88, '2026-10-06 08:00:00'),
    (27, -15.58, '2026-10-06 11:00:00'),
    (27, -19.55, '2026-10-06 14:00:00'),
    (27, -18.49, '2026-10-06 17:00:00');

-- Supermercado Boa Vista S.A. | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (28, 4.40, '2026-10-04 08:00:00'),
    (28, 4.31, '2026-10-04 11:00:00'),
    (28, 0.04, '2026-10-04 14:00:00'),
    (28, 9.37, '2026-10-04 17:00:00'),
    (28, 10.19, '2026-10-04 20:00:00'),
    (28, 9.41, '2026-10-04 23:00:00'),
    (28, 2.96, '2026-10-05 02:00:00'),
    (28, 6.36, '2026-10-05 05:00:00'),
    (28, 3.19, '2026-10-05 08:00:00'),
    (28, 5.54, '2026-10-05 11:00:00'),
    (28, 6.57, '2026-10-05 14:00:00'),
    (28, 5.53, '2026-10-05 17:00:00'),
    (28, 9.95, '2026-10-05 20:00:00'),
    (28, 0.64, '2026-10-05 23:00:00'),
    (28, 4.78, '2026-10-06 02:00:00'),
    (28, 6.76, '2026-10-06 05:00:00'),
    (28, 5.10, '2026-10-06 08:00:00'),
    (28, 3.19, '2026-10-06 11:00:00'),
    (28, 0.68, '2026-10-06 14:00:00'),
    (28, 4.87, '2026-10-06 17:00:00');

-- Restaurante Boa Vista | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (29, -19.59, '2026-10-04 08:00:00'),
    (29, -21.13, '2026-10-04 11:00:00'),
    (29, -19.70, '2026-10-04 14:00:00'),
    (29, -19.23, '2026-10-04 17:00:00'),
    (29, -21.48, '2026-10-04 20:00:00'),
    (29, -21.42, '2026-10-04 23:00:00'),
    (29, -19.16, '2026-10-05 02:00:00'),
    (29, -19.71, '2026-10-05 05:00:00'),
    (29, -16.07, '2026-10-05 08:00:00'),
    (29, -18.58, '2026-10-05 11:00:00'),
    (29, -21.16, '2026-10-05 14:00:00'),
    (29, -23.05, '2026-10-05 17:00:00'),
    (29, -19.62, '2026-10-05 20:00:00'),
    (29, -18.99, '2026-10-05 23:00:00'),
    (29, -21.19, '2026-10-06 02:00:00'),
    (29, -19.28, '2026-10-06 05:00:00'),
    (29, -21.16, '2026-10-06 08:00:00'),
    (29, -19.49, '2026-10-06 11:00:00'),
    (29, -21.14, '2026-10-06 14:00:00'),
    (29, -19.16, '2026-10-06 17:00:00');

-- Restaurante Boa Vista | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (30, -19.15, '2026-10-04 08:00:00'),
    (30, -21.96, '2026-10-04 11:00:00'),
    (30, -23.15, '2026-10-04 14:00:00'),
    (30, -21.98, '2026-10-04 17:00:00'),
    (30, -22.88, '2026-10-04 20:00:00'),
    (30, -19.24, '2026-10-04 23:00:00'),
    (30, -22.70, '2026-10-05 02:00:00'),
    (30, -19.81, '2026-10-05 05:00:00'),
    (30, -19.23, '2026-10-05 08:00:00'),
    (30, -23.35, '2026-10-05 11:00:00'),
    (30, -23.34, '2026-10-05 14:00:00'),
    (30, -20.91, '2026-10-05 17:00:00'),
    (30, -21.86, '2026-10-05 20:00:00'),
    (30, -23.82, '2026-10-05 23:00:00'),
    (30, -23.09, '2026-10-06 02:00:00'),
    (30, -20.16, '2026-10-06 05:00:00'),
    (30, -21.86, '2026-10-06 08:00:00'),
    (30, -16.82, '2026-10-06 11:00:00'),
    (30, -15.77, '2026-10-06 14:00:00'),
    (30, -20.61, '2026-10-06 17:00:00');

-- Restaurante Estrela do Sul & Cia | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (31, -22.55, '2026-10-04 08:00:00'),
    (31, -21.39, '2026-10-04 11:00:00'),
    (31, -20.56, '2026-10-04 14:00:00'),
    (31, -19.95, '2026-10-04 17:00:00'),
    (31, -22.48, '2026-10-04 20:00:00'),
    (31, -20.45, '2026-10-04 23:00:00'),
    (31, -20.80, '2026-10-05 02:00:00'),
    (31, -22.01, '2026-10-05 05:00:00'),
    (31, -22.96, '2026-10-05 08:00:00'),
    (31, -20.34, '2026-10-05 11:00:00'),
    (31, -22.25, '2026-10-05 14:00:00'),
    (31, -23.24, '2026-10-05 17:00:00'),
    (31, -21.36, '2026-10-05 20:00:00'),
    (31, -19.54, '2026-10-05 23:00:00'),
    (31, -19.53, '2026-10-06 02:00:00'),
    (31, -23.29, '2026-10-06 05:00:00'),
    (31, -21.15, '2026-10-06 08:00:00'),
    (31, -21.84, '2026-10-06 11:00:00'),
    (31, -20.51, '2026-10-06 14:00:00'),
    (31, -19.98, '2026-10-06 17:00:00');

-- Restaurante Estrela do Sul & Cia | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (32, -19.90, '2026-10-04 08:00:00'),
    (32, -19.03, '2026-10-04 11:00:00'),
    (32, -20.58, '2026-10-04 14:00:00'),
    (32, -19.19, '2026-10-04 17:00:00'),
    (32, -20.88, '2026-10-04 20:00:00'),
    (32, -21.09, '2026-10-04 23:00:00'),
    (32, -19.57, '2026-10-05 02:00:00'),
    (32, -19.63, '2026-10-05 05:00:00'),
    (32, -20.25, '2026-10-05 08:00:00'),
    (32, -21.03, '2026-10-05 11:00:00'),
    (32, -18.81, '2026-10-05 14:00:00'),
    (32, -18.88, '2026-10-05 17:00:00'),
    (32, -20.18, '2026-10-05 20:00:00'),
    (32, -20.23, '2026-10-05 23:00:00'),
    (32, -21.09, '2026-10-06 02:00:00'),
    (32, -20.44, '2026-10-06 05:00:00'),
    (32, -20.14, '2026-10-06 08:00:00'),
    (32, -20.63, '2026-10-06 11:00:00'),
    (32, -20.70, '2026-10-06 14:00:00'),
    (32, -19.58, '2026-10-06 17:00:00');

-- Frigorífico Alvorada ME | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (33, 4.78, '2026-10-04 08:00:00'),
    (33, 5.50, '2026-10-04 11:00:00'),
    (33, 5.63, '2026-10-04 14:00:00'),
    (33, 4.00, '2026-10-04 17:00:00'),
    (33, 4.14, '2026-10-04 20:00:00'),
    (33, 4.86, '2026-10-04 23:00:00'),
    (33, 4.84, '2026-10-05 02:00:00'),
    (33, 5.16, '2026-10-05 05:00:00'),
    (33, 4.97, '2026-10-05 08:00:00'),
    (33, 4.92, '2026-10-05 11:00:00'),
    (33, 5.44, '2026-10-05 14:00:00'),
    (33, 4.51, '2026-10-05 17:00:00'),
    (33, 5.64, '2026-10-05 20:00:00'),
    (33, 4.79, '2026-10-05 23:00:00'),
    (33, 4.88, '2026-10-06 02:00:00'),
    (33, 4.45, '2026-10-06 05:00:00'),
    (33, 4.29, '2026-10-06 08:00:00'),
    (33, 5.99, '2026-10-06 11:00:00'),
    (33, 5.68, '2026-10-06 14:00:00'),
    (33, 5.54, '2026-10-06 17:00:00');

-- Frigorífico Alvorada ME | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (34, -19.31, '2026-10-04 08:00:00'),
    (34, -19.71, '2026-10-04 11:00:00'),
    (34, -19.64, '2026-10-04 14:00:00'),
    (34, -20.29, '2026-10-04 17:00:00'),
    (34, -20.11, '2026-10-04 20:00:00'),
    (34, -19.49, '2026-10-04 23:00:00'),
    (34, -20.27, '2026-10-05 02:00:00'),
    (34, -20.38, '2026-10-05 05:00:00'),
    (34, -20.63, '2026-10-05 08:00:00'),
    (34, -20.17, '2026-10-05 11:00:00'),
    (34, -20.39, '2026-10-05 14:00:00'),
    (34, -19.31, '2026-10-05 17:00:00'),
    (34, -20.01, '2026-10-05 20:00:00'),
    (34, -19.68, '2026-10-05 23:00:00'),
    (34, -19.95, '2026-10-06 02:00:00'),
    (34, -19.76, '2026-10-06 05:00:00'),
    (34, -20.15, '2026-10-06 08:00:00'),
    (34, -20.70, '2026-10-06 11:00:00'),
    (34, -20.06, '2026-10-06 14:00:00'),
    (34, -19.88, '2026-10-06 17:00:00');

-- Laticínios Sabor Real ME | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (35, 3.79, '2026-10-04 08:00:00'),
    (35, 1.49, '2026-10-04 11:00:00'),
    (35, 2.25, '2026-10-04 14:00:00'),
    (35, 2.83, '2026-10-04 17:00:00'),
    (35, 2.67, '2026-10-04 20:00:00'),
    (35, 1.77, '2026-10-04 23:00:00'),
    (35, 2.53, '2026-10-05 02:00:00'),
    (35, 1.50, '2026-10-05 05:00:00'),
    (35, 3.11, '2026-10-05 08:00:00'),
    (35, 2.36, '2026-10-05 11:00:00'),
    (35, 2.09, '2026-10-05 14:00:00'),
    (35, 2.11, '2026-10-05 17:00:00'),
    (35, 3.38, '2026-10-05 20:00:00'),
    (35, 2.03, '2026-10-05 23:00:00'),
    (35, 1.90, '2026-10-06 02:00:00'),
    (35, 3.50, '2026-10-06 05:00:00'),
    (35, 1.36, '2026-10-06 08:00:00'),
    (35, 3.87, '2026-10-06 11:00:00'),
    (35, 1.41, '2026-10-06 14:00:00'),
    (35, 1.74, '2026-10-06 17:00:00');

-- Laticínios Sabor Real ME | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (36, 6.16, '2026-10-04 08:00:00'),
    (36, 3.79, '2026-10-04 11:00:00'),
    (36, 5.46, '2026-10-04 14:00:00'),
    (36, 3.52, '2026-10-04 17:00:00'),
    (36, 3.23, '2026-10-04 20:00:00'),
    (36, 5.56, '2026-10-04 23:00:00'),
    (36, 6.15, '2026-10-05 02:00:00'),
    (36, 5.97, '2026-10-05 05:00:00'),
    (36, 4.17, '2026-10-05 08:00:00'),
    (36, 6.12, '2026-10-05 11:00:00'),
    (36, 4.65, '2026-10-05 14:00:00'),
    (36, 4.39, '2026-10-05 17:00:00'),
    (36, 4.80, '2026-10-05 20:00:00'),
    (36, 10.87, '2026-10-05 23:00:00'),
    (36, 4.85, '2026-10-06 02:00:00'),
    (36, 5.60, '2026-10-06 05:00:00'),
    (36, 5.61, '2026-10-06 08:00:00'),
    (36, 3.87, '2026-10-06 11:00:00'),
    (36, 5.27, '2026-10-06 14:00:00'),
    (36, 3.94, '2026-10-06 17:00:00');

-- Distribuidora Alvorada & Cia | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (37, 3.60, '2026-10-04 08:00:00'),
    (37, 5.21, '2026-10-04 11:00:00'),
    (37, 5.80, '2026-10-04 14:00:00'),
    (37, 2.76, '2026-10-04 17:00:00'),
    (37, 3.08, '2026-10-04 20:00:00'),
    (37, 3.14, '2026-10-04 23:00:00'),
    (37, 3.97, '2026-10-05 02:00:00'),
    (37, 0.56, '2026-10-05 05:00:00'),
    (37, 2.91, '2026-10-05 08:00:00'),
    (37, 5.51, '2026-10-05 11:00:00'),
    (37, 5.95, '2026-10-05 14:00:00'),
    (37, 7.14, '2026-10-05 17:00:00'),
    (37, 3.24, '2026-10-05 20:00:00'),
    (37, 4.80, '2026-10-05 23:00:00'),
    (37, 6.51, '2026-10-06 02:00:00'),
    (37, 4.78, '2026-10-06 05:00:00'),
    (37, 6.24, '2026-10-06 08:00:00'),
    (37, 3.40, '2026-10-06 11:00:00'),
    (37, 5.09, '2026-10-06 14:00:00'),
    (37, 6.55, '2026-10-06 17:00:00');

-- Distribuidora Alvorada & Cia | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (38, 3.62, '2026-10-04 08:00:00'),
    (38, 2.20, '2026-10-04 11:00:00'),
    (38, 1.13, '2026-10-04 14:00:00'),
    (38, 1.57, '2026-10-04 17:00:00'),
    (38, 3.46, '2026-10-04 20:00:00'),
    (38, 2.67, '2026-10-04 23:00:00'),
    (38, 3.46, '2026-10-05 02:00:00'),
    (38, 3.42, '2026-10-05 05:00:00'),
    (38, 6.10, '2026-10-05 08:00:00'),
    (38, 2.00, '2026-10-05 11:00:00'),
    (38, 4.12, '2026-10-05 14:00:00'),
    (38, 0.77, '2026-10-05 17:00:00'),
    (38, 3.49, '2026-10-05 20:00:00'),
    (38, 3.26, '2026-10-05 23:00:00'),
    (38, 3.09, '2026-10-06 02:00:00'),
    (38, -2.10, '2026-10-06 05:00:00'),
    (38, 1.72, '2026-10-06 08:00:00'),
    (38, 1.00, '2026-10-06 11:00:00'),
    (38, 3.88, '2026-10-06 14:00:00'),
    (38, 4.04, '2026-10-06 17:00:00');

-- Frigorífico Vale Verde | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (39, -21.48, '2026-10-04 08:00:00'),
    (39, -22.10, '2026-10-04 11:00:00'),
    (39, -21.31, '2026-10-04 14:00:00'),
    (39, -21.62, '2026-10-04 17:00:00'),
    (39, -23.48, '2026-10-04 20:00:00'),
    (39, -22.42, '2026-10-04 23:00:00'),
    (39, -20.75, '2026-10-05 02:00:00'),
    (39, -22.02, '2026-10-05 05:00:00'),
    (39, -21.59, '2026-10-05 08:00:00'),
    (39, -21.64, '2026-10-05 11:00:00'),
    (39, -23.03, '2026-10-05 14:00:00'),
    (39, -21.67, '2026-10-05 17:00:00'),
    (39, -21.61, '2026-10-05 20:00:00'),
    (39, -19.98, '2026-10-05 23:00:00'),
    (39, -20.99, '2026-10-06 02:00:00'),
    (39, -20.28, '2026-10-06 05:00:00'),
    (39, -19.86, '2026-10-06 08:00:00'),
    (39, -22.34, '2026-10-06 11:00:00'),
    (39, -22.95, '2026-10-06 14:00:00'),
    (39, -15.20, '2026-10-06 17:00:00');

-- Frigorífico Vale Verde | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (40, 3.43, '2026-10-04 08:00:00'),
    (40, 6.26, '2026-10-04 11:00:00'),
    (40, 3.37, '2026-10-04 14:00:00'),
    (40, 5.98, '2026-10-04 17:00:00'),
    (40, 5.21, '2026-10-04 20:00:00'),
    (40, 6.05, '2026-10-04 23:00:00'),
    (40, 3.83, '2026-10-05 02:00:00'),
    (40, 4.68, '2026-10-05 05:00:00'),
    (40, 4.55, '2026-10-05 08:00:00'),
    (40, 5.37, '2026-10-05 11:00:00'),
    (40, 6.20, '2026-10-05 14:00:00'),
    (40, 5.75, '2026-10-05 17:00:00'),
    (40, 3.26, '2026-10-05 20:00:00'),
    (40, 5.38, '2026-10-05 23:00:00'),
    (40, 4.13, '2026-10-06 02:00:00'),
    (40, 6.50, '2026-10-06 05:00:00'),
    (40, 4.63, '2026-10-06 08:00:00'),
    (40, 4.62, '2026-10-06 11:00:00'),
    (40, 6.54, '2026-10-06 14:00:00'),
    (40, 5.36, '2026-10-06 17:00:00');

-- Frigorífico Sabor Real ME | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (41, 3.69, '2026-10-04 08:00:00'),
    (41, 3.45, '2026-10-04 11:00:00'),
    (41, 6.46, '2026-10-04 14:00:00'),
    (41, 3.63, '2026-10-04 17:00:00'),
    (41, 3.84, '2026-10-04 20:00:00'),
    (41, 4.46, '2026-10-04 23:00:00'),
    (41, 6.28, '2026-10-05 02:00:00'),
    (41, 4.65, '2026-10-05 05:00:00'),
    (41, 5.24, '2026-10-05 08:00:00'),
    (41, 5.32, '2026-10-05 11:00:00'),
    (41, 3.51, '2026-10-05 14:00:00'),
    (41, 4.27, '2026-10-05 17:00:00'),
    (41, 3.31, '2026-10-05 20:00:00'),
    (41, 4.00, '2026-10-05 23:00:00'),
    (41, 5.26, '2026-10-06 02:00:00'),
    (41, 6.05, '2026-10-06 05:00:00'),
    (41, 5.97, '2026-10-06 08:00:00'),
    (41, 4.58, '2026-10-06 11:00:00'),
    (41, 3.39, '2026-10-06 14:00:00'),
    (41, 3.24, '2026-10-06 17:00:00');

-- Frigorífico Sabor Real ME | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (42, 5.39, '2026-10-04 08:00:00'),
    (42, 4.10, '2026-10-04 11:00:00'),
    (42, 6.35, '2026-10-04 14:00:00'),
    (42, 6.74, '2026-10-04 17:00:00'),
    (42, 5.67, '2026-10-04 20:00:00'),
    (42, 5.21, '2026-10-04 23:00:00'),
    (42, 4.21, '2026-10-05 02:00:00'),
    (42, 5.99, '2026-10-05 05:00:00'),
    (42, 4.52, '2026-10-05 08:00:00'),
    (42, 5.90, '2026-10-05 11:00:00'),
    (42, 3.35, '2026-10-05 14:00:00'),
    (42, 4.11, '2026-10-05 17:00:00'),
    (42, 4.11, '2026-10-05 20:00:00'),
    (42, 3.52, '2026-10-05 23:00:00'),
    (42, 4.34, '2026-10-06 02:00:00'),
    (42, 5.91, '2026-10-06 05:00:00'),
    (42, 6.42, '2026-10-06 08:00:00'),
    (42, 4.41, '2026-10-06 11:00:00'),
    (42, 4.65, '2026-10-06 14:00:00'),
    (42, 6.68, '2026-10-06 17:00:00');

-- Empório Sabor Real Ltda. | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (43, -18.70, '2026-10-04 08:00:00'),
    (43, -19.47, '2026-10-04 11:00:00'),
    (43, -20.66, '2026-10-04 14:00:00'),
    (43, -21.13, '2026-10-04 17:00:00'),
    (43, -19.00, '2026-10-04 20:00:00'),
    (43, -15.08, '2026-10-04 23:00:00'),
    (43, -20.28, '2026-10-05 02:00:00'),
    (43, -15.16, '2026-10-05 05:00:00'),
    (43, -16.81, '2026-10-05 08:00:00'),
    (43, -18.86, '2026-10-05 11:00:00'),
    (43, -21.23, '2026-10-05 14:00:00'),
    (43, -19.50, '2026-10-05 17:00:00'),
    (43, -15.68, '2026-10-05 20:00:00'),
    (43, -21.41, '2026-10-05 23:00:00'),
    (43, -21.01, '2026-10-06 02:00:00'),
    (43, -20.31, '2026-10-06 05:00:00'),
    (43, -18.62, '2026-10-06 08:00:00'),
    (43, -18.59, '2026-10-06 11:00:00'),
    (43, -20.00, '2026-10-06 14:00:00'),
    (43, -19.46, '2026-10-06 17:00:00');

-- Empório Sabor Real Ltda. | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (44, -27.89, '2026-10-04 08:00:00'),
    (44, -23.88, '2026-10-04 11:00:00'),
    (44, -21.39, '2026-10-04 14:00:00'),
    (44, -20.98, '2026-10-04 17:00:00'),
    (44, -22.73, '2026-10-04 20:00:00'),
    (44, -23.21, '2026-10-04 23:00:00'),
    (44, -21.45, '2026-10-05 02:00:00'),
    (44, -20.94, '2026-10-05 05:00:00'),
    (44, -21.33, '2026-10-05 08:00:00'),
    (44, -19.46, '2026-10-05 11:00:00'),
    (44, -23.58, '2026-10-05 14:00:00'),
    (44, -23.51, '2026-10-05 17:00:00'),
    (44, -19.69, '2026-10-05 20:00:00'),
    (44, -20.19, '2026-10-05 23:00:00'),
    (44, -20.23, '2026-10-06 02:00:00'),
    (44, -22.76, '2026-10-06 05:00:00'),
    (44, -23.56, '2026-10-06 08:00:00'),
    (44, -20.44, '2026-10-06 11:00:00'),
    (44, -19.12, '2026-10-06 14:00:00'),
    (44, -27.60, '2026-10-06 17:00:00');

-- Frigorífico Campo Belo Ltda. | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (45, 5.64, '2026-10-04 08:00:00'),
    (45, 3.82, '2026-10-04 11:00:00'),
    (45, -0.54, '2026-10-04 14:00:00'),
    (45, 10.65, '2026-10-04 17:00:00'),
    (45, 3.10, '2026-10-04 20:00:00'),
    (45, 6.85, '2026-10-04 23:00:00'),
    (45, 10.64, '2026-10-05 02:00:00'),
    (45, 4.46, '2026-10-05 05:00:00'),
    (45, 7.18, '2026-10-05 08:00:00'),
    (45, 4.01, '2026-10-05 11:00:00'),
    (45, 4.10, '2026-10-05 14:00:00'),
    (45, 8.90, '2026-10-05 17:00:00'),
    (45, 9.27, '2026-10-05 20:00:00'),
    (45, 5.79, '2026-10-05 23:00:00'),
    (45, 7.24, '2026-10-06 02:00:00'),
    (45, 3.58, '2026-10-06 05:00:00'),
    (45, 10.51, '2026-10-06 08:00:00'),
    (45, 5.87, '2026-10-06 11:00:00'),
    (45, 6.93, '2026-10-06 14:00:00'),
    (45, 3.31, '2026-10-06 17:00:00');

-- Frigorífico Campo Belo Ltda. | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (46, 1.37, '2026-10-04 08:00:00'),
    (46, 5.14, '2026-10-04 11:00:00'),
    (46, 1.58, '2026-10-04 14:00:00'),
    (46, 2.69, '2026-10-04 17:00:00'),
    (46, 3.16, '2026-10-04 20:00:00'),
    (46, 6.42, '2026-10-04 23:00:00'),
    (46, 5.84, '2026-10-05 02:00:00'),
    (46, 4.05, '2026-10-05 05:00:00'),
    (46, 3.78, '2026-10-05 08:00:00'),
    (46, 5.96, '2026-10-05 11:00:00'),
    (46, 4.50, '2026-10-05 14:00:00'),
    (46, 4.48, '2026-10-05 17:00:00'),
    (46, 3.31, '2026-10-05 20:00:00'),
    (46, 10.18, '2026-10-05 23:00:00'),
    (46, 10.64, '2026-10-06 02:00:00'),
    (46, 3.06, '2026-10-06 05:00:00'),
    (46, 3.67, '2026-10-06 08:00:00'),
    (46, 3.45, '2026-10-06 11:00:00'),
    (46, 10.37, '2026-10-06 14:00:00'),
    (46, 3.53, '2026-10-06 17:00:00');

-- Restaurante Mar Azul Ltda. | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (47, 6.76, '2026-10-04 08:00:00'),
    (47, 3.51, '2026-10-04 11:00:00'),
    (47, 4.39, '2026-10-04 14:00:00'),
    (47, 6.39, '2026-10-04 17:00:00'),
    (47, 4.38, '2026-10-04 20:00:00'),
    (47, 6.78, '2026-10-04 23:00:00'),
    (47, 6.68, '2026-10-05 02:00:00'),
    (47, 4.58, '2026-10-05 05:00:00'),
    (47, 4.28, '2026-10-05 08:00:00'),
    (47, 6.72, '2026-10-05 11:00:00'),
    (47, 5.01, '2026-10-05 14:00:00'),
    (47, 6.31, '2026-10-05 17:00:00'),
    (47, 4.18, '2026-10-05 20:00:00'),
    (47, 4.53, '2026-10-05 23:00:00'),
    (47, 6.68, '2026-10-06 02:00:00'),
    (47, 8.73, '2026-10-06 05:00:00'),
    (47, 4.12, '2026-10-06 08:00:00'),
    (47, 6.45, '2026-10-06 11:00:00'),
    (47, 5.98, '2026-10-06 14:00:00'),
    (47, 6.10, '2026-10-06 17:00:00');

-- Restaurante Mar Azul Ltda. | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (48, -19.78, '2026-10-04 08:00:00'),
    (48, -23.40, '2026-10-04 11:00:00'),
    (48, -21.67, '2026-10-04 14:00:00'),
    (48, -20.73, '2026-10-04 17:00:00'),
    (48, -21.40, '2026-10-04 20:00:00'),
    (48, -21.39, '2026-10-04 23:00:00'),
    (48, -19.67, '2026-10-05 02:00:00'),
    (48, -22.35, '2026-10-05 05:00:00'),
    (48, -22.36, '2026-10-05 08:00:00'),
    (48, -22.86, '2026-10-05 11:00:00'),
    (48, -19.87, '2026-10-05 14:00:00'),
    (48, -22.83, '2026-10-05 17:00:00'),
    (48, -20.29, '2026-10-05 20:00:00'),
    (48, -20.31, '2026-10-05 23:00:00'),
    (48, -21.88, '2026-10-06 02:00:00'),
    (48, -20.99, '2026-10-06 05:00:00'),
    (48, -19.47, '2026-10-06 08:00:00'),
    (48, -19.47, '2026-10-06 11:00:00'),
    (48, -22.27, '2026-10-06 14:00:00'),
    (48, -22.31, '2026-10-06 17:00:00');

-- Restaurante Terra Fértil ME | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (49, -22.18, '2026-10-04 08:00:00'),
    (49, -21.58, '2026-10-04 11:00:00'),
    (49, -22.31, '2026-10-04 14:00:00'),
    (49, -21.27, '2026-10-04 17:00:00'),
    (49, -19.77, '2026-10-04 20:00:00'),
    (49, -21.34, '2026-10-04 23:00:00'),
    (49, -22.51, '2026-10-05 02:00:00'),
    (49, -19.58, '2026-10-05 05:00:00'),
    (49, -22.51, '2026-10-05 08:00:00'),
    (49, -22.00, '2026-10-05 11:00:00'),
    (49, -20.64, '2026-10-05 14:00:00'),
    (49, -19.80, '2026-10-05 17:00:00'),
    (49, -21.36, '2026-10-05 20:00:00'),
    (49, -21.79, '2026-10-05 23:00:00'),
    (49, -20.85, '2026-10-06 02:00:00'),
    (49, -19.94, '2026-10-06 05:00:00'),
    (49, -20.09, '2026-10-06 08:00:00'),
    (49, -21.42, '2026-10-06 11:00:00'),
    (49, -22.18, '2026-10-06 14:00:00'),
    (49, -23.36, '2026-10-06 17:00:00');

-- Restaurante Terra Fértil ME | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (50, 6.29, '2026-10-04 08:00:00'),
    (50, 6.70, '2026-10-04 11:00:00'),
    (50, 4.30, '2026-10-04 14:00:00'),
    (50, 4.79, '2026-10-04 17:00:00'),
    (50, 5.15, '2026-10-04 20:00:00'),
    (50, 6.54, '2026-10-04 23:00:00'),
    (50, 4.96, '2026-10-05 02:00:00'),
    (50, 6.32, '2026-10-05 05:00:00'),
    (50, 5.15, '2026-10-05 08:00:00'),
    (50, 6.02, '2026-10-05 11:00:00'),
    (50, 5.13, '2026-10-05 14:00:00'),
    (50, 4.65, '2026-10-05 17:00:00'),
    (50, 3.91, '2026-10-05 20:00:00'),
    (50, 3.71, '2026-10-05 23:00:00'),
    (50, 5.51, '2026-10-06 02:00:00'),
    (50, 4.54, '2026-10-06 05:00:00'),
    (50, 4.36, '2026-10-06 08:00:00'),
    (50, 3.28, '2026-10-06 11:00:00'),
    (50, 5.00, '2026-10-06 14:00:00'),
    (50, 3.64, '2026-10-06 17:00:00');

-- Hortifruti Alvorada | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (51, -23.43, '2026-10-04 08:00:00'),
    (51, -21.40, '2026-10-04 11:00:00'),
    (51, -22.07, '2026-10-04 14:00:00'),
    (51, -21.94, '2026-10-04 17:00:00'),
    (51, -21.09, '2026-10-04 20:00:00'),
    (51, -21.55, '2026-10-04 23:00:00'),
    (51, -21.33, '2026-10-05 02:00:00'),
    (51, -22.98, '2026-10-05 05:00:00'),
    (51, -22.59, '2026-10-05 08:00:00'),
    (51, -21.55, '2026-10-05 11:00:00'),
    (51, -23.29, '2026-10-05 14:00:00'),
    (51, -22.83, '2026-10-05 17:00:00'),
    (51, -20.85, '2026-10-05 20:00:00'),
    (51, -23.12, '2026-10-05 23:00:00'),
    (51, -20.31, '2026-10-06 02:00:00'),
    (51, -21.95, '2026-10-06 05:00:00'),
    (51, -20.80, '2026-10-06 08:00:00'),
    (51, -22.99, '2026-10-06 11:00:00'),
    (51, -22.42, '2026-10-06 14:00:00'),
    (51, -21.89, '2026-10-06 17:00:00');

-- Hortifruti Alvorada | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (52, 5.94, '2026-10-04 08:00:00'),
    (52, 6.48, '2026-10-04 11:00:00'),
    (52, 5.51, '2026-10-04 14:00:00'),
    (52, 4.46, '2026-10-04 17:00:00'),
    (52, 3.22, '2026-10-04 20:00:00'),
    (52, 5.15, '2026-10-04 23:00:00'),
    (52, 3.71, '2026-10-05 02:00:00'),
    (52, 4.18, '2026-10-05 05:00:00'),
    (52, 6.03, '2026-10-05 08:00:00'),
    (52, 3.90, '2026-10-05 11:00:00'),
    (52, 4.89, '2026-10-05 14:00:00'),
    (52, 4.15, '2026-10-05 17:00:00'),
    (52, 5.10, '2026-10-05 20:00:00'),
    (52, 6.51, '2026-10-05 23:00:00'),
    (52, 3.70, '2026-10-06 02:00:00'),
    (52, 5.19, '2026-10-06 05:00:00'),
    (52, 6.25, '2026-10-06 08:00:00'),
    (52, 5.01, '2026-10-06 11:00:00'),
    (52, 4.53, '2026-10-06 14:00:00'),
    (52, 3.89, '2026-10-06 17:00:00');

-- Supermercado Nova Safra & Cia | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (53, 7.04, '2026-10-04 08:00:00'),
    (53, 3.33, '2026-10-04 11:00:00'),
    (53, -0.41, '2026-10-04 14:00:00'),
    (53, 3.01, '2026-10-04 17:00:00'),
    (53, 6.95, '2026-10-04 20:00:00'),
    (53, 6.39, '2026-10-04 23:00:00'),
    (53, 8.82, '2026-10-05 02:00:00'),
    (53, 3.61, '2026-10-05 05:00:00'),
    (53, 4.56, '2026-10-05 08:00:00'),
    (53, 2.99, '2026-10-05 11:00:00'),
    (53, 9.25, '2026-10-05 14:00:00'),
    (53, 6.18, '2026-10-05 17:00:00'),
    (53, 2.82, '2026-10-05 20:00:00'),
    (53, 3.77, '2026-10-05 23:00:00'),
    (53, 4.12, '2026-10-06 02:00:00'),
    (53, 3.72, '2026-10-06 05:00:00'),
    (53, 3.50, '2026-10-06 08:00:00'),
    (53, 4.35, '2026-10-06 11:00:00'),
    (53, 3.76, '2026-10-06 14:00:00'),
    (53, 3.44, '2026-10-06 17:00:00');

-- Supermercado Nova Safra & Cia | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (54, 2.91, '2026-10-04 08:00:00'),
    (54, 4.05, '2026-10-04 11:00:00'),
    (54, 6.26, '2026-10-04 14:00:00'),
    (54, 3.76, '2026-10-04 17:00:00'),
    (54, 1.93, '2026-10-04 20:00:00'),
    (54, 3.81, '2026-10-04 23:00:00'),
    (54, -1.77, '2026-10-05 02:00:00'),
    (54, 3.28, '2026-10-05 05:00:00'),
    (54, 3.19, '2026-10-05 08:00:00'),
    (54, 1.36, '2026-10-05 11:00:00'),
    (54, -1.96, '2026-10-05 14:00:00'),
    (54, 2.39, '2026-10-05 17:00:00'),
    (54, 3.70, '2026-10-05 20:00:00'),
    (54, 3.03, '2026-10-05 23:00:00'),
    (54, 1.76, '2026-10-06 02:00:00'),
    (54, 4.28, '2026-10-06 05:00:00'),
    (54, 2.09, '2026-10-06 08:00:00'),
    (54, 2.87, '2026-10-06 11:00:00'),
    (54, 0.70, '2026-10-06 14:00:00'),
    (54, 6.53, '2026-10-06 17:00:00');

-- Padaria Estrela do Sul S.A. | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (55, 5.91, '2026-10-04 08:00:00'),
    (55, 3.88, '2026-10-04 11:00:00'),
    (55, 5.94, '2026-10-04 14:00:00'),
    (55, 6.14, '2026-10-04 17:00:00'),
    (55, 4.79, '2026-10-04 20:00:00'),
    (55, 10.17, '2026-10-04 23:00:00'),
    (55, 10.44, '2026-10-05 02:00:00'),
    (55, 4.25, '2026-10-05 05:00:00'),
    (55, 8.96, '2026-10-05 08:00:00'),
    (55, 2.86, '2026-10-05 11:00:00'),
    (55, 6.79, '2026-10-05 14:00:00'),
    (55, 5.35, '2026-10-05 17:00:00'),
    (55, 5.55, '2026-10-05 20:00:00'),
    (55, 3.64, '2026-10-05 23:00:00'),
    (55, 7.11, '2026-10-06 02:00:00'),
    (55, 6.31, '2026-10-06 05:00:00'),
    (55, 7.04, '2026-10-06 08:00:00'),
    (55, 3.22, '2026-10-06 11:00:00'),
    (55, 2.66, '2026-10-06 14:00:00'),
    (55, 7.12, '2026-10-06 17:00:00');

-- Padaria Estrela do Sul S.A. | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (56, -23.33, '2026-10-04 08:00:00'),
    (56, -16.24, '2026-10-04 11:00:00'),
    (56, -15.08, '2026-10-04 14:00:00'),
    (56, -15.21, '2026-10-04 17:00:00'),
    (56, -15.83, '2026-10-04 20:00:00'),
    (56, -20.61, '2026-10-04 23:00:00'),
    (56, -18.46, '2026-10-05 02:00:00'),
    (56, -18.45, '2026-10-05 05:00:00'),
    (56, -18.73, '2026-10-05 08:00:00'),
    (56, -22.62, '2026-10-05 11:00:00'),
    (56, -20.79, '2026-10-05 14:00:00'),
    (56, -21.00, '2026-10-05 17:00:00'),
    (56, -15.87, '2026-10-05 20:00:00'),
    (56, -19.45, '2026-10-05 23:00:00'),
    (56, -19.47, '2026-10-06 02:00:00'),
    (56, -21.37, '2026-10-06 05:00:00'),
    (56, -24.87, '2026-10-06 08:00:00'),
    (56, -24.81, '2026-10-06 11:00:00'),
    (56, -21.46, '2026-10-06 14:00:00'),
    (56, -20.90, '2026-10-06 17:00:00');

-- Supermercado Mar Azul Ltda. | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (57, -19.30, '2026-10-04 08:00:00'),
    (57, -15.51, '2026-10-04 11:00:00'),
    (57, -21.32, '2026-10-04 14:00:00'),
    (57, -24.73, '2026-10-04 17:00:00'),
    (57, -18.55, '2026-10-04 20:00:00'),
    (57, -16.27, '2026-10-04 23:00:00'),
    (57, -15.08, '2026-10-05 02:00:00'),
    (57, -16.49, '2026-10-05 05:00:00'),
    (57, -18.55, '2026-10-05 08:00:00'),
    (57, -23.48, '2026-10-05 11:00:00'),
    (57, -16.04, '2026-10-05 14:00:00'),
    (57, -15.02, '2026-10-05 17:00:00'),
    (57, -21.06, '2026-10-05 20:00:00'),
    (57, -20.92, '2026-10-05 23:00:00'),
    (57, -19.14, '2026-10-06 02:00:00'),
    (57, -20.98, '2026-10-06 05:00:00'),
    (57, -19.83, '2026-10-06 08:00:00'),
    (57, -17.51, '2026-10-06 11:00:00'),
    (57, -20.67, '2026-10-06 14:00:00'),
    (57, -20.35, '2026-10-06 17:00:00');

-- Supermercado Mar Azul Ltda. | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (58, 10.78, '2026-10-04 08:00:00'),
    (58, 5.09, '2026-10-04 11:00:00'),
    (58, 4.17, '2026-10-04 14:00:00'),
    (58, 6.35, '2026-10-04 17:00:00'),
    (58, 2.76, '2026-10-04 20:00:00'),
    (58, 6.63, '2026-10-04 23:00:00'),
    (58, 4.19, '2026-10-05 02:00:00'),
    (58, 7.06, '2026-10-05 05:00:00'),
    (58, -0.80, '2026-10-05 08:00:00'),
    (58, 4.61, '2026-10-05 11:00:00'),
    (58, 5.84, '2026-10-05 14:00:00'),
    (58, 6.06, '2026-10-05 17:00:00'),
    (58, 3.57, '2026-10-05 20:00:00'),
    (58, 5.76, '2026-10-05 23:00:00'),
    (58, 6.84, '2026-10-06 02:00:00'),
    (58, 4.09, '2026-10-06 05:00:00'),
    (58, 10.96, '2026-10-06 08:00:00'),
    (58, 8.95, '2026-10-06 11:00:00'),
    (58, 6.37, '2026-10-06 14:00:00'),
    (58, 1.54, '2026-10-06 17:00:00');

-- Padaria Alvorada S.A. | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (59, -20.30, '2026-10-04 08:00:00'),
    (59, -18.52, '2026-10-04 11:00:00'),
    (59, -19.16, '2026-10-04 14:00:00'),
    (59, -15.23, '2026-10-04 17:00:00'),
    (59, -16.76, '2026-10-04 20:00:00'),
    (59, -17.12, '2026-10-04 23:00:00'),
    (59, -20.49, '2026-10-05 02:00:00'),
    (59, -19.77, '2026-10-05 05:00:00'),
    (59, -19.81, '2026-10-05 08:00:00'),
    (59, -18.41, '2026-10-05 11:00:00'),
    (59, -17.33, '2026-10-05 14:00:00'),
    (59, -16.69, '2026-10-05 17:00:00'),
    (59, -18.62, '2026-10-05 20:00:00'),
    (59, -15.66, '2026-10-05 23:00:00'),
    (59, -24.03, '2026-10-06 02:00:00'),
    (59, -19.59, '2026-10-06 05:00:00'),
    (59, -18.69, '2026-10-06 08:00:00'),
    (59, -15.92, '2026-10-06 11:00:00'),
    (59, -19.37, '2026-10-06 14:00:00'),
    (59, -18.63, '2026-10-06 17:00:00');

-- Padaria Alvorada S.A. | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (60, 9.87, '2026-10-04 08:00:00'),
    (60, 5.20, '2026-10-04 11:00:00'),
    (60, 10.12, '2026-10-04 14:00:00'),
    (60, 3.71, '2026-10-04 17:00:00'),
    (60, 7.13, '2026-10-04 20:00:00'),
    (60, 3.92, '2026-10-04 23:00:00'),
    (60, 6.55, '2026-10-05 02:00:00'),
    (60, 1.44, '2026-10-05 05:00:00'),
    (60, 9.49, '2026-10-05 08:00:00'),
    (60, 9.06, '2026-10-05 11:00:00'),
    (60, 10.15, '2026-10-05 14:00:00'),
    (60, 4.51, '2026-10-05 17:00:00'),
    (60, 5.64, '2026-10-05 20:00:00'),
    (60, 2.98, '2026-10-05 23:00:00'),
    (60, 4.23, '2026-10-06 02:00:00'),
    (60, -0.37, '2026-10-06 05:00:00'),
    (60, 3.99, '2026-10-06 08:00:00'),
    (60, 7.25, '2026-10-06 11:00:00'),
    (60, 8.76, '2026-10-06 14:00:00'),
    (60, 10.90, '2026-10-06 17:00:00');

-- Distribuidora Boa Vista S.A. | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (61, 5.74, '2026-10-04 08:00:00'),
    (61, 5.19, '2026-10-04 11:00:00'),
    (61, 5.89, '2026-10-04 14:00:00'),
    (61, 4.22, '2026-10-04 17:00:00'),
    (61, 6.04, '2026-10-04 20:00:00'),
    (61, 4.74, '2026-10-04 23:00:00'),
    (61, 4.92, '2026-10-05 02:00:00'),
    (61, 5.26, '2026-10-05 05:00:00'),
    (61, 5.58, '2026-10-05 08:00:00'),
    (61, 5.55, '2026-10-05 11:00:00'),
    (61, 4.37, '2026-10-05 14:00:00'),
    (61, 5.87, '2026-10-05 17:00:00'),
    (61, 5.12, '2026-10-05 20:00:00'),
    (61, 5.85, '2026-10-05 23:00:00'),
    (61, 5.42, '2026-10-06 02:00:00'),
    (61, 5.12, '2026-10-06 05:00:00'),
    (61, 4.73, '2026-10-06 08:00:00'),
    (61, 4.88, '2026-10-06 11:00:00'),
    (61, 4.69, '2026-10-06 14:00:00'),
    (61, 4.02, '2026-10-06 17:00:00');

-- Distribuidora Boa Vista S.A. | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (62, -22.15, '2026-10-04 08:00:00'),
    (62, -21.83, '2026-10-04 11:00:00'),
    (62, -22.61, '2026-10-04 14:00:00'),
    (62, -21.91, '2026-10-04 17:00:00'),
    (62, -22.51, '2026-10-04 20:00:00'),
    (62, -22.36, '2026-10-04 23:00:00'),
    (62, -20.53, '2026-10-05 02:00:00'),
    (62, -20.47, '2026-10-05 05:00:00'),
    (62, -21.53, '2026-10-05 08:00:00'),
    (62, -21.21, '2026-10-05 11:00:00'),
    (62, -20.96, '2026-10-05 14:00:00'),
    (62, -20.57, '2026-10-05 17:00:00'),
    (62, -21.51, '2026-10-05 20:00:00'),
    (62, -22.72, '2026-10-05 23:00:00'),
    (62, -20.97, '2026-10-06 02:00:00'),
    (62, -22.38, '2026-10-06 05:00:00'),
    (62, -21.57, '2026-10-06 08:00:00'),
    (62, -22.58, '2026-10-06 11:00:00'),
    (62, -22.46, '2026-10-06 14:00:00'),
    (62, -22.63, '2026-10-06 17:00:00');

-- Distribuidora Sabor Real S.A. | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (63, 5.93, '2026-10-04 08:00:00'),
    (63, 5.12, '2026-10-04 11:00:00'),
    (63, 4.65, '2026-10-04 14:00:00'),
    (63, 5.68, '2026-10-04 17:00:00'),
    (63, 6.04, '2026-10-04 20:00:00'),
    (63, 5.59, '2026-10-04 23:00:00'),
    (63, 5.87, '2026-10-05 02:00:00'),
    (63, 5.20, '2026-10-05 05:00:00'),
    (63, 5.90, '2026-10-05 08:00:00'),
    (63, 4.95, '2026-10-05 11:00:00'),
    (63, 5.00, '2026-10-05 14:00:00'),
    (63, 5.12, '2026-10-05 17:00:00'),
    (63, 4.74, '2026-10-05 20:00:00'),
    (63, 4.97, '2026-10-05 23:00:00'),
    (63, 4.98, '2026-10-06 02:00:00'),
    (63, 5.36, '2026-10-06 05:00:00'),
    (63, 4.36, '2026-10-06 08:00:00'),
    (63, 4.17, '2026-10-06 11:00:00'),
    (63, 5.30, '2026-10-06 14:00:00'),
    (63, 5.86, '2026-10-06 17:00:00');

-- Distribuidora Sabor Real S.A. | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (64, -21.59, '2026-10-04 08:00:00'),
    (64, -21.81, '2026-10-04 11:00:00'),
    (64, -21.54, '2026-10-04 14:00:00'),
    (64, -20.91, '2026-10-04 17:00:00'),
    (64, -21.63, '2026-10-04 20:00:00'),
    (64, -21.01, '2026-10-04 23:00:00'),
    (64, -22.58, '2026-10-05 02:00:00'),
    (64, -21.21, '2026-10-05 05:00:00'),
    (64, -21.42, '2026-10-05 08:00:00'),
    (64, -22.18, '2026-10-05 11:00:00'),
    (64, -21.77, '2026-10-05 14:00:00'),
    (64, -20.97, '2026-10-05 17:00:00'),
    (64, -21.22, '2026-10-05 20:00:00'),
    (64, -20.93, '2026-10-05 23:00:00'),
    (64, -21.76, '2026-10-06 02:00:00'),
    (64, -21.85, '2026-10-06 05:00:00'),
    (64, -20.73, '2026-10-06 08:00:00'),
    (64, -21.52, '2026-10-06 11:00:00'),
    (64, -21.29, '2026-10-06 14:00:00'),
    (64, -20.52, '2026-10-06 17:00:00');

-- Frigorífico Estrela do Sul | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (65, 4.90, '2026-10-04 08:00:00'),
    (65, 5.10, '2026-10-04 11:00:00'),
    (65, 4.93, '2026-10-04 14:00:00'),
    (65, 4.22, '2026-10-04 17:00:00'),
    (65, 4.05, '2026-10-04 20:00:00'),
    (65, 4.48, '2026-10-04 23:00:00'),
    (65, 4.49, '2026-10-05 02:00:00'),
    (65, 4.25, '2026-10-05 05:00:00'),
    (65, 5.90, '2026-10-05 08:00:00'),
    (65, 5.28, '2026-10-05 11:00:00'),
    (65, 4.58, '2026-10-05 14:00:00'),
    (65, 5.95, '2026-10-05 17:00:00'),
    (65, 5.92, '2026-10-05 20:00:00'),
    (65, 4.02, '2026-10-05 23:00:00'),
    (65, 5.49, '2026-10-06 02:00:00'),
    (65, 5.26, '2026-10-06 05:00:00'),
    (65, 4.91, '2026-10-06 08:00:00'),
    (65, 4.28, '2026-10-06 11:00:00'),
    (65, 4.81, '2026-10-06 14:00:00'),
    (65, 4.43, '2026-10-06 17:00:00');

-- Frigorífico Estrela do Sul | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (66, 2.60, '2026-10-04 08:00:00'),
    (66, 2.55, '2026-10-04 11:00:00'),
    (66, 2.30, '2026-10-04 14:00:00'),
    (66, 2.66, '2026-10-04 17:00:00'),
    (66, 2.22, '2026-10-04 20:00:00'),
    (66, 2.75, '2026-10-04 23:00:00'),
    (66, 1.98, '2026-10-05 02:00:00'),
    (66, 2.75, '2026-10-05 05:00:00'),
    (66, 2.56, '2026-10-05 08:00:00'),
    (66, 3.17, '2026-10-05 11:00:00'),
    (66, 2.12, '2026-10-05 14:00:00'),
    (66, 3.35, '2026-10-05 17:00:00'),
    (66, 2.68, '2026-10-05 20:00:00'),
    (66, 3.16, '2026-10-05 23:00:00'),
    (66, 2.19, '2026-10-06 02:00:00'),
    (66, 1.65, '2026-10-06 05:00:00'),
    (66, 3.19, '2026-10-06 08:00:00'),
    (66, 1.91, '2026-10-06 11:00:00'),
    (66, 3.22, '2026-10-06 14:00:00'),
    (66, 2.51, '2026-10-06 17:00:00');

-- Hortifruti Mar Azul Ltda. | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (67, 4.94, '2026-10-04 08:00:00'),
    (67, 5.95, '2026-10-04 11:00:00'),
    (67, 5.37, '2026-10-04 14:00:00'),
    (67, 5.49, '2026-10-04 17:00:00'),
    (67, 4.65, '2026-10-04 20:00:00'),
    (67, 5.32, '2026-10-04 23:00:00'),
    (67, 4.67, '2026-10-05 02:00:00'),
    (67, 4.67, '2026-10-05 05:00:00'),
    (67, 5.00, '2026-10-05 08:00:00'),
    (67, 5.36, '2026-10-05 11:00:00'),
    (67, 4.72, '2026-10-05 14:00:00'),
    (67, 5.37, '2026-10-05 17:00:00'),
    (67, 4.22, '2026-10-05 20:00:00'),
    (67, 4.45, '2026-10-05 23:00:00'),
    (67, 5.17, '2026-10-06 02:00:00'),
    (67, 4.34, '2026-10-06 05:00:00'),
    (67, 5.60, '2026-10-06 08:00:00'),
    (67, 5.89, '2026-10-06 11:00:00'),
    (67, 5.11, '2026-10-06 14:00:00'),
    (67, 4.35, '2026-10-06 17:00:00');

-- Hortifruti Mar Azul Ltda. | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (68, 4.07, '2026-10-04 08:00:00'),
    (68, 5.37, '2026-10-04 11:00:00'),
    (68, 5.34, '2026-10-04 14:00:00'),
    (68, 4.77, '2026-10-04 17:00:00'),
    (68, 4.53, '2026-10-04 20:00:00'),
    (68, 5.44, '2026-10-04 23:00:00'),
    (68, 4.10, '2026-10-05 02:00:00'),
    (68, 5.90, '2026-10-05 05:00:00'),
    (68, 5.91, '2026-10-05 08:00:00'),
    (68, 5.40, '2026-10-05 11:00:00'),
    (68, 4.45, '2026-10-05 14:00:00'),
    (68, 4.32, '2026-10-05 17:00:00'),
    (68, 5.61, '2026-10-05 20:00:00'),
    (68, 5.15, '2026-10-05 23:00:00'),
    (68, 4.41, '2026-10-06 02:00:00'),
    (68, 5.58, '2026-10-06 05:00:00'),
    (68, 4.93, '2026-10-06 08:00:00'),
    (68, 3.97, '2026-10-06 11:00:00'),
    (68, 5.57, '2026-10-06 14:00:00'),
    (68, 5.29, '2026-10-06 17:00:00');

-- Empório Campo Belo S.A. | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (69, -21.56, '2026-10-04 08:00:00'),
    (69, -21.31, '2026-10-04 11:00:00'),
    (69, -22.12, '2026-10-04 14:00:00'),
    (69, -21.58, '2026-10-04 17:00:00'),
    (69, -21.45, '2026-10-04 20:00:00'),
    (69, -22.26, '2026-10-04 23:00:00'),
    (69, -23.29, '2026-10-05 02:00:00'),
    (69, -20.65, '2026-10-05 05:00:00'),
    (69, -19.77, '2026-10-05 08:00:00'),
    (69, -22.23, '2026-10-05 11:00:00'),
    (69, -21.03, '2026-10-05 14:00:00'),
    (69, -20.37, '2026-10-05 17:00:00'),
    (69, -21.85, '2026-10-05 20:00:00'),
    (69, -20.03, '2026-10-05 23:00:00'),
    (69, -23.07, '2026-10-06 02:00:00'),
    (69, -20.47, '2026-10-06 05:00:00'),
    (69, -22.86, '2026-10-06 08:00:00'),
    (69, -20.71, '2026-10-06 11:00:00'),
    (69, -20.78, '2026-10-06 14:00:00'),
    (69, -22.06, '2026-10-06 17:00:00');

-- Empório Campo Belo S.A. | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (70, 5.25, '2026-10-04 08:00:00'),
    (70, 5.70, '2026-10-04 11:00:00'),
    (70, 3.57, '2026-10-04 14:00:00'),
    (70, 6.07, '2026-10-04 17:00:00'),
    (70, 4.72, '2026-10-04 20:00:00'),
    (70, 3.50, '2026-10-04 23:00:00'),
    (70, 3.51, '2026-10-05 02:00:00'),
    (70, 3.47, '2026-10-05 05:00:00'),
    (70, 5.71, '2026-10-05 08:00:00'),
    (70, 3.35, '2026-10-05 11:00:00'),
    (70, 6.52, '2026-10-05 14:00:00'),
    (70, 4.03, '2026-10-05 17:00:00'),
    (70, 4.56, '2026-10-05 20:00:00'),
    (70, 4.93, '2026-10-05 23:00:00'),
    (70, 6.44, '2026-10-06 02:00:00'),
    (70, 4.38, '2026-10-06 05:00:00'),
    (70, 4.74, '2026-10-06 08:00:00'),
    (70, 6.24, '2026-10-06 11:00:00'),
    (70, 4.20, '2026-10-06 14:00:00'),
    (70, 4.11, '2026-10-06 17:00:00');

-- Supermercado Alvorada & Cia | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (71, 3.15, '2026-10-04 08:00:00'),
    (71, 1.56, '2026-10-04 11:00:00'),
    (71, 3.09, '2026-10-04 14:00:00'),
    (71, -1.44, '2026-10-04 17:00:00'),
    (71, 1.73, '2026-10-04 20:00:00'),
    (71, 4.25, '2026-10-04 23:00:00'),
    (71, 2.11, '2026-10-05 02:00:00'),
    (71, 1.93, '2026-10-05 05:00:00'),
    (71, 3.47, '2026-10-05 08:00:00'),
    (71, 6.97, '2026-10-05 11:00:00'),
    (71, 3.46, '2026-10-05 14:00:00'),
    (71, 0.62, '2026-10-05 17:00:00'),
    (71, 0.81, '2026-10-05 20:00:00'),
    (71, -1.14, '2026-10-05 23:00:00'),
    (71, 0.69, '2026-10-06 02:00:00'),
    (71, 0.76, '2026-10-06 05:00:00'),
    (71, -2.49, '2026-10-06 08:00:00'),
    (71, 2.05, '2026-10-06 11:00:00'),
    (71, 2.65, '2026-10-06 14:00:00'),
    (71, 6.64, '2026-10-06 17:00:00');

-- Supermercado Alvorada & Cia | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (72, -25.95, '2026-10-04 08:00:00'),
    (72, -15.88, '2026-10-04 11:00:00'),
    (72, -23.57, '2026-10-04 14:00:00'),
    (72, -15.07, '2026-10-04 17:00:00'),
    (72, -15.40, '2026-10-04 20:00:00'),
    (72, -26.21, '2026-10-04 23:00:00'),
    (72, -23.84, '2026-10-05 02:00:00'),
    (72, -17.49, '2026-10-05 05:00:00'),
    (72, -20.35, '2026-10-05 08:00:00'),
    (72, -15.66, '2026-10-05 11:00:00'),
    (72, -22.55, '2026-10-05 14:00:00'),
    (72, -23.61, '2026-10-05 17:00:00'),
    (72, -19.89, '2026-10-05 20:00:00'),
    (72, -15.26, '2026-10-05 23:00:00'),
    (72, -23.06, '2026-10-06 02:00:00'),
    (72, -22.98, '2026-10-06 05:00:00'),
    (72, -20.53, '2026-10-06 08:00:00'),
    (72, -24.09, '2026-10-06 11:00:00'),
    (72, -16.50, '2026-10-06 14:00:00'),
    (72, -23.11, '2026-10-06 17:00:00');

-- Hortifruti Campo Belo S.A. | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (73, -19.36, '2026-10-04 08:00:00'),
    (73, -19.94, '2026-10-04 11:00:00'),
    (73, -19.56, '2026-10-04 14:00:00'),
    (73, -18.85, '2026-10-04 17:00:00'),
    (73, -19.56, '2026-10-04 20:00:00'),
    (73, -20.94, '2026-10-04 23:00:00'),
    (73, -19.62, '2026-10-05 02:00:00'),
    (73, -20.29, '2026-10-05 05:00:00'),
    (73, -20.50, '2026-10-05 08:00:00'),
    (73, -18.95, '2026-10-05 11:00:00'),
    (73, -19.87, '2026-10-05 14:00:00'),
    (73, -19.29, '2026-10-05 17:00:00'),
    (73, -20.07, '2026-10-05 20:00:00'),
    (73, -19.35, '2026-10-05 23:00:00'),
    (73, -19.64, '2026-10-06 02:00:00'),
    (73, -19.09, '2026-10-06 05:00:00'),
    (73, -20.01, '2026-10-06 08:00:00'),
    (73, -20.96, '2026-10-06 11:00:00'),
    (73, -19.74, '2026-10-06 14:00:00'),
    (73, -19.16, '2026-10-06 17:00:00');

-- Hortifruti Campo Belo S.A. | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (74, -23.04, '2026-10-04 08:00:00'),
    (74, -20.62, '2026-10-04 11:00:00'),
    (74, -21.78, '2026-10-04 14:00:00'),
    (74, -22.37, '2026-10-04 17:00:00'),
    (74, -20.45, '2026-10-04 20:00:00'),
    (74, -20.06, '2026-10-04 23:00:00'),
    (74, -19.52, '2026-10-05 02:00:00'),
    (74, -19.76, '2026-10-05 05:00:00'),
    (74, -20.03, '2026-10-05 08:00:00'),
    (74, -20.84, '2026-10-05 11:00:00'),
    (74, -22.38, '2026-10-05 14:00:00'),
    (74, -19.95, '2026-10-05 17:00:00'),
    (74, -20.13, '2026-10-05 20:00:00'),
    (74, -21.70, '2026-10-05 23:00:00'),
    (74, -22.17, '2026-10-06 02:00:00'),
    (74, -19.79, '2026-10-06 05:00:00'),
    (74, -22.72, '2026-10-06 08:00:00'),
    (74, -22.87, '2026-10-06 11:00:00'),
    (74, -19.94, '2026-10-06 14:00:00'),
    (74, -21.31, '2026-10-06 17:00:00');

-- Açougue Terra Fértil | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (75, -19.92, '2026-10-04 08:00:00'),
    (75, -20.94, '2026-10-04 11:00:00'),
    (75, -19.23, '2026-10-04 14:00:00'),
    (75, -18.97, '2026-10-04 17:00:00'),
    (75, -19.70, '2026-10-04 20:00:00'),
    (75, -18.82, '2026-10-04 23:00:00'),
    (75, -20.11, '2026-10-05 02:00:00'),
    (75, -18.85, '2026-10-05 05:00:00'),
    (75, -19.87, '2026-10-05 08:00:00'),
    (75, -20.56, '2026-10-05 11:00:00'),
    (75, -21.06, '2026-10-05 14:00:00'),
    (75, -21.11, '2026-10-05 17:00:00'),
    (75, -19.39, '2026-10-05 20:00:00'),
    (75, -20.29, '2026-10-05 23:00:00'),
    (75, -20.35, '2026-10-06 02:00:00'),
    (75, -19.72, '2026-10-06 05:00:00'),
    (75, -21.15, '2026-10-06 08:00:00'),
    (75, -20.70, '2026-10-06 11:00:00'),
    (75, -20.60, '2026-10-06 14:00:00'),
    (75, -19.13, '2026-10-06 17:00:00');

-- Açougue Terra Fértil | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (76, -19.70, '2026-10-04 08:00:00'),
    (76, -20.94, '2026-10-04 11:00:00'),
    (76, -22.83, '2026-10-04 14:00:00'),
    (76, -21.40, '2026-10-04 17:00:00'),
    (76, -20.26, '2026-10-04 20:00:00'),
    (76, -21.43, '2026-10-04 23:00:00'),
    (76, -23.47, '2026-10-05 02:00:00'),
    (76, -21.23, '2026-10-05 05:00:00'),
    (76, -20.90, '2026-10-05 08:00:00'),
    (76, -22.36, '2026-10-05 11:00:00'),
    (76, -22.47, '2026-10-05 14:00:00'),
    (76, -23.49, '2026-10-05 17:00:00'),
    (76, -20.97, '2026-10-05 20:00:00'),
    (76, -19.54, '2026-10-05 23:00:00'),
    (76, -22.64, '2026-10-06 02:00:00'),
    (76, -20.85, '2026-10-06 05:00:00'),
    (76, -20.56, '2026-10-06 08:00:00'),
    (76, -20.47, '2026-10-06 11:00:00'),
    (76, -21.52, '2026-10-06 14:00:00'),
    (76, -19.93, '2026-10-06 17:00:00');

-- Restaurante Nova Safra Ltda. | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (77, -19.58, '2026-10-04 08:00:00'),
    (77, -19.38, '2026-10-04 11:00:00'),
    (77, -15.60, '2026-10-04 14:00:00'),
    (77, -21.12, '2026-10-04 17:00:00'),
    (77, -20.93, '2026-10-04 20:00:00'),
    (77, -20.90, '2026-10-04 23:00:00'),
    (77, -21.41, '2026-10-05 02:00:00'),
    (77, -21.42, '2026-10-05 05:00:00'),
    (77, -20.05, '2026-10-05 08:00:00'),
    (77, -21.26, '2026-10-05 11:00:00'),
    (77, -19.59, '2026-10-05 14:00:00'),
    (77, -19.67, '2026-10-05 17:00:00'),
    (77, -19.60, '2026-10-05 20:00:00'),
    (77, -21.38, '2026-10-05 23:00:00'),
    (77, -19.08, '2026-10-06 02:00:00'),
    (77, -15.46, '2026-10-06 05:00:00'),
    (77, -16.06, '2026-10-06 08:00:00'),
    (77, -19.98, '2026-10-06 11:00:00'),
    (77, -19.58, '2026-10-06 14:00:00'),
    (77, -20.97, '2026-10-06 17:00:00');

-- Restaurante Nova Safra Ltda. | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (78, 1.66, '2026-10-04 08:00:00'),
    (78, 2.30, '2026-10-04 11:00:00'),
    (78, -1.84, '2026-10-04 14:00:00'),
    (78, 6.63, '2026-10-04 17:00:00'),
    (78, 1.95, '2026-10-04 20:00:00'),
    (78, 0.94, '2026-10-04 23:00:00'),
    (78, 1.58, '2026-10-05 02:00:00'),
    (78, 2.34, '2026-10-05 05:00:00'),
    (78, 7.59, '2026-10-05 08:00:00'),
    (78, 2.91, '2026-10-05 11:00:00'),
    (78, 1.03, '2026-10-05 14:00:00'),
    (78, 3.38, '2026-10-05 17:00:00'),
    (78, 6.11, '2026-10-05 20:00:00'),
    (78, 7.58, '2026-10-05 23:00:00'),
    (78, 3.40, '2026-10-06 02:00:00'),
    (78, 2.76, '2026-10-06 05:00:00'),
    (78, 3.52, '2026-10-06 08:00:00'),
    (78, 3.75, '2026-10-06 11:00:00'),
    (78, 6.43, '2026-10-06 14:00:00'),
    (78, 5.86, '2026-10-06 17:00:00');

-- Mercado Campo Belo Ltda. | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (79, 2.26, '2026-10-04 08:00:00'),
    (79, 2.59, '2026-10-04 11:00:00'),
    (79, 2.90, '2026-10-04 14:00:00'),
    (79, 2.15, '2026-10-04 17:00:00'),
    (79, 1.69, '2026-10-04 20:00:00'),
    (79, 1.69, '2026-10-04 23:00:00'),
    (79, 2.99, '2026-10-05 02:00:00'),
    (79, 1.91, '2026-10-05 05:00:00'),
    (79, 2.79, '2026-10-05 08:00:00'),
    (79, 2.44, '2026-10-05 11:00:00'),
    (79, 2.13, '2026-10-05 14:00:00'),
    (79, 1.81, '2026-10-05 17:00:00'),
    (79, 2.99, '2026-10-05 20:00:00'),
    (79, 2.30, '2026-10-05 23:00:00'),
    (79, 2.40, '2026-10-06 02:00:00'),
    (79, 1.65, '2026-10-06 05:00:00'),
    (79, 3.28, '2026-10-06 08:00:00'),
    (79, 1.82, '2026-10-06 11:00:00'),
    (79, 3.06, '2026-10-06 14:00:00'),
    (79, 1.83, '2026-10-06 17:00:00');

-- Mercado Campo Belo Ltda. | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (80, 5.96, '2026-10-04 08:00:00'),
    (80, 4.32, '2026-10-04 11:00:00'),
    (80, 4.07, '2026-10-04 14:00:00'),
    (80, 5.36, '2026-10-04 17:00:00'),
    (80, 4.97, '2026-10-04 20:00:00'),
    (80, 5.19, '2026-10-04 23:00:00'),
    (80, 4.84, '2026-10-05 02:00:00'),
    (80, 5.53, '2026-10-05 05:00:00'),
    (80, 5.41, '2026-10-05 08:00:00'),
    (80, 5.93, '2026-10-05 11:00:00'),
    (80, 5.81, '2026-10-05 14:00:00'),
    (80, 5.10, '2026-10-05 17:00:00'),
    (80, 6.01, '2026-10-05 20:00:00'),
    (80, 5.59, '2026-10-05 23:00:00'),
    (80, 5.19, '2026-10-06 02:00:00'),
    (80, 5.72, '2026-10-06 05:00:00'),
    (80, 5.06, '2026-10-06 08:00:00'),
    (80, 5.52, '2026-10-06 11:00:00'),
    (80, 4.80, '2026-10-06 14:00:00'),
    (80, 4.37, '2026-10-06 17:00:00');

-- Laticínios Boa Vista S.A. | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (81, 6.68, '2026-10-04 08:00:00'),
    (81, 3.31, '2026-10-04 11:00:00'),
    (81, 6.17, '2026-10-04 14:00:00'),
    (81, 4.27, '2026-10-04 17:00:00'),
    (81, 5.24, '2026-10-04 20:00:00'),
    (81, 6.82, '2026-10-04 23:00:00'),
    (81, 3.87, '2026-10-05 02:00:00'),
    (81, 10.08, '2026-10-05 05:00:00'),
    (81, 5.34, '2026-10-05 08:00:00'),
    (81, 9.66, '2026-10-05 11:00:00'),
    (81, 3.57, '2026-10-05 14:00:00'),
    (81, 9.38, '2026-10-05 17:00:00'),
    (81, 3.26, '2026-10-05 20:00:00'),
    (81, 0.16, '2026-10-05 23:00:00'),
    (81, 7.21, '2026-10-06 02:00:00'),
    (81, 4.88, '2026-10-06 05:00:00'),
    (81, 3.12, '2026-10-06 08:00:00'),
    (81, 7.08, '2026-10-06 11:00:00'),
    (81, 6.88, '2026-10-06 14:00:00'),
    (81, 7.24, '2026-10-06 17:00:00');

-- Laticínios Boa Vista S.A. | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (82, -23.99, '2026-10-04 08:00:00'),
    (82, -27.85, '2026-10-04 11:00:00'),
    (82, -15.77, '2026-10-04 14:00:00'),
    (82, -20.55, '2026-10-04 17:00:00'),
    (82, -19.00, '2026-10-04 20:00:00'),
    (82, -23.07, '2026-10-04 23:00:00'),
    (82, -22.16, '2026-10-05 02:00:00'),
    (82, -19.21, '2026-10-05 05:00:00'),
    (82, -17.41, '2026-10-05 08:00:00'),
    (82, -20.87, '2026-10-05 11:00:00'),
    (82, -25.80, '2026-10-05 14:00:00'),
    (82, -24.24, '2026-10-05 17:00:00'),
    (82, -19.28, '2026-10-05 20:00:00'),
    (82, -27.92, '2026-10-05 23:00:00'),
    (82, -23.21, '2026-10-06 02:00:00'),
    (82, -23.64, '2026-10-06 05:00:00'),
    (82, -21.33, '2026-10-06 08:00:00'),
    (82, -21.53, '2026-10-06 11:00:00'),
    (82, -24.24, '2026-10-06 14:00:00'),
    (82, -22.76, '2026-10-06 17:00:00');

-- Laticínios Campo Belo | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (83, 3.05, '2026-10-04 08:00:00'),
    (83, 2.80, '2026-10-04 11:00:00'),
    (83, 1.73, '2026-10-04 14:00:00'),
    (83, 2.13, '2026-10-04 17:00:00'),
    (83, 2.20, '2026-10-04 20:00:00'),
    (83, 1.90, '2026-10-04 23:00:00'),
    (83, 2.85, '2026-10-05 02:00:00'),
    (83, 2.74, '2026-10-05 05:00:00'),
    (83, 2.72, '2026-10-05 08:00:00'),
    (83, 7.36, '2026-10-05 11:00:00'),
    (83, 1.96, '2026-10-05 14:00:00'),
    (83, 2.70, '2026-10-05 17:00:00'),
    (83, 3.68, '2026-10-05 20:00:00'),
    (83, 1.43, '2026-10-05 23:00:00'),
    (83, 3.21, '2026-10-06 02:00:00'),
    (83, 1.18, '2026-10-06 05:00:00'),
    (83, 3.73, '2026-10-06 08:00:00'),
    (83, 1.87, '2026-10-06 11:00:00'),
    (83, 1.62, '2026-10-06 14:00:00'),
    (83, 3.76, '2026-10-06 17:00:00');

-- Laticínios Campo Belo | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (84, 6.21, '2026-10-04 08:00:00'),
    (84, 4.17, '2026-10-04 11:00:00'),
    (84, 3.39, '2026-10-04 14:00:00'),
    (84, 3.63, '2026-10-04 17:00:00'),
    (84, 5.53, '2026-10-04 20:00:00'),
    (84, 3.40, '2026-10-04 23:00:00'),
    (84, 3.94, '2026-10-05 02:00:00'),
    (84, 4.05, '2026-10-05 05:00:00'),
    (84, 6.24, '2026-10-05 08:00:00'),
    (84, 3.74, '2026-10-05 11:00:00'),
    (84, 5.47, '2026-10-05 14:00:00'),
    (84, 4.43, '2026-10-05 17:00:00'),
    (84, 4.52, '2026-10-05 20:00:00'),
    (84, 6.12, '2026-10-05 23:00:00'),
    (84, 6.56, '2026-10-06 02:00:00'),
    (84, 3.83, '2026-10-06 05:00:00'),
    (84, 5.76, '2026-10-06 08:00:00'),
    (84, 4.95, '2026-10-06 11:00:00'),
    (84, 6.53, '2026-10-06 14:00:00'),
    (84, 4.69, '2026-10-06 17:00:00');

-- Padaria Sabor Real S.A. | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (85, -19.20, '2026-10-04 08:00:00'),
    (85, -19.31, '2026-10-04 11:00:00'),
    (85, -20.90, '2026-10-04 14:00:00'),
    (85, -20.82, '2026-10-04 17:00:00'),
    (85, -19.29, '2026-10-04 20:00:00'),
    (85, -20.70, '2026-10-04 23:00:00'),
    (85, -19.84, '2026-10-05 02:00:00'),
    (85, -21.13, '2026-10-05 05:00:00'),
    (85, -18.98, '2026-10-05 08:00:00'),
    (85, -19.14, '2026-10-05 11:00:00'),
    (85, -18.94, '2026-10-05 14:00:00'),
    (85, -19.82, '2026-10-05 17:00:00'),
    (85, -20.95, '2026-10-05 20:00:00'),
    (85, -21.03, '2026-10-05 23:00:00'),
    (85, -20.11, '2026-10-06 02:00:00'),
    (85, -19.04, '2026-10-06 05:00:00'),
    (85, -18.95, '2026-10-06 08:00:00'),
    (85, -19.80, '2026-10-06 11:00:00'),
    (85, -20.61, '2026-10-06 14:00:00'),
    (85, -21.04, '2026-10-06 17:00:00');

-- Padaria Sabor Real S.A. | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (86, 2.45, '2026-10-04 08:00:00'),
    (86, 3.18, '2026-10-04 11:00:00'),
    (86, 1.97, '2026-10-04 14:00:00'),
    (86, 2.91, '2026-10-04 17:00:00'),
    (86, 2.75, '2026-10-04 20:00:00'),
    (86, 1.79, '2026-10-04 23:00:00'),
    (86, 2.98, '2026-10-05 02:00:00'),
    (86, 3.80, '2026-10-05 05:00:00'),
    (86, 2.99, '2026-10-05 08:00:00'),
    (86, 3.64, '2026-10-05 11:00:00'),
    (86, 2.22, '2026-10-05 14:00:00'),
    (86, 1.68, '2026-10-05 17:00:00'),
    (86, 2.50, '2026-10-05 20:00:00'),
    (86, 2.02, '2026-10-05 23:00:00'),
    (86, 2.59, '2026-10-06 02:00:00'),
    (86, 2.26, '2026-10-06 05:00:00'),
    (86, 2.42, '2026-10-06 08:00:00'),
    (86, 1.03, '2026-10-06 11:00:00'),
    (86, 4.00, '2026-10-06 14:00:00'),
    (86, 2.82, '2026-10-06 17:00:00');

-- Frigorífico Nova Safra | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (87, 6.34, '2026-10-04 08:00:00'),
    (87, 5.65, '2026-10-04 11:00:00'),
    (87, 5.02, '2026-10-04 14:00:00'),
    (87, 6.55, '2026-10-04 17:00:00'),
    (87, 5.03, '2026-10-04 20:00:00'),
    (87, 4.68, '2026-10-04 23:00:00'),
    (87, 5.49, '2026-10-05 02:00:00'),
    (87, 10.43, '2026-10-05 05:00:00'),
    (87, 5.15, '2026-10-05 08:00:00'),
    (87, 4.61, '2026-10-05 11:00:00'),
    (87, 6.74, '2026-10-05 14:00:00'),
    (87, 5.64, '2026-10-05 17:00:00'),
    (87, 5.78, '2026-10-05 20:00:00'),
    (87, 5.08, '2026-10-05 23:00:00'),
    (87, 3.86, '2026-10-06 02:00:00'),
    (87, 3.42, '2026-10-06 05:00:00'),
    (87, 5.43, '2026-10-06 08:00:00'),
    (87, 4.87, '2026-10-06 11:00:00'),
    (87, 4.75, '2026-10-06 14:00:00'),
    (87, 6.34, '2026-10-06 17:00:00');

-- Frigorífico Nova Safra | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (88, 3.28, '2026-10-04 08:00:00'),
    (88, 3.41, '2026-10-04 11:00:00'),
    (88, 5.89, '2026-10-04 14:00:00'),
    (88, 3.79, '2026-10-04 17:00:00'),
    (88, 5.32, '2026-10-04 20:00:00'),
    (88, 4.92, '2026-10-04 23:00:00'),
    (88, 6.76, '2026-10-05 02:00:00'),
    (88, 5.19, '2026-10-05 05:00:00'),
    (88, 3.66, '2026-10-05 08:00:00'),
    (88, 5.91, '2026-10-05 11:00:00'),
    (88, 4.38, '2026-10-05 14:00:00'),
    (88, 4.26, '2026-10-05 17:00:00'),
    (88, 6.61, '2026-10-05 20:00:00'),
    (88, 5.82, '2026-10-05 23:00:00'),
    (88, 3.28, '2026-10-06 02:00:00'),
    (88, 3.76, '2026-10-06 05:00:00'),
    (88, 6.13, '2026-10-06 08:00:00'),
    (88, 4.87, '2026-10-06 11:00:00'),
    (88, 6.75, '2026-10-06 14:00:00'),
    (88, 5.08, '2026-10-06 17:00:00');

-- Empório Boa Vista Ltda. | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (89, 5.08, '2026-10-04 08:00:00'),
    (89, 5.70, '2026-10-04 11:00:00'),
    (89, 4.58, '2026-10-04 14:00:00'),
    (89, 4.21, '2026-10-04 17:00:00'),
    (89, 4.70, '2026-10-04 20:00:00'),
    (89, 4.03, '2026-10-04 23:00:00'),
    (89, 4.19, '2026-10-05 02:00:00'),
    (89, 4.04, '2026-10-05 05:00:00'),
    (89, 5.32, '2026-10-05 08:00:00'),
    (89, 4.61, '2026-10-05 11:00:00'),
    (89, 5.21, '2026-10-05 14:00:00'),
    (89, 5.77, '2026-10-05 17:00:00'),
    (89, 5.89, '2026-10-05 20:00:00'),
    (89, 5.29, '2026-10-05 23:00:00'),
    (89, 5.62, '2026-10-06 02:00:00'),
    (89, 5.92, '2026-10-06 05:00:00'),
    (89, 5.71, '2026-10-06 08:00:00'),
    (89, 4.15, '2026-10-06 11:00:00'),
    (89, 5.60, '2026-10-06 14:00:00'),
    (89, 5.90, '2026-10-06 17:00:00');

-- Empório Boa Vista Ltda. | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (90, -22.27, '2026-10-04 08:00:00'),
    (90, -20.39, '2026-10-04 11:00:00'),
    (90, -21.08, '2026-10-04 14:00:00'),
    (90, -21.14, '2026-10-04 17:00:00'),
    (90, -22.45, '2026-10-04 20:00:00'),
    (90, -22.30, '2026-10-04 23:00:00'),
    (90, -22.69, '2026-10-05 02:00:00'),
    (90, -21.29, '2026-10-05 05:00:00'),
    (90, -21.04, '2026-10-05 08:00:00'),
    (90, -21.49, '2026-10-05 11:00:00'),
    (90, -21.47, '2026-10-05 14:00:00'),
    (90, -21.10, '2026-10-05 17:00:00'),
    (90, -20.63, '2026-10-05 20:00:00'),
    (90, -20.42, '2026-10-05 23:00:00'),
    (90, -22.53, '2026-10-06 02:00:00'),
    (90, -22.14, '2026-10-06 05:00:00'),
    (90, -22.59, '2026-10-06 08:00:00'),
    (90, -20.34, '2026-10-06 11:00:00'),
    (90, -20.28, '2026-10-06 14:00:00'),
    (90, -20.32, '2026-10-06 17:00:00');

-- Distribuidora Mar Azul | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (91, 6.91, '2026-10-04 08:00:00'),
    (91, 4.75, '2026-10-04 11:00:00'),
    (91, 10.91, '2026-10-04 14:00:00'),
    (91, 2.78, '2026-10-04 17:00:00'),
    (91, 4.14, '2026-10-04 20:00:00'),
    (91, 4.71, '2026-10-04 23:00:00'),
    (91, 7.03, '2026-10-05 02:00:00'),
    (91, -0.82, '2026-10-05 05:00:00'),
    (91, 8.53, '2026-10-05 08:00:00'),
    (91, 3.88, '2026-10-05 11:00:00'),
    (91, 8.93, '2026-10-05 14:00:00'),
    (91, 3.97, '2026-10-05 17:00:00'),
    (91, 5.33, '2026-10-05 20:00:00'),
    (91, 6.17, '2026-10-05 23:00:00'),
    (91, 1.37, '2026-10-06 02:00:00'),
    (91, 4.30, '2026-10-06 05:00:00'),
    (91, 6.93, '2026-10-06 08:00:00'),
    (91, 6.13, '2026-10-06 11:00:00'),
    (91, 9.58, '2026-10-06 14:00:00'),
    (91, 7.22, '2026-10-06 17:00:00');

-- Distribuidora Mar Azul | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (92, 6.23, '2026-10-04 08:00:00'),
    (92, 6.54, '2026-10-04 11:00:00'),
    (92, 3.25, '2026-10-04 14:00:00'),
    (92, 6.68, '2026-10-04 17:00:00'),
    (92, 10.53, '2026-10-04 20:00:00'),
    (92, 6.43, '2026-10-04 23:00:00'),
    (92, 0.10, '2026-10-05 02:00:00'),
    (92, 10.06, '2026-10-05 05:00:00'),
    (92, 4.58, '2026-10-05 08:00:00'),
    (92, 3.55, '2026-10-05 11:00:00'),
    (92, 3.99, '2026-10-05 14:00:00'),
    (92, 10.85, '2026-10-05 17:00:00'),
    (92, 3.57, '2026-10-05 20:00:00'),
    (92, 5.12, '2026-10-05 23:00:00'),
    (92, 3.66, '2026-10-06 02:00:00'),
    (92, 9.10, '2026-10-06 05:00:00'),
    (92, 9.53, '2026-10-06 08:00:00'),
    (92, 3.32, '2026-10-06 11:00:00'),
    (92, 8.76, '2026-10-06 14:00:00'),
    (92, 5.74, '2026-10-06 17:00:00');

-- Açougue Vale Verde | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (93, 4.73, '2026-10-04 08:00:00'),
    (93, 4.52, '2026-10-04 11:00:00'),
    (93, 4.76, '2026-10-04 14:00:00'),
    (93, 5.90, '2026-10-04 17:00:00'),
    (93, 5.61, '2026-10-04 20:00:00'),
    (93, 4.40, '2026-10-04 23:00:00'),
    (93, 5.23, '2026-10-05 02:00:00'),
    (93, 6.48, '2026-10-05 05:00:00'),
    (93, 5.73, '2026-10-05 08:00:00'),
    (93, 4.91, '2026-10-05 11:00:00'),
    (93, 4.58, '2026-10-05 14:00:00'),
    (93, 5.78, '2026-10-05 17:00:00'),
    (93, 6.24, '2026-10-05 20:00:00'),
    (93, 6.21, '2026-10-05 23:00:00'),
    (93, 4.89, '2026-10-06 02:00:00'),
    (93, 4.60, '2026-10-06 05:00:00'),
    (93, 4.17, '2026-10-06 08:00:00'),
    (93, 5.74, '2026-10-06 11:00:00'),
    (93, 4.21, '2026-10-06 14:00:00'),
    (93, 5.91, '2026-10-06 17:00:00');

-- Açougue Vale Verde | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (94, 5.01, '2026-10-04 08:00:00'),
    (94, 5.19, '2026-10-04 11:00:00'),
    (94, 3.34, '2026-10-04 14:00:00'),
    (94, 4.28, '2026-10-04 17:00:00'),
    (94, 6.10, '2026-10-04 20:00:00'),
    (94, 4.70, '2026-10-04 23:00:00'),
    (94, 6.12, '2026-10-05 02:00:00'),
    (94, 4.00, '2026-10-05 05:00:00'),
    (94, 5.90, '2026-10-05 08:00:00'),
    (94, 4.41, '2026-10-05 11:00:00'),
    (94, 3.26, '2026-10-05 14:00:00'),
    (94, 4.25, '2026-10-05 17:00:00'),
    (94, 4.23, '2026-10-05 20:00:00'),
    (94, 5.11, '2026-10-05 23:00:00'),
    (94, 6.09, '2026-10-06 02:00:00'),
    (94, 5.26, '2026-10-06 05:00:00'),
    (94, 5.40, '2026-10-06 08:00:00'),
    (94, 6.67, '2026-10-06 11:00:00'),
    (94, 4.81, '2026-10-06 14:00:00'),
    (94, 3.46, '2026-10-06 17:00:00');

-- Padaria Terra Fértil ME | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (95, 4.65, '2026-10-04 08:00:00'),
    (95, 3.36, '2026-10-04 11:00:00'),
    (95, 6.42, '2026-10-04 14:00:00'),
    (95, 3.80, '2026-10-04 17:00:00'),
    (95, 4.12, '2026-10-04 20:00:00'),
    (95, 3.80, '2026-10-04 23:00:00'),
    (95, 4.02, '2026-10-05 02:00:00'),
    (95, 5.30, '2026-10-05 05:00:00'),
    (95, 5.43, '2026-10-05 08:00:00'),
    (95, 3.66, '2026-10-05 11:00:00'),
    (95, 3.74, '2026-10-05 14:00:00'),
    (95, 4.40, '2026-10-05 17:00:00'),
    (95, 4.22, '2026-10-05 20:00:00'),
    (95, 4.68, '2026-10-05 23:00:00'),
    (95, 3.57, '2026-10-06 02:00:00'),
    (95, 5.48, '2026-10-06 05:00:00'),
    (95, 4.66, '2026-10-06 08:00:00'),
    (95, 4.82, '2026-10-06 11:00:00'),
    (95, 3.56, '2026-10-06 14:00:00'),
    (95, 4.10, '2026-10-06 17:00:00');

-- Padaria Terra Fértil ME | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (96, 4.64, '2026-10-04 08:00:00'),
    (96, 9.70, '2026-10-04 11:00:00'),
    (96, 6.01, '2026-10-04 14:00:00'),
    (96, 6.02, '2026-10-04 17:00:00'),
    (96, 5.02, '2026-10-04 20:00:00'),
    (96, 6.66, '2026-10-04 23:00:00'),
    (96, 3.80, '2026-10-05 02:00:00'),
    (96, 3.83, '2026-10-05 05:00:00'),
    (96, 4.03, '2026-10-05 08:00:00'),
    (96, 3.45, '2026-10-05 11:00:00'),
    (96, 6.17, '2026-10-05 14:00:00'),
    (96, 4.82, '2026-10-05 17:00:00'),
    (96, 5.94, '2026-10-05 20:00:00'),
    (96, 4.45, '2026-10-05 23:00:00'),
    (96, 6.55, '2026-10-06 02:00:00'),
    (96, 5.54, '2026-10-06 05:00:00'),
    (96, 4.05, '2026-10-06 08:00:00'),
    (96, 4.14, '2026-10-06 11:00:00'),
    (96, 3.74, '2026-10-06 14:00:00'),
    (96, 5.27, '2026-10-06 17:00:00');

-- Mercado Vale Verde | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (97, 4.27, '2026-10-04 08:00:00'),
    (97, 3.77, '2026-10-04 11:00:00'),
    (97, 3.70, '2026-10-04 14:00:00'),
    (97, 5.02, '2026-10-04 17:00:00'),
    (97, 5.92, '2026-10-04 20:00:00'),
    (97, 5.11, '2026-10-04 23:00:00'),
    (97, 6.47, '2026-10-05 02:00:00'),
    (97, 6.71, '2026-10-05 05:00:00'),
    (97, 4.44, '2026-10-05 08:00:00'),
    (97, 6.10, '2026-10-05 11:00:00'),
    (97, 5.73, '2026-10-05 14:00:00'),
    (97, 6.76, '2026-10-05 17:00:00'),
    (97, 6.59, '2026-10-05 20:00:00'),
    (97, 4.54, '2026-10-05 23:00:00'),
    (97, 3.24, '2026-10-06 02:00:00'),
    (97, 3.57, '2026-10-06 05:00:00'),
    (97, 6.59, '2026-10-06 08:00:00'),
    (97, 3.69, '2026-10-06 11:00:00'),
    (97, 5.34, '2026-10-06 14:00:00'),
    (97, 4.13, '2026-10-06 17:00:00');

-- Mercado Vale Verde | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (98, -20.08, '2026-10-04 08:00:00'),
    (98, -21.08, '2026-10-04 11:00:00'),
    (98, -21.11, '2026-10-04 14:00:00'),
    (98, -20.34, '2026-10-04 17:00:00'),
    (98, -20.65, '2026-10-04 20:00:00'),
    (98, -21.06, '2026-10-04 23:00:00'),
    (98, -19.56, '2026-10-05 02:00:00'),
    (98, -20.34, '2026-10-05 05:00:00'),
    (98, -20.83, '2026-10-05 08:00:00'),
    (98, -20.71, '2026-10-05 11:00:00'),
    (98, -18.96, '2026-10-05 14:00:00'),
    (98, -20.97, '2026-10-05 17:00:00'),
    (98, -20.39, '2026-10-05 20:00:00'),
    (98, -20.77, '2026-10-05 23:00:00'),
    (98, -18.83, '2026-10-06 02:00:00'),
    (98, -20.64, '2026-10-06 05:00:00'),
    (98, -19.98, '2026-10-06 08:00:00'),
    (98, -19.81, '2026-10-06 11:00:00'),
    (98, -19.03, '2026-10-06 14:00:00'),
    (98, -16.34, '2026-10-06 17:00:00');

-- Mercado Mar Azul S.A. | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (99, 7.54, '2026-10-04 08:00:00'),
    (99, 3.41, '2026-10-04 11:00:00'),
    (99, 6.97, '2026-10-04 14:00:00'),
    (99, -1.00, '2026-10-04 17:00:00'),
    (99, 2.10, '2026-10-04 20:00:00'),
    (99, 2.13, '2026-10-04 23:00:00'),
    (99, 0.81, '2026-10-05 02:00:00'),
    (99, 2.41, '2026-10-05 05:00:00'),
    (99, 2.84, '2026-10-05 08:00:00'),
    (99, 1.44, '2026-10-05 11:00:00'),
    (99, 4.47, '2026-10-05 14:00:00'),
    (99, 1.77, '2026-10-05 17:00:00'),
    (99, 6.51, '2026-10-05 20:00:00'),
    (99, 2.04, '2026-10-05 23:00:00'),
    (99, 3.84, '2026-10-06 02:00:00'),
    (99, 7.91, '2026-10-06 05:00:00'),
    (99, 6.63, '2026-10-06 08:00:00'),
    (99, 1.52, '2026-10-06 11:00:00'),
    (99, -2.50, '2026-10-06 14:00:00'),
    (99, -1.25, '2026-10-06 17:00:00');

-- Mercado Mar Azul S.A. | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (100, 4.30, '2026-10-04 08:00:00'),
    (100, -0.63, '2026-10-04 11:00:00'),
    (100, 4.31, '2026-10-04 14:00:00'),
    (100, 2.75, '2026-10-04 17:00:00'),
    (100, 4.01, '2026-10-04 20:00:00'),
    (100, 5.17, '2026-10-04 23:00:00'),
    (100, 6.34, '2026-10-05 02:00:00'),
    (100, 6.88, '2026-10-05 05:00:00'),
    (100, 6.37, '2026-10-05 08:00:00'),
    (100, 5.19, '2026-10-05 11:00:00'),
    (100, 3.53, '2026-10-05 14:00:00'),
    (100, 2.63, '2026-10-05 17:00:00'),
    (100, 7.26, '2026-10-05 20:00:00'),
    (100, 9.42, '2026-10-05 23:00:00'),
    (100, 5.66, '2026-10-06 02:00:00'),
    (100, 10.83, '2026-10-06 05:00:00'),
    (100, 9.38, '2026-10-06 08:00:00'),
    (100, 4.88, '2026-10-06 11:00:00'),
    (100, 8.50, '2026-10-06 14:00:00'),
    (100, 4.76, '2026-10-06 17:00:00');

-- Laticínios Mar Azul | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (101, 5.35, '2026-10-04 08:00:00'),
    (101, 3.97, '2026-10-04 11:00:00'),
    (101, 4.32, '2026-10-04 14:00:00'),
    (101, 5.39, '2026-10-04 17:00:00'),
    (101, 5.81, '2026-10-04 20:00:00'),
    (101, 4.19, '2026-10-04 23:00:00'),
    (101, 4.70, '2026-10-05 02:00:00'),
    (101, 4.68, '2026-10-05 05:00:00'),
    (101, 5.56, '2026-10-05 08:00:00'),
    (101, 4.24, '2026-10-05 11:00:00'),
    (101, 5.64, '2026-10-05 14:00:00'),
    (101, 4.18, '2026-10-05 17:00:00'),
    (101, 5.74, '2026-10-05 20:00:00'),
    (101, 4.49, '2026-10-05 23:00:00'),
    (101, 4.03, '2026-10-06 02:00:00'),
    (101, 4.90, '2026-10-06 05:00:00'),
    (101, 4.45, '2026-10-06 08:00:00'),
    (101, 4.02, '2026-10-06 11:00:00'),
    (101, 4.05, '2026-10-06 14:00:00'),
    (101, 4.75, '2026-10-06 17:00:00');

-- Laticínios Mar Azul | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (102, 4.95, '2026-10-04 08:00:00'),
    (102, 4.07, '2026-10-04 11:00:00'),
    (102, 5.37, '2026-10-04 14:00:00'),
    (102, 5.11, '2026-10-04 17:00:00'),
    (102, 4.29, '2026-10-04 20:00:00'),
    (102, 5.39, '2026-10-04 23:00:00'),
    (102, 5.95, '2026-10-05 02:00:00'),
    (102, 4.57, '2026-10-05 05:00:00'),
    (102, 5.67, '2026-10-05 08:00:00'),
    (102, 5.70, '2026-10-05 11:00:00'),
    (102, 4.75, '2026-10-05 14:00:00'),
    (102, 5.22, '2026-10-05 17:00:00'),
    (102, 5.08, '2026-10-05 20:00:00'),
    (102, 5.75, '2026-10-05 23:00:00'),
    (102, 5.04, '2026-10-06 02:00:00'),
    (102, 4.87, '2026-10-06 05:00:00'),
    (102, 5.19, '2026-10-06 08:00:00'),
    (102, 4.54, '2026-10-06 11:00:00'),
    (102, 4.03, '2026-10-06 14:00:00'),
    (102, 4.39, '2026-10-06 17:00:00');

-- Açougue Boa Vista S.A. | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (103, 3.60, '2026-10-04 08:00:00'),
    (103, 10.88, '2026-10-04 11:00:00'),
    (103, 5.95, '2026-10-04 14:00:00'),
    (103, 2.98, '2026-10-04 17:00:00'),
    (103, 6.48, '2026-10-04 20:00:00'),
    (103, 4.62, '2026-10-04 23:00:00'),
    (103, 4.62, '2026-10-05 02:00:00'),
    (103, 5.67, '2026-10-05 05:00:00'),
    (103, 3.54, '2026-10-05 08:00:00'),
    (103, 3.40, '2026-10-05 11:00:00'),
    (103, 5.38, '2026-10-05 14:00:00'),
    (103, 8.60, '2026-10-05 17:00:00'),
    (103, 2.97, '2026-10-05 20:00:00'),
    (103, 7.19, '2026-10-05 23:00:00'),
    (103, 6.66, '2026-10-06 02:00:00'),
    (103, 10.58, '2026-10-06 05:00:00'),
    (103, 4.50, '2026-10-06 08:00:00'),
    (103, 4.39, '2026-10-06 11:00:00'),
    (103, 6.65, '2026-10-06 14:00:00'),
    (103, 6.62, '2026-10-06 17:00:00');

-- Açougue Boa Vista S.A. | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (104, 3.90, '2026-10-04 08:00:00'),
    (104, 3.87, '2026-10-04 11:00:00'),
    (104, 1.34, '2026-10-04 14:00:00'),
    (104, 1.26, '2026-10-04 17:00:00'),
    (104, 2.60, '2026-10-04 20:00:00'),
    (104, 2.55, '2026-10-04 23:00:00'),
    (104, 3.09, '2026-10-05 02:00:00'),
    (104, 3.99, '2026-10-05 05:00:00'),
    (104, 0.65, '2026-10-05 08:00:00'),
    (104, 1.54, '2026-10-05 11:00:00'),
    (104, 6.52, '2026-10-05 14:00:00'),
    (104, 3.26, '2026-10-05 17:00:00'),
    (104, 1.75, '2026-10-05 20:00:00'),
    (104, 2.91, '2026-10-05 23:00:00'),
    (104, 2.74, '2026-10-06 02:00:00'),
    (104, 2.37, '2026-10-06 05:00:00'),
    (104, 1.82, '2026-10-06 08:00:00'),
    (104, -0.58, '2026-10-06 11:00:00'),
    (104, 3.89, '2026-10-06 14:00:00'),
    (104, 3.46, '2026-10-06 17:00:00');

-- Empório Vale Verde & Cia | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (105, 5.56, '2026-10-04 08:00:00'),
    (105, 4.70, '2026-10-04 11:00:00'),
    (105, 5.13, '2026-10-04 14:00:00'),
    (105, 4.11, '2026-10-04 17:00:00'),
    (105, 5.42, '2026-10-04 20:00:00'),
    (105, 4.05, '2026-10-04 23:00:00'),
    (105, 4.35, '2026-10-05 02:00:00'),
    (105, 3.95, '2026-10-05 05:00:00'),
    (105, 4.75, '2026-10-05 08:00:00'),
    (105, 4.55, '2026-10-05 11:00:00'),
    (105, 5.17, '2026-10-05 14:00:00'),
    (105, 4.55, '2026-10-05 17:00:00'),
    (105, 4.47, '2026-10-05 20:00:00'),
    (105, 4.64, '2026-10-05 23:00:00'),
    (105, 5.77, '2026-10-06 02:00:00'),
    (105, 4.87, '2026-10-06 05:00:00'),
    (105, 5.60, '2026-10-06 08:00:00'),
    (105, 5.22, '2026-10-06 11:00:00'),
    (105, 4.43, '2026-10-06 14:00:00'),
    (105, 5.24, '2026-10-06 17:00:00');

-- Empório Vale Verde & Cia | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (106, 4.40, '2026-10-04 08:00:00'),
    (106, 3.98, '2026-10-04 11:00:00'),
    (106, 4.25, '2026-10-04 14:00:00'),
    (106, 5.88, '2026-10-04 17:00:00'),
    (106, 5.04, '2026-10-04 20:00:00'),
    (106, 4.30, '2026-10-04 23:00:00'),
    (106, 4.79, '2026-10-05 02:00:00'),
    (106, 5.09, '2026-10-05 05:00:00'),
    (106, 5.84, '2026-10-05 08:00:00'),
    (106, 5.52, '2026-10-05 11:00:00'),
    (106, 5.32, '2026-10-05 14:00:00'),
    (106, 4.95, '2026-10-05 17:00:00'),
    (106, 4.94, '2026-10-05 20:00:00'),
    (106, 6.01, '2026-10-05 23:00:00'),
    (106, 5.42, '2026-10-06 02:00:00'),
    (106, 4.87, '2026-10-06 05:00:00'),
    (106, 5.33, '2026-10-06 08:00:00'),
    (106, 5.08, '2026-10-06 11:00:00'),
    (106, 5.04, '2026-10-06 14:00:00'),
    (106, 4.61, '2026-10-06 17:00:00');

-- Laticínios Estrela do Sul & Cia | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (107, -20.82, '2026-10-04 08:00:00'),
    (107, -20.33, '2026-10-04 11:00:00'),
    (107, -21.62, '2026-10-04 14:00:00'),
    (107, -20.53, '2026-10-04 17:00:00'),
    (107, -22.86, '2026-10-04 20:00:00'),
    (107, -23.22, '2026-10-04 23:00:00'),
    (107, -22.68, '2026-10-05 02:00:00'),
    (107, -22.63, '2026-10-05 05:00:00'),
    (107, -21.75, '2026-10-05 08:00:00'),
    (107, -20.63, '2026-10-05 11:00:00'),
    (107, -22.10, '2026-10-05 14:00:00'),
    (107, -23.34, '2026-10-05 17:00:00'),
    (107, -19.73, '2026-10-05 20:00:00'),
    (107, -20.95, '2026-10-05 23:00:00'),
    (107, -22.76, '2026-10-06 02:00:00'),
    (107, -22.91, '2026-10-06 05:00:00'),
    (107, -21.67, '2026-10-06 08:00:00'),
    (107, -19.77, '2026-10-06 11:00:00'),
    (107, -21.72, '2026-10-06 14:00:00'),
    (107, -19.93, '2026-10-06 17:00:00');

-- Laticínios Estrela do Sul & Cia | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (108, 2.78, '2026-10-04 08:00:00'),
    (108, 3.65, '2026-10-04 11:00:00'),
    (108, 2.89, '2026-10-04 14:00:00'),
    (108, 3.73, '2026-10-04 17:00:00'),
    (108, 3.76, '2026-10-04 20:00:00'),
    (108, 2.67, '2026-10-04 23:00:00'),
    (108, 3.15, '2026-10-05 02:00:00'),
    (108, 2.97, '2026-10-05 05:00:00'),
    (108, 2.95, '2026-10-05 08:00:00'),
    (108, 3.40, '2026-10-05 11:00:00'),
    (108, 1.00, '2026-10-05 14:00:00'),
    (108, 1.25, '2026-10-05 17:00:00'),
    (108, 3.53, '2026-10-05 20:00:00'),
    (108, 1.72, '2026-10-05 23:00:00'),
    (108, 1.44, '2026-10-06 02:00:00'),
    (108, 5.68, '2026-10-06 05:00:00'),
    (108, 1.96, '2026-10-06 08:00:00'),
    (108, 3.01, '2026-10-06 11:00:00'),
    (108, 2.55, '2026-10-06 14:00:00'),
    (108, 3.37, '2026-10-06 17:00:00');

-- Açougue Mar Azul & Cia | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (109, -20.22, '2026-10-04 08:00:00'),
    (109, -20.93, '2026-10-04 11:00:00'),
    (109, -19.23, '2026-10-04 14:00:00'),
    (109, -18.86, '2026-10-04 17:00:00'),
    (109, -20.52, '2026-10-04 20:00:00'),
    (109, -20.39, '2026-10-04 23:00:00'),
    (109, -21.06, '2026-10-05 02:00:00'),
    (109, -20.58, '2026-10-05 05:00:00'),
    (109, -19.71, '2026-10-05 08:00:00'),
    (109, -19.09, '2026-10-05 11:00:00'),
    (109, -20.20, '2026-10-05 14:00:00'),
    (109, -19.47, '2026-10-05 17:00:00'),
    (109, -20.55, '2026-10-05 20:00:00'),
    (109, -19.54, '2026-10-05 23:00:00'),
    (109, -19.22, '2026-10-06 02:00:00'),
    (109, -19.71, '2026-10-06 05:00:00'),
    (109, -19.43, '2026-10-06 08:00:00'),
    (109, -21.19, '2026-10-06 11:00:00'),
    (109, -19.66, '2026-10-06 14:00:00'),
    (109, -19.59, '2026-10-06 17:00:00');

-- Açougue Mar Azul & Cia | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (110, -21.96, '2026-10-04 08:00:00'),
    (110, -22.54, '2026-10-04 11:00:00'),
    (110, -22.10, '2026-10-04 14:00:00'),
    (110, -22.00, '2026-10-04 17:00:00'),
    (110, -19.49, '2026-10-04 20:00:00'),
    (110, -21.21, '2026-10-04 23:00:00'),
    (110, -19.71, '2026-10-05 02:00:00'),
    (110, -21.10, '2026-10-05 05:00:00'),
    (110, -20.05, '2026-10-05 08:00:00'),
    (110, -21.18, '2026-10-05 11:00:00'),
    (110, -20.88, '2026-10-05 14:00:00'),
    (110, -22.77, '2026-10-05 17:00:00'),
    (110, -21.01, '2026-10-05 20:00:00'),
    (110, -22.43, '2026-10-05 23:00:00'),
    (110, -20.12, '2026-10-06 02:00:00'),
    (110, -22.16, '2026-10-06 05:00:00'),
    (110, -23.43, '2026-10-06 08:00:00'),
    (110, -22.42, '2026-10-06 11:00:00'),
    (110, -19.94, '2026-10-06 14:00:00'),
    (110, -20.19, '2026-10-06 17:00:00');

-- Supermercado Campo Belo & Cia | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (111, -22.68, '2026-10-04 08:00:00'),
    (111, -15.32, '2026-10-04 11:00:00'),
    (111, -23.98, '2026-10-04 14:00:00'),
    (111, -20.77, '2026-10-04 17:00:00'),
    (111, -21.15, '2026-10-04 20:00:00'),
    (111, -25.57, '2026-10-04 23:00:00'),
    (111, -21.60, '2026-10-05 02:00:00'),
    (111, -15.82, '2026-10-05 05:00:00'),
    (111, -27.80, '2026-10-05 08:00:00'),
    (111, -23.96, '2026-10-05 11:00:00'),
    (111, -25.62, '2026-10-05 14:00:00'),
    (111, -23.95, '2026-10-05 17:00:00'),
    (111, -21.15, '2026-10-05 20:00:00'),
    (111, -23.55, '2026-10-05 23:00:00'),
    (111, -20.05, '2026-10-06 02:00:00'),
    (111, -18.98, '2026-10-06 05:00:00'),
    (111, -16.90, '2026-10-06 08:00:00'),
    (111, -23.71, '2026-10-06 11:00:00'),
    (111, -22.69, '2026-10-06 14:00:00'),
    (111, -17.43, '2026-10-06 17:00:00');

-- Supermercado Campo Belo & Cia | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (112, 3.66, '2026-10-04 08:00:00'),
    (112, 9.18, '2026-10-04 11:00:00'),
    (112, 6.97, '2026-10-04 14:00:00'),
    (112, 8.62, '2026-10-04 17:00:00'),
    (112, 6.41, '2026-10-04 20:00:00'),
    (112, 5.33, '2026-10-04 23:00:00'),
    (112, 8.74, '2026-10-05 02:00:00'),
    (112, 5.94, '2026-10-05 05:00:00'),
    (112, 7.06, '2026-10-05 08:00:00'),
    (112, 5.77, '2026-10-05 11:00:00'),
    (112, -0.32, '2026-10-05 14:00:00'),
    (112, 9.92, '2026-10-05 17:00:00'),
    (112, 9.17, '2026-10-05 20:00:00'),
    (112, 5.93, '2026-10-05 23:00:00'),
    (112, 6.29, '2026-10-06 02:00:00'),
    (112, 2.93, '2026-10-06 05:00:00'),
    (112, 10.16, '2026-10-06 08:00:00'),
    (112, -0.97, '2026-10-06 11:00:00'),
    (112, 4.58, '2026-10-06 14:00:00'),
    (112, 9.16, '2026-10-06 17:00:00');

-- Padaria Mar Azul Ltda. | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (113, 2.02, '2026-10-04 08:00:00'),
    (113, 2.20, '2026-10-04 11:00:00'),
    (113, 2.83, '2026-10-04 14:00:00'),
    (113, 2.54, '2026-10-04 17:00:00'),
    (113, 2.95, '2026-10-04 20:00:00'),
    (113, 3.08, '2026-10-04 23:00:00'),
    (113, 3.17, '2026-10-05 02:00:00'),
    (113, 2.58, '2026-10-05 05:00:00'),
    (113, 2.62, '2026-10-05 08:00:00'),
    (113, 1.97, '2026-10-05 11:00:00'),
    (113, 2.31, '2026-10-05 14:00:00'),
    (113, 2.89, '2026-10-05 17:00:00'),
    (113, 2.48, '2026-10-05 20:00:00'),
    (113, 2.10, '2026-10-05 23:00:00'),
    (113, 2.81, '2026-10-06 02:00:00'),
    (113, 1.89, '2026-10-06 05:00:00'),
    (113, 2.98, '2026-10-06 08:00:00'),
    (113, 3.13, '2026-10-06 11:00:00'),
    (113, 2.91, '2026-10-06 14:00:00'),
    (113, 2.06, '2026-10-06 17:00:00');

-- Padaria Mar Azul Ltda. | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (114, -21.42, '2026-10-04 08:00:00'),
    (114, -22.39, '2026-10-04 11:00:00'),
    (114, -20.93, '2026-10-04 14:00:00'),
    (114, -20.84, '2026-10-04 17:00:00'),
    (114, -21.85, '2026-10-04 20:00:00'),
    (114, -22.08, '2026-10-04 23:00:00'),
    (114, -21.06, '2026-10-05 02:00:00'),
    (114, -20.34, '2026-10-05 05:00:00'),
    (114, -20.53, '2026-10-05 08:00:00'),
    (114, -20.52, '2026-10-05 11:00:00'),
    (114, -20.57, '2026-10-05 14:00:00'),
    (114, -22.35, '2026-10-05 17:00:00'),
    (114, -20.51, '2026-10-05 20:00:00'),
    (114, -21.39, '2026-10-05 23:00:00'),
    (114, -21.78, '2026-10-06 02:00:00'),
    (114, -21.84, '2026-10-06 05:00:00'),
    (114, -21.19, '2026-10-06 08:00:00'),
    (114, -22.71, '2026-10-06 11:00:00'),
    (114, -21.61, '2026-10-06 14:00:00'),
    (114, -21.21, '2026-10-06 17:00:00');

-- Empório Mar Azul & Cia | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (115, 6.16, '2026-10-04 08:00:00'),
    (115, 2.70, '2026-10-04 11:00:00'),
    (115, 2.72, '2026-10-04 14:00:00'),
    (115, 3.62, '2026-10-04 17:00:00'),
    (115, 2.02, '2026-10-04 20:00:00'),
    (115, 1.53, '2026-10-04 23:00:00'),
    (115, 1.51, '2026-10-05 02:00:00'),
    (115, 2.74, '2026-10-05 05:00:00'),
    (115, 1.29, '2026-10-05 08:00:00'),
    (115, 3.97, '2026-10-05 11:00:00'),
    (115, 6.72, '2026-10-05 14:00:00'),
    (115, 3.55, '2026-10-05 17:00:00'),
    (115, 3.83, '2026-10-05 20:00:00'),
    (115, 2.77, '2026-10-05 23:00:00'),
    (115, 7.27, '2026-10-06 02:00:00'),
    (115, 2.98, '2026-10-06 05:00:00'),
    (115, 2.09, '2026-10-06 08:00:00'),
    (115, 1.89, '2026-10-06 11:00:00'),
    (115, 3.22, '2026-10-06 14:00:00'),
    (115, 3.21, '2026-10-06 17:00:00');

-- Empório Mar Azul & Cia | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (116, 3.97, '2026-10-04 08:00:00'),
    (116, 5.96, '2026-10-04 11:00:00'),
    (116, 5.71, '2026-10-04 14:00:00'),
    (116, 3.67, '2026-10-04 17:00:00'),
    (116, 4.28, '2026-10-04 20:00:00'),
    (116, 5.71, '2026-10-04 23:00:00'),
    (116, 4.41, '2026-10-05 02:00:00'),
    (116, 4.48, '2026-10-05 05:00:00'),
    (116, 4.69, '2026-10-05 08:00:00'),
    (116, 6.14, '2026-10-05 11:00:00'),
    (116, 4.49, '2026-10-05 14:00:00'),
    (116, 4.45, '2026-10-05 17:00:00'),
    (116, 6.22, '2026-10-05 20:00:00'),
    (116, 4.02, '2026-10-05 23:00:00'),
    (116, 3.72, '2026-10-06 02:00:00'),
    (116, 4.96, '2026-10-06 05:00:00'),
    (116, 3.28, '2026-10-06 08:00:00'),
    (116, 5.50, '2026-10-06 11:00:00'),
    (116, 6.59, '2026-10-06 14:00:00'),
    (116, 4.21, '2026-10-06 17:00:00');

-- Hortifruti Boa Vista | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (117, -20.66, '2026-10-04 08:00:00'),
    (117, -21.75, '2026-10-04 11:00:00'),
    (117, -22.23, '2026-10-04 14:00:00'),
    (117, -21.53, '2026-10-04 17:00:00'),
    (117, -21.92, '2026-10-04 20:00:00'),
    (117, -21.63, '2026-10-04 23:00:00'),
    (117, -21.92, '2026-10-05 02:00:00'),
    (117, -21.64, '2026-10-05 05:00:00'),
    (117, -20.37, '2026-10-05 08:00:00'),
    (117, -22.41, '2026-10-05 11:00:00'),
    (117, -21.25, '2026-10-05 14:00:00'),
    (117, -21.66, '2026-10-05 17:00:00'),
    (117, -21.23, '2026-10-05 20:00:00'),
    (117, -22.17, '2026-10-05 23:00:00'),
    (117, -21.02, '2026-10-06 02:00:00'),
    (117, -20.44, '2026-10-06 05:00:00'),
    (117, -21.21, '2026-10-06 08:00:00'),
    (117, -20.46, '2026-10-06 11:00:00'),
    (117, -21.32, '2026-10-06 14:00:00'),
    (117, -20.49, '2026-10-06 17:00:00');

-- Hortifruti Boa Vista | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (118, 2.09, '2026-10-04 08:00:00'),
    (118, 2.61, '2026-10-04 11:00:00'),
    (118, 1.70, '2026-10-04 14:00:00'),
    (118, 3.21, '2026-10-04 17:00:00'),
    (118, 2.73, '2026-10-04 20:00:00'),
    (118, 1.83, '2026-10-04 23:00:00'),
    (118, 2.53, '2026-10-05 02:00:00'),
    (118, 2.71, '2026-10-05 05:00:00'),
    (118, 2.89, '2026-10-05 08:00:00'),
    (118, 2.15, '2026-10-05 11:00:00'),
    (118, 2.17, '2026-10-05 14:00:00'),
    (118, 3.25, '2026-10-05 17:00:00'),
    (118, 2.89, '2026-10-05 20:00:00'),
    (118, 2.16, '2026-10-05 23:00:00'),
    (118, 2.42, '2026-10-06 02:00:00'),
    (118, 2.87, '2026-10-06 05:00:00'),
    (118, 1.73, '2026-10-06 08:00:00'),
    (118, 3.34, '2026-10-06 11:00:00'),
    (118, 1.96, '2026-10-06 14:00:00'),
    (118, 3.18, '2026-10-06 17:00:00');

-- Mercado Pão Dourado | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (119, 5.94, '2026-10-04 08:00:00'),
    (119, 3.85, '2026-10-04 11:00:00'),
    (119, 3.67, '2026-10-04 14:00:00'),
    (119, 5.80, '2026-10-04 17:00:00'),
    (119, 5.86, '2026-10-04 20:00:00'),
    (119, 6.18, '2026-10-04 23:00:00'),
    (119, 4.93, '2026-10-05 02:00:00'),
    (119, 3.78, '2026-10-05 05:00:00'),
    (119, 3.79, '2026-10-05 08:00:00'),
    (119, 6.34, '2026-10-05 11:00:00'),
    (119, 6.13, '2026-10-05 14:00:00'),
    (119, 4.04, '2026-10-05 17:00:00'),
    (119, 6.19, '2026-10-05 20:00:00'),
    (119, 3.70, '2026-10-05 23:00:00'),
    (119, 3.87, '2026-10-06 02:00:00'),
    (119, 4.63, '2026-10-06 05:00:00'),
    (119, 5.83, '2026-10-06 08:00:00'),
    (119, 5.51, '2026-10-06 11:00:00'),
    (119, 6.43, '2026-10-06 14:00:00'),
    (119, 5.72, '2026-10-06 17:00:00');

-- Mercado Pão Dourado | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (120, 3.58, '2026-10-04 08:00:00'),
    (120, 2.12, '2026-10-04 11:00:00'),
    (120, 1.44, '2026-10-04 14:00:00'),
    (120, 2.58, '2026-10-04 17:00:00'),
    (120, 1.16, '2026-10-04 20:00:00'),
    (120, 6.55, '2026-10-04 23:00:00'),
    (120, 1.45, '2026-10-05 02:00:00'),
    (120, 1.71, '2026-10-05 05:00:00'),
    (120, 1.49, '2026-10-05 08:00:00'),
    (120, 1.29, '2026-10-05 11:00:00'),
    (120, 1.57, '2026-10-05 14:00:00'),
    (120, 2.74, '2026-10-05 17:00:00'),
    (120, 1.29, '2026-10-05 20:00:00'),
    (120, 3.71, '2026-10-05 23:00:00'),
    (120, 1.23, '2026-10-06 02:00:00'),
    (120, 1.24, '2026-10-06 05:00:00'),
    (120, 1.92, '2026-10-06 08:00:00'),
    (120, 3.75, '2026-10-06 11:00:00'),
    (120, 1.30, '2026-10-06 14:00:00'),
    (120, 1.30, '2026-10-06 17:00:00');

-- Açougue Sabor Real Ltda. | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (121, 10.34, '2026-10-04 08:00:00'),
    (121, 6.66, '2026-10-04 11:00:00'),
    (121, 10.12, '2026-10-04 14:00:00'),
    (121, 7.35, '2026-10-04 17:00:00'),
    (121, 5.18, '2026-10-04 20:00:00'),
    (121, 2.73, '2026-10-04 23:00:00'),
    (121, 5.17, '2026-10-05 02:00:00'),
    (121, 3.82, '2026-10-05 05:00:00'),
    (121, 5.44, '2026-10-05 08:00:00'),
    (121, 8.83, '2026-10-05 11:00:00'),
    (121, 6.49, '2026-10-05 14:00:00'),
    (121, 5.26, '2026-10-05 17:00:00'),
    (121, 3.03, '2026-10-05 20:00:00'),
    (121, 7.08, '2026-10-05 23:00:00'),
    (121, 6.39, '2026-10-06 02:00:00'),
    (121, 6.61, '2026-10-06 05:00:00'),
    (121, 1.45, '2026-10-06 08:00:00'),
    (121, 4.70, '2026-10-06 11:00:00'),
    (121, 8.75, '2026-10-06 14:00:00'),
    (121, 4.58, '2026-10-06 17:00:00');

-- Açougue Sabor Real Ltda. | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (122, -25.74, '2026-10-04 08:00:00'),
    (122, -18.85, '2026-10-04 11:00:00'),
    (122, -19.04, '2026-10-04 14:00:00'),
    (122, -19.04, '2026-10-04 17:00:00'),
    (122, -23.31, '2026-10-04 20:00:00'),
    (122, -22.34, '2026-10-04 23:00:00'),
    (122, -22.46, '2026-10-05 02:00:00'),
    (122, -18.79, '2026-10-05 05:00:00'),
    (122, -23.46, '2026-10-05 08:00:00'),
    (122, -18.78, '2026-10-05 11:00:00'),
    (122, -19.72, '2026-10-05 14:00:00'),
    (122, -23.85, '2026-10-05 17:00:00'),
    (122, -22.26, '2026-10-05 20:00:00'),
    (122, -16.50, '2026-10-05 23:00:00'),
    (122, -15.40, '2026-10-06 02:00:00'),
    (122, -21.34, '2026-10-06 05:00:00'),
    (122, -19.97, '2026-10-06 08:00:00'),
    (122, -16.83, '2026-10-06 11:00:00'),
    (122, -19.36, '2026-10-06 14:00:00'),
    (122, -25.69, '2026-10-06 17:00:00');

-- Hortifruti Vale Verde S.A. | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (123, 2.24, '2026-10-04 08:00:00'),
    (123, 2.33, '2026-10-04 11:00:00'),
    (123, 1.73, '2026-10-04 14:00:00'),
    (123, 1.70, '2026-10-04 17:00:00'),
    (123, 2.36, '2026-10-04 20:00:00'),
    (123, 2.62, '2026-10-04 23:00:00'),
    (123, 1.98, '2026-10-05 02:00:00'),
    (123, 1.66, '2026-10-05 05:00:00'),
    (123, 2.36, '2026-10-05 08:00:00'),
    (123, 2.91, '2026-10-05 11:00:00'),
    (123, 2.72, '2026-10-05 14:00:00'),
    (123, 2.96, '2026-10-05 17:00:00'),
    (123, 2.49, '2026-10-05 20:00:00'),
    (123, 1.88, '2026-10-05 23:00:00'),
    (123, 2.00, '2026-10-06 02:00:00'),
    (123, 2.18, '2026-10-06 05:00:00'),
    (123, 2.91, '2026-10-06 08:00:00'),
    (123, 3.14, '2026-10-06 11:00:00'),
    (123, 1.90, '2026-10-06 14:00:00'),
    (123, 3.28, '2026-10-06 17:00:00');

-- Hortifruti Vale Verde S.A. | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (124, -21.77, '2026-10-04 08:00:00'),
    (124, -20.45, '2026-10-04 11:00:00'),
    (124, -21.13, '2026-10-04 14:00:00'),
    (124, -21.03, '2026-10-04 17:00:00'),
    (124, -20.86, '2026-10-04 20:00:00'),
    (124, -20.70, '2026-10-04 23:00:00'),
    (124, -22.37, '2026-10-05 02:00:00'),
    (124, -20.86, '2026-10-05 05:00:00'),
    (124, -21.50, '2026-10-05 08:00:00'),
    (124, -20.46, '2026-10-05 11:00:00'),
    (124, -22.20, '2026-10-05 14:00:00'),
    (124, -20.80, '2026-10-05 17:00:00'),
    (124, -20.94, '2026-10-05 20:00:00'),
    (124, -21.64, '2026-10-05 23:00:00'),
    (124, -20.92, '2026-10-06 02:00:00'),
    (124, -21.68, '2026-10-06 05:00:00'),
    (124, -21.19, '2026-10-06 08:00:00'),
    (124, -21.15, '2026-10-06 11:00:00'),
    (124, -21.35, '2026-10-06 14:00:00'),
    (124, -20.68, '2026-10-06 17:00:00');

-- Padaria Vale Verde & Cia | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (125, 5.57, '2026-10-04 08:00:00'),
    (125, 0.48, '2026-10-04 11:00:00'),
    (125, 10.56, '2026-10-04 14:00:00'),
    (125, 7.14, '2026-10-04 17:00:00'),
    (125, 6.59, '2026-10-04 20:00:00'),
    (125, 6.91, '2026-10-04 23:00:00'),
    (125, 6.99, '2026-10-05 02:00:00'),
    (125, 8.94, '2026-10-05 05:00:00'),
    (125, 10.76, '2026-10-05 08:00:00'),
    (125, 1.32, '2026-10-05 11:00:00'),
    (125, 6.76, '2026-10-05 14:00:00'),
    (125, 5.83, '2026-10-05 17:00:00'),
    (125, 0.42, '2026-10-05 20:00:00'),
    (125, 3.90, '2026-10-05 23:00:00'),
    (125, 7.22, '2026-10-06 02:00:00'),
    (125, 8.48, '2026-10-06 05:00:00'),
    (125, -0.04, '2026-10-06 08:00:00'),
    (125, 4.51, '2026-10-06 11:00:00'),
    (125, 1.15, '2026-10-06 14:00:00'),
    (125, 8.67, '2026-10-06 17:00:00');

-- Padaria Vale Verde & Cia | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (126, -22.94, '2026-10-04 08:00:00'),
    (126, -22.99, '2026-10-04 11:00:00'),
    (126, -21.98, '2026-10-04 14:00:00'),
    (126, -23.38, '2026-10-04 17:00:00'),
    (126, -19.94, '2026-10-04 20:00:00'),
    (126, -21.78, '2026-10-04 23:00:00'),
    (126, -21.67, '2026-10-05 02:00:00'),
    (126, -20.82, '2026-10-05 05:00:00'),
    (126, -21.71, '2026-10-05 08:00:00'),
    (126, -16.20, '2026-10-05 11:00:00'),
    (126, -21.90, '2026-10-05 14:00:00'),
    (126, -16.21, '2026-10-05 17:00:00'),
    (126, -18.80, '2026-10-05 20:00:00'),
    (126, -20.12, '2026-10-05 23:00:00'),
    (126, -23.53, '2026-10-06 02:00:00'),
    (126, -19.39, '2026-10-06 05:00:00'),
    (126, -26.56, '2026-10-06 08:00:00'),
    (126, -15.14, '2026-10-06 11:00:00'),
    (126, -21.18, '2026-10-06 14:00:00'),
    (126, -24.08, '2026-10-06 17:00:00');

-- Supermercado Vale Verde Ltda. | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (127, 5.15, '2026-10-04 08:00:00'),
    (127, 4.07, '2026-10-04 11:00:00'),
    (127, 9.04, '2026-10-04 14:00:00'),
    (127, 10.26, '2026-10-04 17:00:00'),
    (127, 3.94, '2026-10-04 20:00:00'),
    (127, 6.48, '2026-10-04 23:00:00'),
    (127, 2.80, '2026-10-05 02:00:00'),
    (127, 9.53, '2026-10-05 05:00:00'),
    (127, 6.28, '2026-10-05 08:00:00'),
    (127, 4.10, '2026-10-05 11:00:00'),
    (127, 6.74, '2026-10-05 14:00:00'),
    (127, 6.74, '2026-10-05 17:00:00'),
    (127, 4.93, '2026-10-05 20:00:00'),
    (127, 3.50, '2026-10-05 23:00:00'),
    (127, 3.73, '2026-10-06 02:00:00'),
    (127, 5.57, '2026-10-06 05:00:00'),
    (127, 4.40, '2026-10-06 08:00:00'),
    (127, 1.55, '2026-10-06 11:00:00'),
    (127, 2.68, '2026-10-06 14:00:00'),
    (127, 7.02, '2026-10-06 17:00:00');

-- Supermercado Vale Verde Ltda. | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (128, 3.48, '2026-10-04 08:00:00'),
    (128, 1.88, '2026-10-04 11:00:00'),
    (128, 3.32, '2026-10-04 14:00:00'),
    (128, 7.94, '2026-10-04 17:00:00'),
    (128, -1.48, '2026-10-04 20:00:00'),
    (128, 1.87, '2026-10-04 23:00:00'),
    (128, 6.60, '2026-10-05 02:00:00'),
    (128, 1.52, '2026-10-05 05:00:00'),
    (128, 0.89, '2026-10-05 08:00:00'),
    (128, 7.54, '2026-10-05 11:00:00'),
    (128, 1.08, '2026-10-05 14:00:00'),
    (128, 2.83, '2026-10-05 17:00:00'),
    (128, -1.14, '2026-10-05 20:00:00'),
    (128, -0.89, '2026-10-05 23:00:00'),
    (128, 6.66, '2026-10-06 02:00:00'),
    (128, 1.22, '2026-10-06 05:00:00'),
    (128, 6.04, '2026-10-06 08:00:00'),
    (128, -2.31, '2026-10-06 11:00:00'),
    (128, 7.83, '2026-10-06 14:00:00'),
    (128, 2.03, '2026-10-06 17:00:00');

-- Supermercado Pão Dourado Ltda. | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (129, 2.08, '2026-10-04 08:00:00'),
    (129, 1.67, '2026-10-04 11:00:00'),
    (129, 2.82, '2026-10-04 14:00:00'),
    (129, 2.16, '2026-10-04 17:00:00'),
    (129, 2.72, '2026-10-04 20:00:00'),
    (129, 1.96, '2026-10-04 23:00:00'),
    (129, 3.25, '2026-10-05 02:00:00'),
    (129, 2.29, '2026-10-05 05:00:00'),
    (129, 2.89, '2026-10-05 08:00:00'),
    (129, 2.87, '2026-10-05 11:00:00'),
    (129, 1.96, '2026-10-05 14:00:00'),
    (129, 2.78, '2026-10-05 17:00:00'),
    (129, 3.17, '2026-10-05 20:00:00'),
    (129, 1.86, '2026-10-05 23:00:00'),
    (129, 1.82, '2026-10-06 02:00:00'),
    (129, 1.90, '2026-10-06 05:00:00'),
    (129, 3.26, '2026-10-06 08:00:00'),
    (129, 2.97, '2026-10-06 11:00:00'),
    (129, 3.10, '2026-10-06 14:00:00'),
    (129, 2.05, '2026-10-06 17:00:00');

-- Supermercado Pão Dourado Ltda. | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (130, -20.69, '2026-10-04 08:00:00'),
    (130, -19.89, '2026-10-04 11:00:00'),
    (130, -20.20, '2026-10-04 14:00:00'),
    (130, -20.53, '2026-10-04 17:00:00'),
    (130, -19.52, '2026-10-04 20:00:00'),
    (130, -19.70, '2026-10-04 23:00:00'),
    (130, -20.23, '2026-10-05 02:00:00'),
    (130, -19.67, '2026-10-05 05:00:00'),
    (130, -20.51, '2026-10-05 08:00:00'),
    (130, -20.27, '2026-10-05 11:00:00'),
    (130, -19.58, '2026-10-05 14:00:00'),
    (130, -20.45, '2026-10-05 17:00:00'),
    (130, -20.12, '2026-10-05 20:00:00'),
    (130, -20.67, '2026-10-05 23:00:00'),
    (130, -19.93, '2026-10-06 02:00:00'),
    (130, -20.26, '2026-10-06 05:00:00'),
    (130, -19.57, '2026-10-06 08:00:00'),
    (130, -19.51, '2026-10-06 11:00:00'),
    (130, -20.56, '2026-10-06 14:00:00'),
    (130, -19.74, '2026-10-06 17:00:00');

-- Empório Estrela do Sul ME | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (131, -21.01, '2026-10-04 08:00:00'),
    (131, -19.58, '2026-10-04 11:00:00'),
    (131, -19.93, '2026-10-04 14:00:00'),
    (131, -20.02, '2026-10-04 17:00:00'),
    (131, -20.94, '2026-10-04 20:00:00'),
    (131, -19.23, '2026-10-04 23:00:00'),
    (131, -19.54, '2026-10-05 02:00:00'),
    (131, -19.59, '2026-10-05 05:00:00'),
    (131, -20.32, '2026-10-05 08:00:00'),
    (131, -19.79, '2026-10-05 11:00:00'),
    (131, -19.94, '2026-10-05 14:00:00'),
    (131, -20.50, '2026-10-05 17:00:00'),
    (131, -19.49, '2026-10-05 20:00:00'),
    (131, -19.16, '2026-10-05 23:00:00'),
    (131, -20.44, '2026-10-06 02:00:00'),
    (131, -20.65, '2026-10-06 05:00:00'),
    (131, -20.64, '2026-10-06 08:00:00'),
    (131, -19.96, '2026-10-06 11:00:00'),
    (131, -19.57, '2026-10-06 14:00:00'),
    (131, -20.62, '2026-10-06 17:00:00');

-- Empório Estrela do Sul ME | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (132, -21.03, '2026-10-04 08:00:00'),
    (132, -21.56, '2026-10-04 11:00:00'),
    (132, -23.08, '2026-10-04 14:00:00'),
    (132, -23.19, '2026-10-04 17:00:00'),
    (132, -22.33, '2026-10-04 20:00:00'),
    (132, -22.84, '2026-10-04 23:00:00'),
    (132, -20.63, '2026-10-05 02:00:00'),
    (132, -22.99, '2026-10-05 05:00:00'),
    (132, -16.55, '2026-10-05 08:00:00'),
    (132, -22.05, '2026-10-05 11:00:00'),
    (132, -21.74, '2026-10-05 14:00:00'),
    (132, -19.58, '2026-10-05 17:00:00'),
    (132, -20.15, '2026-10-05 20:00:00'),
    (132, -22.90, '2026-10-05 23:00:00'),
    (132, -20.60, '2026-10-06 02:00:00'),
    (132, -20.03, '2026-10-06 05:00:00'),
    (132, -20.18, '2026-10-06 08:00:00'),
    (132, -22.71, '2026-10-06 11:00:00'),
    (132, -20.29, '2026-10-06 14:00:00'),
    (132, -20.90, '2026-10-06 17:00:00');

-- Hortifruti Terra Fértil Ltda. | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (133, -21.05, '2026-10-04 08:00:00'),
    (133, -22.35, '2026-10-04 11:00:00'),
    (133, -20.38, '2026-10-04 14:00:00'),
    (133, -20.64, '2026-10-04 17:00:00'),
    (133, -21.56, '2026-10-04 20:00:00'),
    (133, -22.15, '2026-10-04 23:00:00'),
    (133, -20.43, '2026-10-05 02:00:00'),
    (133, -21.99, '2026-10-05 05:00:00'),
    (133, -21.69, '2026-10-05 08:00:00'),
    (133, -21.40, '2026-10-05 11:00:00'),
    (133, -21.80, '2026-10-05 14:00:00'),
    (133, -21.44, '2026-10-05 17:00:00'),
    (133, -21.79, '2026-10-05 20:00:00'),
    (133, -22.40, '2026-10-05 23:00:00'),
    (133, -20.41, '2026-10-06 02:00:00'),
    (133, -22.59, '2026-10-06 05:00:00'),
    (133, -21.71, '2026-10-06 08:00:00'),
    (133, -20.30, '2026-10-06 11:00:00'),
    (133, -20.72, '2026-10-06 14:00:00'),
    (133, -22.62, '2026-10-06 17:00:00');

-- Hortifruti Terra Fértil Ltda. | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (134, 4.51, '2026-10-04 08:00:00'),
    (134, 4.08, '2026-10-04 11:00:00'),
    (134, 4.82, '2026-10-04 14:00:00'),
    (134, 4.14, '2026-10-04 17:00:00'),
    (134, 5.54, '2026-10-04 20:00:00'),
    (134, 4.66, '2026-10-04 23:00:00'),
    (134, 4.28, '2026-10-05 02:00:00'),
    (134, 5.34, '2026-10-05 05:00:00'),
    (134, 5.78, '2026-10-05 08:00:00'),
    (134, 4.22, '2026-10-05 11:00:00'),
    (134, 5.93, '2026-10-05 14:00:00'),
    (134, 5.57, '2026-10-05 17:00:00'),
    (134, 4.51, '2026-10-05 20:00:00'),
    (134, 5.53, '2026-10-05 23:00:00'),
    (134, 4.69, '2026-10-06 02:00:00'),
    (134, 5.02, '2026-10-06 05:00:00'),
    (134, 5.63, '2026-10-06 08:00:00'),
    (134, 4.93, '2026-10-06 11:00:00'),
    (134, 5.36, '2026-10-06 14:00:00'),
    (134, 5.22, '2026-10-06 17:00:00');

-- Restaurante Campo Belo | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (135, 2.40, '2026-10-04 08:00:00'),
    (135, 2.62, '2026-10-04 11:00:00'),
    (135, 2.13, '2026-10-04 14:00:00'),
    (135, 2.51, '2026-10-04 17:00:00'),
    (135, 3.35, '2026-10-04 20:00:00'),
    (135, 2.35, '2026-10-04 23:00:00'),
    (135, 3.36, '2026-10-05 02:00:00'),
    (135, 3.00, '2026-10-05 05:00:00'),
    (135, 2.26, '2026-10-05 08:00:00'),
    (135, 2.79, '2026-10-05 11:00:00'),
    (135, 2.95, '2026-10-05 14:00:00'),
    (135, 3.16, '2026-10-05 17:00:00'),
    (135, 2.36, '2026-10-05 20:00:00'),
    (135, 1.72, '2026-10-05 23:00:00'),
    (135, 1.99, '2026-10-06 02:00:00'),
    (135, 2.42, '2026-10-06 05:00:00'),
    (135, 3.10, '2026-10-06 08:00:00'),
    (135, 2.12, '2026-10-06 11:00:00'),
    (135, 2.36, '2026-10-06 14:00:00'),
    (135, 2.75, '2026-10-06 17:00:00');

-- Restaurante Campo Belo | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (136, -20.70, '2026-10-04 08:00:00'),
    (136, -21.77, '2026-10-04 11:00:00'),
    (136, -21.36, '2026-10-04 14:00:00'),
    (136, -21.92, '2026-10-04 17:00:00'),
    (136, -20.92, '2026-10-04 20:00:00'),
    (136, -21.50, '2026-10-04 23:00:00'),
    (136, -20.51, '2026-10-05 02:00:00'),
    (136, -21.58, '2026-10-05 05:00:00'),
    (136, -21.52, '2026-10-05 08:00:00'),
    (136, -22.51, '2026-10-05 11:00:00'),
    (136, -20.97, '2026-10-05 14:00:00'),
    (136, -21.94, '2026-10-05 17:00:00'),
    (136, -20.68, '2026-10-05 20:00:00'),
    (136, -21.64, '2026-10-05 23:00:00'),
    (136, -20.29, '2026-10-06 02:00:00'),
    (136, -22.40, '2026-10-06 05:00:00'),
    (136, -20.72, '2026-10-06 08:00:00'),
    (136, -20.57, '2026-10-06 11:00:00'),
    (136, -20.39, '2026-10-06 14:00:00'),
    (136, -21.70, '2026-10-06 17:00:00');

-- Distribuidora Pão Dourado | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (137, 3.33, '2026-10-04 08:00:00'),
    (137, 2.96, '2026-10-04 11:00:00'),
    (137, 2.86, '2026-10-04 14:00:00'),
    (137, 2.52, '2026-10-04 17:00:00'),
    (137, 3.14, '2026-10-04 20:00:00'),
    (137, 2.21, '2026-10-04 23:00:00'),
    (137, 1.80, '2026-10-05 02:00:00'),
    (137, 1.95, '2026-10-05 05:00:00'),
    (137, 2.67, '2026-10-05 08:00:00'),
    (137, 2.96, '2026-10-05 11:00:00'),
    (137, 2.13, '2026-10-05 14:00:00'),
    (137, 2.34, '2026-10-05 17:00:00'),
    (137, 2.87, '2026-10-05 20:00:00'),
    (137, 2.92, '2026-10-05 23:00:00'),
    (137, 2.59, '2026-10-06 02:00:00'),
    (137, 2.46, '2026-10-06 05:00:00'),
    (137, 2.40, '2026-10-06 08:00:00'),
    (137, 1.99, '2026-10-06 11:00:00'),
    (137, 2.24, '2026-10-06 14:00:00'),
    (137, 2.50, '2026-10-06 17:00:00');

-- Distribuidora Pão Dourado | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (138, 5.67, '2026-10-04 08:00:00'),
    (138, 4.98, '2026-10-04 11:00:00'),
    (138, 5.10, '2026-10-04 14:00:00'),
    (138, 4.31, '2026-10-04 17:00:00'),
    (138, 4.51, '2026-10-04 20:00:00'),
    (138, 5.74, '2026-10-04 23:00:00'),
    (138, 4.65, '2026-10-05 02:00:00'),
    (138, 5.14, '2026-10-05 05:00:00'),
    (138, 4.78, '2026-10-05 08:00:00'),
    (138, 4.38, '2026-10-05 11:00:00'),
    (138, 5.52, '2026-10-05 14:00:00'),
    (138, 6.02, '2026-10-05 17:00:00'),
    (138, 5.09, '2026-10-05 20:00:00'),
    (138, 5.85, '2026-10-05 23:00:00'),
    (138, 5.33, '2026-10-06 02:00:00'),
    (138, 5.17, '2026-10-06 05:00:00'),
    (138, 4.27, '2026-10-06 08:00:00'),
    (138, 4.66, '2026-10-06 11:00:00'),
    (138, 4.21, '2026-10-06 14:00:00'),
    (138, 5.32, '2026-10-06 17:00:00');

-- Restaurante Sabor Real S.A. | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (139, 1.36, '2026-10-04 08:00:00'),
    (139, 2.34, '2026-10-04 11:00:00'),
    (139, 6.49, '2026-10-04 14:00:00'),
    (139, 0.81, '2026-10-04 17:00:00'),
    (139, 1.01, '2026-10-04 20:00:00'),
    (139, 2.34, '2026-10-04 23:00:00'),
    (139, 0.64, '2026-10-05 02:00:00'),
    (139, 0.91, '2026-10-05 05:00:00'),
    (139, 1.73, '2026-10-05 08:00:00'),
    (139, 2.87, '2026-10-05 11:00:00'),
    (139, 1.25, '2026-10-05 14:00:00'),
    (139, 6.25, '2026-10-05 17:00:00'),
    (139, 3.01, '2026-10-05 20:00:00'),
    (139, 2.26, '2026-10-05 23:00:00'),
    (139, 1.37, '2026-10-06 02:00:00'),
    (139, 1.74, '2026-10-06 05:00:00'),
    (139, 1.43, '2026-10-06 08:00:00'),
    (139, 3.53, '2026-10-06 11:00:00'),
    (139, 2.60, '2026-10-06 14:00:00'),
    (139, 6.17, '2026-10-06 17:00:00');

-- Restaurante Sabor Real S.A. | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (140, 6.15, '2026-10-04 08:00:00'),
    (140, 5.77, '2026-10-04 11:00:00'),
    (140, 1.26, '2026-10-04 14:00:00'),
    (140, 5.67, '2026-10-04 17:00:00'),
    (140, 4.79, '2026-10-04 20:00:00'),
    (140, 4.95, '2026-10-04 23:00:00'),
    (140, 10.23, '2026-10-05 02:00:00'),
    (140, 2.97, '2026-10-05 05:00:00'),
    (140, 7.20, '2026-10-05 08:00:00'),
    (140, 4.52, '2026-10-05 11:00:00'),
    (140, 3.04, '2026-10-05 14:00:00'),
    (140, 4.19, '2026-10-05 17:00:00'),
    (140, 3.43, '2026-10-05 20:00:00'),
    (140, 4.65, '2026-10-05 23:00:00'),
    (140, 4.09, '2026-10-06 02:00:00'),
    (140, 3.70, '2026-10-06 05:00:00'),
    (140, 7.20, '2026-10-06 08:00:00'),
    (140, 4.58, '2026-10-06 11:00:00'),
    (140, 6.49, '2026-10-06 14:00:00'),
    (140, 3.36, '2026-10-06 17:00:00');

-- Frigorífico Terra Fértil Ltda. | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (141, 3.14, '2026-10-04 08:00:00'),
    (141, 2.39, '2026-10-04 11:00:00'),
    (141, 3.89, '2026-10-04 14:00:00'),
    (141, 3.55, '2026-10-04 17:00:00'),
    (141, 1.21, '2026-10-04 20:00:00'),
    (141, 1.14, '2026-10-04 23:00:00'),
    (141, 3.44, '2026-10-05 02:00:00'),
    (141, 2.14, '2026-10-05 05:00:00'),
    (141, 2.38, '2026-10-05 08:00:00'),
    (141, 2.55, '2026-10-05 11:00:00'),
    (141, 2.24, '2026-10-05 14:00:00'),
    (141, 7.35, '2026-10-05 17:00:00'),
    (141, 1.84, '2026-10-05 20:00:00'),
    (141, 2.05, '2026-10-05 23:00:00'),
    (141, 2.54, '2026-10-06 02:00:00'),
    (141, 2.13, '2026-10-06 05:00:00'),
    (141, 2.60, '2026-10-06 08:00:00'),
    (141, 1.70, '2026-10-06 11:00:00'),
    (141, 2.18, '2026-10-06 14:00:00'),
    (141, 1.61, '2026-10-06 17:00:00');

-- Frigorífico Terra Fértil Ltda. | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (142, 6.08, '2026-10-04 08:00:00'),
    (142, 3.38, '2026-10-04 11:00:00'),
    (142, 4.50, '2026-10-04 14:00:00'),
    (142, 6.67, '2026-10-04 17:00:00'),
    (142, 5.98, '2026-10-04 20:00:00'),
    (142, 5.37, '2026-10-04 23:00:00'),
    (142, 3.64, '2026-10-05 02:00:00'),
    (142, 9.57, '2026-10-05 05:00:00'),
    (142, 4.64, '2026-10-05 08:00:00'),
    (142, 4.41, '2026-10-05 11:00:00'),
    (142, 3.27, '2026-10-05 14:00:00'),
    (142, 4.08, '2026-10-05 17:00:00'),
    (142, 3.90, '2026-10-05 20:00:00'),
    (142, 4.58, '2026-10-05 23:00:00'),
    (142, 6.42, '2026-10-06 02:00:00'),
    (142, 5.59, '2026-10-06 05:00:00'),
    (142, 6.33, '2026-10-06 08:00:00'),
    (142, 4.86, '2026-10-06 11:00:00'),
    (142, 5.51, '2026-10-06 14:00:00'),
    (142, 3.59, '2026-10-06 17:00:00');

-- Laticínios Vale Verde & Cia | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (143, 4.33, '2026-10-04 08:00:00'),
    (143, 5.61, '2026-10-04 11:00:00'),
    (143, 4.59, '2026-10-04 14:00:00'),
    (143, 4.56, '2026-10-04 17:00:00'),
    (143, 5.51, '2026-10-04 20:00:00'),
    (143, 4.81, '2026-10-04 23:00:00'),
    (143, 4.65, '2026-10-05 02:00:00'),
    (143, 4.07, '2026-10-05 05:00:00'),
    (143, 4.87, '2026-10-05 08:00:00'),
    (143, 4.74, '2026-10-05 11:00:00'),
    (143, 5.60, '2026-10-05 14:00:00'),
    (143, 4.91, '2026-10-05 17:00:00'),
    (143, 5.89, '2026-10-05 20:00:00'),
    (143, 4.50, '2026-10-05 23:00:00'),
    (143, 4.97, '2026-10-06 02:00:00'),
    (143, 5.02, '2026-10-06 05:00:00'),
    (143, 5.33, '2026-10-06 08:00:00'),
    (143, 4.88, '2026-10-06 11:00:00'),
    (143, 5.70, '2026-10-06 14:00:00'),
    (143, 4.62, '2026-10-06 17:00:00');

-- Laticínios Vale Verde & Cia | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (144, -22.37, '2026-10-04 08:00:00'),
    (144, -20.32, '2026-10-04 11:00:00'),
    (144, -21.95, '2026-10-04 14:00:00'),
    (144, -22.19, '2026-10-04 17:00:00'),
    (144, -21.49, '2026-10-04 20:00:00'),
    (144, -21.72, '2026-10-04 23:00:00'),
    (144, -22.55, '2026-10-05 02:00:00'),
    (144, -20.84, '2026-10-05 05:00:00'),
    (144, -20.35, '2026-10-05 08:00:00'),
    (144, -22.00, '2026-10-05 11:00:00'),
    (144, -22.10, '2026-10-05 14:00:00'),
    (144, -21.72, '2026-10-05 17:00:00'),
    (144, -21.59, '2026-10-05 20:00:00'),
    (144, -20.48, '2026-10-05 23:00:00'),
    (144, -21.74, '2026-10-06 02:00:00'),
    (144, -20.85, '2026-10-06 05:00:00'),
    (144, -21.70, '2026-10-06 08:00:00'),
    (144, -20.69, '2026-10-06 11:00:00'),
    (144, -22.71, '2026-10-06 14:00:00'),
    (144, -22.35, '2026-10-06 17:00:00');

-- Hortifruti Estrela do Sul ME | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (145, 4.17, '2026-10-04 08:00:00'),
    (145, 1.06, '2026-10-04 11:00:00'),
    (145, 3.71, '2026-10-04 14:00:00'),
    (145, 1.24, '2026-10-04 17:00:00'),
    (145, 2.84, '2026-10-04 20:00:00'),
    (145, 4.22, '2026-10-04 23:00:00'),
    (145, 3.99, '2026-10-05 02:00:00'),
    (145, 3.96, '2026-10-05 05:00:00'),
    (145, 1.78, '2026-10-05 08:00:00'),
    (145, 2.75, '2026-10-05 11:00:00'),
    (145, 0.88, '2026-10-05 14:00:00'),
    (145, 1.67, '2026-10-05 17:00:00'),
    (145, 2.66, '2026-10-05 20:00:00'),
    (145, 2.46, '2026-10-05 23:00:00'),
    (145, 4.20, '2026-10-06 02:00:00'),
    (145, 7.96, '2026-10-06 05:00:00'),
    (145, -1.95, '2026-10-06 08:00:00'),
    (145, 4.31, '2026-10-06 11:00:00'),
    (145, 2.42, '2026-10-06 14:00:00'),
    (145, 4.29, '2026-10-06 17:00:00');

-- Hortifruti Estrela do Sul ME | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (146, 4.60, '2026-10-04 08:00:00'),
    (146, 7.12, '2026-10-04 11:00:00'),
    (146, 4.46, '2026-10-04 14:00:00'),
    (146, 3.26, '2026-10-04 17:00:00'),
    (146, 4.30, '2026-10-04 20:00:00'),
    (146, 5.60, '2026-10-04 23:00:00'),
    (146, 3.45, '2026-10-05 02:00:00'),
    (146, 5.24, '2026-10-05 05:00:00'),
    (146, 3.97, '2026-10-05 08:00:00'),
    (146, 4.96, '2026-10-05 11:00:00'),
    (146, 4.94, '2026-10-05 14:00:00'),
    (146, 7.13, '2026-10-05 17:00:00'),
    (146, 4.62, '2026-10-05 20:00:00'),
    (146, 5.84, '2026-10-05 23:00:00'),
    (146, 4.87, '2026-10-06 02:00:00'),
    (146, 6.31, '2026-10-06 05:00:00'),
    (146, 6.13, '2026-10-06 08:00:00'),
    (146, 6.44, '2026-10-06 11:00:00'),
    (146, 6.22, '2026-10-06 14:00:00'),
    (146, 6.48, '2026-10-06 17:00:00');

-- Hortifruti Pão Dourado | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (147, -1.12, '2026-10-04 08:00:00'),
    (147, 2.83, '2026-10-04 11:00:00'),
    (147, 7.40, '2026-10-04 14:00:00'),
    (147, 5.83, '2026-10-04 17:00:00'),
    (147, 1.83, '2026-10-04 20:00:00'),
    (147, 3.36, '2026-10-04 23:00:00'),
    (147, 1.50, '2026-10-05 02:00:00'),
    (147, 6.15, '2026-10-05 05:00:00'),
    (147, 1.54, '2026-10-05 08:00:00'),
    (147, 1.39, '2026-10-05 11:00:00'),
    (147, 7.74, '2026-10-05 14:00:00'),
    (147, 6.89, '2026-10-05 17:00:00'),
    (147, 7.54, '2026-10-05 20:00:00'),
    (147, 2.99, '2026-10-05 23:00:00'),
    (147, 1.81, '2026-10-06 02:00:00'),
    (147, 3.40, '2026-10-06 05:00:00'),
    (147, 3.97, '2026-10-06 08:00:00'),
    (147, 7.78, '2026-10-06 11:00:00'),
    (147, 3.76, '2026-10-06 14:00:00'),
    (147, 1.80, '2026-10-06 17:00:00');

-- Hortifruti Pão Dourado | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (148, -17.18, '2026-10-04 08:00:00'),
    (148, -17.55, '2026-10-04 11:00:00'),
    (148, -23.49, '2026-10-04 14:00:00'),
    (148, -20.17, '2026-10-04 17:00:00'),
    (148, -20.57, '2026-10-04 20:00:00'),
    (148, -18.75, '2026-10-04 23:00:00'),
    (148, -20.24, '2026-10-05 02:00:00'),
    (148, -20.58, '2026-10-05 05:00:00'),
    (148, -20.27, '2026-10-05 08:00:00'),
    (148, -19.80, '2026-10-05 11:00:00'),
    (148, -18.75, '2026-10-05 14:00:00'),
    (148, -23.15, '2026-10-05 17:00:00'),
    (148, -15.16, '2026-10-05 20:00:00'),
    (148, -16.96, '2026-10-05 23:00:00'),
    (148, -17.53, '2026-10-06 02:00:00'),
    (148, -16.57, '2026-10-06 05:00:00'),
    (148, -18.80, '2026-10-06 08:00:00'),
    (148, -21.06, '2026-10-06 11:00:00'),
    (148, -23.53, '2026-10-06 14:00:00'),
    (148, -23.32, '2026-10-06 17:00:00');

-- Mercado Estrela do Sul & Cia | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (149, 2.15, '2026-10-04 08:00:00'),
    (149, 2.04, '2026-10-04 11:00:00'),
    (149, 2.41, '2026-10-04 14:00:00'),
    (149, 1.84, '2026-10-04 17:00:00'),
    (149, 2.69, '2026-10-04 20:00:00'),
    (149, 1.71, '2026-10-04 23:00:00'),
    (149, 2.54, '2026-10-05 02:00:00'),
    (149, 3.17, '2026-10-05 05:00:00'),
    (149, 2.10, '2026-10-05 08:00:00'),
    (149, 2.62, '2026-10-05 11:00:00'),
    (149, 1.80, '2026-10-05 14:00:00'),
    (149, 2.31, '2026-10-05 17:00:00'),
    (149, 2.15, '2026-10-05 20:00:00'),
    (149, 1.77, '2026-10-05 23:00:00'),
    (149, 3.24, '2026-10-06 02:00:00'),
    (149, 2.31, '2026-10-06 05:00:00'),
    (149, 2.06, '2026-10-06 08:00:00'),
    (149, 2.67, '2026-10-06 11:00:00'),
    (149, 1.71, '2026-10-06 14:00:00'),
    (149, 2.23, '2026-10-06 17:00:00');

-- Mercado Estrela do Sul & Cia | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (150, -20.22, '2026-10-04 08:00:00'),
    (150, -19.83, '2026-10-04 11:00:00'),
    (150, -20.45, '2026-10-04 14:00:00'),
    (150, -19.94, '2026-10-04 17:00:00'),
    (150, -20.37, '2026-10-04 20:00:00'),
    (150, -19.39, '2026-10-04 23:00:00'),
    (150, -19.81, '2026-10-05 02:00:00'),
    (150, -19.33, '2026-10-05 05:00:00'),
    (150, -20.13, '2026-10-05 08:00:00'),
    (150, -20.09, '2026-10-05 11:00:00'),
    (150, -20.29, '2026-10-05 14:00:00'),
    (150, -19.32, '2026-10-05 17:00:00'),
    (150, -20.47, '2026-10-05 20:00:00'),
    (150, -19.85, '2026-10-05 23:00:00'),
    (150, -20.41, '2026-10-06 02:00:00'),
    (150, -20.21, '2026-10-06 05:00:00'),
    (150, -19.81, '2026-10-06 08:00:00'),
    (150, -19.91, '2026-10-06 11:00:00'),
    (150, -19.42, '2026-10-06 14:00:00'),
    (150, -20.43, '2026-10-06 17:00:00');

-- Mercado Alvorada | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (151, -18.88, '2026-10-04 08:00:00'),
    (151, -19.85, '2026-10-04 11:00:00'),
    (151, -15.74, '2026-10-04 14:00:00'),
    (151, -18.81, '2026-10-04 17:00:00'),
    (151, -21.81, '2026-10-04 20:00:00'),
    (151, -19.64, '2026-10-04 23:00:00'),
    (151, -22.26, '2026-10-05 02:00:00'),
    (151, -19.57, '2026-10-05 05:00:00'),
    (151, -23.03, '2026-10-05 08:00:00'),
    (151, -19.30, '2026-10-05 11:00:00'),
    (151, -23.17, '2026-10-05 14:00:00'),
    (151, -26.42, '2026-10-05 17:00:00'),
    (151, -19.38, '2026-10-05 20:00:00'),
    (151, -19.71, '2026-10-05 23:00:00'),
    (151, -17.46, '2026-10-06 02:00:00'),
    (151, -18.74, '2026-10-06 05:00:00'),
    (151, -26.31, '2026-10-06 08:00:00'),
    (151, -17.23, '2026-10-06 11:00:00'),
    (151, -16.02, '2026-10-06 14:00:00'),
    (151, -15.81, '2026-10-06 17:00:00');

-- Mercado Alvorada | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (152, 2.97, '2026-10-04 08:00:00'),
    (152, -0.25, '2026-10-04 11:00:00'),
    (152, 9.71, '2026-10-04 14:00:00'),
    (152, 6.29, '2026-10-04 17:00:00'),
    (152, 5.31, '2026-10-04 20:00:00'),
    (152, 5.59, '2026-10-04 23:00:00'),
    (152, 3.15, '2026-10-05 02:00:00'),
    (152, -0.54, '2026-10-05 05:00:00'),
    (152, 4.56, '2026-10-05 08:00:00'),
    (152, 2.86, '2026-10-05 11:00:00'),
    (152, 5.38, '2026-10-05 14:00:00'),
    (152, 8.63, '2026-10-05 17:00:00'),
    (152, 5.70, '2026-10-05 20:00:00'),
    (152, 0.65, '2026-10-05 23:00:00'),
    (152, 6.05, '2026-10-06 02:00:00'),
    (152, 9.87, '2026-10-06 05:00:00'),
    (152, 6.34, '2026-10-06 08:00:00'),
    (152, 6.42, '2026-10-06 11:00:00'),
    (152, 8.68, '2026-10-06 14:00:00'),
    (152, 3.98, '2026-10-06 17:00:00');

-- Supermercado Estrela do Sul ME | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (153, -16.68, '2026-10-04 08:00:00'),
    (153, -18.75, '2026-10-04 11:00:00'),
    (153, -24.93, '2026-10-04 14:00:00'),
    (153, -18.79, '2026-10-04 17:00:00'),
    (153, -17.13, '2026-10-04 20:00:00'),
    (153, -18.47, '2026-10-04 23:00:00'),
    (153, -21.19, '2026-10-05 02:00:00'),
    (153, -15.31, '2026-10-05 05:00:00'),
    (153, -19.72, '2026-10-05 08:00:00'),
    (153, -17.50, '2026-10-05 11:00:00'),
    (153, -19.60, '2026-10-05 14:00:00'),
    (153, -20.66, '2026-10-05 17:00:00'),
    (153, -21.37, '2026-10-05 20:00:00'),
    (153, -19.75, '2026-10-05 23:00:00'),
    (153, -15.19, '2026-10-06 02:00:00'),
    (153, -20.69, '2026-10-06 05:00:00'),
    (153, -20.84, '2026-10-06 08:00:00'),
    (153, -18.82, '2026-10-06 11:00:00'),
    (153, -19.96, '2026-10-06 14:00:00'),
    (153, -20.43, '2026-10-06 17:00:00');

-- Supermercado Estrela do Sul ME | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (154, 4.01, '2026-10-04 08:00:00'),
    (154, 5.80, '2026-10-04 11:00:00'),
    (154, 4.40, '2026-10-04 14:00:00'),
    (154, 2.36, '2026-10-04 17:00:00'),
    (154, 1.16, '2026-10-04 20:00:00'),
    (154, 4.35, '2026-10-04 23:00:00'),
    (154, -2.50, '2026-10-05 02:00:00'),
    (154, 3.96, '2026-10-05 05:00:00'),
    (154, 0.80, '2026-10-05 08:00:00'),
    (154, 3.89, '2026-10-05 11:00:00'),
    (154, 2.76, '2026-10-05 14:00:00'),
    (154, 7.11, '2026-10-05 17:00:00'),
    (154, 6.84, '2026-10-05 20:00:00'),
    (154, -1.45, '2026-10-05 23:00:00'),
    (154, 1.63, '2026-10-06 02:00:00'),
    (154, 1.07, '2026-10-06 05:00:00'),
    (154, 2.68, '2026-10-06 08:00:00'),
    (154, 6.78, '2026-10-06 11:00:00'),
    (154, 5.83, '2026-10-06 14:00:00'),
    (154, 1.03, '2026-10-06 17:00:00');

-- Padaria Nova Safra & Cia | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (155, 2.94, '2026-10-04 08:00:00'),
    (155, 2.91, '2026-10-04 11:00:00'),
    (155, 2.05, '2026-10-04 14:00:00'),
    (155, 2.51, '2026-10-04 17:00:00'),
    (155, 1.83, '2026-10-04 20:00:00'),
    (155, 2.62, '2026-10-04 23:00:00'),
    (155, 3.10, '2026-10-05 02:00:00'),
    (155, 2.22, '2026-10-05 05:00:00'),
    (155, 2.62, '2026-10-05 08:00:00'),
    (155, 3.25, '2026-10-05 11:00:00'),
    (155, 2.76, '2026-10-05 14:00:00'),
    (155, 1.98, '2026-10-05 17:00:00'),
    (155, 2.35, '2026-10-05 20:00:00'),
    (155, 3.30, '2026-10-05 23:00:00'),
    (155, 1.67, '2026-10-06 02:00:00'),
    (155, 3.20, '2026-10-06 05:00:00'),
    (155, 3.35, '2026-10-06 08:00:00'),
    (155, 2.93, '2026-10-06 11:00:00'),
    (155, 2.11, '2026-10-06 14:00:00'),
    (155, 3.10, '2026-10-06 17:00:00');

-- Padaria Nova Safra & Cia | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (156, -20.66, '2026-10-04 08:00:00'),
    (156, -20.14, '2026-10-04 11:00:00'),
    (156, -19.70, '2026-10-04 14:00:00'),
    (156, -19.86, '2026-10-04 17:00:00'),
    (156, -20.04, '2026-10-04 20:00:00'),
    (156, -20.15, '2026-10-04 23:00:00'),
    (156, -20.17, '2026-10-05 02:00:00'),
    (156, -20.35, '2026-10-05 05:00:00'),
    (156, -20.07, '2026-10-05 08:00:00'),
    (156, -19.62, '2026-10-05 11:00:00'),
    (156, -19.74, '2026-10-05 14:00:00'),
    (156, -19.34, '2026-10-05 17:00:00'),
    (156, -20.60, '2026-10-05 20:00:00'),
    (156, -20.34, '2026-10-05 23:00:00'),
    (156, -20.34, '2026-10-06 02:00:00'),
    (156, -19.53, '2026-10-06 05:00:00'),
    (156, -20.31, '2026-10-06 08:00:00'),
    (156, -20.37, '2026-10-06 11:00:00'),
    (156, -19.84, '2026-10-06 14:00:00'),
    (156, -19.70, '2026-10-06 17:00:00');

-- Restaurante Alvorada & Cia | Freezer Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (157, -21.97, '2026-10-04 08:00:00'),
    (157, -21.16, '2026-10-04 11:00:00'),
    (157, -22.85, '2026-10-04 14:00:00'),
    (157, -22.96, '2026-10-04 17:00:00'),
    (157, -23.06, '2026-10-04 20:00:00'),
    (157, -22.88, '2026-10-04 23:00:00'),
    (157, -19.90, '2026-10-05 02:00:00'),
    (157, -21.51, '2026-10-05 05:00:00'),
    (157, -22.29, '2026-10-05 08:00:00'),
    (157, -19.89, '2026-10-05 11:00:00'),
    (157, -27.61, '2026-10-05 14:00:00'),
    (157, -22.40, '2026-10-05 17:00:00'),
    (157, -19.50, '2026-10-05 20:00:00'),
    (157, -22.98, '2026-10-05 23:00:00'),
    (157, -21.56, '2026-10-06 02:00:00'),
    (157, -23.29, '2026-10-06 05:00:00'),
    (157, -19.74, '2026-10-06 08:00:00'),
    (157, -20.23, '2026-10-06 11:00:00'),
    (157, -20.72, '2026-10-06 14:00:00'),
    (157, -19.89, '2026-10-06 17:00:00');

-- Restaurante Alvorada & Cia | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (158, -19.36, '2026-10-04 08:00:00'),
    (158, -20.31, '2026-10-04 11:00:00'),
    (158, -20.94, '2026-10-04 14:00:00'),
    (158, -19.75, '2026-10-04 17:00:00'),
    (158, -19.29, '2026-10-04 20:00:00'),
    (158, -18.86, '2026-10-04 23:00:00'),
    (158, -20.70, '2026-10-05 02:00:00'),
    (158, -20.62, '2026-10-05 05:00:00'),
    (158, -18.98, '2026-10-05 08:00:00'),
    (158, -19.63, '2026-10-05 11:00:00'),
    (158, -19.84, '2026-10-05 14:00:00'),
    (158, -19.37, '2026-10-05 17:00:00'),
    (158, -19.26, '2026-10-05 20:00:00'),
    (158, -20.97, '2026-10-05 23:00:00'),
    (158, -19.00, '2026-10-06 02:00:00'),
    (158, -19.07, '2026-10-06 05:00:00'),
    (158, -19.40, '2026-10-06 08:00:00'),
    (158, -20.95, '2026-10-06 11:00:00'),
    (158, -20.62, '2026-10-06 14:00:00'),
    (158, -20.80, '2026-10-06 17:00:00');

-- Açougue Nova Safra ME | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (159, -20.93, '2026-10-04 08:00:00'),
    (159, -27.89, '2026-10-04 11:00:00'),
    (159, -21.51, '2026-10-04 14:00:00'),
    (159, -23.31, '2026-10-04 17:00:00'),
    (159, -19.66, '2026-10-04 20:00:00'),
    (159, -19.81, '2026-10-04 23:00:00'),
    (159, -22.49, '2026-10-05 02:00:00'),
    (159, -17.07, '2026-10-05 05:00:00'),
    (159, -22.67, '2026-10-05 08:00:00'),
    (159, -21.68, '2026-10-05 11:00:00'),
    (159, -20.82, '2026-10-05 14:00:00'),
    (159, -18.89, '2026-10-05 17:00:00'),
    (159, -20.27, '2026-10-05 20:00:00'),
    (159, -19.65, '2026-10-05 23:00:00'),
    (159, -20.49, '2026-10-06 02:00:00'),
    (159, -21.02, '2026-10-06 05:00:00'),
    (159, -20.52, '2026-10-06 08:00:00'),
    (159, -16.75, '2026-10-06 11:00:00'),
    (159, -21.65, '2026-10-06 14:00:00'),
    (159, -22.24, '2026-10-06 17:00:00');

-- Açougue Nova Safra ME | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (160, 2.59, '2026-10-04 08:00:00'),
    (160, 3.08, '2026-10-04 11:00:00'),
    (160, -1.45, '2026-10-04 14:00:00'),
    (160, 5.87, '2026-10-04 17:00:00'),
    (160, 7.78, '2026-10-04 20:00:00'),
    (160, 2.85, '2026-10-04 23:00:00'),
    (160, 3.85, '2026-10-05 02:00:00'),
    (160, 7.88, '2026-10-05 05:00:00'),
    (160, 3.65, '2026-10-05 08:00:00'),
    (160, 7.72, '2026-10-05 11:00:00'),
    (160, -2.23, '2026-10-05 14:00:00'),
    (160, 4.37, '2026-10-05 17:00:00'),
    (160, 4.19, '2026-10-05 20:00:00'),
    (160, 4.32, '2026-10-05 23:00:00'),
    (160, 3.24, '2026-10-06 02:00:00'),
    (160, 4.27, '2026-10-06 05:00:00'),
    (160, 1.20, '2026-10-06 08:00:00'),
    (160, -1.55, '2026-10-06 11:00:00'),
    (160, 3.27, '2026-10-06 14:00:00'),
    (160, 1.78, '2026-10-06 17:00:00');

-- Padaria Campo Belo | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (161, 4.38, '2026-10-04 08:00:00'),
    (161, 2.87, '2026-10-04 11:00:00'),
    (161, 3.45, '2026-10-04 14:00:00'),
    (161, 0.66, '2026-10-04 17:00:00'),
    (161, 4.03, '2026-10-04 20:00:00'),
    (161, 1.13, '2026-10-04 23:00:00'),
    (161, 2.01, '2026-10-05 02:00:00'),
    (161, 2.47, '2026-10-05 05:00:00'),
    (161, 3.38, '2026-10-05 08:00:00'),
    (161, 1.49, '2026-10-05 11:00:00'),
    (161, 1.38, '2026-10-05 14:00:00'),
    (161, 1.19, '2026-10-05 17:00:00'),
    (161, 2.09, '2026-10-05 20:00:00'),
    (161, 2.16, '2026-10-05 23:00:00'),
    (161, -0.77, '2026-10-06 02:00:00'),
    (161, 0.63, '2026-10-06 05:00:00'),
    (161, 1.69, '2026-10-06 08:00:00'),
    (161, 3.21, '2026-10-06 11:00:00'),
    (161, 2.60, '2026-10-06 14:00:00'),
    (161, -1.82, '2026-10-06 17:00:00');

-- Padaria Campo Belo | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (162, 6.03, '2026-10-04 08:00:00'),
    (162, 5.17, '2026-10-04 11:00:00'),
    (162, 3.03, '2026-10-04 14:00:00'),
    (162, 10.39, '2026-10-04 17:00:00'),
    (162, 5.66, '2026-10-04 20:00:00'),
    (162, 4.43, '2026-10-04 23:00:00'),
    (162, 0.54, '2026-10-05 02:00:00'),
    (162, 5.75, '2026-10-05 05:00:00'),
    (162, 8.44, '2026-10-05 08:00:00'),
    (162, 3.67, '2026-10-05 11:00:00'),
    (162, 5.62, '2026-10-05 14:00:00'),
    (162, 5.29, '2026-10-05 17:00:00'),
    (162, -0.77, '2026-10-05 20:00:00'),
    (162, 6.11, '2026-10-05 23:00:00'),
    (162, 4.18, '2026-10-06 02:00:00'),
    (162, 6.77, '2026-10-06 05:00:00'),
    (162, -0.17, '2026-10-06 08:00:00'),
    (162, 8.70, '2026-10-06 11:00:00'),
    (162, 10.73, '2026-10-06 14:00:00'),
    (162, 2.86, '2026-10-06 17:00:00');

-- Empório Terra Fértil & Cia | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (163, 2.35, '2026-10-04 08:00:00'),
    (163, 2.71, '2026-10-04 11:00:00'),
    (163, 1.11, '2026-10-04 14:00:00'),
    (163, 3.35, '2026-10-04 17:00:00'),
    (163, 3.59, '2026-10-04 20:00:00'),
    (163, 2.97, '2026-10-04 23:00:00'),
    (163, 2.53, '2026-10-05 02:00:00'),
    (163, 3.71, '2026-10-05 05:00:00'),
    (163, 1.19, '2026-10-05 08:00:00'),
    (163, 1.28, '2026-10-05 11:00:00'),
    (163, 1.99, '2026-10-05 14:00:00'),
    (163, 1.46, '2026-10-05 17:00:00'),
    (163, 3.55, '2026-10-05 20:00:00'),
    (163, 2.72, '2026-10-05 23:00:00'),
    (163, 1.71, '2026-10-06 02:00:00'),
    (163, 2.10, '2026-10-06 05:00:00'),
    (163, 3.30, '2026-10-06 08:00:00'),
    (163, 1.88, '2026-10-06 11:00:00'),
    (163, 1.87, '2026-10-06 14:00:00'),
    (163, 3.19, '2026-10-06 17:00:00');

-- Empório Terra Fértil & Cia | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (164, 6.03, '2026-10-04 08:00:00'),
    (164, 5.20, '2026-10-04 11:00:00'),
    (164, 3.29, '2026-10-04 14:00:00'),
    (164, 4.97, '2026-10-04 17:00:00'),
    (164, 4.83, '2026-10-04 20:00:00'),
    (164, 6.05, '2026-10-04 23:00:00'),
    (164, 6.47, '2026-10-05 02:00:00'),
    (164, 6.06, '2026-10-05 05:00:00'),
    (164, 6.78, '2026-10-05 08:00:00'),
    (164, 5.08, '2026-10-05 11:00:00'),
    (164, 10.70, '2026-10-05 14:00:00'),
    (164, 3.50, '2026-10-05 17:00:00'),
    (164, 3.23, '2026-10-05 20:00:00'),
    (164, 4.03, '2026-10-05 23:00:00'),
    (164, 4.65, '2026-10-06 02:00:00'),
    (164, 3.95, '2026-10-06 05:00:00'),
    (164, 6.14, '2026-10-06 08:00:00'),
    (164, 5.75, '2026-10-06 11:00:00'),
    (164, 3.25, '2026-10-06 14:00:00'),
    (164, 4.65, '2026-10-06 17:00:00');

-- Empório Nova Safra | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (165, 3.67, '2026-10-04 08:00:00'),
    (165, 5.67, '2026-10-04 11:00:00'),
    (165, 5.75, '2026-10-04 14:00:00'),
    (165, 4.62, '2026-10-04 17:00:00'),
    (165, 5.20, '2026-10-04 20:00:00'),
    (165, 4.68, '2026-10-04 23:00:00'),
    (165, 5.75, '2026-10-05 02:00:00'),
    (165, 3.73, '2026-10-05 05:00:00'),
    (165, 5.28, '2026-10-05 08:00:00'),
    (165, 4.37, '2026-10-05 11:00:00'),
    (165, 5.71, '2026-10-05 14:00:00'),
    (165, 5.80, '2026-10-05 17:00:00'),
    (165, 4.92, '2026-10-05 20:00:00'),
    (165, 3.71, '2026-10-05 23:00:00'),
    (165, 6.78, '2026-10-06 02:00:00'),
    (165, 5.91, '2026-10-06 05:00:00'),
    (165, 4.12, '2026-10-06 08:00:00'),
    (165, 5.54, '2026-10-06 11:00:00'),
    (165, 4.01, '2026-10-06 14:00:00'),
    (165, 4.02, '2026-10-06 17:00:00');

-- Empório Nova Safra | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (166, 3.87, '2026-10-04 08:00:00'),
    (166, 5.87, '2026-10-04 11:00:00'),
    (166, 5.69, '2026-10-04 14:00:00'),
    (166, 5.20, '2026-10-04 17:00:00'),
    (166, 3.45, '2026-10-04 20:00:00'),
    (166, 5.10, '2026-10-04 23:00:00'),
    (166, 3.53, '2026-10-05 02:00:00'),
    (166, 5.69, '2026-10-05 05:00:00'),
    (166, 3.64, '2026-10-05 08:00:00'),
    (166, 5.42, '2026-10-05 11:00:00'),
    (166, 6.15, '2026-10-05 14:00:00'),
    (166, 5.01, '2026-10-05 17:00:00'),
    (166, 5.40, '2026-10-05 20:00:00'),
    (166, 5.79, '2026-10-05 23:00:00'),
    (166, 4.82, '2026-10-06 02:00:00'),
    (166, 3.78, '2026-10-06 05:00:00'),
    (166, 4.32, '2026-10-06 08:00:00'),
    (166, 5.18, '2026-10-06 11:00:00'),
    (166, 3.96, '2026-10-06 14:00:00'),
    (166, 5.60, '2026-10-06 17:00:00');

-- Padaria Boa Vista ME | Refrigerador Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (167, 6.56, '2026-10-04 08:00:00'),
    (167, 4.84, '2026-10-04 11:00:00'),
    (167, 5.52, '2026-10-04 14:00:00'),
    (167, 5.90, '2026-10-04 17:00:00'),
    (167, 6.89, '2026-10-04 20:00:00'),
    (167, 2.95, '2026-10-04 23:00:00'),
    (167, 6.36, '2026-10-05 02:00:00'),
    (167, 3.78, '2026-10-05 05:00:00'),
    (167, 2.97, '2026-10-05 08:00:00'),
    (167, 5.17, '2026-10-05 11:00:00'),
    (167, 6.59, '2026-10-05 14:00:00'),
    (167, 5.69, '2026-10-05 17:00:00'),
    (167, 9.70, '2026-10-05 20:00:00'),
    (167, 6.43, '2026-10-05 23:00:00'),
    (167, 5.21, '2026-10-06 02:00:00'),
    (167, 4.32, '2026-10-06 05:00:00'),
    (167, 5.37, '2026-10-06 08:00:00'),
    (167, 3.04, '2026-10-06 11:00:00'),
    (167, 6.45, '2026-10-06 14:00:00'),
    (167, 4.52, '2026-10-06 17:00:00');

-- Padaria Boa Vista ME | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (168, 4.03, '2026-10-04 08:00:00'),
    (168, -0.06, '2026-10-04 11:00:00'),
    (168, 5.98, '2026-10-04 14:00:00'),
    (168, 5.43, '2026-10-04 17:00:00'),
    (168, 5.41, '2026-10-04 20:00:00'),
    (168, 1.47, '2026-10-04 23:00:00'),
    (168, 9.66, '2026-10-05 02:00:00'),
    (168, 2.90, '2026-10-05 05:00:00'),
    (168, 3.19, '2026-10-05 08:00:00'),
    (168, 6.61, '2026-10-05 11:00:00'),
    (168, 4.56, '2026-10-05 14:00:00'),
    (168, 10.42, '2026-10-05 17:00:00'),
    (168, 5.01, '2026-10-05 20:00:00'),
    (168, 4.09, '2026-10-05 23:00:00'),
    (168, 3.28, '2026-10-06 02:00:00'),
    (168, 6.37, '2026-10-06 05:00:00'),
    (168, 4.04, '2026-10-06 08:00:00'),
    (168, 4.20, '2026-10-06 11:00:00'),
    (168, 6.84, '2026-10-06 14:00:00'),
    (168, 6.11, '2026-10-06 17:00:00');

-- Empório Pão Dourado S.A. | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (169, -20.39, '2026-10-04 08:00:00'),
    (169, -20.21, '2026-10-04 11:00:00'),
    (169, -18.62, '2026-10-04 14:00:00'),
    (169, -20.64, '2026-10-04 17:00:00'),
    (169, -21.22, '2026-10-04 20:00:00'),
    (169, -21.59, '2026-10-04 23:00:00'),
    (169, -15.62, '2026-10-05 02:00:00'),
    (169, -17.57, '2026-10-05 05:00:00'),
    (169, -20.63, '2026-10-05 08:00:00'),
    (169, -19.65, '2026-10-05 11:00:00'),
    (169, -21.12, '2026-10-05 14:00:00'),
    (169, -17.50, '2026-10-05 17:00:00'),
    (169, -19.13, '2026-10-05 20:00:00'),
    (169, -23.22, '2026-10-05 23:00:00'),
    (169, -20.67, '2026-10-06 02:00:00'),
    (169, -19.48, '2026-10-06 05:00:00'),
    (169, -18.74, '2026-10-06 08:00:00'),
    (169, -23.59, '2026-10-06 11:00:00'),
    (169, -19.31, '2026-10-06 14:00:00'),
    (169, -20.08, '2026-10-06 17:00:00');

-- Empório Pão Dourado S.A. | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (170, -16.00, '2026-10-04 08:00:00'),
    (170, -24.11, '2026-10-04 11:00:00'),
    (170, -19.73, '2026-10-04 14:00:00'),
    (170, -21.06, '2026-10-04 17:00:00'),
    (170, -20.92, '2026-10-04 20:00:00'),
    (170, -21.05, '2026-10-04 23:00:00'),
    (170, -22.50, '2026-10-05 02:00:00'),
    (170, -18.87, '2026-10-05 05:00:00'),
    (170, -22.10, '2026-10-05 08:00:00'),
    (170, -26.31, '2026-10-05 11:00:00'),
    (170, -23.06, '2026-10-05 14:00:00'),
    (170, -22.00, '2026-10-05 17:00:00'),
    (170, -18.97, '2026-10-05 20:00:00'),
    (170, -18.91, '2026-10-05 23:00:00'),
    (170, -16.96, '2026-10-06 02:00:00'),
    (170, -24.10, '2026-10-06 05:00:00'),
    (170, -22.48, '2026-10-06 08:00:00'),
    (170, -21.01, '2026-10-06 11:00:00'),
    (170, -16.53, '2026-10-06 14:00:00'),
    (170, -22.77, '2026-10-06 17:00:00');

-- Distribuidora Vale Verde ME | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (171, 5.94, '2026-10-04 08:00:00'),
    (171, 5.26, '2026-10-04 11:00:00'),
    (171, 6.50, '2026-10-04 14:00:00'),
    (171, 5.16, '2026-10-04 17:00:00'),
    (171, 4.19, '2026-10-04 20:00:00'),
    (171, 6.50, '2026-10-04 23:00:00'),
    (171, 3.77, '2026-10-05 02:00:00'),
    (171, 6.61, '2026-10-05 05:00:00'),
    (171, 6.00, '2026-10-05 08:00:00'),
    (171, 6.78, '2026-10-05 11:00:00'),
    (171, 4.04, '2026-10-05 14:00:00'),
    (171, 6.15, '2026-10-05 17:00:00'),
    (171, 5.21, '2026-10-05 20:00:00'),
    (171, 3.85, '2026-10-05 23:00:00'),
    (171, 3.86, '2026-10-06 02:00:00'),
    (171, 4.08, '2026-10-06 05:00:00'),
    (171, 5.61, '2026-10-06 08:00:00'),
    (171, 6.03, '2026-10-06 11:00:00'),
    (171, 3.39, '2026-10-06 14:00:00'),
    (171, 3.35, '2026-10-06 17:00:00');

-- Distribuidora Vale Verde ME | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (172, -20.51, '2026-10-04 08:00:00'),
    (172, -21.54, '2026-10-04 11:00:00'),
    (172, -22.58, '2026-10-04 14:00:00'),
    (172, -20.18, '2026-10-04 17:00:00'),
    (172, -23.07, '2026-10-04 20:00:00'),
    (172, -19.40, '2026-10-04 23:00:00'),
    (172, -23.21, '2026-10-05 02:00:00'),
    (172, -22.95, '2026-10-05 05:00:00'),
    (172, -21.91, '2026-10-05 08:00:00'),
    (172, -23.26, '2026-10-05 11:00:00'),
    (172, -19.80, '2026-10-05 14:00:00'),
    (172, -20.79, '2026-10-05 17:00:00'),
    (172, -22.47, '2026-10-05 20:00:00'),
    (172, -20.76, '2026-10-05 23:00:00'),
    (172, -20.31, '2026-10-06 02:00:00'),
    (172, -23.11, '2026-10-06 05:00:00'),
    (172, -23.34, '2026-10-06 08:00:00'),
    (172, -22.18, '2026-10-06 11:00:00'),
    (172, -23.46, '2026-10-06 14:00:00'),
    (172, -21.23, '2026-10-06 17:00:00');

-- Distribuidora Nova Safra ME | Câmara Fria 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (173, 2.58, '2026-10-04 08:00:00'),
    (173, 4.03, '2026-10-04 11:00:00'),
    (173, 2.73, '2026-10-04 14:00:00'),
    (173, 1.97, '2026-10-04 17:00:00'),
    (173, 1.21, '2026-10-04 20:00:00'),
    (173, 4.24, '2026-10-04 23:00:00'),
    (173, 3.31, '2026-10-05 02:00:00'),
    (173, 2.11, '2026-10-05 05:00:00'),
    (173, 0.91, '2026-10-05 08:00:00'),
    (173, 4.09, '2026-10-05 11:00:00'),
    (173, 7.41, '2026-10-05 14:00:00'),
    (173, 2.67, '2026-10-05 17:00:00'),
    (173, 0.74, '2026-10-05 20:00:00'),
    (173, 3.29, '2026-10-05 23:00:00'),
    (173, 2.62, '2026-10-06 02:00:00'),
    (173, 4.10, '2026-10-06 05:00:00'),
    (173, -1.71, '2026-10-06 08:00:00'),
    (173, 2.96, '2026-10-06 11:00:00'),
    (173, 1.32, '2026-10-06 14:00:00'),
    (173, 4.33, '2026-10-06 17:00:00');

-- Distribuidora Nova Safra ME | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (174, -19.52, '2026-10-04 08:00:00'),
    (174, -21.48, '2026-10-04 11:00:00'),
    (174, -20.30, '2026-10-04 14:00:00'),
    (174, -19.14, '2026-10-04 17:00:00'),
    (174, -15.82, '2026-10-04 20:00:00'),
    (174, -18.86, '2026-10-04 23:00:00'),
    (174, -21.39, '2026-10-05 02:00:00'),
    (174, -20.03, '2026-10-05 05:00:00'),
    (174, -19.49, '2026-10-05 08:00:00'),
    (174, -17.35, '2026-10-05 11:00:00'),
    (174, -18.71, '2026-10-05 14:00:00'),
    (174, -19.65, '2026-10-05 17:00:00'),
    (174, -19.56, '2026-10-05 20:00:00'),
    (174, -18.93, '2026-10-05 23:00:00'),
    (174, -19.35, '2026-10-06 02:00:00'),
    (174, -21.43, '2026-10-06 05:00:00'),
    (174, -20.10, '2026-10-06 08:00:00'),
    (174, -19.11, '2026-10-06 11:00:00'),
    (174, -18.81, '2026-10-06 14:00:00'),
    (174, -19.65, '2026-10-06 17:00:00');

-- Mercado Sabor Real ME | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (175, 3.90, '2026-10-04 08:00:00'),
    (175, 3.36, '2026-10-04 11:00:00'),
    (175, 1.74, '2026-10-04 14:00:00'),
    (175, 2.32, '2026-10-04 17:00:00'),
    (175, 2.60, '2026-10-04 20:00:00'),
    (175, 3.57, '2026-10-04 23:00:00'),
    (175, 2.41, '2026-10-05 02:00:00'),
    (175, 2.25, '2026-10-05 05:00:00'),
    (175, 3.83, '2026-10-05 08:00:00'),
    (175, 3.95, '2026-10-05 11:00:00'),
    (175, 3.08, '2026-10-05 14:00:00'),
    (175, 3.64, '2026-10-05 17:00:00'),
    (175, 2.46, '2026-10-05 20:00:00'),
    (175, 2.30, '2026-10-05 23:00:00'),
    (175, 3.15, '2026-10-06 02:00:00'),
    (175, 3.62, '2026-10-06 05:00:00'),
    (175, 2.71, '2026-10-06 08:00:00'),
    (175, 2.11, '2026-10-06 11:00:00'),
    (175, 3.02, '2026-10-06 14:00:00'),
    (175, 1.07, '2026-10-06 17:00:00');

-- Mercado Sabor Real ME | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (176, 4.73, '2026-10-04 08:00:00'),
    (176, 5.58, '2026-10-04 11:00:00'),
    (176, 4.74, '2026-10-04 14:00:00'),
    (176, 6.27, '2026-10-04 17:00:00'),
    (176, 6.17, '2026-10-04 20:00:00'),
    (176, 4.81, '2026-10-04 23:00:00'),
    (176, 5.98, '2026-10-05 02:00:00'),
    (176, 4.20, '2026-10-05 05:00:00'),
    (176, 3.29, '2026-10-05 08:00:00'),
    (176, 3.72, '2026-10-05 11:00:00'),
    (176, 5.82, '2026-10-05 14:00:00'),
    (176, 3.52, '2026-10-05 17:00:00'),
    (176, 3.89, '2026-10-05 20:00:00'),
    (176, 5.82, '2026-10-05 23:00:00'),
    (176, 10.03, '2026-10-06 02:00:00'),
    (176, 6.44, '2026-10-06 05:00:00'),
    (176, 4.49, '2026-10-06 08:00:00'),
    (176, 6.56, '2026-10-06 11:00:00'),
    (176, 3.48, '2026-10-06 14:00:00'),
    (176, 3.90, '2026-10-06 17:00:00');

-- Hortifruti Nova Safra & Cia | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (177, 4.42, '2026-10-04 08:00:00'),
    (177, 4.91, '2026-10-04 11:00:00'),
    (177, 5.71, '2026-10-04 14:00:00'),
    (177, 3.98, '2026-10-04 17:00:00'),
    (177, 6.04, '2026-10-04 20:00:00'),
    (177, 4.81, '2026-10-04 23:00:00'),
    (177, 5.03, '2026-10-05 02:00:00'),
    (177, 4.79, '2026-10-05 05:00:00'),
    (177, 5.91, '2026-10-05 08:00:00'),
    (177, 5.04, '2026-10-05 11:00:00'),
    (177, 4.31, '2026-10-05 14:00:00'),
    (177, 5.78, '2026-10-05 17:00:00'),
    (177, 4.77, '2026-10-05 20:00:00'),
    (177, 4.39, '2026-10-05 23:00:00'),
    (177, 4.51, '2026-10-06 02:00:00'),
    (177, 4.37, '2026-10-06 05:00:00'),
    (177, 4.42, '2026-10-06 08:00:00'),
    (177, 5.30, '2026-10-06 11:00:00'),
    (177, 4.44, '2026-10-06 14:00:00'),
    (177, 4.95, '2026-10-06 17:00:00');

-- Hortifruti Nova Safra & Cia | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (178, -21.36, '2026-10-04 08:00:00'),
    (178, -21.87, '2026-10-04 11:00:00'),
    (178, -20.67, '2026-10-04 14:00:00'),
    (178, -21.67, '2026-10-04 17:00:00'),
    (178, -22.51, '2026-10-04 20:00:00'),
    (178, -22.62, '2026-10-04 23:00:00'),
    (178, -22.20, '2026-10-05 02:00:00'),
    (178, -22.54, '2026-10-05 05:00:00'),
    (178, -20.36, '2026-10-05 08:00:00'),
    (178, -20.58, '2026-10-05 11:00:00'),
    (178, -20.97, '2026-10-05 14:00:00'),
    (178, -21.19, '2026-10-05 17:00:00'),
    (178, -20.48, '2026-10-05 20:00:00'),
    (178, -20.62, '2026-10-05 23:00:00'),
    (178, -22.56, '2026-10-06 02:00:00'),
    (178, -20.86, '2026-10-06 05:00:00'),
    (178, -22.48, '2026-10-06 08:00:00'),
    (178, -22.27, '2026-10-06 11:00:00'),
    (178, -22.14, '2026-10-06 14:00:00'),
    (178, -21.20, '2026-10-06 17:00:00');

-- Mercado Boa Vista ME | Câmara Fria 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (179, 3.13, '2026-10-04 08:00:00'),
    (179, 3.19, '2026-10-04 11:00:00'),
    (179, 3.97, '2026-10-04 14:00:00'),
    (179, 2.59, '2026-10-04 17:00:00'),
    (179, 3.54, '2026-10-04 20:00:00'),
    (179, 2.06, '2026-10-04 23:00:00'),
    (179, 1.20, '2026-10-05 02:00:00'),
    (179, 1.38, '2026-10-05 05:00:00'),
    (179, 2.20, '2026-10-05 08:00:00'),
    (179, 2.38, '2026-10-05 11:00:00'),
    (179, 3.17, '2026-10-05 14:00:00'),
    (179, 2.69, '2026-10-05 17:00:00'),
    (179, 2.19, '2026-10-05 20:00:00'),
    (179, 2.81, '2026-10-05 23:00:00'),
    (179, 3.18, '2026-10-06 02:00:00'),
    (179, 1.21, '2026-10-06 05:00:00'),
    (179, 3.63, '2026-10-06 08:00:00'),
    (179, 3.82, '2026-10-06 11:00:00'),
    (179, 2.63, '2026-10-06 14:00:00'),
    (179, 1.84, '2026-10-06 17:00:00');

-- Mercado Boa Vista ME | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (180, -21.50, '2026-10-04 08:00:00'),
    (180, -23.38, '2026-10-04 11:00:00'),
    (180, -20.57, '2026-10-04 14:00:00'),
    (180, -23.10, '2026-10-04 17:00:00'),
    (180, -21.30, '2026-10-04 20:00:00'),
    (180, -19.67, '2026-10-04 23:00:00'),
    (180, -20.23, '2026-10-05 02:00:00'),
    (180, -21.08, '2026-10-05 05:00:00'),
    (180, -19.43, '2026-10-05 08:00:00'),
    (180, -19.69, '2026-10-05 11:00:00'),
    (180, -20.37, '2026-10-05 14:00:00'),
    (180, -21.22, '2026-10-05 17:00:00'),
    (180, -19.52, '2026-10-05 20:00:00'),
    (180, -20.65, '2026-10-05 23:00:00'),
    (180, -23.44, '2026-10-06 02:00:00'),
    (180, -22.69, '2026-10-06 05:00:00'),
    (180, -19.87, '2026-10-06 08:00:00'),
    (180, -20.07, '2026-10-06 11:00:00'),
    (180, -23.39, '2026-10-06 14:00:00'),
    (180, -23.59, '2026-10-06 17:00:00');

-- Laticínios Terra Fértil ME | Freezer Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (181, -21.66, '2026-10-04 08:00:00'),
    (181, -20.26, '2026-10-04 11:00:00'),
    (181, -20.59, '2026-10-04 14:00:00'),
    (181, -20.36, '2026-10-04 17:00:00'),
    (181, -21.36, '2026-10-04 20:00:00'),
    (181, -22.63, '2026-10-04 23:00:00'),
    (181, -20.81, '2026-10-05 02:00:00'),
    (181, -20.50, '2026-10-05 05:00:00'),
    (181, -23.20, '2026-10-05 08:00:00'),
    (181, -19.93, '2026-10-05 11:00:00'),
    (181, -21.40, '2026-10-05 14:00:00'),
    (181, -20.30, '2026-10-05 17:00:00'),
    (181, -21.54, '2026-10-05 20:00:00'),
    (181, -22.03, '2026-10-05 23:00:00'),
    (181, -22.60, '2026-10-06 02:00:00'),
    (181, -21.38, '2026-10-06 05:00:00'),
    (181, -20.13, '2026-10-06 08:00:00'),
    (181, -21.94, '2026-10-06 11:00:00'),
    (181, -22.25, '2026-10-06 14:00:00'),
    (181, -19.88, '2026-10-06 17:00:00');

-- Laticínios Terra Fértil ME | Refrigerador 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (182, 6.05, '2026-10-04 08:00:00'),
    (182, 4.66, '2026-10-04 11:00:00'),
    (182, 5.50, '2026-10-04 14:00:00'),
    (182, 4.08, '2026-10-04 17:00:00'),
    (182, 5.71, '2026-10-04 20:00:00'),
    (182, 5.85, '2026-10-04 23:00:00'),
    (182, 6.73, '2026-10-05 02:00:00'),
    (182, 6.77, '2026-10-05 05:00:00'),
    (182, 6.56, '2026-10-05 08:00:00'),
    (182, 3.63, '2026-10-05 11:00:00'),
    (182, 3.31, '2026-10-05 14:00:00'),
    (182, 5.91, '2026-10-05 17:00:00'),
    (182, 6.77, '2026-10-05 20:00:00'),
    (182, 4.48, '2026-10-05 23:00:00'),
    (182, 4.15, '2026-10-06 02:00:00'),
    (182, 5.70, '2026-10-06 05:00:00'),
    (182, 6.13, '2026-10-06 08:00:00'),
    (182, 6.51, '2026-10-06 11:00:00'),
    (182, 5.11, '2026-10-06 14:00:00'),
    (182, 3.31, '2026-10-06 17:00:00');

-- Restaurante Vale Verde | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (183, 5.81, '2026-10-04 08:00:00'),
    (183, 4.47, '2026-10-04 11:00:00'),
    (183, 4.61, '2026-10-04 14:00:00'),
    (183, 5.86, '2026-10-04 17:00:00'),
    (183, 4.15, '2026-10-04 20:00:00'),
    (183, 4.43, '2026-10-04 23:00:00'),
    (183, 5.48, '2026-10-05 02:00:00'),
    (183, 4.08, '2026-10-05 05:00:00'),
    (183, 4.33, '2026-10-05 08:00:00'),
    (183, 4.26, '2026-10-05 11:00:00'),
    (183, 4.94, '2026-10-05 14:00:00'),
    (183, 5.17, '2026-10-05 17:00:00'),
    (183, 4.58, '2026-10-05 20:00:00'),
    (183, 5.58, '2026-10-05 23:00:00'),
    (183, 4.19, '2026-10-06 02:00:00'),
    (183, 6.04, '2026-10-06 05:00:00'),
    (183, 5.78, '2026-10-06 08:00:00'),
    (183, 5.29, '2026-10-06 11:00:00'),
    (183, 5.30, '2026-10-06 14:00:00'),
    (183, 4.54, '2026-10-06 17:00:00');

-- Restaurante Vale Verde | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (184, -20.58, '2026-10-04 08:00:00'),
    (184, -22.46, '2026-10-04 11:00:00'),
    (184, -22.27, '2026-10-04 14:00:00'),
    (184, -20.84, '2026-10-04 17:00:00'),
    (184, -21.46, '2026-10-04 20:00:00'),
    (184, -20.36, '2026-10-04 23:00:00'),
    (184, -21.30, '2026-10-05 02:00:00'),
    (184, -20.44, '2026-10-05 05:00:00'),
    (184, -21.13, '2026-10-05 08:00:00'),
    (184, -21.64, '2026-10-05 11:00:00'),
    (184, -20.36, '2026-10-05 14:00:00'),
    (184, -20.28, '2026-10-05 17:00:00'),
    (184, -21.50, '2026-10-05 20:00:00'),
    (184, -21.55, '2026-10-05 23:00:00'),
    (184, -20.81, '2026-10-06 02:00:00'),
    (184, -21.96, '2026-10-06 05:00:00'),
    (184, -22.65, '2026-10-06 08:00:00'),
    (184, -20.69, '2026-10-06 11:00:00'),
    (184, -22.51, '2026-10-06 14:00:00'),
    (184, -22.26, '2026-10-06 17:00:00');

-- Açougue Estrela do Sul Ltda. | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (185, -20.72, '2026-10-04 08:00:00'),
    (185, -18.52, '2026-10-04 11:00:00'),
    (185, -19.07, '2026-10-04 14:00:00'),
    (185, -20.38, '2026-10-04 17:00:00'),
    (185, -19.20, '2026-10-04 20:00:00'),
    (185, -19.79, '2026-10-04 23:00:00'),
    (185, -21.08, '2026-10-05 02:00:00'),
    (185, -19.16, '2026-10-05 05:00:00'),
    (185, -19.15, '2026-10-05 08:00:00'),
    (185, -21.19, '2026-10-05 11:00:00'),
    (185, -21.40, '2026-10-05 14:00:00'),
    (185, -20.40, '2026-10-05 17:00:00'),
    (185, -16.30, '2026-10-05 20:00:00'),
    (185, -21.46, '2026-10-05 23:00:00'),
    (185, -18.59, '2026-10-06 02:00:00'),
    (185, -18.99, '2026-10-06 05:00:00'),
    (185, -20.65, '2026-10-06 08:00:00'),
    (185, -20.66, '2026-10-06 11:00:00'),
    (185, -20.81, '2026-10-06 14:00:00'),
    (185, -19.09, '2026-10-06 17:00:00');

-- Açougue Estrela do Sul Ltda. | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (186, 5.09, '2026-10-04 08:00:00'),
    (186, 2.99, '2026-10-04 11:00:00'),
    (186, 5.91, '2026-10-04 14:00:00'),
    (186, 5.90, '2026-10-04 17:00:00'),
    (186, 5.05, '2026-10-04 20:00:00'),
    (186, 4.81, '2026-10-04 23:00:00'),
    (186, 3.96, '2026-10-05 02:00:00'),
    (186, 3.85, '2026-10-05 05:00:00'),
    (186, 9.55, '2026-10-05 08:00:00'),
    (186, 5.80, '2026-10-05 11:00:00'),
    (186, 4.97, '2026-10-05 14:00:00'),
    (186, 4.98, '2026-10-05 17:00:00'),
    (186, 6.94, '2026-10-05 20:00:00'),
    (186, 6.97, '2026-10-05 23:00:00'),
    (186, 5.54, '2026-10-06 02:00:00'),
    (186, 2.98, '2026-10-06 05:00:00'),
    (186, 8.51, '2026-10-06 08:00:00'),
    (186, -0.44, '2026-10-06 11:00:00'),
    (186, 1.04, '2026-10-06 14:00:00'),
    (186, 3.64, '2026-10-06 17:00:00');

-- Supermercado Terra Fértil | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (187, 6.73, '2026-10-04 08:00:00'),
    (187, 4.95, '2026-10-04 11:00:00'),
    (187, 3.27, '2026-10-04 14:00:00'),
    (187, 6.60, '2026-10-04 17:00:00'),
    (187, 6.72, '2026-10-04 20:00:00'),
    (187, 6.48, '2026-10-04 23:00:00'),
    (187, 4.84, '2026-10-05 02:00:00'),
    (187, 4.03, '2026-10-05 05:00:00'),
    (187, 6.42, '2026-10-05 08:00:00'),
    (187, 4.92, '2026-10-05 11:00:00'),
    (187, 5.66, '2026-10-05 14:00:00'),
    (187, 6.67, '2026-10-05 17:00:00'),
    (187, 5.39, '2026-10-05 20:00:00'),
    (187, 6.00, '2026-10-05 23:00:00'),
    (187, 4.65, '2026-10-06 02:00:00'),
    (187, 6.45, '2026-10-06 05:00:00'),
    (187, 5.79, '2026-10-06 08:00:00'),
    (187, 5.96, '2026-10-06 11:00:00'),
    (187, 3.46, '2026-10-06 14:00:00'),
    (187, 4.09, '2026-10-06 17:00:00');

-- Supermercado Terra Fértil | Freezer 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (188, -20.96, '2026-10-04 08:00:00'),
    (188, -21.09, '2026-10-04 11:00:00'),
    (188, -19.91, '2026-10-04 14:00:00'),
    (188, -20.46, '2026-10-04 17:00:00'),
    (188, -19.57, '2026-10-04 20:00:00'),
    (188, -19.65, '2026-10-04 23:00:00'),
    (188, -20.50, '2026-10-05 02:00:00'),
    (188, -19.32, '2026-10-05 05:00:00'),
    (188, -20.78, '2026-10-05 08:00:00'),
    (188, -20.17, '2026-10-05 11:00:00'),
    (188, -19.91, '2026-10-05 14:00:00'),
    (188, -18.94, '2026-10-05 17:00:00'),
    (188, -18.98, '2026-10-05 20:00:00'),
    (188, -19.41, '2026-10-05 23:00:00'),
    (188, -19.89, '2026-10-06 02:00:00'),
    (188, -20.72, '2026-10-06 05:00:00'),
    (188, -19.34, '2026-10-06 08:00:00'),
    (188, -19.46, '2026-10-06 11:00:00'),
    (188, -20.19, '2026-10-06 14:00:00'),
    (188, -20.96, '2026-10-06 17:00:00');

-- Laticínios Alvorada | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (189, 4.78, '2026-10-04 08:00:00'),
    (189, 3.83, '2026-10-04 11:00:00'),
    (189, 5.35, '2026-10-04 14:00:00'),
    (189, 6.09, '2026-10-04 17:00:00'),
    (189, 3.67, '2026-10-04 20:00:00'),
    (189, 6.64, '2026-10-04 23:00:00'),
    (189, 6.86, '2026-10-05 02:00:00'),
    (189, 6.96, '2026-10-05 05:00:00'),
    (189, 4.88, '2026-10-05 08:00:00'),
    (189, 2.87, '2026-10-05 11:00:00'),
    (189, 4.82, '2026-10-05 14:00:00'),
    (189, 2.97, '2026-10-05 17:00:00'),
    (189, -0.92, '2026-10-05 20:00:00'),
    (189, 6.04, '2026-10-05 23:00:00'),
    (189, 5.75, '2026-10-06 02:00:00'),
    (189, 4.03, '2026-10-06 05:00:00'),
    (189, 4.77, '2026-10-06 08:00:00'),
    (189, 3.21, '2026-10-06 11:00:00'),
    (189, 10.44, '2026-10-06 14:00:00'),
    (189, 6.19, '2026-10-06 17:00:00');

-- Laticínios Alvorada | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (190, 7.03, '2026-10-04 08:00:00'),
    (190, 7.04, '2026-10-04 11:00:00'),
    (190, 10.28, '2026-10-04 14:00:00'),
    (190, 5.09, '2026-10-04 17:00:00'),
    (190, 7.25, '2026-10-04 20:00:00'),
    (190, 10.08, '2026-10-04 23:00:00'),
    (190, 7.18, '2026-10-05 02:00:00'),
    (190, 6.63, '2026-10-05 05:00:00'),
    (190, 2.91, '2026-10-05 08:00:00'),
    (190, 4.48, '2026-10-05 11:00:00'),
    (190, 6.05, '2026-10-05 14:00:00'),
    (190, 2.84, '2026-10-05 17:00:00'),
    (190, 3.02, '2026-10-05 20:00:00'),
    (190, 3.75, '2026-10-05 23:00:00'),
    (190, 4.90, '2026-10-06 02:00:00'),
    (190, 5.13, '2026-10-06 05:00:00'),
    (190, 3.34, '2026-10-06 08:00:00'),
    (190, 7.13, '2026-10-06 11:00:00'),
    (190, 6.21, '2026-10-06 14:00:00'),
    (190, 4.29, '2026-10-06 17:00:00');

-- Frigorífico Boa Vista ME | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (191, 4.92, '2026-10-04 08:00:00'),
    (191, 6.60, '2026-10-04 11:00:00'),
    (191, 6.01, '2026-10-04 14:00:00'),
    (191, 4.52, '2026-10-04 17:00:00'),
    (191, 5.44, '2026-10-04 20:00:00'),
    (191, 5.57, '2026-10-04 23:00:00'),
    (191, 5.39, '2026-10-05 02:00:00'),
    (191, 3.97, '2026-10-05 05:00:00'),
    (191, 3.40, '2026-10-05 08:00:00'),
    (191, 5.95, '2026-10-05 11:00:00'),
    (191, 5.85, '2026-10-05 14:00:00'),
    (191, 3.73, '2026-10-05 17:00:00'),
    (191, 10.79, '2026-10-05 20:00:00'),
    (191, 4.08, '2026-10-05 23:00:00'),
    (191, 3.53, '2026-10-06 02:00:00'),
    (191, 5.84, '2026-10-06 05:00:00'),
    (191, 5.50, '2026-10-06 08:00:00'),
    (191, 4.18, '2026-10-06 11:00:00'),
    (191, 6.71, '2026-10-06 14:00:00'),
    (191, 4.40, '2026-10-06 17:00:00');

-- Frigorífico Boa Vista ME | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (192, 3.81, '2026-10-04 08:00:00'),
    (192, 6.19, '2026-10-04 11:00:00'),
    (192, 4.68, '2026-10-04 14:00:00'),
    (192, 5.76, '2026-10-04 17:00:00'),
    (192, 4.31, '2026-10-04 20:00:00'),
    (192, 4.70, '2026-10-04 23:00:00'),
    (192, 5.08, '2026-10-05 02:00:00'),
    (192, 4.58, '2026-10-05 05:00:00'),
    (192, 6.53, '2026-10-05 08:00:00'),
    (192, 6.18, '2026-10-05 11:00:00'),
    (192, 4.62, '2026-10-05 14:00:00'),
    (192, 3.55, '2026-10-05 17:00:00'),
    (192, 6.20, '2026-10-05 20:00:00'),
    (192, 5.82, '2026-10-05 23:00:00'),
    (192, 6.01, '2026-10-06 02:00:00'),
    (192, 5.45, '2026-10-06 05:00:00'),
    (192, 6.71, '2026-10-06 08:00:00'),
    (192, 6.45, '2026-10-06 11:00:00'),
    (192, 5.70, '2026-10-06 14:00:00'),
    (192, 5.54, '2026-10-06 17:00:00');

-- Distribuidora Estrela do Sul ME | Refrigerador 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (193, 4.89, '2026-10-04 08:00:00'),
    (193, 6.49, '2026-10-04 11:00:00'),
    (193, 3.28, '2026-10-04 14:00:00'),
    (193, 0.23, '2026-10-04 17:00:00'),
    (193, 10.99, '2026-10-04 20:00:00'),
    (193, 6.26, '2026-10-04 23:00:00'),
    (193, 9.18, '2026-10-05 02:00:00'),
    (193, 6.10, '2026-10-05 05:00:00'),
    (193, 3.20, '2026-10-05 08:00:00'),
    (193, 4.90, '2026-10-05 11:00:00'),
    (193, 10.89, '2026-10-05 14:00:00'),
    (193, 3.67, '2026-10-05 17:00:00'),
    (193, 5.81, '2026-10-05 20:00:00'),
    (193, 5.29, '2026-10-05 23:00:00'),
    (193, 2.85, '2026-10-06 02:00:00'),
    (193, 3.85, '2026-10-06 05:00:00'),
    (193, 5.81, '2026-10-06 08:00:00'),
    (193, 5.85, '2026-10-06 11:00:00'),
    (193, 3.27, '2026-10-06 14:00:00'),
    (193, 3.81, '2026-10-06 17:00:00');

-- Distribuidora Estrela do Sul ME | Freezer 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (194, -20.35, '2026-10-04 08:00:00'),
    (194, -19.60, '2026-10-04 11:00:00'),
    (194, -15.89, '2026-10-04 14:00:00'),
    (194, -18.98, '2026-10-04 17:00:00'),
    (194, -20.17, '2026-10-04 20:00:00'),
    (194, -20.03, '2026-10-04 23:00:00'),
    (194, -20.95, '2026-10-05 02:00:00'),
    (194, -18.85, '2026-10-05 05:00:00'),
    (194, -22.87, '2026-10-05 08:00:00'),
    (194, -19.25, '2026-10-05 11:00:00'),
    (194, -17.05, '2026-10-05 14:00:00'),
    (194, -18.45, '2026-10-05 17:00:00'),
    (194, -18.47, '2026-10-05 20:00:00'),
    (194, -20.78, '2026-10-05 23:00:00'),
    (194, -15.68, '2026-10-06 02:00:00'),
    (194, -20.75, '2026-10-06 05:00:00'),
    (194, -20.87, '2026-10-06 08:00:00'),
    (194, -18.64, '2026-10-06 11:00:00'),
    (194, -19.13, '2026-10-06 14:00:00'),
    (194, -18.51, '2026-10-06 17:00:00');

-- Açougue Pão Dourado ME | Freezer 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (195, -20.08, '2026-10-04 08:00:00'),
    (195, -19.39, '2026-10-04 11:00:00'),
    (195, -20.05, '2026-10-04 14:00:00'),
    (195, -20.06, '2026-10-04 17:00:00'),
    (195, -19.42, '2026-10-04 20:00:00'),
    (195, -20.11, '2026-10-04 23:00:00'),
    (195, -19.66, '2026-10-05 02:00:00'),
    (195, -20.07, '2026-10-05 05:00:00'),
    (195, -19.99, '2026-10-05 08:00:00'),
    (195, -19.93, '2026-10-05 11:00:00'),
    (195, -19.63, '2026-10-05 14:00:00'),
    (195, -19.75, '2026-10-05 17:00:00'),
    (195, -20.64, '2026-10-05 20:00:00'),
    (195, -19.72, '2026-10-05 23:00:00'),
    (195, -20.16, '2026-10-06 02:00:00'),
    (195, -20.25, '2026-10-06 05:00:00'),
    (195, -20.03, '2026-10-06 08:00:00'),
    (195, -20.57, '2026-10-06 11:00:00'),
    (195, -19.46, '2026-10-06 14:00:00'),
    (195, -19.88, '2026-10-06 17:00:00');

-- Açougue Pão Dourado ME | Refrigerador Industrial 01
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (196, 5.00, '2026-10-04 08:00:00'),
    (196, 4.90, '2026-10-04 11:00:00'),
    (196, 5.02, '2026-10-04 14:00:00'),
    (196, 5.82, '2026-10-04 17:00:00'),
    (196, 5.49, '2026-10-04 20:00:00'),
    (196, 5.21, '2026-10-04 23:00:00'),
    (196, 5.10, '2026-10-05 02:00:00'),
    (196, 4.76, '2026-10-05 05:00:00'),
    (196, 6.03, '2026-10-05 08:00:00'),
    (196, 4.70, '2026-10-05 11:00:00'),
    (196, 4.15, '2026-10-05 14:00:00'),
    (196, 5.31, '2026-10-05 17:00:00'),
    (196, 5.03, '2026-10-05 20:00:00'),
    (196, 5.13, '2026-10-05 23:00:00'),
    (196, 5.43, '2026-10-06 02:00:00'),
    (196, 5.58, '2026-10-06 05:00:00'),
    (196, 5.08, '2026-10-06 08:00:00'),
    (196, 4.01, '2026-10-06 11:00:00'),
    (196, 4.37, '2026-10-06 14:00:00'),
    (196, 4.08, '2026-10-06 17:00:00');

-- Restaurante Pão Dourado | Refrigerador 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (197, 5.08, '2026-10-04 08:00:00'),
    (197, 4.74, '2026-10-04 11:00:00'),
    (197, 3.68, '2026-10-04 14:00:00'),
    (197, 6.78, '2026-10-04 17:00:00'),
    (197, 4.28, '2026-10-04 20:00:00'),
    (197, 3.91, '2026-10-04 23:00:00'),
    (197, 5.50, '2026-10-05 02:00:00'),
    (197, 6.30, '2026-10-05 05:00:00'),
    (197, 3.80, '2026-10-05 08:00:00'),
    (197, 3.57, '2026-10-05 11:00:00'),
    (197, 4.57, '2026-10-05 14:00:00'),
    (197, 5.44, '2026-10-05 17:00:00'),
    (197, 6.72, '2026-10-05 20:00:00'),
    (197, 6.14, '2026-10-05 23:00:00'),
    (197, 4.97, '2026-10-06 02:00:00'),
    (197, 3.81, '2026-10-06 05:00:00'),
    (197, 4.44, '2026-10-06 08:00:00'),
    (197, 5.34, '2026-10-06 11:00:00'),
    (197, 4.01, '2026-10-06 14:00:00'),
    (197, 5.93, '2026-10-06 17:00:00');

-- Restaurante Pão Dourado | Refrigerador Industrial 03
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (198, 3.70, '2026-10-04 08:00:00'),
    (198, 6.47, '2026-10-04 11:00:00'),
    (198, 5.81, '2026-10-04 14:00:00'),
    (198, 6.16, '2026-10-04 17:00:00'),
    (198, 6.01, '2026-10-04 20:00:00'),
    (198, 9.82, '2026-10-04 23:00:00'),
    (198, 6.52, '2026-10-05 02:00:00'),
    (198, 4.18, '2026-10-05 05:00:00'),
    (198, 5.30, '2026-10-05 08:00:00'),
    (198, 4.98, '2026-10-05 11:00:00'),
    (198, 5.74, '2026-10-05 14:00:00'),
    (198, 5.32, '2026-10-05 17:00:00'),
    (198, 5.62, '2026-10-05 20:00:00'),
    (198, 3.99, '2026-10-05 23:00:00'),
    (198, 5.73, '2026-10-06 02:00:00'),
    (198, 5.62, '2026-10-06 05:00:00'),
    (198, 6.38, '2026-10-06 08:00:00'),
    (198, 5.87, '2026-10-06 11:00:00'),
    (198, 4.30, '2026-10-06 14:00:00'),
    (198, 6.55, '2026-10-06 17:00:00');

-- Açougue Campo Belo | Câmara Fria 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (199, 2.20, '2026-10-04 08:00:00'),
    (199, 3.09, '2026-10-04 11:00:00'),
    (199, 2.68, '2026-10-04 14:00:00'),
    (199, 3.58, '2026-10-04 17:00:00'),
    (199, 0.71, '2026-10-04 20:00:00'),
    (199, 2.84, '2026-10-04 23:00:00'),
    (199, 0.73, '2026-10-05 02:00:00'),
    (199, 1.08, '2026-10-05 05:00:00'),
    (199, 3.55, '2026-10-05 08:00:00'),
    (199, 4.00, '2026-10-05 11:00:00'),
    (199, 3.69, '2026-10-05 14:00:00'),
    (199, 1.52, '2026-10-05 17:00:00'),
    (199, 2.26, '2026-10-05 20:00:00'),
    (199, 1.79, '2026-10-05 23:00:00'),
    (199, 0.75, '2026-10-06 02:00:00'),
    (199, 4.36, '2026-10-06 05:00:00'),
    (199, 3.07, '2026-10-06 08:00:00'),
    (199, 2.32, '2026-10-06 11:00:00'),
    (199, 4.19, '2026-10-06 14:00:00'),
    (199, 0.69, '2026-10-06 17:00:00');

-- Açougue Campo Belo | Freezer Industrial 02
INSERT INTO leituras_temperatura (equipamento_id, temperatura, registrada_em) VALUES
    (200, -22.07, '2026-10-04 08:00:00'),
    (200, -19.54, '2026-10-04 11:00:00'),
    (200, -21.03, '2026-10-04 14:00:00'),
    (200, -19.15, '2026-10-04 17:00:00'),
    (200, -19.64, '2026-10-04 20:00:00'),
    (200, -19.65, '2026-10-04 23:00:00'),
    (200, -19.68, '2026-10-05 02:00:00'),
    (200, -18.90, '2026-10-05 05:00:00'),
    (200, -24.07, '2026-10-05 08:00:00'),
    (200, -21.41, '2026-10-05 11:00:00'),
    (200, -19.09, '2026-10-05 14:00:00'),
    (200, -15.82, '2026-10-05 17:00:00'),
    (200, -21.57, '2026-10-05 20:00:00'),
    (200, -22.90, '2026-10-05 23:00:00'),
    (200, -20.59, '2026-10-06 02:00:00'),
    (200, -19.77, '2026-10-06 05:00:00'),
    (200, -23.41, '2026-10-06 08:00:00'),
    (200, -27.06, '2026-10-06 11:00:00'),
    (200, -21.84, '2026-10-06 14:00:00'),
    (200, -20.94, '2026-10-06 17:00:00');


-- ============================================================
-- CONTATOS FICTÍCIOS PARA TESTE
-- ============================================================

INSERT INTO contatos
    (nome, email, telefone, empresa, mensagem)
VALUES
    ('Carlos Almeida', 'carlos@pão.com.br', '(11) 98888-1001', 'Laticínios Pão Dourado', 'Gostaria de conhecer a solução de monitoramento de temperatura.'),
    ('Mariana Souza', 'mariana@nova.com.br', '(11) 97777-2002', 'Mercado Nova Safra Ltda.', 'Gostaria de saber como funciona o acompanhamento das temperaturas.'),
    ('Rafael Oliveira', 'rafael@sabor.com.br', '(11) 96666-3003', 'Supermercado Sabor Real', 'Tenho interesse no sistema TempControl.'),
    ('Juliana Santos', 'juliana@terra.com.br', '(11) 95555-4004', 'Distribuidora Terra Fértil S.A.', 'Gostaria de obter mais informações sobre o monitoramento.'),
    ('Lucas Pereira', 'lucas@sabor.com.br', '(11) 94444-5005', 'Hortifruti Sabor Real Ltda.', 'Quero conhecer melhor a solução.');


-- ============================================================
-- CONSULTAS DE CONFERÊNCIA
-- ============================================================

SELECT COUNT(DISTINCT empresa) AS total_empresas FROM equipamentos;
SELECT COUNT(*) AS total_equipamentos FROM equipamentos;
SELECT COUNT(*) AS total_leituras FROM leituras_temperatura;

-- Média e conformidade por empresa
SELECT
    e.empresa,
    COUNT(DISTINCT e.equipamento_id) AS equipamentos,
    COUNT(l.leitura_id) AS leituras,
    ROUND(AVG(l.temperatura), 2) AS temperatura_media,
    ROUND(100 * SUM(l.temperatura BETWEEN e.temp_min AND e.temp_max) / COUNT(*), 1) AS conformidade
FROM equipamentos e
INNER JOIN leituras_temperatura l
    ON e.equipamento_id = l.equipamento_id
GROUP BY e.empresa
ORDER BY conformidade DESC, e.empresa
LIMIT 10;


USE tempcontrol;

-- ============================================================
-- GERAR DATAS E HORARIOS ALEATORIOS
-- 25 primeiras empresas: equipamentos de ID 1 a 50.
-- Cada leitura recebe uma data e um horario aleatorios.
-- As datas ficam entre 01/10/2026 e 27/10/2026.
-- ATENCAO: este UPDATE modifica as datas salvas no banco.
-- Execute novamente para sortear novas datas e horarios.
-- ============================================================

UPDATE leituras_temperatura
SET registrada_em = TIMESTAMP(
    DATE_ADD(
        '2026-10-01',
        INTERVAL FLOOR(RAND() * 27) DAY
    ),
    MAKETIME(
        FLOOR(RAND() * 24),
        FLOOR(RAND() * 60),
        FLOOR(RAND() * 60)
    )
)
WHERE equipamento_id BETWEEN 1 AND 50;


-- ============================================================
-- 1. CONSULTA COM FUNCOES DE DATA
-- Uma leitura aleatoria de cada uma das 25 empresas.
-- ============================================================

WITH leituras_aleatorias AS (
    SELECT
        e.empresa,
        e.nome AS equipamento,
        l.temperatura,
        l.registrada_em,
        MIN(e.equipamento_id) OVER (
            PARTITION BY e.empresa
        ) AS ordem_empresa,
        ROW_NUMBER() OVER (
            PARTITION BY e.empresa
            ORDER BY RAND()
        ) AS sorteio
    FROM equipamentos AS e
    INNER JOIN leituras_temperatura AS l
        ON e.equipamento_id = l.equipamento_id
    WHERE e.equipamento_id BETWEEN 1 AND 50
)
SELECT
    empresa,
    equipamento,
    temperatura,
    DATE_FORMAT(
        registrada_em,
        '%d/%m/%Y %H:%i:%s'
    ) AS data_hora_leitura,
    DATEDIFF(
        CURDATE(),
        DATE(registrada_em)
    ) AS dias_desde_leitura
FROM leituras_aleatorias
WHERE sorteio = 1
ORDER BY ordem_empresa;


-- ============================================================
-- 2. CONSULTA COM FUNCOES DE TEXTO
-- Padroniza as empresas e agrupa seus equipamentos.
-- ============================================================

SELECT
    UPPER(TRIM(e.empresa)) AS empresa_formatada,
    GROUP_CONCAT(
        DISTINCT TRIM(e.nome)
        ORDER BY TRIM(e.nome)
        SEPARATOR ', '
    ) AS equipamentos,
    COUNT(DISTINCT e.equipamento_id) AS total_equipamentos
FROM equipamentos AS e
WHERE e.equipamento_id BETWEEN 1 AND 50
GROUP BY e.empresa
ORDER BY MIN(e.equipamento_id);


-- ============================================================
-- 3. CONSULTA DE QUALIDADE DOS DADOS
-- Verifica temperaturas fora da faixa e datas futuras.
-- ============================================================

SELECT
    e.empresa,
    COUNT(DISTINCT e.equipamento_id) AS total_equipamentos,
    COUNT(l.leitura_id) AS total_leituras,

    SUM(
        CASE
            WHEN l.temperatura < e.temp_min
              OR l.temperatura > e.temp_max
            THEN 1
            ELSE 0
        END
    ) AS leituras_fora_faixa,

    SUM(
        CASE
            WHEN l.registrada_em > NOW()
            THEN 1
            ELSE 0
        END
    ) AS datas_futuras

FROM equipamentos AS e
INNER JOIN leituras_temperatura AS l
    ON e.equipamento_id = l.equipamento_id

WHERE e.equipamento_id BETWEEN 1 AND 50

GROUP BY e.empresa
ORDER BY MIN(e.equipamento_id);
