--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.4 (Ubuntu 15.4-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_medicamento_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_funcionario_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_cliente_cadastrado_fkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_farmacia_fkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_gerente_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_medicamento_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_endereco_fkey;
ALTER TABLE ONLY public.enderecos_clientes DROP CONSTRAINT enderecos_clientes_cliente_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_tipo_s_exclude;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_bairro_unique;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.enderecos_clientes DROP CONSTRAINT enderecos_clientes_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
ALTER TABLE public.vendas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medicamentos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.farmacias ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entregas ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.vendas_id_seq;
DROP TABLE public.vendas;
DROP SEQUENCE public.medicamentos_id_seq;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP SEQUENCE public.farmacias_id_seq;
DROP TABLE public.farmacias;
DROP SEQUENCE public.entregas_id_seq;
DROP TABLE public.entregas;
DROP TABLE public.enderecos_clientes;
DROP TABLE public.clientes;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: samuellvm
--

CREATE TABLE public.clientes (
    cpf character(11) NOT NULL,
    data_nasc date,
    CONSTRAINT clientes_cpf_valido CHECK ((length(cpf) = 11)),
    CONSTRAINT clientes_data_nasc_valida CHECK ((EXTRACT(year FROM age((CURRENT_DATE)::timestamp with time zone, (data_nasc)::timestamp with time zone)) >= (18)::numeric))
);


ALTER TABLE public.clientes OWNER TO samuellvm;

--
-- Name: enderecos_clientes; Type: TABLE; Schema: public; Owner: samuellvm
--

CREATE TABLE public.enderecos_clientes (
    cep character(8) NOT NULL,
    num smallint NOT NULL,
    complemento character varying(15),
    ponto_referencia character varying(25),
    tipo character(1),
    cliente character(11) NOT NULL,
    CONSTRAINT enderecos_clientes_cep_valido CHECK ((length(cep) = 8)),
    CONSTRAINT enderecos_clientes_tipo_valido CHECK (((tipo = 'R'::bpchar) OR (tipo = 'T'::bpchar) OR (tipo = 'O'::bpchar)))
);


ALTER TABLE public.enderecos_clientes OWNER TO samuellvm;

--
-- Name: entregas; Type: TABLE; Schema: public; Owner: samuellvm
--

CREATE TABLE public.entregas (
    id integer NOT NULL,
    endereco_cep character(8) NOT NULL,
    endereco_num smallint NOT NULL,
    medicamento integer NOT NULL,
    medicamento_precisa_receita boolean NOT NULL
);


ALTER TABLE public.entregas OWNER TO samuellvm;

--
-- Name: entregas_id_seq; Type: SEQUENCE; Schema: public; Owner: samuellvm
--

CREATE SEQUENCE public.entregas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entregas_id_seq OWNER TO samuellvm;

--
-- Name: entregas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: samuellvm
--

ALTER SEQUENCE public.entregas_id_seq OWNED BY public.entregas.id;


--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: samuellvm
--

CREATE TABLE public.farmacias (
    id integer NOT NULL,
    bairro character varying(15),
    cidade character varying(15),
    estado public.estadonordeste,
    tipo character(1),
    gerente character(11),
    trabalho_gerente character(1),
    CONSTRAINT farmacias_gerente_trabalho_valido CHECK (((trabalho_gerente = 'F'::bpchar) OR (trabalho_gerente = 'A'::bpchar))),
    CONSTRAINT farmacias_tipo_valido CHECK (((tipo = 'S'::bpchar) OR (tipo = 'F'::bpchar)))
);


ALTER TABLE public.farmacias OWNER TO samuellvm;

--
-- Name: farmacias_id_seq; Type: SEQUENCE; Schema: public; Owner: samuellvm
--

CREATE SEQUENCE public.farmacias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacias_id_seq OWNER TO samuellvm;

--
-- Name: farmacias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: samuellvm
--

ALTER SEQUENCE public.farmacias_id_seq OWNED BY public.farmacias.id;


--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: samuellvm
--

CREATE TABLE public.funcionarios (
    cpf character(11) NOT NULL,
    trabalho character(1) NOT NULL,
    farmacia integer,
    CONSTRAINT funcionarios_cpf_valido CHECK ((length(cpf) = 11)),
    CONSTRAINT funcionarios_trabalho_valido CHECK (((trabalho = 'F'::bpchar) OR (trabalho = 'V'::bpchar) OR (trabalho = 'E'::bpchar) OR (trabalho = 'C'::bpchar) OR (trabalho = 'A'::bpchar)))
);


ALTER TABLE public.funcionarios OWNER TO samuellvm;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: samuellvm
--

CREATE TABLE public.medicamentos (
    id integer NOT NULL,
    precisa_receita boolean NOT NULL,
    nome character varying(25)
);


ALTER TABLE public.medicamentos OWNER TO samuellvm;

--
-- Name: medicamentos_id_seq; Type: SEQUENCE; Schema: public; Owner: samuellvm
--

CREATE SEQUENCE public.medicamentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamentos_id_seq OWNER TO samuellvm;

--
-- Name: medicamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: samuellvm
--

ALTER SEQUENCE public.medicamentos_id_seq OWNED BY public.medicamentos.id;


--
-- Name: vendas; Type: TABLE; Schema: public; Owner: samuellvm
--

CREATE TABLE public.vendas (
    cliente_cadastrado character(11),
    funcionario character(11),
    funcionario_trabalho character(1),
    medicamento integer,
    medicamento_precisa_receita boolean,
    id integer NOT NULL,
    CONSTRAINT vendas_funcionario_trabalho_valido CHECK ((funcionario_trabalho = 'V'::bpchar)),
    CONSTRAINT vendas_medicamento_precisa_receita CHECK ((((medicamento_precisa_receita = true) AND (cliente_cadastrado IS NOT NULL)) OR (medicamento_precisa_receita = false)))
);


ALTER TABLE public.vendas OWNER TO samuellvm;

--
-- Name: vendas_id_seq; Type: SEQUENCE; Schema: public; Owner: samuellvm
--

CREATE SEQUENCE public.vendas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendas_id_seq OWNER TO samuellvm;

--
-- Name: vendas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: samuellvm
--

ALTER SEQUENCE public.vendas_id_seq OWNED BY public.vendas.id;


--
-- Name: entregas id; Type: DEFAULT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.entregas ALTER COLUMN id SET DEFAULT nextval('public.entregas_id_seq'::regclass);


--
-- Name: farmacias id; Type: DEFAULT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.farmacias ALTER COLUMN id SET DEFAULT nextval('public.farmacias_id_seq'::regclass);


--
-- Name: medicamentos id; Type: DEFAULT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.medicamentos ALTER COLUMN id SET DEFAULT nextval('public.medicamentos_id_seq'::regclass);


--
-- Name: vendas id; Type: DEFAULT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id SET DEFAULT nextval('public.vendas_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: samuellvm
--

INSERT INTO public.clientes (cpf, data_nasc) VALUES ('12345678901', '2003-12-12');


--
-- Data for Name: enderecos_clientes; Type: TABLE DATA; Schema: public; Owner: samuellvm
--

INSERT INTO public.enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', 210, NULL, NULL, 'R', '12345678901');
INSERT INTO public.enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', 211, NULL, NULL, 'T', '12345678901');
INSERT INTO public.enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', 212, NULL, NULL, 'O', '12345678901');


--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: samuellvm
--

INSERT INTO public.entregas (id, endereco_cep, endereco_num, medicamento, medicamento_precisa_receita) VALUES (2, '55405050', 210, 1, true);


--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: samuellvm
--

INSERT INTO public.farmacias (id, bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES (5, 'catole', 'campina grande', 'PB', 'F', '12345678905', 'A');
INSERT INTO public.farmacias (id, bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES (6, 'prata', 'campina grande', 'PB', 'F', '12345678901', 'F');
INSERT INTO public.farmacias (id, bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES (8, 'bodocongo', 'campina grande', 'PB', 'S', '12345678905', 'A');


--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: samuellvm
--

INSERT INTO public.funcionarios (cpf, trabalho, farmacia) VALUES ('12345678901', 'F', NULL);
INSERT INTO public.funcionarios (cpf, trabalho, farmacia) VALUES ('12345678905', 'A', NULL);
INSERT INTO public.funcionarios (cpf, trabalho, farmacia) VALUES ('12345678902', 'V', 5);
INSERT INTO public.funcionarios (cpf, trabalho, farmacia) VALUES ('12345678903', 'E', 5);
INSERT INTO public.funcionarios (cpf, trabalho, farmacia) VALUES ('12345678904', 'C', 5);


--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: samuellvm
--

INSERT INTO public.medicamentos (id, precisa_receita, nome) VALUES (1, true, 'nome generico1');
INSERT INTO public.medicamentos (id, precisa_receita, nome) VALUES (2, false, 'nome generico2');


--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: samuellvm
--

INSERT INTO public.vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita, id) VALUES (NULL, '12345678902', 'V', 2, false, 1);
INSERT INTO public.vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita, id) VALUES ('12345678901', '12345678902', 'V', 1, true, 8);


--
-- Name: entregas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: samuellvm
--

SELECT pg_catalog.setval('public.entregas_id_seq', 2, true);


--
-- Name: farmacias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: samuellvm
--

SELECT pg_catalog.setval('public.farmacias_id_seq', 9, true);


--
-- Name: medicamentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: samuellvm
--

SELECT pg_catalog.setval('public.medicamentos_id_seq', 2, true);


--
-- Name: vendas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: samuellvm
--

SELECT pg_catalog.setval('public.vendas_id_seq', 9, true);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cpf);


--
-- Name: enderecos_clientes enderecos_clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.enderecos_clientes
    ADD CONSTRAINT enderecos_clientes_pkey PRIMARY KEY (cep, num);


--
-- Name: entregas entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (id);


--
-- Name: farmacias farmacias_bairro_unique; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_bairro_unique UNIQUE (bairro);


--
-- Name: farmacias farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_pkey PRIMARY KEY (id);


--
-- Name: farmacias farmacias_tipo_s_exclude; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_tipo_s_exclude EXCLUDE USING gist (tipo WITH =) WHERE ((tipo = 'S'::bpchar));


--
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (cpf, trabalho);


--
-- Name: medicamentos medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (id, precisa_receita);


--
-- Name: vendas vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);


--
-- Name: enderecos_clientes enderecos_clientes_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.enderecos_clientes
    ADD CONSTRAINT enderecos_clientes_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.clientes(cpf);


--
-- Name: entregas entregas_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_endereco_fkey FOREIGN KEY (endereco_cep, endereco_num) REFERENCES public.enderecos_clientes(cep, num);


--
-- Name: entregas entregas_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_medicamento_fkey FOREIGN KEY (medicamento, medicamento_precisa_receita) REFERENCES public.medicamentos(id, precisa_receita);


--
-- Name: farmacias farmacias_gerente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_gerente_fkey FOREIGN KEY (gerente, trabalho_gerente) REFERENCES public.funcionarios(cpf, trabalho);


--
-- Name: funcionarios funcionarios_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_farmacia_fkey FOREIGN KEY (farmacia) REFERENCES public.farmacias(id);


--
-- Name: vendas vendas_cliente_cadastrado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_cliente_cadastrado_fkey FOREIGN KEY (cliente_cadastrado) REFERENCES public.clientes(cpf);


--
-- Name: vendas vendas_funcionario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_funcionario_fkey FOREIGN KEY (funcionario, funcionario_trabalho) REFERENCES public.funcionarios(cpf, trabalho) ON DELETE RESTRICT;


--
-- Name: vendas vendas_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: samuellvm
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_medicamento_fkey FOREIGN KEY (medicamento, medicamento_precisa_receita) REFERENCES public.medicamentos(id, precisa_receita) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--


-- 
-- COMANDOS ADICIONAIS 
-- 

-- FUNCIONARIO SO PODE SER FARMACEUTICO, VENDEDOR, ENTREGADOR, CAIXA OU ADMINISTRADOR E
-- FUNCIONARIO PODE NÃO ESTAR LOTADO EM UMA FARMÁCIA
	-- Com error:
	-- INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678901', 'Z', null);
-- INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678901', 'F', null);
-- INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678902', 'V', null);
-- INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678903', 'E', null);
-- INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678904', 'C', null);
-- INSERT INTO funcionarios (cpf, trabalho, farmacia) VALUES ('12345678905', 'A', null);

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
-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('catole', 'campina grande', 'PB', 'F', '12345678905', 'A');
-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('prata', 'campina grande', 'PB', 'F', '12345678901', 'F');

-- SO PODE TER UMA FARMACIA POR BAIRRO
	-- Com error:
	-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('prata', 'campina grande', 'PB', 'F', '12345678901', 'F');

-- SO PODE TER UMA SEDE DE FARMACIAS
-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('bodocongo', 'campina grande', 'PB', 'S', '12345678905', 'A');
	-- Com error:
	-- INSERT INTO farmacias (bairro, cidade, estado, tipo, gerente, trabalho_gerente) VALUES ('liberdade', 'campina grande', 'PB', 'S', '12345678901', 'F');

-- FUNCIONARIOS ESTÃO LOTADOS EM UMA ÚNICA FARMÁCIA
-- UPDATE funcionarios SET farmacia = 5 WHERE trabalho != 'A' AND trabalho != 'F';

-- CLIENTES CADASTRADOS DEVEM TER MAIS DE 18 ANOS
	-- Com error:
	-- INSERT INTO clientes (cpf, data_nasc) VALUES ('12345678901', '12-12-2010');
-- INSERT INTO clientes (cpf, data_nasc) VALUES ('12345678901', '12-12-2003');

-- ENDEREÇOS SO PODEM SER DOS TIPOS RESIDÊNCIA, TRABALHO OU OUTRO E
-- CLIENTES PODEM TER MAIS DE UM ENDEREÇO CADASTRADO
	-- Com error:
	-- INSERT INTO enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', '210', NULL, NULL, 'Z', '12345678901');
-- INSERT INTO enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', '210', NULL, NULL, 'R', '12345678901');
-- INSERT INTO enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', '211', NULL, NULL, 'T', '12345678901');
-- INSERT INTO enderecos_clientes (cep, num, complemento, ponto_referencia, tipo, cliente) VALUES ('55405050', '212', NULL, NULL, 'O', '12345678901');

-- MEDICAMENTOS PODEM SER DE VENDA EXCLUSIVA COM RECEITA
-- INSERT INTO medicamentos (nome, precisa_receita) VALUES ('nome generico1', TRUE);
-- INSERT INTO medicamentos (nome, precisa_receita) VALUES ('nome generico2', FALSE);

-- ENTREGAS SÃO REALIZADAS APENAS PARA CLIENTES CADASTRADOS EM ALGUM ENDEREÇO VÁLIDO DO CLIENTE
	-- Com error:
	-- INSERT INTO entregas (endereco_cep, endereco_num, medicamento, medicamento_precisa_receita) VALUES ('55405051', '210', 1, TRUE);
-- INSERT INTO entregas (endereco_cep, endereco_num, medicamento, medicamento_precisa_receita) VALUES ('55405050', '210', 1, TRUE);

-- OUTRAS VENDAS PODEM SER REALIZADAS PARA QUALQUER CLIENTE
-- INSERT INTO vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita) VALUES (NULL, '12345678902', 'V', 2, FALSE);

-- NÃO DEVE SER POSSÍVEL EXCLUIR UM FUNCIONÁRIO ASSOCIADO À ALGUMA VENDA
	-- Com error:
	-- DELETE FROM funcionarios WHERE (cpf = '12345678902');

-- NÃO DEVE SER POSSÍVEL EXCLUIR UM MEDICAMENTO ASSOCIADO À ALGUMA VENDA
        -- Com error:
        -- DELETE FROM medicamentos WHERE (id = 2);

-- MEDICAMENTOS COM VENDA EXCLUSIVA SO PODEM SER VENDIDOS A CLIENTES CADASTRADOS
	-- Com error:
	-- INSERT INTO vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita) VALUES (NULL, '12345678902', 'V', 1, TRUE);
-- INSERT INTO vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita) VALUES ('12345678901', '12345678902', 'V', 1, TRUE);

-- UMA VENDA SO PODE SER FEITA POR UM FUNCIONARIO VENDEDOR
	-- Com error: INSERT INTO vendas (cliente_cadastrado, funcionario, funcionario_trabalho, medicamento, medicamento_precisa_receita) VALUES ('12345678901', '12345678903', 'E', 1, TRUE);

