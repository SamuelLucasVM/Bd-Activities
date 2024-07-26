CREATE TYPE ESTADONORDESTE AS ENUM ('AL', 'BA', 'CE', 'MA', 'PB', 'PN', 'PI', 'RN', 'SE');

CREATE TABLE farmacias (
	id SERIAL,
	bairro VARCHAR(15),
	cidade VARCHAR(15),
	estado ESTADONORDESTE,
	tipo CHAR(1),
	gerente CHAR(11),
	trabalho_gerente CHAR(1)
);

ALTER TABLE farmacias ADD CONSTRAINT farmacias_pkey PRIMARY KEY (id);
ALTER TABLE farmacias ADD CONSTRAINT farmacias_bairro_unique UNIQUE (bairro);
ALTER TABLE farmacias ADD CONSTRAINT farmacias_tipo_s_exclude EXCLUDE USING gist(tipo WITH =) WHERE (tipo = 'S');

-- TIPOS --
-- S = sede 
-- F = filial
ALTER TABLE farmacias ADD CONSTRAINT farmacias_tipo_valido CHECK (
	tipo = 'S' OR 
	tipo = 'F'
);

CREATE TABLE funcionarios (
	cpf CHAR(11),
	trabalho CHAR(1),
	farmacia INTEGER
);

ALTER TABLE funcionarios ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (cpf, trabalho);
ALTER TABLE funcionarios ADD CONSTRAINT funcionarios_cpf_valido CHECK (LENGTH(cpf) = 11);
ALTER TABLE funcionarios ADD CONSTRAINT funcionarios_farmacia_fkey FOREIGN KEY (farmacia) REFERENCES farmacias (id);

-- TIPOS DE TRABALHOS --
-- F = farmacêutico 
-- V = vendendor
-- E = entregador
-- C = caixa
-- A = administrador
ALTER TABLE funcionarios ADD CONSTRAINT funcionarios_trabalho_valido CHECK (
	trabalho = 'F' OR
	trabalho = 'V' OR
	trabalho = 'E' OR
	trabalho = 'C' OR
	trabalho = 'A'
);

ALTER TABLE farmacias ADD CONSTRAINT farmacias_gerente_fkey FOREIGN KEY (gerente, trabalho_gerente) REFERENCES funcionarios (cpf, trabalho);
ALTER TABLE farmacias ADD CONSTRAINT farmacias_gerente_trabalho_valido CHECK (trabalho_gerente = 'F' OR trabalho_gerente = 'A');

CREATE TABLE medicamentos (
	id SERIAL,
	nome VARCHAR(25),
	precisa_receita BOOLEAN	
);

ALTER TABLE medicamentos ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (id, precisa_receita);

CREATE TABLE vendas (
	id SERIAL;
	cliente_cadastrado CHAR(11),
	funcionario CHAR(11),
	funcionario_trabalho CHAR(1),
	medicamento INTEGER,
	medicamento_precisa_receita BOOLEAN
);

ALTER TABLE vendas ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);
ALTER TABLE vendas ADD CONSTRAINT vendas_funcionario_fkey FOREIGN KEY (funcionario, funcionario_trabalho) REFERENCES funcionarios (cpf, trabalho) ON DELETE RESTRICT;
ALTER TABLE vendas ADD CONSTRAINT vendas_medicamento_fkey FOREIGN KEY (medicamento, medicamento_precisa_receita) REFERENCES medicamentos (id, precisa_receita) ON DELETE RESTRICT;
ALTER TABLE vendas ADD CONSTRAINT vendas_medicamento_precisa_receita CHECK (
	(medicamento_precisa_receita = TRUE AND cliente_cadastrado IS NOT NULL) OR
	(medicamento_precisa_receita = FALSE)
);
ALTER TABLE vendas ADD CONSTRAINT vendas_funcionario_trabalho_valido CHECK (funcionario_trabalho = 'V');


CREATE TABLE entregas (
	id SERIAL,
	endereco_cep CHAR(8),
	endereco_num SMALLINT,
	medicamento INTEGER,
	medicamento_precisa_receita BOOLEAN
);

ALTER TABLE entregas ADD CONSTRAINT entregas_pkey PRIMARY KEY (id);
ALTER TABLE entregas ADD CONSTRAINT entregas_medicamento_fkey FOREIGN KEY (medicamento, medicamento_precisa_receita) REFERENCES medicamentos (id, precisa_receita);
ALTER TABLE entregas ALTER COLUMN endereco_cep SET NOT NULL;
ALTER TABLE entregas ALTER COLUMN endereco_num SET NOT NULL;
ALTER TABLE entregas ALTER COLUMN medicamento SET NOT NULL;
ALTER TABLE entregas ALTER COLUMN medicamento_precisa_receita SET NOT NULL;

CREATE TABLE clientes (
	cpf CHAR(11),
	data_nasc DATE
);

ALTER TABLE clientes ADD CONSTRAINT clientes_pkey PRIMARY KEY (cpf);
ALTER TABLE clientes ADD CONSTRAINT clientes_cpf_valido CHECK (LENGTH(cpf) = 11);
ALTER TABLE clientes ADD CONSTRAINT clientes_data_nasc_valida CHECK (EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nasc)) >= 18);

CREATE TABLE enderecos_clientes (
	cep CHAR(8),
	num SMALLINT,
	complemento VARCHAR(15),
	ponto_referencia VARCHAR(25),
	tipo CHAR(1),
	cliente CHAR(11)
);

ALTER TABLE vendas ADD CONSTRAINT vendas_cliente_cadastrado_fkey FOREIGN KEY (cliente_cadastrado) REFERENCES clientes (cpf);

-- TIPOS --
-- R = residência 
-- T = trabalho
-- O = "outro"
ALTER TABLE enderecos_clientes ADD CONSTRAINT enderecos_clientes_tipo_valido CHECK (
        tipo = 'R' OR
        tipo = 'T' OR
        tipo = 'O'
);


ALTER TABLE enderecos_clientes ADD CONSTRAINT enderecos_clientes_pkey PRIMARY KEY (cep, num);
ALTER TABLE enderecos_clientes ADD CONSTRAINT enderecos_clientes_cep_valido CHECK (LENGTH(cep) = 8);
ALTER TABLE enderecos_clientes ADD CONSTRAINT enderecos_clientes_cliente_fkey FOREIGN KEY (cliente) REFERENCES clientes (cpf);
ALTER TABLE enderecos_clientes ALTER COLUMN cliente SET NOT NULL;

ALTER TABLE entregas ADD CONSTRAINT entregas_endereco_fkey FOREIGN KEY (endereco_cep, endereco_num) REFERENCES enderecos_clientes (cep, num);

-- COMANDOS ADICIONAIS

-- FUNCIONARIO SO PODE SER FARMACEUTICO, VENDEDOR, ENTREGADOR, CAIXA OU ADMINISTRADOR E
-- FUNCIONARIO PODE NÃO ESTAR LOTADO EM UMA FARMÁCIA
	-- Com error:
	-- INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678901', 'Z', null);
INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678901', 'F', null);
INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678902', 'V', null);
INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678903', 'E', null);
INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678904', 'C', null);
INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678905', 'A', null);

-- FARMACIA NÃO PODE TER ESTADO FORA DO NORDESTE
	-- Com error:
	-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('catole', 'campina grande', 'RS', 'F', '12345678905', 'A');

-- FARMACIA SO PODE SER SEDE OU FILIAL
	-- Com error: 
	-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('catole', 'campina grande', 'PB', 'Z', '12345678905', 'A');

-- FARMACIA SO PODE TER GERENTE ADMINISTRADOR OU FARMACÊUTICO E
-- SO PODE TER UM GERENTE
        -- Com error:
        -- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('catole', 'campina grande', 'PB', 'F', '12345678905', 'V');
	-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('catole', 'campina grande', 'PB', 'F', '12345678905', 'E');
	-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('catole', 'campina grande', 'PB', 'F', '12345678905', 'C');
INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('catole', 'campina grande', 'PB', 'F', '12345678905', 'A');
INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('prata', 'campina grande', 'PB', 'F', '12345678901', 'F');

-- SO PODE TER UMA FARMACIA POR BAIRRO 
	-- Com error: 
	-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('prata', 'campina grande', 'PB', 'F', '12345678901', 'F');

-- SO PODE TER UMA SEDE DE FARMACIAS
INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('bodocongo', 'campina grande', 'PB', 'S', '12345678905', 'A');
	-- Com error: 
	-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('liberdade', 'campina grande', 'PB', 'S', '12345678901', 'F');

-- FUNCIONARIOS ESTÃO LOTADOS EM UMA ÚNICA FARMÁCIA
UPDATE funcionarios SET farmacia = 5 WHERE trabalho != 'A' AND trabalho != 'F';

-- CLIENTES CADASTRADOS DEVEM TER MAIS DE 18 ANOS
	-- Com error:
	-- INSERT INTO clientes (cpf, data_nasc) VALUES ('12345678901', '12-12-2010');
INSERT INTO clientes (cpf, data_nasc) VALUES ('12345678901', '12-12-2003');

-- ENDEREÇOS SO PODEM SER DOS TIPOS RESIDÊNCIA, TRABALHO OU OUTRO E 
-- CLIENTES PODEM TER MAIS DE UM ENDEREÇO CADASTRADO
	-- Com error:
	-- INSERT INTO enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', '210', NULL, NULL, 'Z', '12345678901');
 INSERT INTO enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', '210', NULL, NULL, 'R', '12345678901');
 INSERT INTO enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', '211', NULL, NULL, 'T', '12345678901');
 INSERT INTO enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', '212', NULL, NULL, 'O', '12345678901');

-- MEDICAMENTOS PODEM SER DE VENDA EXCLUSIVA COM RECEITA
INSERT INTO medicamentos (nome, precisa_receita) VALUES ('nome generico1', TRUE);
INSERT INTO medicamentos (nome, precisa_receita) VALUES ('nome generico2', FALSE);

-- ENTREGAS SÃO REALIZADAS APENAS PARA CLIENTES CADASTRADOS EM ALGUM ENDEREÇO VÁLIDO DO CLIENTE
	-- Com error: 
	-- INSERT INTO entregas (endereco_cep, endereco_num, medicamento, medicamento_precisa_receita) VALUES ('55405051', '210', 1, TRUE);
INSERT INTO entregas (endereco_cep, endereco_num, medicamento, medicamento_precisa_receita) VALUES ('55405050', '210', 1, TRUE);

-- OUTRAS VENDAS PODEM SER REALIZADAS PARA QUALQUER CLIENTE 
INSERT INTO vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita) VALUES (NULL, '12345678902', 'V', 2, FALSE);

-- NÃO DEVE SER POSSÍVEL EXCLUIR UM FUNCIONÁRIO ASSOCIADO À ALGUMA VENDA
	-- Com error:
	-- DELETE FROM funcionarios WHERE (cpf = '12345678902');

-- NÃO DEVE SER POSSÍVEL EXCLUIR UM MEDICAMENTO ASSOCIADO À ALGUMA VENDA
        -- Com error:
        -- DELETE FROM medicamentos WHERE (id = 2);

-- MEDICAMENTOS COM VENDA EXCLUSIVA SO PODEM SER VENDIDOS A CLIENTES CADASTRADOS 
	-- Com error:
	-- INSERT INTO vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita) VALUES (NULL, '12345678902', 'V', 1, TRUE);
INSERT INTO vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita) VALUES ('12345678901', '12345678902', 'V', 1, TRUE);

-- UMA VENDA SO PODE SER FEITA POR UM FUNCIONARIO VENDEDOR
	-- Com error: INSERT INTO vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita) VALUES ('12345678901', '12345678903', 'E', 1, TRUE);


