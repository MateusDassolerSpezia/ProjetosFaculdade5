/*
HeideSQL1 (bd_teste)
*/

SELECT USER();

SELECT * FROM tab1;

INSERT INTO tab1 VALUES ('registro 4');

-- inicia uma transação 
START TRANSACTION;
INSERT INTO tab1 VALUES ('registro 5');
-- confirmando a inclusão 
COMMIT;

-- inicia uma transação 
START TRANSACTION;
INSERT INTO tab1 VALUES ('registro 4', 4);
-- cancela a inclusão
ROLLBACK;

-- inicia uma transação 
START TRANSACTION;
DELETE FROM tab1 WHERE tx = 'registro 4';

START TRANSACTION;
INSERT INTO tab1 VALUES ('registro 0');
-- executar o comando DDl (termina a transação automaticamente e commita, mas só se for na própria sessão
ALTER TABLE tab1
 ADD COLUMN cd INT;
UPDATE tab1 SET cd = 2 WHERE tx = 'registro 2';
UPDATE tab1 SET cd = 3 WHERE tx = 'registro 3';
UPDATE tab1 SET cd = 5 WHERE tx = 'registro 5';
UPDATE tab1 SET cd = 0 WHERE tx = 'registro 0';

START TRANSACTION;
INSERT INTO tab1 VALUES ('registro 6', 6);
SAVEPOINT A;
INSERT INTO tab1 VALUES ('registro 7', 7);
-- rollback até o ponto A (desfaz o insert 7)
ROLLBACK TO A;
-- rollback (desfaz toda a transação)
ROLLBACK;
COMMIT;

DELETE FROM tab1 WHERE cd = 0;
-- com a chave primária a transação vai bloquear por linha, antes estava bloqueando a tabela inteira
ALTER TABLE tab1 ADD PRIMARY KEY (cd);

START TRANSACTION;
UPDATE tab1 SET tx = 'registro 1 new' WHERE cd = 1;
-- tentando alterar um registro que está bloqueado por outro usuário (HeideSQL2)
-- ERRO deadlock (quando os dois usuários tentam alterar um registro bloqueado por outro usuário ao mesmo tempo)
-- prevalece as alterações do usuário que executar primeiro
UPDATE tab1 SET tx = 'registro 5 new' WHERE cd = 5;
COMMIT;

SELECT * FROM tab1;

START TRANSACTION;
SELECT * 
FROM tab1 WHERE cd IN (4,5) FOR UPDATE; 


/*
HeideSQL2 (bd_teste)
*/

SELECT USER();

SELECT * FROM tab1; 

UPDATE tab1 SET tx = 'registro 44'
WHERE tx = 'registro 4';

UPDATE tab1 SET tx = 'registro 55'
WHERE tx = 'registro 5';

UPDATE tab1 SET cd = 1 WHERE tx = 'registro 1';

START TRANSACTION;
DELETE FROM tab1 WHERE cd = 5;
-- tentando alterar um registro que está bloqueado por outro usuário (HeideSQL1)
-- deadlock (quando os dois usuários tentam alterar um registro bloqueado por outro usuário ao mesmo tempo)
-- prevalece as alterações do usuário que executar primeiro
UPDATE tab1 SET tx = 'registro 1' WHERE cd = 1;

DELETE FROM tab1 WHERE cd = 5;