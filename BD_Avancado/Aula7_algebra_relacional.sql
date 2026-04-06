/*
bd_teste
*/

-- criando tabelas para exemplificar operações sobre a álgebra relacional
CREATE TABLE tab1 (tx VARCHAR(20));
CREATE TABLE tab2 (tx VARCHAR(20));

-- inserindo dados para os testes
INSERT INTO tab1 VALUE ('registro 1'), ('registro 2'), ('registro 3'), ('registro 4'); 
INSERT INTO tab2 VALUE ('registro 0'), ('registro 2'), ('registro 3'), ('registro 5'); 
SELECT * FROM tab1;
SELECT * FROM tab2;

-- para fazer essas operações, deve-se ter a mesma quantidade de dados (colunas) entre as tabelas

-- operações de UNION
SELECT * FROM tab1
UNION 
SELECT * FROM tab2;

SELECT * FROM tab1
UNION ALL 
SELECT * FROM tab2;

-- operações de INTERSECT
SELECT * FROM tab1
INTERSECT 
SELECT * FROM tab2;

-- operações de EXCEPT
SELECT * FROM tab1
EXCEPT
SELECT * FROM tab2;
-- ou
SELECT * FROM tab2
EXCEPT
SELECT * FROM tab1;

-- operação de produto cartesiano
SELECT * FROM tab1, tab2, tab1 t3;

/*
base_ceps_brasil
*/

CREATE TABLE ceps_do_brasil
AS
-- dados dos logradouros 
SELECT lg.nr_cep, lg.nm_logradouro_comp, ba.nm_bairro, lo.nm_localidade_comp, lg.sg_uf
FROM logradouro lg JOIN localidade lo ON (lg.cd_localidade = lo.cd_localidade)
                   JOIN bairro ba ON (lg.cd_bairro_inicio = ba.cd_bairro)                   
-- dados dos grandes usuários
UNION 
SELECT gu.nr_cep, lg.nm_logradouro_comp, ba.nm_bairro, lo.nm_localidade_comp, gu.sg_uf
FROM grande_usuario gu JOIN logradouro lg ON (gu.cd_logradouro = lg.cd_logradouro)
							  JOIN bairro ba ON (gu.cd_bairro = ba.cd_bairro)
							  JOIN localidade lo ON (gu.cd_localidade = lo.cd_localidade)							
-- dados das localidades
UNION 
SELECT lo.nr_cep, NULL, NULL, lo.nm_localidade_comp, lo.sg_uf
FROM localidade lo
WHERE lo.nr_cep IS NOT NULL;

SELECT *
FROM ceps_do_brasil cp
WHERE cp.nm_localidade_comp = 'blumenau';