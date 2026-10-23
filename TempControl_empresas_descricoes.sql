-- ============================================================
-- TEMPCONTROL | SOMENTE EMPRESAS E DESCRIÇÕES
-- 100 empresas fictícias.
-- As descrições foram inferidas a partir dos nomes e do contexto do banco;
-- não são descrições oficiais fornecidas pela fonte.
-- ============================================================

CREATE DATABASE IF NOT EXISTS tempcontrol CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE tempcontrol;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS empresas;

CREATE TABLE empresas (
    empresa_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(160) NOT NULL,
    descricao VARCHAR(500) NOT NULL,
    PRIMARY KEY (empresa_id),
    UNIQUE KEY uq_empresas_nome (nome)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO
    empresas (nome, descricao)
VALUES (
        'Laticínios Pão Dourado',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Mercado Nova Safra Ltda.',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Supermercado Sabor Real',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Distribuidora Terra Fértil S.A.',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Hortifruti Sabor Real Ltda.',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Mercado Terra Fértil Ltda.',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Padaria Pão Dourado',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Distribuidora Campo Belo S.A.',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Empório Alvorada Ltda.',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Frigorífico Pão Dourado ME',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Frigorífico Mar Azul Ltda.',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Laticínios Nova Safra ME',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Açougue Alvorada S.A.',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Supermercado Boa Vista S.A.',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Restaurante Boa Vista',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Restaurante Estrela do Sul & Cia',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Frigorífico Alvorada ME',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Laticínios Sabor Real ME',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Distribuidora Alvorada & Cia',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Frigorífico Vale Verde',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Frigorífico Sabor Real ME',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Empório Sabor Real Ltda.',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Frigorífico Campo Belo Ltda.',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Restaurante Mar Azul Ltda.',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Restaurante Terra Fértil ME',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Hortifruti Alvorada',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Supermercado Nova Safra & Cia',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Padaria Estrela do Sul S.A.',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Supermercado Mar Azul Ltda.',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Padaria Alvorada S.A.',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Distribuidora Boa Vista S.A.',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Distribuidora Sabor Real S.A.',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Frigorífico Estrela do Sul',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Hortifruti Mar Azul Ltda.',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Empório Campo Belo S.A.',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Supermercado Alvorada & Cia',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Hortifruti Campo Belo S.A.',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Açougue Terra Fértil',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Restaurante Nova Safra Ltda.',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Mercado Campo Belo Ltda.',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Laticínios Boa Vista S.A.',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Laticínios Campo Belo',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Padaria Sabor Real S.A.',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Frigorífico Nova Safra',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Empório Boa Vista Ltda.',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Distribuidora Mar Azul',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Açougue Vale Verde',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Padaria Terra Fértil ME',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Mercado Vale Verde',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Mercado Mar Azul S.A.',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Laticínios Mar Azul',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Açougue Boa Vista S.A.',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Empório Vale Verde & Cia',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Laticínios Estrela do Sul & Cia',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Açougue Mar Azul & Cia',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Supermercado Campo Belo & Cia',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Padaria Mar Azul Ltda.',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Empório Mar Azul & Cia',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Hortifruti Boa Vista',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Mercado Pão Dourado',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Açougue Sabor Real Ltda.',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Hortifruti Vale Verde S.A.',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Padaria Vale Verde & Cia',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Supermercado Vale Verde Ltda.',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Supermercado Pão Dourado Ltda.',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Empório Estrela do Sul ME',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Hortifruti Terra Fértil Ltda.',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Restaurante Campo Belo',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Distribuidora Pão Dourado',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Restaurante Sabor Real S.A.',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Frigorífico Terra Fértil Ltda.',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Laticínios Vale Verde & Cia',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Hortifruti Estrela do Sul ME',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Hortifruti Pão Dourado',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Mercado Estrela do Sul & Cia',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Mercado Alvorada',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Supermercado Estrela do Sul ME',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Padaria Nova Safra & Cia',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Restaurante Alvorada & Cia',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Açougue Nova Safra ME',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Padaria Campo Belo',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Empório Terra Fértil & Cia',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Empório Nova Safra',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Padaria Boa Vista ME',
        'Empresa fictícia do segmento de panificação, associada à conservação de ingredientes e produtos alimentícios.'
    ),
    (
        'Empório Pão Dourado S.A.',
        'Empresa fictícia do segmento de empório e comércio de alimentos, associada ao armazenamento refrigerado.'
    ),
    (
        'Distribuidora Vale Verde ME',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Distribuidora Nova Safra ME',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Mercado Sabor Real ME',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Hortifruti Nova Safra & Cia',
        'Empresa fictícia do segmento de hortifrúti, associada ao armazenamento refrigerado de frutas, verduras e legumes.'
    ),
    (
        'Mercado Boa Vista ME',
        'Empresa fictícia do segmento de mercado varejista, associada à conservação de alimentos refrigerados e congelados.'
    ),
    (
        'Laticínios Terra Fértil ME',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Restaurante Vale Verde',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Açougue Estrela do Sul Ltda.',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Supermercado Terra Fértil',
        'Empresa fictícia do segmento de supermercado, associada à conservação de alimentos em equipamentos refrigerados.'
    ),
    (
        'Laticínios Alvorada',
        'Empresa fictícia do segmento de laticínios, associada ao armazenamento refrigerado de produtos lácteos.'
    ),
    (
        'Frigorífico Boa Vista ME',
        'Empresa fictícia do segmento frigorífico, associada à refrigeração e ao armazenamento de produtos de origem animal.'
    ),
    (
        'Distribuidora Estrela do Sul ME',
        'Empresa fictícia do segmento de distribuição de alimentos, associada ao armazenamento e à logística refrigerada.'
    ),
    (
        'Açougue Pão Dourado ME',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    ),
    (
        'Restaurante Pão Dourado',
        'Empresa fictícia do segmento de alimentação e restaurante, associada à conservação de ingredientes e alimentos.'
    ),
    (
        'Açougue Campo Belo',
        'Empresa fictícia do segmento de açougue, associada à conservação refrigerada e congelada de carnes.'
    );