/*
Usuário root
*/

-- alterando senha do usuário
ALTER USER root
 IDENTIFIED BY 'senha';

-- vendo qual usuário está sendo usado 
SELECT USER();

-- criando um usuário
CREATE USER 'user1'
 IDENTIFIED BY 'user1';
 
-- concedendo privilégio de select na tabela conta do bd_teste
GRANT SELECT ON bd_teste.tab1 TO 'user1';

GRANT SELECT (tipo)
 ON bd_teste.tab3 TO 'user1';

-- concedendo priv de insert em tab1
GRANT INSERT ON bd_teste.tab1 TO 'user1';

-- concendendo priv de sistema (create)
-- necessário reiniciar o user1 por ser um privilégio de sistema
GRANT CREATE ON bd_teste.* TO 'user1';

-- revogando priv
REVOKE CREATE ON bd_teste.* FROM 'user1';

-- criando um papél (role)
CREATE ROLE r1;

-- concedendo priv á r1
GRANT INSERT, DELETE, UPDATE ON bd_teste.tab1 TO r1;

-- associando r1 para o usuário "user1"
GRANT r1 TO 'user1';

-- setando a role default
SET DEFAULT ROLE r1 FOR 'user1';

/*
Usuário user1
*/

SELECT USER();

SELECT * FROM tab1;

SELECT * FROM tab3;
SELECT tipo FROM tab3;

DESC tab1;

INSERT INTO tab1 VALUE ('registro 5');

CREATE TABLE tab5 (ds VARCHAR(10));

-- verificando os privs
SHOW GRANTS FOR 'user1';

DELETE FROM tab1
 WHERE tx = 'registro 5';