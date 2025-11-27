

-- 03_inserts.sql

-- CLIENTES (com cpf)
INSERT INTO cliente (cpf, nome_completo, email, telefone, data_nascimento)
VALUES
('123.456.789-14','Lucas Andrade','lucas.andrade@example.com','(11)99999-9999','1990-05-10'),
('234.567.890-10','Mariana Souza','mariana.souza@example.com','(21)98888-8888','1988-09-20'),
('345.678.901-25','Carlos Pereira','carlos.pereira@example.com','(31)97777-7777','1985-02-14');

-- ENDEREÇOS
INSERT INTO endereco (cliente_id, tipo_endereco, cep, logradouro, numero, bairro, cidade, estado, endereco_principal)
VALUES
(1, 'entrega', '01310-000', 'Av. Paulista', '1000', 'Bela Vista', 'São Paulo', 'SP', TRUE),
(2, 'entrega', '20000-000', 'Rua das Flores', '200', 'Centro', 'Rio de Janeiro', 'RJ', TRUE),
(3, 'entrega', '30100-000', 'Av. Afonso Pena', '500', 'Centro', 'Belo Horizonte', 'MG', TRUE);

-- CATEGORIAS
INSERT INTO categoria_produto (nome_categoria, descricao)
VALUES ('Smartphones', 'Celulares e smartphones'),
       ('Notebooks', 'Notebooks e ultrabooks'),
       ('Acessórios', 'Cabos, carregadores e periféricos');

-- PRODUTOS
INSERT INTO produto (categoria_id, nome_produto, descricao, preco_unitario, preco_custo, estoque_quantidade, marca, sku)
VALUES
(1, 'iPhone 14', 'Apple iPhone 14, 128GB', 4500.00, 3200.00, 10, 'Apple', 'APL-IPH14-128'),
(1, 'Samsung Galaxy S23', 'Samsung S23, 256GB', 3800.00, 2500.00, 12, 'Samsung', 'SMS-S23-256'),
(2, 'Dell Inspiron 15', 'Dell Inspiron - Core i5', 3500.00, 2300.00, 5, 'Dell', 'DLL-INSP15-I5'),
(3, 'Carregador USB-C 20W', 'Carregador rápido 20W', 80.00, 30.00, 50, 'Generic', 'ACC-USB20W');

-- CARRINHOS
INSERT INTO carrinho_compras (cliente_id, status) VALUES (1,'ativo'), (2,'ativo');

-- ITENS DE CARRINHO
INSERT INTO item_carrinho (carrinho_id, produto_id, quantidade, preco_unitario_momento)
VALUES (1,1,1,4500.00), (1,4,2,80.00), (2,2,1,3800.00);

-- PEDIDOS
INSERT INTO pedido (cliente_id, endereco_entrega_id, numero_pedido, status_pedido, valor_frete, valor_desconto)
VALUES
(1, 1, 'PED-2025-00001', 'pendente', 20.00, 0.00),
(2, 2, 'PED-2025-00002', 'pendente', 25.00, 50.00);

-- ITENS DO PEDIDO (ao inserir, trigger calculará subtotal e atualizará pedido)
INSERT INTO item_pedido (pedido_id, produto_id, quantidade, preco_unitario, desconto_item)
VALUES
(1, 1, 1, 4500.00, 0),
(1, 4, 2, 80.00, 0),
(2, 2, 1, 3800.00, 100.00);
