CREATE TABLE pessoa2
AS 
 SELECT CONCAT(p.id,' - ',p.nome,' - ',p.email,' - ',p.empresa,' - ',p.departamento,' - ',p.cor,' - ',p.marca_automovel,' - ',p.alimentos) 
 AS dados -- este "concat" vai juntar todos os dados em um literal 
 FROM pessoa p;

-- alterando o tipo da tabela
ALTER TABLE pessoa2 ENGINE=MYISAM;

-- identificando os índices de uma tabela
SHOW INDEXES FROM pessoa2;

-- criando índice para a coluna de dados
CREATE INDEX pessoa2_dados_idx ON pessoa2(dados);

-- criando um índice fulltext para a coluna dados
CREATE FULLTEXT INDEX pessoa2_dados_idx_full ON pessoa2(dados);

INSERT INTO pessoa2 SELECT * FROM pessoa2;

-- index padrão
EXPLAIN 
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '333111%';

EXPLAIN
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '%guisado%';

EXPLAIN
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '%microsoft%';

EXPLAIN
SELECT *
FROM pessoa2 p2
WHERE p2.dados LIKE '%microsoft%' AND p2.dados LIKE '%azul%' AND p2.dados NOT LIKE '%sopas%' AND p2.dados LIKE '%lex%';

-- index fulltext
EXPLAIN 
SELECT *
FROM pessoa2 p2
WHERE MATCH(p2.dados) AGAINST('guisados');

EXPLAIN 
SELECT *
FROM pessoa2 p2
WHERE MATCH(p2.dados) AGAINST('+microsoft +azul -sopas +lex*' IN BOOLEAN MODE);
