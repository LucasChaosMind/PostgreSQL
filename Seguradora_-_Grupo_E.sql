/* Grupo E:  
 * 
 * Lucas Calado Bresolino
 *		   &
 * Lúcio Sganzerla
 *
 */


/*
 * INICIO DA PARTE 1 – Scripts de criação e inserção de dados
 *  
 * 1. Crie o banco de dados para o modelo de dados relacional acima no PostgreSQL,
 * selecionando adequadamente os tipos de dados para cada atributo.
 */


/* Criação do banco*/
--create database seguradora_grupo_e;


/* ACESSE O BANCO DE DADOS CRIADO ANTERIORMENTE ANTES DE SEGUIR COM A EXECUÇÃO */


/* Criação do schema */
--create schema seguradora;


/* Criação das tabelas do banco já com chave primaria */
create table seguradora.estados (
	cod_estado int8 not null,
	nome_estado varchar(50) null,
	constraint estado_pk primary key (cod_estado));

create table seguradora.cidades (
	cod_cidade int8 not null,
	nome_cidade varchar(50) null,
	cod_estado int8 not null,
	constraint cidade_pk primary key (cod_cidade));

create table seguradora.pessoasfisicas (
	cpf varchar(50) not null,
	rg varchar(50) null,
	nomecompleto varchar(50) not null,
	cidade int8 not null,
	datanascimento date not null,
	constraint pessoa_pk primary key (cpf));
	
create table seguradora.marcas (
	cod_marca int8 not null,
	nome_marca varchar(50) null,
	constraint marca_pk primary key (cod_marca));

create table seguradora.modelos (
	cod_modelo int8 not null,
	nome_modelo varchar(50) null,
	tipo_modelo varchar(50) null,
	cor_modelo varchar(50) null,
	cidade_modelo int8 not null,
	cod_marca int8 not null,
	constraint modelo_pk primary key (cod_modelo));

create table seguradora.automoveis (
	cod_automovel int8 not null,
	modelo int8 not null,
	ano_modelo int8 null,
	ano_fabricacao int8 not null,
	proprietario varchar(50) not null,
	constraint automoveis_pk primary key (cod_automovel));

create table seguradora.sinistros (
	codsinistro int8 not null,
	codautomovel int8 not null,
	motorista varchar(50) not null,
	data_sinistro date not null,
	valor_sinistro money not null,
	constraint sinistros_pk primary key (codsinistro));

/* Adição das chaves estrangeiras */
alter table seguradora.cidades add constraint estado_fk FOREIGN key (cod_estado) REFERENCES seguradora.estados(cod_estado);
alter table seguradora.modelos add constraint marca_fk FOREIGN key (cod_marca) REFERENCES seguradora.marcas(cod_marca);
alter table seguradora.modelos add constraint cidade_fk FOREIGN key (cidade_modelo) REFERENCES seguradora.cidades(cod_cidade);
alter table seguradora.automoveis add constraint modelo_fk FOREIGN key (modelo) REFERENCES seguradora.modelos(cod_modelo);
alter table seguradora.automoveis add constraint pessoa_fk FOREIGN key (proprietario) REFERENCES seguradora.pessoasfisicas(cpf);
alter table seguradora.sinistros add constraint codautomovel_fk FOREIGN key (codautomovel) REFERENCES seguradora.automoveis(cod_automovel);
alter table seguradora.sinistros add constraint motorista_fk FOREIGN key (motorista) REFERENCES seguradora.pessoasfisicas(cpf);


/*
 * 2. Inserir pelo menos 5 registros em cada tabela, usando o comando INSERT.
 */

INSERT INTO seguradora.estados (cod_estado,nome_estado)	VALUES (0,'RJ');
INSERT INTO seguradora.estados (cod_estado,nome_estado)	VALUES (1,'SP');
INSERT INTO seguradora.estados (cod_estado,nome_estado)	VALUES (2,'RS');
INSERT INTO seguradora.estados (cod_estado,nome_estado)	VALUES (3,'SC');
INSERT INTO seguradora.estados (cod_estado,nome_estado)	VALUES (4,'PR');

INSERT INTO seguradora.cidades (cod_cidade,nome_cidade,cod_estado) VALUES (0,'Rio de Janeiro',0);
INSERT INTO seguradora.cidades (cod_cidade,nome_cidade,cod_estado) VALUES (1,'Bauru',1);
INSERT INTO seguradora.cidades (cod_cidade,nome_cidade,cod_estado) VALUES (2,'Nova Prata',2);
INSERT INTO seguradora.cidades (cod_cidade,nome_cidade,cod_estado) VALUES (3,'Torres',3);
INSERT INTO seguradora.cidades (cod_cidade,nome_cidade,cod_estado) VALUES (4,'Pato Branco',4);

INSERT INTO seguradora.pessoasfisicas (cpf,rg,nomecompleto,cidade,datanascimento) VALUES ('529.018.207-19','27.715.969-6','Martin Luiz Bruno das Neves',0,'1963-01-09');
INSERT INTO seguradora.pessoasfisicas (cpf,rg,nomecompleto,cidade,datanascimento) VALUES ('536.212.068-92','35.138.301-3','Yasmin Luna da Conceição',1,'1950-02-02');
INSERT INTO seguradora.pessoasfisicas (cpf,rg,nomecompleto,cidade,datanascimento) VALUES ('850.838.000-39','48.879.606-4','Mariana Jéssica Freitas',2,'1997-09-06');
INSERT INTO seguradora.pessoasfisicas (cpf,rg,nomecompleto,cidade,datanascimento) VALUES ('282.813.319-25','39.357.526-3','Fábio Nelson Alves',3,'1964-02-06');
INSERT INTO seguradora.pessoasfisicas (cpf,rg,nomecompleto,cidade,datanascimento) VALUES ('765.762.579-10','42.156.417-9','Daiane Maria Tatiane Barros',4,'1951-05-04');

INSERT INTO seguradora.marcas (cod_marca, nome_marca) VALUES(0, 'Libra');
INSERT INTO seguradora.marcas (cod_marca, nome_marca) VALUES(1, 'Peixes');
INSERT INTO seguradora.marcas (cod_marca, nome_marca) VALUES(2, 'Sagitário');
INSERT INTO seguradora.marcas (cod_marca, nome_marca) VALUES(3, 'Capricórnio');
INSERT INTO seguradora.marcas (cod_marca, nome_marca) VALUES(4, 'Câncer');

INSERT INTO seguradora.modelos (cod_modelo, nome_modelo, tipo_modelo, cor_modelo, cidade_modelo, cod_marca) VALUES(0, 'Foxfox', 'Galaxy S5', 'Azul', 4, 0);
INSERT INTO seguradora.modelos (cod_modelo, nome_modelo, tipo_modelo, cor_modelo, cidade_modelo, cod_marca) VALUES(1, 'Foxfox', 'Galaxy S10', 'Verde', 3, 1);
INSERT INTO seguradora.modelos (cod_modelo, nome_modelo, tipo_modelo, cor_modelo, cidade_modelo, cod_marca) VALUES(2, 'Tilibras', 'Moto G3', 'Vermelho', 2, 2);
INSERT INTO seguradora.modelos (cod_modelo, nome_modelo, tipo_modelo, cor_modelo, cidade_modelo, cod_marca) VALUES(3, 'Tilibras', 'Moto G3 Power', 'Amarelo', 1, 3);
INSERT INTO seguradora.modelos (cod_modelo, nome_modelo, tipo_modelo, cor_modelo, cidade_modelo, cod_marca) VALUES(4, 'Naiomi', 'R9', 'Branco', 0, 4);

INSERT INTO seguradora.automoveis (cod_automovel,modelo,ano_modelo,ano_fabricacao,proprietario) VALUES (0,4,2001,2000,'529.018.207-19');
INSERT INTO seguradora.automoveis (cod_automovel,modelo,ano_modelo,ano_fabricacao,proprietario) VALUES (1,3,2001,2000,'282.813.319-25');
INSERT INTO seguradora.automoveis (cod_automovel,modelo,ano_modelo,ano_fabricacao,proprietario) VALUES (2,2,2001,2000,'282.813.319-25');
INSERT INTO seguradora.automoveis (cod_automovel,modelo,ano_modelo,ano_fabricacao,proprietario) VALUES (3,1,2001,2000,'282.813.319-25');
INSERT INTO seguradora.automoveis (cod_automovel,modelo,ano_modelo,ano_fabricacao,proprietario) VALUES (4,0,2001,2000,'536.212.068-92');

INSERT INTO seguradora.sinistros (codsinistro,codautomovel,motorista,data_sinistro,valor_sinistro) VALUES (0,1,'529.018.207-19','2006-10-25',350);
INSERT INTO seguradora.sinistros (codsinistro,codautomovel,motorista,data_sinistro,valor_sinistro) VALUES (1,2,'282.813.319-25','2012-08-18',120);
INSERT INTO seguradora.sinistros (codsinistro,codautomovel,motorista,data_sinistro,valor_sinistro) VALUES (2,3,'282.813.319-25','2010-04-26',3650);
INSERT INTO seguradora.sinistros (codsinistro,codautomovel,motorista,data_sinistro,valor_sinistro) VALUES (3,4,'282.813.319-25','2004-09-14',420);
INSERT INTO seguradora.sinistros (codsinistro,codautomovel,motorista,data_sinistro,valor_sinistro) VALUES (4,0,'536.212.068-92','2006-02-12',10);

/* 
 * 3. Altere a tabela de PessoasFisicas e acrescente os campos Celular e Email.
 */

ALTER TABLE seguradora.pessoasfisicas ADD celular int8 NULL;
ALTER TABLE seguradora.pessoasfisicas ADD email varchar(50) NULL;

/* 
 * Exclua 1 registro qualquer da tabela de sinistros.
 */

DELETE FROM seguradora.sinistros WHERE codsinistro=2;

/*
 * 5. Atualize o registro da primeira pessoa física inserido na tabela, alterando a data de nascimento para “10/10/1970”.
 */

UPDATE seguradora.pessoasfisicas SET datanascimento='1970-10-10' WHERE cpf='529.018.207-19';

/*
 * 
 *  PARTE 2 – Consultas SELECT
 * 
 */

-- 1) Encontre o valor médio dos sinistros do ano de 2019.

-- 2) Exiba uma listagem com os dados do proprietário, o automóvel, marca, modelo e os sinistros que constam para o automóvel.

-- 3) Exiba o motorista mais novo. Dica: pesquisar a diretiva LIMIT do PgSQL.

-- 4) Exiba uma listagem de automóveis, com marca e modelo, mas exiba somente automóveis da cor verde e que o ano do modelo seja igual ao ano de fabricação.

-- 5) Exiba uma listagem dos motoristas envolvidos em sinistros com carros da marca Chevrolet, da cidade de Guarapuava e de cor vermelha.