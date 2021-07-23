
create table cliente(
	cpf int8 constraint cpfpk primary key,
	senha constraint senhann not null,
	nome varchar(40) constraint not null,
	idade date constraint idadenn not null,
	telefone varchar(15) constraint telun unique
);
create table cartoes_salvos(
	cod_cartao serial constraint cod_cartaopk primary key,
	cpf int8,
	bandeira varchar(45) constraint bandeirann not null,
	num_do_cartão numeric(16,0) constraint num_do_cartãoun unique,
	cvv numeric(3,0) constraint cvvnn not null,
	nome_do_cartao varchar(20)
);
create table pedidos_feitos(
	cod_pedido int8 constraint cod_pedidopk primary key,
	cod_restaurante int8 constraint cod_restaurantenn not null,
	cod_comida int8,
	data_da_compra date constraint data_da_comprann not null,
	valor money constraint valornn not null
);
create table estado(
	cod_estado int8 constraint cod_estadopk primary key,
	nome varchar(40) constraint nomenn not null,
	uf varchar(2) constraint ufnn not null
);
create table cidade(
	cod_cidade int8 constraint cod_cidadepk primary key,
	cod_estado constraint cod_estadofk foreign key references estado(cod_estado);
	nome varchar(40) constraint nomenn not null
);
create table bairro(
	cod_bairro int8 constraint cod_bairropk primary key,
	cod_cidade int8 constraint cod_cidadefk foreign key cidade(cod_cidade),
	cod_estado int8 constraint cod_estadofk foreign key estado(cod_estado),
	nome varchar(40) constraint nomenn not null,
	cep int8 constraint cepnn not null
);
create table endereço_do_cliente(
	cod_endereco_cleinte int8 constraint cod_endereco_clientepk primary key,
	cod_cidade int8 constraint cod_cidadefk foreign key references cidade(cod_cidade),
	cod_estado int8 constraint cod_estadofk foreign key references estado(cod_estado),
	cod_bairro int8 constraint cod_bairrofk foreign key references bairro(cod_bairro),
	rua varchar(40) constraint ruann not null,
	numero int8 constraint numeronn not null,
	complemento varchar(15),
	cep int8 constraint cepnn not null,
);
create table pagamento_aceito(
	tipo_pagamento int8 constraint tipo_pagamentopk primary key,
	dinheiro boolean constraint dinheironn not null,
	cartao_de_credito boolean cartao_de_credetonn constraint not null,
	cartao_de_debito boolean constraint cartao_de_debitonn not null
);
create table restaurante(
	cod_restaurante int8 constraint cod_restaurantepk primary key,
	nome varchar(40) constraint nomenn not null,
	cod_cidade int8 constraint cod_cidadefk foreign key cidade(cod_cidade),
	cod_estado int8 constraint cod_estadofk foreign key estado(cod_estado),
	cod_bairro int8 constraint cod_bairrofk foreign key bairro(cod_bairro),
	tipo_pagamento int8 constraint tipo_pagamentofk foreign key references pagamento_aceito(tipo_pagamento)
	cpnj int8 constraint cpnjnn not null
);
create table endereco_restaurante(
	cod_endereco_restaurante int8 constraint cod_endereco_restaurantepk primary key,
	cod_restaurante int8 constraint cod_restaurantefk foreign key references restaurante(cod_restaurante),
	cod_cidade int8 constraint cod_cidadefk foreign key references cidade(cod_cidade),
	cod_estado int8 constraint cod_estadofk foreign key references estad(cod_estado),
	rua varchar(40) constraint ruann not null,
	numero int8 constraint numeronn not null,
	complemento varchar(20),
	cep int8 constraint cepnn not null
);
create table cardapio(
	cod_comida int8 constraint cod_comidapk primary key,
	cod_restaurante int8 constraint cod_restaurantefk foreign key references restaurante(cod_restaurante),
	nome varchar(40) constraint nomenn not null,
	descricao varchar(150) constraint descricaonn not null,
	preco money constraint preconn not null
);
create table avaliacao_restaurante(
	avaliacao serial constraint primary key,
	cpf int8 constraint cpffk foreign key references cliente(cpf), 
	cod_restaurante int8 constraint cod_restaurantefk foreign key references restaurante(cod_restaurante),
	nota int constraint notack check(('nota'>0)&&('nota'<=5)),
	comentario varchar(150),
	cod_comida int8 constraint cod_comidafk foreign key references cardapio(cod_comida)
);
create table entregador(
	identificacao int8 constraint identificacaopk primary key,
	cpf int8 constraint cpfun unique,
	senha varchar(15) constraint not null,
	nome varchar(40) constraint, 
	cnh int8 constraint cnhun unique,
	telefone varchar(15) constraint telefoneun unique
);

alter table cartoes_salvos add constraint cpffk foreign key (cpf) references cliente(cpf);
alter table pedidos_feitos add constraint cod_comidafk foreign key(id_comida) references cardapio(id_comida);