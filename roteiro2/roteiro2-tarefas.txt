-- QUESTÃO 01 --

CREATE TABLE tarefas (
	atarefado INTEGER,
	tarefa TEXT,
	rendimento_hora VARCHAR(11),
	pausas SMALLINT,
	concluido CHAR(1)
);

-- Comandos 1 --

INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F');

INSERT INTO tarefas VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');

INSERT INTO tarefas VALUES (null, null, null, null, null);

	-- comandos com error: 

	-- INSERT INTO tarefas VALUES (2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');

	-- INSERT INTO tarefas VALUES (2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF');

----------------

-- QUESTÃO 02 --
	
-- Comandos 2 --

	-- comando com error:	

	-- INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');

----------------

ALTER TABLE tarefas ALTER COLUMN atarefado TYPE BIGINT;

-- Comandos 2 --

INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');

----------------

-- PERCEBI QUE O CONCLUÍDO PARECE MAIS UMA NOTA DO QUE UM BOOL --

ALTER TABLE tarefas RENAME COLUMN concluido TO NOTA;

-- QUESTÃO 03 --

-- Comandos 3 --

	-- comandos com error (ja estavam sem permitir): 

	-- INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal', '32322525199', 32768, 'A');

	-- INSERT INTO tarefas VALUES (2147483650, 'limpar janelas da entrada principal', '32333233288', 32769, 'A');

----------------
-- Comandos 4 --

INSERT INTO tarefas VALUES (2147483651, 'limpar portas do 1o andar', '32323232911', 32767, 'A');

INSERT INTO tarefas VALUES (2147483652, 'limpar portas do 2o andar', '32323232911', 32766, 'A');

----------------

-- QUESTÃO 04 --

	-- comandos com error:

	-- ALTER TABLE tarefas ALTER COLUMN atarefado SET NOT NULL;
	-- ALTER TABLE tarefas ALTER COLUMN tarefa SET NOT NULL;
	-- ALTER TABLE tarefas ALTER COLUMN rendimento_hora SET NOT NULL;
	-- ALTER TABLE tarefas ALTER COLUMN pausas SET NOT NULL;
	-- ALTER TABLE tarefas ALTER COLUMN nota SET NOT NULL;

ALTER TABLE tarefas RENAME COLUMN atarefado TO id;
ALTER TABLE tarefas RENAME COLUMN tarefa TO descricao;
ALTER TABLE tarefas RENAME COLUMN rendimento_hora TO func_resp_cpf;
ALTER TABLE tarefas RENAME COLUMN pausas TO prioridade;
ALTER TABLE tarefas RENAME COLUMN nota TO status;

DELETE FROM tarefas WHERE
	id IS NULL AND
	descricao IS NULL AND
	func_resp_cpf IS NULL AND
	prioridade IS NULL AND
	status IS NULL;

ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;

-- QUESTÃO 05 --

-- Comandos 5 --

INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'A');

INSERT INTO tarefas VALUES (2147483653, 'aparar a grama da área frontal', '32323232911', 3, 'A');

----------------

-- FUNCIONOU ENTÃO IREI APAGAR --
DELETE FROM tarefas WHERE prioridade = 3;

ALTER TABLE tarefas ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);

-- Comandos 5 (em partes) --

	-- comando com error:
	-- INSERT INTO tarefas VALUES (2147483653, 'aparar a grama da área frontal', '32323232911', 3, 'A');

----------------------------

-- QUESTÃO 06.A --

ALTER TABLE tarefas ADD CONSTRAINT func_resp_cpf_11 CHECK (
	LENGTH(func_resp_cpf) = 11
);

	-- comandos com error:
	-- INSERT INTO tarefas VALUES (2147483654, 'limpar portas do 3o andar', 3232323291, 2, 'A');
	-- INSERT INTO tarefas VALUES (2147483654, 'limpar portas do 3o andar', 323232329111, 2, 'A');

-- QUESTÃO 06.B --

	-- comando com error:

	-- ALTER TABLE tarefas ADD CONSTRAINT status_valido CHECK (
	-- 	 status = 'P' OR
	-- 	 status = 'E' OR
	-- 	 status = 'C'
	-- );

UPDATE tarefas SET status = 'P' WHERE status = 'A';
UPDATE tarefas SET status = 'E' WHERE status = 'R';
UPDATE tarefas SET status = 'C' WHERE status = 'F';

ALTER TABLE tarefas ADD CONSTRAINT status_valido CHECK (
	status = 'P' OR
	status = 'E' OR
        status = 'C'
);

-- QUESTÃO 07 --

	-- comando com error:
	-- ALTER TABLE tarefas ADD CONSTRAINT prioridade_limite CHECK (prioridade <= 5 AND prioridade >= 0);

UPDATE tarefas SET prioridade = 5 WHERE prioridade > 5;

ALTER TABLE tarefas ADD CONSTRAINT prioridade_limite CHECK (prioridade <= 5 AND prioridade >= 0);

-- QUESTÃO 08 -- 

CREATE TABLE funcionario (
	cpf CHAR(11) CONSTRAINT funcionario_pkey PRIMARY KEY,
	data_nasc DATE NOT NULL,
	nome VARCHAR(25) NOT NULL,
	funcao VARCHAR(11),
	nivel CHAR(1) NOT NULL,
	superior_cpf CHAR(11),
	CONSTRAINT tipos_funcao CHECK (funcao = 'LIMPEZA' OR funcao = 'SUP_LIMPEZA'),
	CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES funcionario (cpf),
	CONSTRAINT limpeza_tem_superior CHECK ((funcao = 'LIMPEZA' AND superior_cpf IS NOT NULL) OR (funcao = 'SUP_LIMPEZA')),
	CONSTRAINT tipos_nivel CHECK (nivel = 'J' OR nivel = 'P' OR nivel = 'S')
);

-- Comandos 6 --

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');

	-- comando com error:
	-- INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1980-04-09', 'joao da Silva', 'LIMPEZA', 'J', null);

----------------

-- QUESTÃO 09 --

-- comandos funcionando --

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1980-04-04', 'Junior da Silva', 'SUP_LIMPEZA', 'P', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1985-10-10', 'Joaquim da Silva', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', '1970-04-02', 'Jorge da Silva', 'SUP_LIMPEZA', 'J', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '2000-01-01', 'Jonathan da Silva', 'SUP_LIMPEZA', 'P', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '2003-12-12', 'Jason da Silva', 'SUP_LIMPEZA', 'S', null);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1980-04-04', 'Jaymisson da Silva', 'LIMPEZA', 'P', '12345678913');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1985-10-10', 'Josikwylkson da Silva', 'LIMPEZA', 'S', '12345678914');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678920', '1970-04-02', 'Josik da Silva', 'LIMPEZA', 'J', '12345678915');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '2000-01-01', 'Jessica da Silva', 'LIMPEZA', 'P', '12345678916');
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '2003-12-12', 'Josi da Silva', 'LIMPEZA', 'S', '12345678917');

	-- comandos com error:

	-- Por primary key --
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1960-11-23', 'João da Silva', 'SUP_LIMPEZA', 'S', null);
	-- Por ser LIMPEZA e não ter superior --
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '1950-11-11', 'Jonny da Silva', 'LIMPEZA', 'J', null);
	-- Por nivel inválido -- 
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '2001-01-01', 'Josue da Silva', 'LIMPEZA', 'I', '12345678911');
	-- Por funcao inválida -- 
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '2003-12-12', 'Jason da Silva', 'INVALIDA', 'S', '12345678911');
	-- Por date null --
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', null, 'Jaymisson da Silva', 'LIMPEZA', 'P', '12345678913');
	-- Por nome null --
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '1985-10-10', null, 'LIMPEZA', 'S', '12345678914');
	-- Por nivel null --
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '1970-04-02', 'Josik da Silva', 'LIMPEZA', null, '12345678915');
	-- Por date invalida -- 
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '2000-13-13', 'Jessica da Silva', 'LIMPEZA', 'P', '12345678916');
	-- Por nome inválido -- 
	-- INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '2003-12-12', 'Josinaldo Florentino Mendonça Vieira Matos Augustino III da Silva', 'LIMPEZA', 'S', '12345678917');

-- QUESTÃO 10 -- 

	-- comando com error:
	-- ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario (cpf) ON DELETE RESTRICT;

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
        (32323232955, '2000-01-01', 'J da Silva', 'SUP_LIMPEZA', 'S', NULL),
        (98765432111, '2000-01-01', 'J da Silva', 'SUP_LIMPEZA', 'S', NULL),
        (98765432122, '2000-01-01', 'J da Silva', 'SUP_LIMPEZA', 'S', NULL),
        (32323232911, '2000-01-01', 'J da Silva', 'SUP_LIMPEZA', 'S', NULL);

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario (cpf) ON DELETE CASCADE;

DELETE FROM funcionario WHERE (cpf = '32323232955');

ALTER TABLE tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario (cpf) ON DELETE RESTRICT;

	-- comando com error:
	-- DELETE FROM funcionario WHERE (cpf = '98765432111');
	-- erro: ERROR:  update or delete on table "funcionario" violates foreign key constraint "tarefas_func_resp_cpf_fkey" on table "tarefas"

-- QUESTÃO 11 --

ALTER TABLE tarefas ADD CONSTRAINT planejada_sem_resp CHECK ((func_resp_cpf = NULL AND status = 'P') OR (func_resp_cpf IS NOT NULL));

ALTER TABLE tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario (cpf) ON DELETE SET NULL;

ALTER TABLE tarefas ALTER COLUMN func_resp_cpf DROP NOT NULL;

-- teste --

INSERT INTO tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES
	(2147483654, 'limpar tudo', '32323232911', 5, 'P'),
	(2147483655, 'limpar tudo', '32323232911', 5, 'C'),
	(2147483656, 'limpar tudo', '32323232911', 5, 'E');

	-- comando com error:
	-- DELETE FROM funcionario WHERE (cpf = '32323232911');
	-- error: ERROR:  new row for relation "tarefas" violates check constraint "planejada_sem_resp"
	-- DETAIL:  Failing row contains (2147483655, limpar tudo, null, 5, C).
	-- CONTEXT:  SQL statement "UPDATE ONLY "public"."tarefas" SET "func_resp_cpf" = NULL WHERE $1 OPERATOR(pg_catalog.=) "func_resp_cpf"::pg_catalog.bpchar"


