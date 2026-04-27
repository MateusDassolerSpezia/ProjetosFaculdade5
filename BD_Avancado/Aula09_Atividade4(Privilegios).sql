/*
TABELAS:
- atendimento
- animal
- tutor
*/

CREATE USER 'mateus'
 IDENTIFIED BY 'adm';
 
CREATE USER 'lucas'
 IDENTIFIED BY 'rec';
 
CREATE USER 'joao'
 IDENTIFIED BY 'vet';

CREATE ROLE administrador;
GRANT ALL PRIVILEGES ON atividade_4.* TO administrador;
GRANT administrador TO 'mateus';
SET DEFAULT ROLE administrador FOR 'mateus';

CREATE ROLE recepcionista;
GRANT SELECT, INSERT, UPDATE, DELETE ON atividade_4.animal TO recepcionista;
GRANT SELECT ON atividade_4.atendimento TO recepcionista;
GRANT recepcionista TO 'lucas';
SET DEFAULT ROLE recepcionista FOR 'lucas';

CREATE ROLE veterinario;
GRANT SELECT ON atividade_4.animal TO veterinario;
GRANT SELECT ON atividade_4.tutor TO veterinario;
GRANT SELECT, INSERT, UPDATE, DELETE ON atividade_4.atendimento TO veterinario;
GRANT veterinario TO 'joao';
SET DEFAULT ROLE veterinario FOR 'joao';