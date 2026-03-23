/*
CONSULTA 1:
*/

-- exibe os índices de uma determinada tabela
SHOW INDEXES FROM localidade;

-- exibe os índices considerando filtros
SELECT st.`TABLE_NAME` AS tabela, st.INDEX_NAME AS indice, st.`COLUMN_NAME` AS coluna, st.NON_UNIQUE AS unico
FROM information_schema.STATISTICS st
WHERE st.TABLE_SCHEMA = 'base_ceps_brasil';

-- INDEX ordena os dados e depois faz uma busca binária para achar somente os valores desejados

EXPLAIN 
SELECT *
FROM localidade l
WHERE l.nm_localidade = 'blumenau';

EXPLAIN 
SELECT *
FROM localidade l
WHERE l.cd_localidade = '8377';

-- criando um índice para a coluna "nm_localidade"
CREATE INDEX localidade_nm_localidade_idx ON localidade(nm_localidade);

EXPLAIN 
SELECT *
FROM localidade l
WHERE l.nm_localidade LIKE 'São João%';

EXPLAIN 
SELECT *
FROM localidade l
WHERE l.nm_localidade LIKE '%João%';

EXPLAIN 
SELECT *
FROM localidade l
WHERE UPPER(l.nm_localidade) LIKE 'GASPAR';

-- criando um índice único para a coluna "nr_cep" em localidade
CREATE UNIQUE INDEX localidade_nr_cep_idx ON localidade(nr_cep);

SELECT COUNT(*)
FROM localidade l
WHERE l.nr_cep IS NULL;

EXPLAIN
SELECT *
FROM localidade l
WHERE l.nr_cep = '89460000';

/*
CONSULTA 2:
*/

-- identificando os dados do seu cep
EXPLAIN
SELECT lg.tp_logradouro, lg.nm_logradouro, b.nm_bairro, l.nm_localidade, lg.sg_uf, lg.nr_cep
FROM logradouro lg, localidade l, bairro b
WHERE lg.nr_cep = '89037585'
	AND lg.cd_localidade = l.cd_localidade
	AND lg.cd_bairro_inicio = b.cd_bairro;
	
EXPLAIN 	
SELECT lg.tp_logradouro, lg.nm_logradouro, b.nm_bairro, l.nm_localidade, lg.sg_uf, lg.nr_cep
FROM logradouro lg JOIN bairro b ON (lg.cd_bairro_inicio = b.cd_bairro)
						 JOIN localidade l ON (lg.cd_localidade = l.cd_localidade)
WHERE lg.sg_uf = 'SC';
-- WHERE l.nm_localidade = 'blumenau';
-- WHERE lg.nr_cep = '89037585';

-- criando índices para as FK de bairro e localidade
CREATE INDEX logradouro_cd_bairro_idx ON logradouro(cd_bairro_inicio);
CREATE INDEX logradouro_cd_localidade_idx ON logradouro(cd_localidade);
CREATE INDEX logradouro_nr_cep_idx ON logradouro(nr_cep);
CREATE INDEX logradouro_sg_uf_idx ON logradouro(sg_uf);

-- eliminando um índice
DROP INDEX logradouro_sg_uf_idx ON logradouro;

SHOW INDEXES FROM logradouro;

DESC grande_usuario;

EXPLAIN 
SELECT gu.nm_grande_usuario, lg.nm_logradouro_comp, ba.nm_bairro, lo.nm_localidade, gu.sg_uf, gu.nr_cep
FROM grande_usuario gu JOIN localidade lo ON (gu.cd_localidade = lo.cd_localidade)
							  JOIN bairro ba ON (gu.cd_bairro = ba.cd_bairro)
							  JOIN logradouro lg ON (gu.cd_logradouro = lg.cd_logradouro)
WHERE lo.nm_localidade = 'Blumenau';

CREATE INDEX grande_usuario_cd_localidade_idx ON grande_usuario(cd_localidade);
CREATE INDEX grande_usuario_cd_bairro_idx ON grande_usuario(cd_bairro);
CREATE INDEX grande_usuario_cd_logradouro ON grande_usuario(cd_logradouro);