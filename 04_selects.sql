
-- Listar todos os clientes ordenados pelo nome
SELECT cliente_id, nome_completo, email
FROM cliente
ORDER BY nome_completo;

-- Mostrar produtos com preço acima de 2000 ordenando pelos mais caros
SELECT produto_id, nome_produto, preco_unitario
FROM produto
WHERE preco_unitario > 2000
ORDER BY preco_unitario DESC;

-- Ver pedidos com cliente e valores totais (JOIN)
SELECT 
    p.pedido_id,
    c.nome_completo AS cliente,
    p.valor_total,
    p.status_pedido
FROM pedido p
JOIN cliente c ON p.cliente_id = c.cliente_id;

-- Ver itens de pedido detalhados com nome dos produtos
SELECT 
    ip.item_pedido_id,
    pr.nome_produto,
    ip.quantidade,
    ip.subtotal
FROM item_pedido ip
JOIN produto pr ON ip.produto_id = pr.produto_id;

-- Encontrar produtos com baixo estoque
SELECT nome_produto, estoque_quantidade
FROM produto
WHERE estoque_quantidade < 15;
