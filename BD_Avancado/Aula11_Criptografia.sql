DESC cliente;

-- alterando a estrutura de cliente
ALTER TABLE cliente
ADD COLUMN ds_senha VARCHAR(200),
ADD COLUMN nr_cpf VARCHAR(100);

INSERT INTO cliente (nm_cliente, ds_senha) VALUES ('Maria', SHA2('12345', 256)); -- senha é "12345"
INSERT INTO cliente (nm_cliente, ds_senha) VALUES ('Ana', MD5('12345')); -- senha é "12345"

SELECT "Ok! Usuário autenticado :)!" AS STATUS
	FROM cliente
	WHERE nm_cliente = 'Maria' AND ds_senha = SHA2('12345', 256);
	
SELECT "Ok! Usuário autenticado :)!" AS STATUS
	FROM cliente
	WHERE nm_cliente = 'Ana' AND ds_senha = MD5('12345');

SELECT * FROM cliente;

UPDATE cliente SET nr_cpf = AES_ENCRYPT('123456789-01', 'chave')
	WHERE cd_cliente = 7;
	
UPDATE cliente SET nr_cpf = AES_ENCRYPT('123456789-01', 'chaves')
	WHERE cd_cliente = 8;
	
-- descriptografando a coluna CPF
SELECT c.nm_cliente, AES_DECRYPT(c.nr_cpf, 'chave') AS cpf
FROM cliente c;