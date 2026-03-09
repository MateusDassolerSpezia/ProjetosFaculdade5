-- exemplo para a atividade 1 (listar os nomes de proprietários de veículos movidos por mais de um combustível)
SELECT v.nr_placa, p.nm_proprietario
FROM veiculo v, proprietario p
WHERE v.cd_proprietario = p.cd_proprietario
	AND v.nr_placa IN (SELECT vc.nr_placa -- ,COUNT(*) qtde
								FROM veiculo_combustivel vc
								GROUP BY vc.nr_placa
								HAVING COUNT(*) > 4);
								
-- exemplo para a atividade 1 (listar os veículos que são movidos por maior número de combustíveis)
SELECT v.nr_placa, m.ds_modelo, COUNT(*) AS qtde
FROM veiculo v, modelo m, veiculo_combustivel vc
WHERE v.cd_modelo = m.cd_modelo
	AND v.nr_placa = vc.nr_placa
GROUP by v.nr_placa, m.ds_modelo
HAVING COUNT(*) >= ALL (SELECT COUNT(*) qtde
								FROM veiculo_combustivel vc
								GROUP BY vc.nr_placa);

-- a) Recuperar o(s) acessório(s) que não estão associado(s) a nenhum veículo
SELECT a.ds_acessorio, COUNT(*) AS qtde
FROM acessorio a, veiculo v, veiculo_acessorio va
WHERE a.cd_acessorio = va.cd_acessorio
	AND va.nr_placa = v.nr_placa
GROUP BY a.ds_acessorio;

-- b) Listar a descrição do(s) acessório(s) mais popular (que mais é encontrado entre os veículos cadastrados);

-- c) Listar a descrição da marca que possui o maior número de veículos cadastrado;

-- d) Listar a descrição do combustível que apresenta o menor número de veículos associado;

-- e) Listar a(s) marca(s) e modelo(s) de veículo(s) movido(s) ao combustível "Elétrico" e que apresenta(m) acessório "ADAS".