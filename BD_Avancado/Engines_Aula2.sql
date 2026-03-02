/*
CONSULTA 1:
*/

-- criando as tabelas
CREATE TABLE categoria (
id_categoria INT AUTO_INCREMENT PRIMARY KEY,
ds_categoria VARCHAR(50)
);

CREATE TABLE produto (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
nm_produto CHAR(50) DEFAULT 'sem nome',
id_categoria INT REFERENCES categoria(id_categoria)
);

-- povoando as tabelas
INSERT INTO categoria (ds_categoria) VALUES ('Processador'),('Memória'),('SSD');
INSERT INTO produto (nm_produto, id_categoria) VALUES ('Intel I5', 1);
INSERT INTO produto (nm_produto, id_categoria) VALUES ('Monitor Full HD 29pol', 5);

-- descrevendo a estrutura criada
DESC categoria;
DESC produto;

-- selecionando informações das tabelas
SELECT * FROM categoria;
SELECT * FROM produto;

-- selecionando informação da versão
SELECT VERSION();

-- verificando a engine padrão
SHOW GLOBAL VARIABLES LIKE "default_storage%";

-- selecionando informações do banco
SELECT tbs.TABLE_SCHEMA, tbs.`TABLE_NAME`, tbs.`ENGINE`, tbs.`ROW_FORMAT`
FROM information_schema.`TABLES` tbs
WHERE tbs.TABLE_SCHEMA = 'bd_turma_mat';


/*
CONSULTA 2:
*/

-- criando as tabelas
CREATE TABLE categoria_myisam (
id_categoria INT AUTO_INCREMENT PRIMARY KEY,
ds_categoria VARCHAR(50)
)ENGINE=myisam;

CREATE TABLE produto_myisam (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
nm_produto CHAR(50) DEFAULT 'sem nome',
id_categoria INT REFERENCES categoria_myisam(id_categoria)
)ENGINE=MYISAM;

-- alterando tabelas para usar a engine myisam (não funcionou pois as tabelas estão interligadas e não podem ter engines (inferiores?) diferentes
ALTER TABLE categoria_myisam ENGINE=MYISAM;
ALTER TABLE produto_myisam ENGINE=MYISAM;

-- dropando as tabelas para cria-las novamente com a engine correta
DROP TABLE produto_myisam;
DROP TABLE categoria_myisam;

-- povoando as tabelas
INSERT INTO categoria_myisam (ds_categoria) VALUES ('Processador'),('Memória'),('SSD');
INSERT INTO produto_myisam (nm_produto, id_categoria) VALUES ('Intel I5', 1);
INSERT INTO produto_myisam (nm_produto, id_categoria) VALUES ('Monitor Full HD 29pol', 5);

-- selecionando informações das tabelas
SELECT * FROM categoria_myisam;
SELECT * FROM produto_myisam;

-- selecionando informações do banco
SELECT tbs.TABLE_SCHEMA, tbs.`TABLE_NAME`, tbs.`ENGINE`, tbs.`ROW_FORMAT`
FROM information_schema.`TABLES` tbs
WHERE tbs.TABLE_SCHEMA = 'bd_turma_mat';


/*
CONSULTA 3:
*/

-- criando as tabelas
CREATE TABLE categoria_memory (
id_categoria INT AUTO_INCREMENT PRIMARY KEY,
ds_categoria VARCHAR(50)
)ENGINE=memory;

CREATE TABLE produto_memory (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
nm_produto CHAR(50) DEFAULT 'sem nome',
id_categoria INT REFERENCES categoria_memory(id_categoria)
)ENGINE=memory;

-- povoando as tabelas
INSERT INTO categoria_memory (ds_categoria) VALUES ('Processador'),('Memória'),('SSD');
INSERT INTO produto_memory (nm_produto, id_categoria) VALUES ('Intel I5', 1);
INSERT INTO produto_memory (nm_produto, id_categoria) VALUES ('Monitor Full HD 29pol', 5);

-- selecionando informações das tabelas
SELECT * FROM categoria_memory;
SELECT * FROM produto_memory;

-- selecionando informações do banco
SELECT tbs.TABLE_SCHEMA, tbs.`TABLE_NAME`, tbs.`ENGINE`, tbs.`ROW_FORMAT`
FROM information_schema.`TABLES` tbs
WHERE tbs.TABLE_SCHEMA = 'bd_turma_mat';


/*
CONSULTA 4:
*/

-- criando as tabelas
CREATE TABLE categoria_csv (
id_categoria INT NOT NULL,
ds_categoria VARCHAR(50) NOT NULL 
)ENGINE=CSV;

-- povoando as tabelas
INSERT INTO categoria_csv VALUES (1, 'Processador'),(2, 'Memória'),(3, 'SSD');