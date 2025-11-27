

-- 02_triggers.sql

-- Função para calcular subtotal do item_pedido antes de inserir/update
CREATE OR REPLACE FUNCTION calcular_subtotal_item()
RETURNS TRIGGER AS $$
BEGIN
    NEW.subtotal := (NEW.quantidade * NEW.preco_unitario) - COALESCE(NEW.desconto_item, 0);
    IF NEW.subtotal < 0 THEN
        NEW.subtotal := 0;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_calcular_subtotal_item
BEFORE INSERT OR UPDATE ON item_pedido
FOR EACH ROW
EXECUTE FUNCTION calcular_subtotal_item();

-- Função para atualizar valor_subtotal e valor_total do pedido
CREATE OR REPLACE FUNCTION atualizar_totais_pedido()
RETURNS TRIGGER AS $$
DECLARE
    v_subtotal NUMERIC(14,2);
BEGIN
    SELECT COALESCE(SUM(subtotal),0) INTO v_subtotal FROM item_pedido WHERE pedido_id = COALESCE(NEW.pedido_id, OLD.pedido_id);
    UPDATE pedido
    SET valor_subtotal = v_subtotal,
        valor_total = v_subtotal + COALESCE(valor_frete,0) - COALESCE(valor_desconto,0)
    WHERE pedido_id = COALESCE(NEW.pedido_id, OLD.pedido_id);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Aciona após inserir/atualizar/deletar no item_pedido
CREATE TRIGGER tg_atualizar_totais_item
AFTER INSERT OR UPDATE OR DELETE ON item_pedido
FOR EACH ROW
EXECUTE FUNCTION atualizar_totais_pedido();
