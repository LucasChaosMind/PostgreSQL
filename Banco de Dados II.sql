create schema banco;



create table banco.estado(
	cod_estado int8 not null, 
	nome varchar(20) not null,
	constraint cod_estadopk primary key (cod_estado)
);

create table banco.cidade(
	cod_cidade int8 not null,
	nome varchar(20) not null,
	cod_estado int8 not null,
	constraint cod_cidadepk primary key (cod_cidade)
);

create table banco.bancos(
	cod_banco int8 not null,
	nome varchar(35) not null,
	rua varchar(35) not null,
	numero int8 not null,
	bairro varchar(35) not null,
	complemento varchar(15),
	cod_cidade int8 not null
);

create table banco.agencia(
	num_agencia int8 not null,
	rua varchar(35) not null,
	numero int8 not null,
	bairro varchar(35) not null,
	complemento varchar(15),
	cod_cidade int8 not null,
	cod_banco int8,
	constraint num_agenciapk primary key (num_agencia)
);

create table banco.clientes(
	cpf varchar(35) unique,
	nome varchar(60) not null,
	rua varchar(35) not null,
	numero int8 not null,
	bairro varchar(35) not null,
	complemento varchar(15),
	cod_cidade int8 not null,
	constraint cpfpk primary key (cpf)
);

create table banco.telefone(
	cod_telefone serial,
	cpf varchar(35) unique,
	ddd varchar(15) not null,
	numero varchar(35) not null
);

create table banco.tipo_conta(
	cod_tipo int8,
	nome varchar(35) not null,
	constraint cod_tipopk primary key(cod_tipo)
);

create table banco.conta(
	num_conta serial unique,
	saldo numeric(9,3),
	cod_tipo int8 not null,
	num_agencia int8 not null
);

create table banco.conta_cliente(
	num_conta serial constraint num_contapk unique,
	cpf varchar(35) constraint cpfpk not null,
	--constraint num_contapk primary key (num_conta),
	--constraint cpfpk primary key (cpf)
	primary key (num_conta,cpf)
);


create table banco.tipo_emprestimo(
	cod_tipo int8 not null,
	nome varchar(35) not null,
	constraint cod_tipo_pk primary key (cod_tipo) 
);

create table banco.emprestimos(
	num_emp int8 not null,
	quantia numeric(7,3) not null,
	cod_tipo int8 not null,
	num_agencia int8 not null,
	constraint num_emppk primary key (num_emp)
);

create table banco.emprestimo_cliente(
	num_emp int8 constraint num_emppk not null,
	cpf varchar(35) constraint cpfpk not null,
	primary key(num_emp,cpf)
);

alter table banco.cidade add constraint cod_estadofk foreign key (cod_estado) references banco.estado(cod_estado);
alter table banco.bancos add constraint cod_bancopk primary key (cod_banco);
alter table banco.bancos add constraint cod_cidadefk foreign key (cod_cidade) references banco.cidade(cod_cidade);
alter table banco.agencia add constraint cod_cidadefk foreign key (cod_cidade) references banco.cidade(cod_cidade);
alter table banco.agencia add constraint cod_bancofk foreign key (cod_banco) references banco.bancos (cod_banco);
alter table banco.clientes add constraint cod_cidadefk foreign key (cod_cidade) references banco.cidade (cod_cidade);
alter table banco.telefone add constraint cpffk foreign key (cpf) references banco.clientes(cpf);
alter table banco.conta add constraint cod_tipofk foreign key (cod_tipo) references banco.tipo_conta(cod_tipo);
alter table banco.conta add constraint num_agenciafk foreign key (num_agencia) references banco.agencia (num_agencia);
alter table banco.conta_cliente add constraint num_contafk foreign key (num_conta) references banco.conta (num_conta);
alter table banco.conta_cliente add constraint cpffk foreign key (cpf) references banco.clientes(cpf);
alter table banco.emprestimos add constraint cod_tipofk foreign key (cod_tipo) references banco.tipo_emprestimo (cod_tipo);
alter table banco.emprestimos add constraint num_agenciafk foreign key (num_agencia) references banco.agencia (num_agencia);
alter table banco.emprestimo_cliente add constraint num_empfk foreign key (num_emp) references banco.emprestimos (num_emp);
alter table banco.emprestimo_cliente add constraint cpffk foreign key (cpf) references banco.clientes (cpf);