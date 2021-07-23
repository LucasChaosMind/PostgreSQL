/* Grupo E:  
 * 
 * Lucas Calado Bresolino
 *		   &
 * Lucio Sganzerla
 *
 */

/* Criacao do banco*/
create database banco_grupo_e;


/* ACESSE O BANCO DE DADOS CRIADO ANTERIORMENTE ANTES DE SEGUIR COM A EXECUCAO */


/* Criacao do schema */
create schema banco_grupo_e;


/* Criacao das tabelas do banco ja com chave primaria */
create table banco_grupo_e.estado (
	cod_estado int8 not null,
	nome varchar(50) not null,
	constraint estado_pk primary key (cod_estado));
	
create table banco_grupo_e.tipoconta (
	cod_tipo int8 not null,
	nome varchar(50) not null,
	constraint tipoconta_pk primary key (cod_tipo));

create table banco_grupo_e.tipoemprestimo (
	cod_tipo int8 not null,
	nome varchar(50) not null,
	constraint tipoemprestimo_pk primary key (cod_tipo));

create table banco_grupo_e.conta (
	num_conta int8 not null,
	saldo money not null,
	cod_tipo int8 not null,
	num_agencia int8 not null,
	constraint conta_pk primary key (num_conta));

create table banco_grupo_e.cidade (
	cod_cidade int8 not null,
	nome varchar(50) not null,
	cod_estado int8 not null,
	constraint cidade_pk primary key (cod_cidade));

create table banco_grupo_e.bancos (
	cod_banco int8 not null,
	nome varchar(50) not null,
	rua varchar(50) not null,
	numero int8 not null,
	bairro varchar(50) not null,
	complemento varchar(50) null,
	cod_cidade int8 not null,
	constraint bancos_pk primary key (cod_banco));

create table banco_grupo_e.agencia (
	num_agencia int8 not null,
	rua varchar(50) not null,
	numero int8 not null,
	bairro varchar(50) not null,
	complemento varchar(50) null,
	cod_cidade int8 not null,
	cod_banco int8 not null,
	constraint num_agencia_pk primary key (num_agencia));

create table banco_grupo_e.conta_cliente (
	num_conta int8 null,
	cpf varchar(50) not null,
	constraint cpf_pk primary key (cpf));
	
create table banco_grupo_e.emprestimos (
	num_emp int8 not null,
	quantia money not null,
	cod_tipo int8 not null,
	num_agencia int8 not null,
	constraint num_emp_pk primary key (num_emp));

create table banco_grupo_e.emprestimo_cliente (
	num_emp int8 not null,
	cpf varchar(50) not null,
	constraint emprestimo_cliente_pk primary key (num_emp));

create table banco_grupo_e.clientes (
	cpf varchar(50) not null,
	nome varchar(50) not null,
	rua varchar(50) not null,
	numero int8 not null,
	bairro varchar(50) not null,
	complemento varchar(50) null,
	cod_cidade int8 not null,
	constraint clientes_pk primary key (cpf));

create table banco_grupo_e.telefone (
	cod_telefone int8 not null,
	cpf varchar(50) not null,
	ddd int8 not null,
	numero int8 not null,
	constraint telefone_pk primary key (cod_telefone));

/* Adicao das chaves estrangeiras */
alter table banco_grupo_e.conta ADD constraint conta_tipo_fk FOREIGN key (cod_tipo) REFERENCES banco_grupo_e.tipoconta(cod_tipo);
alter table banco_grupo_e.conta ADD constraint num_agencia_fk FOREIGN key (num_agencia) REFERENCES banco_grupo_e.agencia(num_agencia);
alter table banco_grupo_e.cidade add constraint cod_estado_fk foreign key (cod_estado) references banco_grupo_e.estado(cod_estado);
alter table banco_grupo_e.bancos add constraint cod_cidade_fk foreign key (cod_cidade) references banco_grupo_e.cidade(cod_cidade);
alter table banco_grupo_e.conta_cliente add constraint num_conta_fk foreign key (num_conta) references banco_grupo_e.conta(num_conta);
alter table banco_grupo_e.conta_cliente add constraint cpf_fk foreign key (cpf) references banco_grupo_e.clientes(cpf);
alter table banco_grupo_e.emprestimos add constraint cod_tipo_fk foreign key (cod_tipo) references banco_grupo_e.tipoemprestimo(cod_tipo);
alter table banco_grupo_e.emprestimos ADD constraint num_agencia_fk FOREIGN key (num_agencia) REFERENCES banco_grupo_e.agencia(num_agencia);
alter table banco_grupo_e.agencia add constraint cod_cidade_fk foreign key (cod_cidade) references banco_grupo_e.cidade(cod_cidade);
alter table banco_grupo_e.agencia add constraint cod_banco_fk foreign key (cod_banco) references banco_grupo_e.bancos(cod_banco);
alter table banco_grupo_e.emprestimo_cliente add constraint num_emp_fk foreign key (num_emp) references banco_grupo_e.emprestimos(num_emp);
alter table banco_grupo_e.emprestimo_cliente add constraint cpf_fk foreign key (cpf) references banco_grupo_e.clientes(cpf);
alter table banco_grupo_e.clientes add constraint cod_cidade_fk foreign key (cod_cidade) references banco_grupo_e.cidade(cod_cidade);
alter table banco_grupo_e.telefone add constraint cpf_fk foreign key (cpf) references banco_grupo_e.clientes(cpf);
