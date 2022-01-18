-- SCHEMA: public

-- DROP SCHEMA public ;

CREATE SCHEMA public
    AUTHORIZATION postgres;

COMMENT ON SCHEMA public
    IS 'standard public schema';

GRANT ALL ON SCHEMA public TO PUBLIC;

GRANT ALL ON SCHEMA public TO postgres;

--OK!
create table cliente(
	cpf int8 constraint cpfpk primary key,
	cod_endereco_cliente int8 constraint cod_endereco_clientenn not null,
	senha varchar(15) constraint senhann not null,
	nome varchar(40) constraint nomenn not null,
	data_de_nacimento date constraint idadenn not null,
	telefone varchar(15) constraint telun unique
);
--OK!
create table bandeiras(
	cod_bandeira int8 constraint cod_bandeirapk primary key,
	nome varchar(35) constraint nomenn not null
);
--OK! 2 FK cod_bandeira, cpf
create table cartoes_salvos(
	cod_cartao serial constraint cod_cartaopk primary key,
	cpf int8 constraint cpfnn not null,
	cod_bandeira int8 constraint cod_bandeirann not null,
	num_do_cartao bigint constraint num_do_cartaoun unique,
	cvv numeric(3,0) constraint cvvnn not null,
	nome_do_cartao varchar(20)
);
--OK!
create table pedido_feito(
	cod_pedido int8 constraint cod_pedidopk primary key,
	cpf int8 constraint cpffnn not null,
	cod_restaurante int8 constraint cod_restaurantenn not null,
	cod_comida int8 constraint cod_comida not null,
	data_da_compra date constraint data_da_comprann not null,
	cod_motoboy int8 constraint cod_motoboynn not null,
	valor money constraint valornn not null
);

--OK!
create table estado(
	cod_estado int8 constraint cod_estadopk primary key,
	nome varchar(40) constraint nomenn not null,
	uf varchar(2) constraint ufnn not null
);
--OK! 1 FK CodEstado
create table cidade(
	cod_cidade int8 constraint cod_cidadepk primary key,
	cod_estado int8 constraint cod_estadonn not null,
	nome varchar(40) constraint nomenn not null
);
--OK! 1 FK CodCidade
create table bairro(
	cod_bairro int8 constraint cod_bairropk primary key,
	cod_cidade int8 constraint cod_cidadenn not null,
	nome varchar(40) constraint nomenn not null,
	cep int8 constraint cepnn not null
);
--OK! 1FK CodBairro
create table endereco_do_cliente(
	cod_endereco_cliente int8 constraint cod_endereco_clientepk primary key,
	cod_bairro int8 constraint cod_bairronn not null,
	rua varchar(40) constraint ruann not null,
	numero int8 constraint numeronn not null,
	complemento varchar(15),
	cep int8 constraint cepnn not null
);
--OK! 
create table pagamento_aceito(
	tipo_pagamento int8 constraint tipo_pagamentopk primary key,
	dinheiro boolean constraint dinheironn not null,
	cartao_de_credito boolean  constraint cartao_de_credetonn not null,
	cartao_de_debito boolean constraint cartao_de_debitonn not null
);
--OK!  2 FK cod_bairro tipo_pagamento
create table restaurante(
	cod_restaurante int8 constraint cod_restaurantepk primary key,
	nome varchar(40) constraint nomenn not null,
	cod_bairro int8 constraint cod_bairronn not null,
	tipo_pagamento int8 constraint tipo_pagamentonn not null,
	cpnj int8 constraint cpnjnn not null
);
cod_restaurante,nome,cod_bairro,tipo_pagamento,cpnj
--OK! 2 FK cod_restaurante cod_bairro
create table endereco_restaurante(
	cod_endereco_restaurante int8 constraint cod_endereco_restaurantepk primary key,
	cod_restaurante int8 constraint cod_restaurantenn not null,
	cod_bairro int8 constraint cod_bairronn not null,
	rua varchar(40) constraint ruann not null,
	numero int8 constraint numeronn not null,
	complemento varchar(20),
	cep int8 constraint cepnn not null
);
--OK! 1 FK cod_restaurante
create table cardapio(
	cod_comida int8 constraint cod_comidapk primary key,
	cod_restaurante int8 constraint cod_restaurantenn not null,
	nome varchar(40) constraint nomenn not null,
	descricao varchar(150) constraint descricaonn not null,
	preco money constraint preconn not null,
	serv_pessoas int8
);
--OK! 3 FK CPF CodREs CodComida
create table avaliacao_restaurante(
	avaliacao serial constraint avaliacao_pk primary key,
	cpf int8 constraint cpfnn not null, 
	cod_restaurante int8 constraint cod_restaurantenn not null,
	nota int,
	comentario varchar(150),
	cod_comida int8 constraint cod_comidann not null
);
--OK! 
create table entregador(
	cod_motoboy int8 constraint cod_motoboypk primary key,
	cpf int8 constraint cpfun unique,
	senha varchar(15) constraint senhann not null,
	nome varchar(40) constraint nomenn not null, 
	cnh int8 constraint cnhun unique,
	telefone varchar(15) constraint telefoneun unique
);
--- <log da tabela pedido_feito>

create table pedido_feito_log(
	cod_pedido int8,
	cpf int8,
	cod_restaurante int8,
	cod_comida int8,
	data_da_compra date,
	cod_motoboy int8,
	valor money,
 -- <Variaveis de controle>	
	operacao varchar(1),
	valornovo varchar(255),
	valorantigo varchar(255),
	username varchar(15),
	dataacao date
);


alter table pedido_feito add constraint cpffk foreign key (cpf) references cliente(cpf);

alter table pedido_feito add constraint cod_motoboyfk foreign key (cod_motoboy) references entregador(cod_motoboy);
alter table cliente add constraint cod_endereco_clientefk foreign key (cod_endereco_cliente) references endereco_do_cliente(cod_endereco_cliente);
alter table avaliacao_restaurante add constraint cod_comidafk foreign key(cod_comida) references cardapio(cod_comida);
alter table avaliacao_restaurante add constraint cpffk foreign key (cpf) references cliente(cpf);
alter table avaliacao_restaurante add constraint cod_restaurantefk foreign key (cod_restaurante) references restaurante(cod_restaurante);
alter table cardapio add constraint cod_restaurantefk foreign key (cod_restaurante) references restaurante(cod_restaurante);
alter table endereco_restaurante add constraint cod_restaurantefk foreign key (cod_restaurante) references restaurante(cod_restaurante);
alter table endereco_restaurante add constraint cod_bairrofk foreign key (cod_bairro) references bairro(cod_bairro);
alter table restaurante add constraint tipo_pagamentofk foreign key(tipo_pagamento) references pagamento_aceito(tipo_pagamento);
alter table restaurante add constraint cod_bairrofk foreign key (cod_bairro) references bairro(cod_bairro);
alter table endereco_do_cliente add constraint cod_bairrofk foreign key(cod_bairro) references bairro(cod_bairro);
alter table bairro add constraint cod_cidadefk foreign key (cod_cidade) references cidade(cod_cidade);
alter table cidade add constraint cod_estadofk foreign key (cod_estado) references estado(cod_estado);
alter table cartoes_salvos add constraint cod_bandeirafk foreign key (cod_bandeira) references bandeiras(cod_bandeira);
alter table cartoes_salvos add constraint cpffk foreign key (cpf) references cliente(cpf);
alter table pedido_feito add constraint cod_comidafk foreign key(cod_comida) references cardapio(cod_comida);

--- <VIEW's>



CREATE OR REPLACE VIEW v_consulta_restaurante AS(
	select res.cod_restaurante,ba.nome as nomeBairro,cid.nome as nomeCidade,est.nome as nomeEstado ,ende.rua, ende.numero, ende.complemento,ende.cep
	from restaurante as res
	inner join bairro ba on ba.cod_bairro = res.cod_bairro
	inner join cidade cid on cid.cod_cidade = ba.cod_cidade
	inner join estado est on est.cod_estado = cid.cod_estado
	inner join endereco_restaurante ende on ende.cod_restaurante = res.cod_restaurante
	order by ba.nome,cid.nome,est.nome
);

CREATE OR REPLACE VIEW v_consulta_pedido AS(
	select cli.nome as nomeCliente, pe.cod_pedido,pe.data_da_compra,ca.nome,ca.descricao,ca.preco
	from cliente cli
	inner join pedido_feito pe on pe.cpf = cli.cpf
	inner join cardapio ca on ca.cod_comida = pe.cod_comida
	order by pe.data_da_compra desc
);

--- <Function>


CREATE OR REPLACE FUNCTION busca_entregador_print (nex int8)
RETURNS VOID AS $$
DECLARE
	codmb int8;
	nomemb varchar(40);
	codpd int8;
	nomeca varchar(40);
	codca int8;
BEGIN
	codpd := -1;
	WHILE codpd IS NOT null LOOP
		select en.cod_motoboy, en.nome,pe.cod_pedido,ca.nome,ca.cod_comida
		into codmb,nomemb,codpd,nomeca,codca
		from entregador en
		inner join pedido_feito pe on pe.cod_motoboy = en.cod_motoboy
		inner join cardapio ca on ca.cod_comida = pe.cod_comida
		where en.cod_motoboy = nex and  pe.cod_pedido > codpd;
        IF (codpd is not null) THEN
			RAISE NOTICE 'Codigo do Motoboy: %',codmb;
			RAISE NOTICE 'Nome: %',nomemb;
			RAISE NOTICE 'Codigo do Pedido: %',codpd;
			RAISE NOTICE 'Nome Comida: %',nomeca;
			RAISE NOTICE 'Codigo da Comida: %',codca;
        END IF;
   	END LOOP;

END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION atributo_cliente(fcpf int8,fcod_endereco_cliente int8,fsenha varchar(15),fnome varchar(40),fdata_de_nacimento date,ftelefone varchar(15))
RETURNS VOID AS $$
DECLARE
	acpf int8;
	anome varchar;
BEGIN
	select nome, cpf
	into anome, acpf
	from cliente c
	where c.cpf = fcpf and c.nome ilike fnome;

	IF (acpf IS NOT NULL) THEN
		RAISE NOTICE 'Erro CPF: % Pertence a: %',acpf,anome;
	ELSE
		INSERT INTO public.cliente (cpf,cod_endereco_cliente,senha,nome,data_de_nacimento,telefone) VALUES (fcpf,fcod_endereco_cliente,fsenha,fnome,fdata_de_nacimento,ftelefone);
		RAISE NOTICE 'Insert Efetuado!';
	END IF;			
END;
$$ LANGUAGE plpgsql;

-- <Trigger's>

CREATE FUNCTION log_pedido_feitofunc()
RETURNS TRIGGER AS $$
BEGIN
	IF(TG_OP = 'DELETE') THEN
		INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
		VALUES (old.cod_pedido,old.cpf,old.cod_restaurante,old.cod_comida,old.data_da_compra,old.cod_motoboy,old.valor,'D',null,'All',user,now());
	RETURN OLD;
	
	
	ELSIF(TG_OP = 'INSERT') THEN
		INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
		VALUES (new.cod_pedido,new.cpf,new.cod_restaurante,new.cod_comida,new.data_da_compra,new.cod_motoboy,new.valor,'I','All',null,user,now());
	RETURN NEW;
	
	
	ELSIF(TG_OP = 'UPDATE') THEN
		IF(new.cod_pedido != old.cod_pedido) THEN
			INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
			VALUES (new.cod_pedido,new.cpf,new.cod_restaurante,new.cod_comida,new.data_da_compra,new.cod_motoboy,new.valor,'U',new.cod_pedido,old.cod_pedido,user,now());
		
		
		ELSIF(new.cpf != old.cpf) THEN
				INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
				VALUES (new.cod_pedido,new.cpf,new.cod_restaurante,new.cod_comida,new.data_da_compra,new.cod_motoboy,new.valor,'U',new.cpf,old.cpf,user,now());
		
		
		ELSIF(new.cod_restaurante != old.cod_restaurante) THEN
				INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
		VALUES (new.cod_pedido,new.cpf,new.cod_restaurante,new.cod_comida,new.data_da_compra,new.cod_motoboy,new.valor,'U',new.cod_restaurante,old.cod_restaurante,user,now());
		
		
		ELSIF(new.cod_comida != old.cod_comida) THEN
				INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
		VALUES (new.cod_pedido,new.cpf,new.cod_restaurante,new.cod_comida,new.data_da_compra,new.cod_motoboy,new.valor,'U',new.cod_comida,old.cod_comida,user,now());
		
		
		ELSIF(new.data_da_compra != old.data_da_compra) THEN
				INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
		VALUES (new.cod_pedido,new.cpf,new.cod_restaurante,new.cod_comida,new.data_da_compra,new.cod_motoboy,new.valor,'U',new.data_da_compra,old.data_da_compra,user,now());
		
		
		ELSIF(new.cod_motoboy != old.cod_motoboy) THEN
				INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
		VALUES (new.cod_pedido,new.cpf,new.cod_restaurante,new.cod_comida,new.data_da_compra,new.cod_motoboy,new.valor,'U',new.cod_motoboy,old.cod_motoboy,user,now());
		
	
		ELSIF(new.valor != old.valor) THEN
				INSERT INTO pedido_feito_log (cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor,operacao,valornovo,valorantigo,username,dataacao) 
		VALUES (new.cod_pedido,new.cpf,new.cod_restaurante,new.cod_comida,new.data_da_compra,new.cod_motoboy,new.valor,'U',new.valor,old.valor,user,now());
		END IF;
	RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER log_pedido_feito_trigger
AFTER INSERT OR UPDATE OR DELETE ON "pedido_feito"
FOR EACH ROW EXECUTE PROCEDURE log_pedido_feitofunc();


CREATE FUNCTION cartao_salvofunc()
RETURNS TRIGGER AS $$
DECLARE
	aux int8;
	--aux bigint;
BEGIN
	IF(TG_OP = 'DELETE') THEN
		RAISE NOTICE 'Delete Permitido!';
		RETURN OLD;
	ELSIF(TG_OP = 'INSERT') THEN
		select ((new.num_do_cartao%10)+((new.num_do_cartao/10)%10)+((new.num_do_cartao/100)%10)+((new.num_do_cartao/1000)%10)+((new.num_do_cartao/10000)%10)+((new.num_do_cartao/100000)%10)+((new.num_do_cartao/1000000)%10)+((new.num_do_cartao/10000000)%10)+((new.num_do_cartao/100000000)%10)+((new.num_do_cartao/1000000000)%10)+((new.num_do_cartao/10000000000)%10)+((new.num_do_cartao/100000000000)%10)+((new.num_do_cartao/1000000000000)%10)+((new.num_do_cartao/10000000000000)%10)+((new.num_do_cartao/100000000000000)%10)+(new.num_do_cartao/1000000000000000)):: int8
		into aux;
		IF(aux!=new.cvv) THEN
			RAISE EXCEPTION 'CVV ou Numero de Cartão Invalido!';
			RETURN NEW;
		ELSIF(aux=new.cvv) THEN
			RAISE NOTICE 'Insert Permitido!';
		END IF;
	RETURN NEW;
	ELSIF(TG_OP = 'UPDATE') THEN
		select ((new.num_do_cartao%10)+((new.num_do_cartao/10)%10)+((new.num_do_cartao/100)%10)+((new.num_do_cartao/1000)%10)+((new.num_do_cartao/10000)%10)+((new.num_do_cartao/100000)%10)+((new.num_do_cartao/1000000)%10)+((new.num_do_cartao/10000000)%10)+((new.num_do_cartao/100000000)%10)+((new.num_do_cartao/1000000000)%10)+((new.num_do_cartao/10000000000)%10)+((new.num_do_cartao/100000000000)%10)+((new.num_do_cartao/1000000000000)%10)+((new.num_do_cartao/10000000000000)%10)+((new.num_do_cartao/100000000000000)%10)+(new.num_do_cartao/1000000000000000)):: int8
		into aux;
		IF(new.num_do_cartao!=old.num_do_cartao) THEN	
			IF(aux!=old.cvv) THEN
				RAISE EXCEPTION 'Cartão Invalido!';
			ELSIF(aux=old.cvv) THEN
				RAISE NOTICE 'Cartão Valido! Update Permitido!';
			END IF;
		ELSIF (new.cvv!= old.cvv) THEN
			IF(aux!= new.cvv) THEN
				RAISE EXCEPTION 'CVV Invalido!';
			ELSIF(AUX=new.cvv) THEN
				RAISE NOTICE 'CVV Valido!';
			END IF;
		END IF;
	RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cartao_salvofunctrigger
BEFORE INSERT OR UPDATE OR DELETE ON "cartoes_salvos"
FOR EACH ROW EXECUTE PROCEDURE cartao_salvofunc();

-- <Insert>

--1
insert into entregador(cod_motoboy,cpf,senha,nome,cnh,telefone) values(1,50001,'123','Lucas [º~º]',100,'(46)123-321');
insert into entregador(cod_motoboy,cpf,senha,nome,cnh,telefone) values(2,40002,'123','Falchi ^_^',200,'(11)321-123');
insert into entregador(cod_motoboy,cpf,senha,nome,cnh,telefone) values(3,30003,'123','Lucio =D',300,'(46)329-792');
insert into entregador(cod_motoboy,cpf,senha,nome,cnh,telefone) values(4,20004,'123','Bruno XD',400,'(42)511-239');
insert into entregador(cod_motoboy,cpf,senha,nome,cnh,telefone) values(5,10005,'123','Gabizinha >_<',500,'(44)982-752');
--2

insert into pagamento_aceito(tipo_pagamento,dinheiro,cartao_de_credito,cartao_de_debito) values(1,TRUE,TRUE,TRUE);
insert into pagamento_aceito(tipo_pagamento,dinheiro,cartao_de_credito,cartao_de_debito) values(2,FALSE,TRUE,FALSE);
insert into pagamento_aceito(tipo_pagamento,dinheiro,cartao_de_credito,cartao_de_debito) values(3,TRUE,FALSE,TRUE);
insert into pagamento_aceito(tipo_pagamento,dinheiro,cartao_de_credito,cartao_de_debito) values(4,FALSE,TRUE,FALSE);
insert into pagamento_aceito(tipo_pagamento,dinheiro,cartao_de_credito,cartao_de_debito) values(5,TRUE,FALSE,TRUE);
--3
insert into estado(cod_estado,nome,uf) values(1,'Paraná','PR');
insert into estado(cod_estado,nome,uf) values(2,'São Paulo','SP');
insert into estado(cod_estado,nome,uf) values(3,'Santa Catarina','SC');
insert into estado(cod_estado,nome,uf) values(4,'Tibia','TB');
insert into estado(cod_estado,nome,uf) values(5,'Perfec World','PW');
--4
insert into cidade(cod_cidade,cod_estado,nome) values(1,1,'Pato Branco');
insert into cidade(cod_cidade,cod_estado,nome) values(2,2,'São Paulo');
insert into cidade(cod_cidade,cod_estado,nome) values(3,3,'Chapeco');
insert into cidade(cod_cidade,cod_estado,nome) values(4,4,'Venore');
insert into cidade(cod_cidade,cod_estado,nome) values(5,5,'Cidade das Tormentas');
--5
insert into bairro(cod_bairro,cod_cidade,nome,cep) values(1,1,'Fraron',01);
insert into bairro(cod_bairro,cod_cidade,nome,cep) values(2,2,'Belem',2);
insert into bairro(cod_bairro,cod_cidade,nome,cep) values(3,3,'Teris',3);
insert into bairro(cod_bairro,cod_cidade,nome,cep) values(4,4,'PVP',3);
insert into bairro(cod_bairro,cod_cidade,nome,cep) values(5,5,'PVE',4);
--6
insert into restaurante(cod_restaurante,nome,cod_bairro,tipo_pagamento,cpnj) values(1,'Xia',1,1,501);
insert into restaurante(cod_restaurante,nome,cod_bairro,tipo_pagamento,cpnj) values(2,'Tsu',2,2,402);
insert into restaurante(cod_restaurante,nome,cod_bairro,tipo_pagamento,cpnj) values(3,'Hip',3,3,303);
insert into restaurante(cod_restaurante,nome,cod_bairro,tipo_pagamento,cpnj) values(4,'Yoo',4,4,204);
insert into restaurante(cod_restaurante,nome,cod_bairro,tipo_pagamento,cpnj) values(5,'Ruk',5,5,105);
--7
insert into endereco_do_cliente(cod_endereco_cliente,cod_bairro,rua,numero,complemento,cep) values(1,1,'Rolk',1,1,501);
insert into endereco_do_cliente(cod_endereco_cliente,cod_bairro,rua,numero,complemento,cep) values(2,2,'Sung',2,2,402);
insert into endereco_do_cliente(cod_endereco_cliente,cod_bairro,rua,numero,complemento,cep) values(3,3,'Jsu',3,3,303);
insert into endereco_do_cliente(cod_endereco_cliente,cod_bairro,rua,numero,complemento,cep) values(4,4,'Huh',4,4,204);
insert into endereco_do_cliente(cod_endereco_cliente,cod_bairro,rua,numero,complemento,cep) values(5,5,'Zun',5,5,105);
--8
insert into endereco_restaurante(cod_endereco_restaurante,cod_restaurante,cod_bairro,rua,numero,complemento,cep) values(1,1,1,'Ryyc',105,'A',105);
insert into endereco_restaurante(cod_endereco_restaurante,cod_restaurante,cod_bairro,rua,numero,complemento,cep) values(2,2,2,'Size',204,'B',204);
insert into endereco_restaurante(cod_endereco_restaurante,cod_restaurante,cod_bairro,rua,numero,complemento,cep) values(3,3,3,'Itty',303,'C',303);
insert into endereco_restaurante(cod_endereco_restaurante,cod_restaurante,cod_bairro,rua,numero,complemento,cep) values(4,4,4,'Irsu',402,'D',402);
insert into endereco_restaurante(cod_endereco_restaurante,cod_restaurante,cod_bairro,rua,numero,complemento,cep) values(5,5,5,'Heeh',501,'E',501);
--9
insert into cardapio(cod_comida,cod_restaurante,nome,descricao,preco,serv_pessoas) values(1,1,'Batata Frita','Potato',75.5,2);
insert into cardapio(cod_comida,cod_restaurante,nome,descricao,preco,serv_pessoas) values(2,2,'Hamburguer','Anti-Vegano',27.45,1);
insert into cardapio(cod_comida,cod_restaurante,nome,descricao,preco,serv_pessoas) values(3,3,'Bolo de Chocolate','Obba!',45.25,5);
insert into cardapio(cod_comida,cod_restaurante,nome,descricao,preco,serv_pessoas) values(4,4,'Vegetais','Natureza <3',20,3);
insert into cardapio(cod_comida,cod_restaurante,nome,descricao,preco,serv_pessoas) values(5,5,'Puddin','Felicidade tem Preço!',25,4);
--10
insert into cliente(cpf,cod_endereco_cliente,senha,nome,data_de_nacimento,telefone) values(50001,1,'123','GiL','1996-12-02','(40)111-222');
insert into cliente(cpf,cod_endereco_cliente,senha,nome,data_de_nacimento,telefone) values(40002,2,'123','Geovana','2000-08-05','(44)222-333');
insert into cliente(cpf,cod_endereco_cliente,senha,nome,data_de_nacimento,telefone) values(30003,3,'123','Denner','2000-05-08','(45)222-111');
insert into cliente(cpf,cod_endereco_cliente,senha,nome,data_de_nacimento,telefone) values(20004,4,'123','Cecilia','2000-07-03','(46)333-222');
insert into cliente(cpf,cod_endereco_cliente,senha,nome,data_de_nacimento,telefone) values(10005,5,'123','Jão Lucas','1999-03-03','(44)555-555');
--11
insert into avaliacao_restaurante(avaliacao,cpf,cod_restaurante,nota,comentario,cod_comida) values(1,50001,1,5,'Bom!',1);
insert into avaliacao_restaurante(avaliacao,cpf,cod_restaurante,nota,comentario,cod_comida) values(2,40002,2,4,'Gostei!',2);
insert into avaliacao_restaurante(avaliacao,cpf,cod_restaurante,nota,comentario,cod_comida) values(3,30003,3,3,'Regular!',3);
insert into avaliacao_restaurante(avaliacao,cpf,cod_restaurante,nota,comentario,cod_comida) values(4,20004,4,2,'Sem Sal!',4);
insert into avaliacao_restaurante(avaliacao,cpf,cod_restaurante,nota,comentario,cod_comida) values(5,10005,5,1,'Ruin!',5);
--12
  																					   
insert into bandeiras(cod_bandeira,nome) values(1,'Master Divida');
insert into bandeiras(cod_bandeira,nome) values(2,'Credi Cruz');
insert into bandeiras(cod_bandeira,nome) values(3,'Elo CooL');
insert into bandeiras(cod_bandeira,nome) values(4,'E-Divida');
insert into bandeiras(cod_bandeira,nome) values(5,'Visa Tua?');
--13
  																						   
insert into cartoes_salvos(cod_cartao,cpf,cod_bandeira,num_do_cartao,cvv,nome_do_cartao) values(1,50001,1,12,3,'Atomic Bomb');
insert into cartoes_salvos(cod_cartao,cpf,cod_bandeira,num_do_cartao,cvv,nome_do_cartao) values(2,40002,2,13,4,'Fire BoLL');
insert into cartoes_salvos(cod_cartao,cpf,cod_bandeira,num_do_cartao,cvv,nome_do_cartao) values(3,30003,3,14,5,'NuBOmB');
insert into cartoes_salvos(cod_cartao,cpf,cod_bandeira,num_do_cartao,cvv,nome_do_cartao) values(4,20004,4,15,6,'Red Noise');
insert into cartoes_salvos(cod_cartao,cpf,cod_bandeira,num_do_cartao,cvv,nome_do_cartao) values(5,10005,5,16,7,'Azul Biolet');
--14  																						   
insert into pedido_feito(cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor) values(1,50001,1,1,'2020-07-03',1,25.5);
insert into pedido_feito(cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor) values(2,40002,2,2,'2020-08-07',2,25.7);
insert into pedido_feito(cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor) values(3,30003,3,3,'2020-03-09',3,27.5);
insert into pedido_feito(cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor) values(4,20004,4,4,'2020-02-10',4,55.25);
insert into pedido_feito(cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor) values(5,10005,5,5,'2020-10-07',5,100.25);

-- <Mostrar os efeitos>

--- <Views>

select * from v_consulta_restaurante;
select * from v_consulta_pedido;

-- <Functions>
select busca_entregador_print(1);

--Inserindo um cpf e nome existente
select atributo_cliente(10009,1,'123','ADM','2000-03-03','(31)3131');
--inserindo um novo resgistro cpf e nome não usados
select atributo_cliente(133335,1,'123','Neox','2000-03-03','(31)4587');

-- <trigger's>

-- trigger 1

--Select
select *
from pedido_feito_log;
--Delete
delete
from pedido_feito
where cod_pedido = 1;
--Insert
insert into pedido_feito(cod_pedido,cpf,cod_restaurante,cod_comida,data_da_compra,cod_motoboy,valor) values(1,50001,1,1,'2020-07-03',1,25.5);
--Update
update pedido_feito
set valor = 50.25
where cod_pedido = 1;

---trigger 2

--Insert Correto
insert into cartoes_salvos(cod_cartao,cpf,cod_bandeira,num_do_cartao,cvv,nome_do_cartao) 
values(5,1222,5,18,9,'Azul Biolet');
--Insert Incorreto
insert into cartoes_salvos(cod_cartao,cpf,cod_bandeira,num_do_cartao,cvv,nome_do_cartao) 
values(5,1888,5,18,7,'Azul Biolet');
--Delete
delete 
from cartoes_salvos
where cpf = 1222;

select *
from cartoes_salvos
order by cod_cartao;
--Update Errado
update cartoes_salvos
set cvv = 4
where cod_cartao =  1;
--Update correto
update cartoes_salvos
set num_do_cartao = 3
where cod_cartao =  1;

--Aluno: Lucas Calado Bresolino
--RA: 2037882
--Nota: ?/10
