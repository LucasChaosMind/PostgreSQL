select warehouse.insert_dim_produtos();
select * from warehouse.dim_produtos;

select warehouse.insert_dim_enderecos();
select * from warehouse.dim_enderecos;

select warehouse.insert_dim_lojas();
select * from warehouse.dim_lojas;

select warehouse.insert_dim_fornecedores();
select * from warehouse.dim_fornecedores;

select warehouse.insert_dim_funcionarios();
select * from warehouse.dim_funcionarios;

select warehouse.insert_fato_vendas();
select * from warehouse.fato_vendas;

select warehouse.insert_fato_compras();
select * from warehouse.fato_compras;