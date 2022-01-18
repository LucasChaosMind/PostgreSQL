create table if not exists warehouse.dim_produtos (
    id                   serial constraint prd_alimentos_pk primary key,
    descricao            varchar(255),
    categoria            varchar(255)
);

create table if not exists warehouse.dim_enderecos (
    id               serial constraint endereco_pk primary key,
    nome_rua         varchar(255) not null,
    bairro           varchar(255) not null,
    nome_cidade      varchar(255) not null,
    nome_estado      varchar(255) not null
);

create table if not exists warehouse.dim_lojas (
    id                 serial constraint lojas_pk primary key,
    cod_endereco       integer     not null constraint lojas_endereco_fk references warehouse.dim_enderecos,
    matriz             integer,
    cnpj_loja          varchar(20) not null
);

create table if not exists warehouse.dim_fornecedores (
    id  serial constraint fornecedores_pk primary key,
    cod_fornecedor integer not null,
    razao_social   varchar(255),
    nome_fantasia  varchar(255),
    cod_endereco   integer constraint fornecedores_endereco_fk references warehouse.dim_enderecos
);

create table if not exists warehouse.dim_funcionarios (
    id                  serial constraint funcionarios_pk primary key,
    cod_funcionario     integer        not null,
    cod_loja            integer        not null constraint funcionarios_loja_fk references warehouse.dim_lojas,
    nome_completo       varchar(255)   not null
);

create table if not exists warehouse.fato_vendas (
    id              serial constraint vendas_pk primary key,
    cod_produto     integer        not null constraint vendas_produto_fk references warehouse.dim_produtos,
    cod_funcionario integer        not null constraint vendas_funcionario_fk references warehouse.dim_funcionarios,
    data            varchar(8)     not null,
    quantidade      numeric(10)    not null,
    valor           numeric(12, 4) not null
);

create table if not exists warehouse.fato_compras (
    id             serial constraint compras_pk primary key,
    cod_produto    integer        not null constraint compras_produto_fk references warehouse.dim_produtos,
    cod_fornecedor integer        not null constraint compras_fornecedor_fk references warehouse.dim_fornecedores,
    data           varchar(8)     not null,
    quantidade     numeric(10)    not null,
    valor          numeric(12, 4) not null
);


/*
 CRIAÇÃO DA FUNÇÃO DE SEGURANÇA DO WAREHOUSE PARA EVITAR EDIÇÃO OU REMOÇÃO DE DADOS
 */
create or replace function warehouse.func_block_update_and_delete() returns trigger as $$
begin
    IF (TG_OP = 'UPDATE' or TG_OP = 'DELETE') THEN
        raise exception 'Ação não permitida em um warehouse!';
    END IF;
end $$ language plpgsql;

create trigger tgaud_block_edition_dim_enderecos after update or delete on warehouse.dim_enderecos for each row execute function warehouse.func_block_update_and_delete();
create trigger tgaud_block_edition_dim_fornecedores after update or delete on warehouse.dim_fornecedores for each row execute function warehouse.func_block_update_and_delete();
create trigger tgaud_block_edition_dim_funcionarios after update or delete on warehouse.dim_funcionarios for each row execute function warehouse.func_block_update_and_delete();
create trigger tgaud_block_edition_dim_lojas after update or delete on warehouse.dim_lojas for each row execute function warehouse.func_block_update_and_delete();
create trigger tgaud_block_edition_dim_produtos after update or delete on warehouse.dim_produtos for each row execute function warehouse.func_block_update_and_delete();
create trigger tgaud_block_edition_fato_compras after update or delete on warehouse.fato_compras for each row execute function warehouse.func_block_update_and_delete();
create trigger tgaud_block_edition_fato_vendas after update or delete on warehouse.fato_vendas for each row execute function warehouse.func_block_update_and_delete();
