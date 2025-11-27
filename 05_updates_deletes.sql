
-- UPDATE — Atualizando o e-mail do cliente 3
UPDATE cliente
SET email = 'maria_alves_novo@example.com'
WHERE cliente_id = 3;

-- UPDATE — Alterar preço de produto específico (id=2)
UPDATE produto
SET preco_unitario = preco_unitario + 50
WHERE produto_id = 2;

-- UPDATE — Alterar status de pedido para "entregue"
UPDATE pedido
SET status_pedido = 'entregue'
WHERE pedido_id = 3;

-- Teste dos UPDATEs
SELECT * FROM cliente WHERE cliente_id = 3;
SELECT * FROM produto WHERE produto_id = 2;
SELECT * FROM pedido WHERE pedido_id = 3;

-- DELETE — Remover item do pedido (item 2)
DELETE FROM item_pedido WHERE item_pedido_id = 2;

-- DELETE — Remover categoria sem produtos
DELETE FROM categoria_produto WHERE categoria_id = 4;

-- DELETE — Remover cliente inativo
DELETE FROM cliente WHERE ativo = FALSE;

-- Teste dos DELETEs
SELECT * FROM item_pedido;
SELECT * FROM categoria_produto;
SELECT * FROM cliente;
