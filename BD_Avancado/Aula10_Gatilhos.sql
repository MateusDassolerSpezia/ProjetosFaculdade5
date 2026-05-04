/*
CONSULTA 1
*/

CREATE TABLE pessoa (
id INT PRIMARY KEY,
nome VARCHAR(50),
email VARCHAR(50)
);

CREATE TABLE registro_log (
dt_op DATE,
hr_op TIME,
ds_op VARCHAR(100)
);

SELECT * FROM pessoa;
SELECT * FROM registro_log;

-- criando um gatilho
delimiter $ -- ajustando o caracter terminador de instrução para $
CREATE OR REPLACE TRIGGER tg_inserindo_pessoa
	AFTER INSERT ON pessoa FOR EACH ROW -- NEW e OLD referenciam a essa tabela
BEGIN
	INSERT INTO registro_log (dt_op, hr_op, ds_op)
		VALUES (CURDATE(), CURTIME(), CONCAT('Inserindo row pessoa id: ', NEW.id));
		-- curdate() retorna a data instantânea do servidor
		-- curtime() retorna a hora instantânea do servidor
		-- concat() concatena literais/strings
END $

-- inserindo dado em pessoa e testando o gatilho
INSERT INTO pessoa (id, nome, email) VALUES (1, 'Pessoa 1', 'pessoa1@gamil.com');

-- criando um gatilho / alterando o gatilho *
delimiter $ -- ajustando o caracter terminador de instrução para $
CREATE OR REPLACE TRIGGER tg_alterando_pessoa
	BEFORE UPDATE ON pessoa FOR EACH row
BEGIN
	-- testando valor de campo *
	if OLD.nome <> NEW.nome then -- *
	INSERT INTO registro_log (dt_op, hr_op, ds_op)
		VALUES (CURDATE(), CURTIME(), CONCAT('Alterando row pessoa nome: ', /*OLD.id*/ OLD.nome, ' para: ', /*NEW.id*/ NEW.nome));
	END if; -- *
END $

-- testando o gatilho alterando dados de pessoa
UPDATE pessoa SET id = 11 WHERE id = 1; -- id 1 passa a ser 11
UPDATE pessoa SET nome = 'novo nome P1' WHERE id = 11;

-- identificando as rotinas criadas
SELECT *
FROM information_schema.`TRIGGERS` r
WHERE r.TRIGGER_SCHEMA = 'base_pl_testes';

/*
CONSULTA 2 (Inserindo novas tabelas e dados)
*/

-- DROP TABLE ItemNotaFiscal;
-- DROP TABLE Medicamento;
-- DROP TABLE NotaFiscal;
-- DROP TABLE Cliente
 
CREATE TABLE cliente (
    cd_cliente integer  NOT NULL AUTO_INCREMENT,
    nm_cliente VARCHAR(255) NOT NULL,
    nr_telefone VARCHAR(15) NULL,
	dt_nascimento DATE NULL,
	primary key (cd_cliente)
);
 
CREATE TABLE Medicamento (
	cd_medicamento integer AUTO_INCREMENT,
	nm_medicamento varchar(50) ,
	ds_medicamento varchar(200) ,
	vl_custo decimal(8,2) default 0,
	vl_venda decimal(8,2) default 0,
	qt_estoque integer  default 0,
	PRIMARY KEY (cd_medicamento)
);
 
CREATE TABLE NotaFiscal (
	nr_notafiscal integer AUTO_INCREMENT ,
	cd_cliente integer references cliente(cd_cliente),
	dt_emissao date ,
	vl_total decimal(8,2) default 0 ,
	PRIMARY KEY (nr_notafiscal)
);
 
CREATE TABLE ItemNotaFiscal (
	nr_notafiscal integer,
	cd_medicamento integer,
	qt_vendida integer default 0,
	vl_venda decimal(8,2) default 0,
    PRIMARY KEY (nr_notafiscal, cd_medicamento),
	FOREIGN KEY (nr_notafiscal) REFERENCES Notafiscal(nr_notafiscal),
	FOREIGN KEY (cd_medicamento) REFERENCES Medicamento(cd_medicamento)
);
 
INSERT INTO cliente (nm_cliente, nr_telefone, dt_nascimento) VALUES('Ana Clara Mendes', '(11) 91234-5678', '1995-04-12');
INSERT INTO cliente (nm_cliente, nr_telefone, dt_nascimento) VALUES('Bruno Alves', '(21) 99876-5432', '1988-11-03');
INSERT INTO cliente (nm_cliente, nr_telefone, dt_nascimento) VALUES('Carlos Eduardo', NULL, '1979-07-22');
INSERT INTO cliente (nm_cliente, nr_telefone, dt_nascimento) VALUES('Daniela Souza', '(31) 98765-4321', NULL);
INSERT INTO cliente (nm_cliente, nr_telefone, dt_nascimento) VALUES('Eduarda Lima', '(41) 99123-4567', '2000-01-15');
 
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Benegripe', 'Remédio pra gripe', 5.0, 10.0, 11);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Aspirina C', 'Remédio pra aumentar a resistência', 7.0, 11.0, 22);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Dermatos', 'Remédio pra dores', 20.0, 30.0, 33);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Cataflan', 'Remédio pra dor de garganta', 10.0, 15.0, 44);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Remédio 5', 'Remédio pra dores na barriga', 35.0, 50.0, 55);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Benegripe Genérico', 'Remédio pra gripe genérico', 9.0, 15.0, 66);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Dermatos Genérico', 'Remédio pra dores genérico', 50.0, 70.0, 77);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Vodol 50mg','Remédio para micose',21.20, 28.90, 30);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Vick' ,'Pastilha para garganta',11.50, 17.50, 80);
INSERT INTO Medicamento (nm_medicamento,ds_medicamento,vl_custo,vl_venda,qt_estoque) VALUES ('Doralgina','Remédio para dor de cabeça',9.90, 15, 10);

/*
CONSULTA 3
*/

SELECT * FROM medicamento;
SELECT * FROM notafiscal;
SELECT * FROM itemnotafiscal;

-- criando um gatilho para atualizar o estoque de um medicamento vendido
delimiter $
CREATE OR REPLACE TRIGGER tg_venda_medicamento BEFORE INSERT 
	ON itemnotafiscal FOR EACH ROW 
BEGIN
	DECLARE v_valor_med DECIMAL(8,2) DEFAULT 0.0;
	DECLARE v_estoque_med INT DEFAULT 0;
	-- obtendo a qtde em estoque do medicamento
	SELECT m.qt_estoque INTO v_estoque_med -- atribui o estoque à variável
		FROM medicamento m WHERE m.cd_medicamento = NEW.cd_medicamento;
	-- testando o estoque em relação ao que está sendo vendido
	if v_estoque_med < NEW.qt_vendida then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente!'; -- tratamento!
	END if;
	-- diminuindo a qtde do estoque
	UPDATE medicamento m 
		SET m.qt_estoque = m.qt_estoque - NEW.qt_vendida 
		WHERE m.cd_medicamento = NEW.cd_medicamento; 
	-- obtendo o valor do medicamento
	SELECT m.vl_venda INTO v_valor_med FROM medicamento m
		WHERE m.cd_medicamento = NEW.cd_medicamento;
	-- ajustando o valor da venda
	SET NEW.vl_venda = v_valor_med; -- atribuindo o valor obtido na tabela medicamento
	-- atualizando o valor total da nf
	UPDATE notafiscal nf 
		SET nf.vl_total = nf.vl_total + (NEW.qt_vendida * NEW.vl_venda)
		WHERE nf.nr_notafiscal = NEW.nr_notafiscal;
END $

-- testando o gatilho
INSERT INTO cliente (nm_cliente) VALUES ('José');
INSERT INTO notafiscal (cd_cliente) VALUES (1);
INSERT INTO itemnotafiscal (nr_notafiscal, cd_medicamento, qt_vendida, vl_venda) VALUES (1, 1, 2, 0);