DELIMITER $
CREATE OR REPLACE PROCEDURE sp_atualiza_valor_medicamento 
       (IN p_percentual INTEGER)
BEGIN
    UPDATE medicamento
       SET vl_venda = vl_venda + (vl_venda * p_percentual /100);
END $

-- testando procedure criada
CALL sp_atualiza_valor_medicamento(10);

SELECT * FROM medicamento;


DELIMITER $
CREATE OR REPLACE PROCEDURE sp_calcular_desconto 
	(IN p_preco DECIMAL, IN p_percentual INT, OUT p_preco_final DECIMAL)
BEGIN
    SET p_preco_final = p_preco - (p_preco * p_percentual / 100);
END $

-- declara uma variável de ambiente para receber o valor do retorno
SET @valor = 1000;
-- obtem o preço do produto passado como parâmetro e 10% desconto
CALL sp_calcular_desconto (100.00,10, @valor);
-- exibe o valor do retorno – variável valor
Select @valor;

DELIMITER $
CREATE OR REPLACE PROCEDURE sp_calcular_desconto2 
       (IN p_medicamento INTEGER, IN p_percentual DECIMAL, INOUT p_preco DECIMAL)
BEGIN
    SELECT vl_venda INTO p_preco
	 	FROM medicamento 
      WHERE cd_medicamento = p_medicamento;
    SET p_preco = p_preco - (p_preco * p_percentual / 100);
END $

SET @valor = 0.00;
-- obtem o preço do produto passado como parâmetro e 10% desconto
CALL sp_calcular_desconto2 (5,10, @valor);
SELECT @valor;

SELECT * FROM medicamento;
SELECT * FROM categoria;

delimiter $
CREATE OR REPLACE PROCEDURE sp_atualiza_preco_venda_por_cat (IN p_categoria INT)
BEGIN
	if p_categoria IS NULL then 
		UPDATE medicamento m JOIN categoria c ON (m.cd_categoria = c.cd_categoria)
			SET m.vl_venda = ROUND(m.vl_custo * (1 + (c.pc_margem_lucro/100)), 2);
	ELSE 
		UPDATE medicamento m JOIN categoria c ON (m.cd_categoria = c.cd_categoria)
			SET m.vl_venda = ROUND(m.vl_custo * (1 + (c.pc_margem_lucro/100)), 2)
			WHERE m.cd_categoria = p_categoria;
	END if;
END $

-- testando a procedure criada
CALL sp_atualiza_preco_venda_por_cat(1);

SELECT * FROM medicamento;
SELECT * FROM categoria;

UPDATE categoria SET pc_margem_lucro = 100 WHERE cd_categoria = 1;

delimiter $
CREATE OR REPLACE PROCEDURE sp_lista_medicamentos_cat (IN p_categoria INT)
BEGIN
	SELECT m.nm_medicamento, m.qt_estoque, m.vl_custo, m.vl_venda, fc_margem_lucro(m.cd_medicamento)
	FROM medicamento m JOIN categoria c ON (m.cd_categoria = c.cd_categoria)
	WHERE m.cd_categoria = p_categoria;
END $

CALL sp_lista_medicamentos_cat(1);