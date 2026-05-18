-- rotina para ajustar preço de medicamentos considerando parâmetros
-- entrada: preço mínimo, preço máximo e desconto
-- saída: sem retorno
delimiter $
CREATE OR REPLACE PROCEDURE sp_atualiza_preco (IN p_ini DECIMAL(8,2),
												 			  IN p_fim DECIMAL (8,2),
												 			  IN p_percentual DECIMAL(4,1))
												 
BEGIN
	DECLARE v_controle INT DEFAULT 1; -- controle do cursor
	DECLARE v_custo DECIMAL(8,2); -- recebe o preço do medicamento
	DECLARE v_preco_ajustado DECIMAL(8,2); -- manter o novo preço do medicamento
	DECLARE v_medicamento INT; -- recebe o id do medicamento
	-- criando o cursor
	DECLARE cur_medicamentos CURSOR FOR SELECT m.cd_medicamento, m.vl_custo
													FROM medicamento m
													WHERE m.vl_custo BETWEEN p_ini AND p_fim;
	-- declarando o tratamento para o fim do cursor, ou seja, acabou muda para 0
	DECLARE CONTINUE handler FOR NOT FOUND SET v_controle = 0;
	
	OPEN cur_medicamentos;
		loop_med: loop
		fetch cur_medicamentos INTO v_medicamento, v_custo; -- atribuindo valores das colunas às variáveis
		if v_controle = 0 then -- testando se fim da estrutura (dados do cursos)
			leave loop_med; -- interrompe o laço/looping
		END if;
		-- ajustando o preço do medicamento
		SET v_preco_ajustado = (v_custo - (v_custo * p_percentual / 100));
		UPDATE medicamento m SET m.vl_venda = v_preco_ajustado -- atualiza o preço de venda
						 WHERE m.cd_medicamento = v_medicamento; -- para cada medicamento obtido do cursor
	END loop;
	close cur_medicamentos; -- fechamento do cursor (desaloca estrutura da memória)
END $

-- testando a rotina criada
CALL sp_atualiza_preco(10, 30, 50); -- meds entre R$10,00 e R$30,00 terão 50% de desconto

SELECT * FROM medicamento WHERE vl_custo BETWEEN 10 AND 30;