-- a) Listar todos os logradouros da cidade de "Blumenau", seus respectivos bairros e CEPs, ordenados alfabeticamente pelo nome do bairro, seguido pelo nome do logradouro;
EXPLAIN
SELECT lg.tp_logradouro, lg.nm_logradouro, b.nm_bairro, l.nm_localidade, lg.sg_uf, lg.nr_cep
FROM logradouro lg, bairro b, localidade l
WHERE l.nm_localidade = 'blumenau'
	AND lg.cd_localidade = l.cd_localidade
	AND lg.cd_bairro_inicio = b.cd_bairro
ORDER BY b.nm_bairro, lg.nm_logradouro;

-- b) Listar o nome dos distritos (fl_tipo_localidade= 'D') e do respectivo município que cada distrito está associado. Considerar como filtro apenas a UF "SC" e ordenar pelo nome do município, seguido do distrito;
EXPLAIN
SELECT di.nm_localidade AS distrito, lo.nm_localidade AS 'localidade', di.nm_localidade_comp
FROM localidade lo, localidade di
WHERE di.fl_tipo_localidade = 'D'
	AND di.sg_uf = 'SC'
	AND lo.cd_localidade = di.cd_localidade_sub
ORDER BY 2, 1;

CREATE INDEX localidade_fl_tipo_localidade ON localidade(fl_tipo_localidade);
CREATE INDEX localidade_sg_uf_idx ON localidade(sg_uf);

-- c) Listar o nome do(s) bairro(s) de "Florianópolis" com respectiva quantidade de CEPs associados. Ordenar pelo maior número de CEPs;
EXPLAIN
SELECT b.nm_bairro, l.nm_localidade, COUNT(*) AS qtde
FROM localidade l, bairro b, logradouro lg
WHERE lg.cd_localidade = l.cd_localidade
	AND lg.cd_bairro_inicio = b.cd_bairro
	AND l.nm_localidade = 'Florianópolis'
GROUP BY b.nm_bairro, l.nm_localidade
ORDER BY qtde DESC;

-- d) Listar quais nomes de municípios são encontrados em mais de uma UF. Listar também a quantidade de vezes em que o nome do município é encontrado. Ordenar pelos municípios mais populares;
EXPLAIN 
SELECT lo.nm_localidade, COUNT(*) AS qtde
FROM localidade lo 
GROUP BY lo.nm_localidade
ORDER BY qtde DESC;

-- e) Listar qual o número de total de CEPs encontrados em cada município, com respectiva UF, ordenados pelo maior número (de CEPs listados). Considerar apenas os municípios que possuem mais de um CEP (tabela logradouro);
EXPLAIN 


-- f) Listar qual o nome do logradouro mais popular no Brasil, ou seja, o que é encontrado no maior número de municípios. Atenção, aqui poderá haver mais de um logradouro, haja vista que podem apresentar o mesmo número de ocorrências e, neste caso, todos os empatados na 1a. posição (maior número) devem ser exibidos;