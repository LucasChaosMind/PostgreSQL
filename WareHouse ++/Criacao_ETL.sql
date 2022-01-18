create or replace function warehouse.insert_dim_enderecos() returns void as
$$
BEGIN

    insert into warehouse.dim_enderecos (nome_rua, bairro, nome_cidade, nome_estado)
select enderecos.tb003_nome_rua, enderecos.tb003_bairro, c.tb002_nome_cidade, uf.tb001_nome_estado
    from varejo.tb003_enderecos enderecos left join
         varejo.tb002_cidades c on c.tb002_cod_cidade = enderecos.tb002_cod_cidade left join
         varejo.tb001_uf uf on uf.tb001_sigla_uf = enderecos.tb001_sigla_uf
    where (select de.id from warehouse.dim_enderecos de
           where de.nome_rua = enderecos.tb003_nome_rua
             and de.bairro = enderecos.tb003_bairro
             and de.nome_cidade = c.tb002_nome_cidade
             and de.nome_estado = uf.tb001_nome_estado) is null
    group by enderecos.tb003_nome_rua, enderecos.tb003_bairro, c.tb002_nome_cidade, uf.tb001_nome_estado;

END;
$$ LANGUAGE plpgsql;

create or replace function warehouse.insert_dim_produtos() returns void as
$$
BEGIN
    insert into warehouse.dim_produtos (descricao, categoria)
    select produto.tb012_descricao, cat.tb013_descricao
    from varejo.tb012_produtos produto
             left join varejo.tb013_categorias cat on produto.tb013_cod_categoria = cat.tb013_cod_categoria
    where (select produto.tb012_cod_produto
           from warehouse.dim_produtos dp
           where dp.descricao = produto.tb012_descricao
             and dp.categoria = cat.tb013_descricao) is null
    group by produto.tb012_cod_produto, produto.tb012_descricao, cat.tb013_descricao;
END;
$$ LANGUAGE plpgsql;

create or replace function warehouse.insert_dim_lojas() returns void as
$$
BEGIN
    insert into warehouse.dim_lojas (cod_endereco, matriz, cnpj_loja)
    select (select id
            from warehouse.dim_enderecos ends
            where ends.bairro = enderecos.tb003_bairro
              and ends.nome_rua = enderecos.tb003_nome_rua
              and ends.nome_cidade = cidades.tb002_nome_cidade
              and ends.nome_estado = uf.tb001_nome_estado
            order by id desc
            limit 1) as cod_endereco,
           loja.tb004_matriz,
           loja.tb004_cnpj_loja
    from varejo.tb004_lojas loja
             left join varejo.tb003_enderecos enderecos on enderecos.tb003_cod_endereco = loja.tb003_cod_endereco
             left join varejo.tb002_cidades cidades on cidades.tb002_cod_cidade = enderecos.tb002_cod_cidade
             left join varejo.tb001_uf uf on uf.tb001_sigla_uf = enderecos.tb001_sigla_uf
    where (select dloja.id
           from warehouse.dim_lojas dloja
           where dloja.cod_endereco = (select ends.id
                                       from warehouse.dim_enderecos ends
                                       where ends.bairro = enderecos.tb003_bairro
                                         and ends.nome_rua = enderecos.tb003_nome_rua
                                         and ends.nome_cidade = cidades.tb002_nome_cidade
                                         and ends.nome_estado = uf.tb001_nome_estado
                                       order by id desc
                                       limit 1)
             and dloja.cnpj_loja = loja.tb004_cnpj_loja) is null;
END;
$$ LANGUAGE plpgsql;

create or replace function warehouse.insert_dim_fornecedores() returns void as
$$
BEGIN

    insert into warehouse.dim_fornecedores (cod_fornecedor, razao_social, nome_fantasia, cod_endereco)
    select func.tb017_cod_fornecedor,
           func.tb017_razao_social,
           func.tb017_nome_fantasia,
           (select ends.id
            from warehouse.dim_enderecos ends
            where ends.bairro = enderecos.tb003_bairro
              and ends.nome_rua = enderecos.tb003_nome_rua
              and ends.nome_cidade = cidades.tb002_nome_cidade
              and ends.nome_estado = uf.tb001_nome_estado
            order by ends.id desc
            limit 1) as cod_endereco
    from varejo.tb017_fornecedores func
             left join varejo.tb003_enderecos enderecos on enderecos.tb003_cod_endereco = func.tb003_cod_endereco
             left join varejo.tb002_cidades cidades on cidades.tb002_cod_cidade = enderecos.tb002_cod_cidade
             left join varejo.tb001_uf uf on uf.tb001_sigla_uf = enderecos.tb001_sigla_uf
    where (select forn.id
           from warehouse.dim_fornecedores forn
           where forn.cod_endereco = (select ends.id
                            from warehouse.dim_enderecos ends
                            where ends.bairro = enderecos.tb003_bairro
                              and ends.nome_rua = enderecos.tb003_nome_rua
                              and ends.nome_cidade = cidades.tb002_nome_cidade
                              and ends.nome_estado = uf.tb001_nome_estado
                            order by ends.id desc
                            limit 1)
        and forn.razao_social = func.tb017_razao_social and forn.nome_fantasia = func.tb017_nome_fantasia) is null;

END;
$$ LANGUAGE plpgsql;

create or replace function warehouse.insert_dim_funcionarios() returns void as
$$
BEGIN
    insert into warehouse.dim_funcionarios (cod_funcionario, cod_loja, nome_completo)
    select func.tb005_matricula,
           (select loja.id
            from warehouse.dim_lojas loja
            where loja.cnpj_loja = l.tb004_cnpj_loja),
           func.tb005_nome_completo
    from varejo.tb005_funcionarios func
             left join varejo.tb004_lojas l on func.tb004_cod_loja = l.tb004_cod_loja
    where (select f.id
           from warehouse.dim_funcionarios f
           where f.cod_funcionario = func.tb005_matricula
             and f.nome_completo = func.tb005_nome_completo
             and f.cod_loja = (select loja.id
                               from warehouse.dim_lojas loja
                               where loja.cnpj_loja = l.tb004_cnpj_loja)) is null;
END;
$$ LANGUAGE plpgsql;

create or replace function warehouse.insert_fato_vendas() returns void as
$$
BEGIN
    insert into warehouse.fato_vendas (cod_produto, cod_funcionario, data, quantidade, valor)
    select (select p.id
            from warehouse.dim_produtos p
                     left join varejo.tb012_produtos produtos on vendas.tb012_cod_produto = produtos.tb012_cod_produto
                     left join varejo.tb013_categorias categorias
                               on produtos.tb013_cod_categoria = categorias.tb013_cod_categoria
            where p.descricao like produtos.tb012_descricao
              and p.categoria like categorias.tb013_descricao),
           (select func.id
            from warehouse.dim_funcionarios func
            where func.cod_funcionario = vendas.tb005_matricula
            order by id desc
            limit 1),
           to_char(vendas.tb010_012_data, 'MM-YYYY'),
           sum(vendas.tb010_012_quantidade),
           (sum(vendas.tb010_012_quantidade) * sum(vendas.tb010_012_valor_unitario))
    from varejo.tb010_012_vendas vendas
             left join varejo.tb012_produtos produtos on vendas.tb012_cod_produto = produtos.tb012_cod_produto
             left join varejo.tb013_categorias categorias
                       on produtos.tb013_cod_categoria = categorias.tb013_cod_categoria
    where (select v.data
           from warehouse.fato_vendas v
           where v.data like to_char(vendas.tb010_012_data, 'MM-YYYY')
             and v.cod_funcionario = (select func.id
                                      from warehouse.dim_funcionarios func
                                      where func.cod_funcionario = vendas.tb005_matricula
                                      order by id desc
                                      limit 1)
             and v.cod_produto = (select p.id
                                  from warehouse.dim_produtos p
                                           left join varejo.tb012_produtos produtos
                                                     on vendas.tb012_cod_produto = produtos.tb012_cod_produto
                                           left join varejo.tb013_categorias categorias
                                                     on produtos.tb013_cod_categoria = categorias.tb013_cod_categoria
                                  where p.descricao like produtos.tb012_descricao
                                    and p.categoria like categorias.tb013_descricao
                                  order by id desc
                                  limit 1)
           order by v.id desc
           limit 1) is null
    group by vendas.tb012_cod_produto, to_char(vendas.tb010_012_data, 'MM-YYYY'), vendas.tb005_matricula;
END ;
$$ LANGUAGE plpgsql;

create or replace function warehouse.insert_fato_compras() returns void as
$$
BEGIN
    insert into warehouse.fato_compras (cod_produto, cod_fornecedor, data, quantidade, valor)
    select (select p.id
            from warehouse.dim_produtos p
                     left join varejo.tb012_produtos produtos on compras.tb012_cod_produto = produtos.tb012_cod_produto
                     left join varejo.tb013_categorias categorias
                               on produtos.tb013_cod_categoria = categorias.tb013_cod_categoria
            where p.descricao like produtos.tb012_descricao
              and p.categoria like categorias.tb013_descricao),
           (select forn.id
            from warehouse.dim_fornecedores forn
            where forn.cod_fornecedor = compras.tb017_cod_fornecedor
            order by id desc
            limit 1),
           to_char(compras.tb012_017_data, 'MM-YYYY'),
           sum(compras.tb012_017_quantidade),
           (sum(compras.tb012_017_quantidade) * sum(compras.tb012_017_valor_unitario))
    from varejo.tb012_017_compras compras
             left join varejo.tb012_produtos produtos on compras.tb012_cod_produto = produtos.tb012_cod_produto
             left join varejo.tb013_categorias categorias
                       on produtos.tb013_cod_categoria = categorias.tb013_cod_categoria
    where (select v.data
           from warehouse.fato_compras v
           where v.data like to_char(compras.tb012_017_data, 'MM-YYYY')
             and v.cod_fornecedor = (select forn.id
                                     from warehouse.dim_fornecedores forn
                                     where forn.cod_fornecedor = compras.tb017_cod_fornecedor
                                     order by id desc
                                     limit 1)
             and v.cod_produto = (select p.id
                                  from warehouse.dim_produtos p
                                           left join varejo.tb012_produtos produtos
                                                     on compras.tb012_cod_produto = produtos.tb012_cod_produto
                                           left join varejo.tb013_categorias categorias
                                                     on produtos.tb013_cod_categoria = categorias.tb013_cod_categoria
                                  where p.descricao like produtos.tb012_descricao
                                    and p.categoria like categorias.tb013_descricao
                                  order by id desc
                                  limit 1)
           order by v.id desc
           limit 1) is null
    group by compras.tb012_cod_produto, to_char(compras.tb012_017_data, 'MM-YYYY'), compras.tb017_cod_fornecedor;
END ;
$$ LANGUAGE plpgsql;