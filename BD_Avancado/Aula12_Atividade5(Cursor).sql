-- selecionar o medicamento com a respectiva quantidade em estoque considerando os lotes
SELECT m.cd_medicamento, m.nm_medicamento, SUM(l.qt_lote) AS qtde_estoque
FROM medicamento m JOIN lotemedicamento l ON (m.cd_medicamento = l.cd_medicamento)
GROUP BY m.cd_medicamento, m.nm_medicamento;

SELECT * FROM lotemedicamento;

-- rotina para atualizar o estoque dos medicamentos após o lançamento(s) em lote(s)
-- sem parâmetros
delimiter $
CREATE OR REPLACE PROCEDURE sp_atualiza_estoque_med()
BEGIN 
	UPDATE medicamento m
		SET m.qt_estoque = (SELECT SUM(l.qt_lote)
								  FROM lotemedicamento l
								  WHERE m.cd_medicamento = l.cd_medicamento
								  	AND l.st_lote = 'A'); -- 'A' -> lote ativo
END $

-- testando a rotina criada
CALL sp_atualiza_estoque_med(); -- deverá atualizar o estoque de cada medicamento

SELECT * FROM medicamento;

-- rotina para baixar de estoque medicamento vendido considerando a qtde em cada lote
-- sendo que devem ser "baixadas" as qtdes dos lotes mais próximos do vencimento
-- parâmetro de entrada o id do medicamento e a quantidade vendida
-- cursor pegando os lotes e suas quantidades - order by pela data
delimiter $
CREATE OR REPLACE PROCEDURE sp_baixa_estoque_med (IN p_med INT, IN p_qtde INT)
BEGIN
    DECLARE v_controle INT DEFAULT 1;
    DECLARE v_qtde_lote INT;
    DECLARE v_lote INT;
    DECLARE v_qtde_restante INT;

    -- cursor
    DECLARE cur_lotes_medicamentos CURSOR FOR
        SELECT l.cd_lote, l.qt_lote
        FROM lotemedicamento l
        WHERE l.cd_medicamento = p_med
          AND l.st_lote = 'A'
          AND l.qt_lote > 0
        ORDER BY l.dt_validade;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_controle = 0;

    SET v_qtde_restante = p_qtde;

    OPEN cur_lotes_medicamentos;

    loop_lote: LOOP

        FETCH cur_lotes_medicamentos
        INTO v_lote, v_qtde_lote;

        IF v_controle = 0 THEN
            LEAVE loop_lote;
        END IF;

        IF v_qtde_restante <= v_qtde_lote THEN

            UPDATE lotemedicamento
               SET qt_lote = qt_lote - v_qtde_restante
             WHERE cd_lote = v_lote;

            SET v_qtde_restante = 0;

        ELSE

            UPDATE lotemedicamento
               SET qt_lote = 0
             WHERE cd_lote = v_lote;

            SET v_qtde_restante =
                v_qtde_restante - v_qtde_lote;

        END IF;

    END LOOP loop_lote;

    CLOSE cur_lotes_medicamentos;

    CALL sp_atualiza_estoque_med();

END $

call sp_baixa_estoque_med(1, 12);

SELECT * FROM medicamento;
SELECT * FROM lotemedicamento;