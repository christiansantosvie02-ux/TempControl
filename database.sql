
CREATE DATABASE IF NOT EXISTS tempcontrol
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tempcontrol;

CREATE TABLE IF NOT EXISTS contatos (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL,
    telefone VARCHAR(30) NULL,
    empresa VARCHAR(160) NULL,
    mensagem VARCHAR(2000) NOT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    INDEX idx_contatos_email (email),
    INDEX idx_contatos_criado_em (criado_em)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;
