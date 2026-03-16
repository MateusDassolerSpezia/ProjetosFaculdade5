-- view que recupera o(s) acessório(s) que não estão associado(s) a nenhum veículo;
CREATE OR REPLACE VIEW vw_acessorios_sem_veiculos
AS
SELECT a.ds_acessorio AS descricao, a.cd_acessorio AS codigo
FROM acessorio a
WHERE a.cd_acessorio NOT IN (SELECT va.cd_acessorio
										FROM veiculo_acessorio va);
										
SELECT * FROM vw_acessorios_sem_veiculos;										
										
-- view para listar o veículo e a quantidade de acessórios
CREATE OR REPLACE VIEW vw_veiculo_qtde_acessorios
AS 
SELECT v.nr_placa, COUNT(*)
FROM veiculo v JOIN veiculo_acessorio va ON (v.nr_placa = va.nr_placa)
GROUP BY v.nr_placa;

SELECT * FROM vw_veiculo_qtde_acessorios;
																					
-- para listar/identificar views
SELECT vs.`TABLE_NAME`, vs.VIEW_DEFINITION
FROM information_schema.VIEWS vs
WHERE vs.TABLE_SCHEMA = 'bd_veiculos';

-- ATIVIDADE

-- a) Criação de uma view para listar a descrição da marca, a descrição do modelo e a quantidade de veículos cadastrados;
CREATE OR REPLACE VIEW vw_marca_modelo_quantidade
AS
	SELECT m.ds_marca AS 'marca', mo.ds_modelo AS 'modelo', COUNT(*) AS qtde_veiculos
	FROM marca m, modelo mo, veiculo v
	WHERE mo.cd_modelo = v.cd_modelo
		AND mo.cd_marca = m.cd_marca
	GROUP BY m.cd_marca, mo.cd_modelo;
	
SELECT * FROM vw_marca_modelo_quantidade;

-- b) Criação de uma view para listar dados completos dos veículos: placa, descrição da marca, descrição do modelo, descrição dos acessórios e descrição do combustível que o move, O resultado desta busca poderá resultar na repetição dos do veículo (placa, marca e modelo) face a apresentação de mais de um combustível e/ou acessório;
CREATE OR REPLACE VIEW vw_dados_veiculos
AS 
	SELECT v.nr_placa AS placa, m.ds_marca AS 'marca', mo.ds_modelo AS 'modelo', a.ds_acessorio AS 'acessorio', c.ds_combustivel AS 'combustivel'
	FROM veiculo v, marca m, modelo mo, acessorio a, combustivel c, veiculo_acessorio va, veiculo_combustivel vc
	WHERE mo.cd_modelo = v.cd_modelo
		AND mo.cd_marca = m.cd_marca
		AND va.nr_placa = v.nr_placa
		AND vc.nr_placa = v.nr_placa
		AND a.cd_acessorio = va.cd_acessorio
		AND c.cd_combustivel = vc.cd_combustivel
	ORDER BY 1, 5, 4;	
	
SELECT * FROM vw_dados_veiculos;

-- c) Criação de uma view para listar o nome da localidade com a respectiva quantidade proprietários associada (que residem na respectiva localidade);
CREATE OR REPLACE VIEW vw_localidade_proprietarios
AS 
	SELECT l.nm_localidade AS 'localidade', COUNT(*) AS residentes
	FROM localidade l, proprietario p
	WHERE l.cd_localidade = p.cd_localidade
	GROUP BY 1;
	
SELECT * FROM vw_localidade_proprietarios;
	
-- d) Criação de uma view para listar a descrição do acessório com a respectiva quantidade de veículos associados a cada acessório listado;
CREATE OR REPLACE VIEW vw_acessorios_veiculos
AS 
	SELECT a.ds_acessorio AS 'acessorio', COUNT(*) AS veiculos
	FROM acessorio a, veiculo_acessorio va
	WHERE a.cd_acessorio = va.cd_acessorio
	GROUP BY 1;
	
SELECT * FROM vw_acessorios_veiculos;

-- e) Criação de uma view para listar a descrição do modelo, a descrição da marca, ano do modelo e a respectiva cor de cada veículo;
CREATE OR REPLACE VIEW vw_modelo_marca_ano_cor
AS 
	SELECT  mo.ds_modelo AS 'modelo', m.ds_marca AS 'marca', v.nr_ano_mod AS ano_modelo, c.ds_cor AS 'cor'
	FROM modelo mo, marca m, veiculo v, cor c
	WHERE mo.cd_marca = m.cd_marca
		AND mo.cd_modelo = v.cd_modelo
		AND v.cd_cor = c.cd_cor
	GROUP BY 1, 4;
	
SELECT * FROM vw_modelo_marca_ano_cor;