DELIMITER $
CREATE  OR REPLACE FUNCTION fc_tempo_servico (p_data DATE) RETURNS INTEGER
BEGIN
   DECLARE data_atual DATE;
   SET data_atual = (select CURDATE());
   RETURN YEAR(data_atual) - YEAR(p_data);
END $

-- testando function criada
SELECT fc_tempo_servico('1993-02-17');

SELECT * FROM medicamento;

-- função para calcular a margem de lucro do medicamento
delimiter $
CREATE OR REPLACE FUNCTION fc_margem_lucro (p_medicamento INT) RETURNS DECIMAL(5,2)
BEGIN
	DECLARE v_custo DECIMAL(8,2) DEFAULT 0.00;
	DECLARE v_venda DECIMAL(8,2) DEFAULT 0.00;
	DECLARE v_margem DECIMAL(8,2) DEFAULT 0.00;
	
	SELECT vl_custo, vl_venda
	INTO v_custo, v_venda
	FROM medicamento m
	WHERE m.cd_medicamento = p_medicamento;
	
	SET v_margem = ROUND((v_venda - v_custo) / v_venda * 100,2);
	
	RETURN v_margem;
END $

SELECT m.nm_medicamento, fc_margem_lucro(m.cd_medicamento) AS pct
FROM medicamento m;