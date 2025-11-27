

-- 01_ddl.sql
-- Execute conectado ao banco techstore
-- Todas as tabelas serão criadas no schema PUBLIC

SET search_path TO public;

-- =======================================
-- TABELA CLIENTE
-- =======================================
CREATE TABLE IF NOT EXISTS cliente (
    cliente_id SERIAL PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome_completo VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(25),
    data_nascimento DATE,
    senha_hash TEXT,
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now(),
    ativo BOOLEAN DEFAULT TRUE
);

-- =======================================
-- TABELA ENDEREÇO
-- =======================================
CREATE TABLE IF NOT EXISTS endereco (
    endereco_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    tipo_endereco VARCHAR(20) DEFAULT 'entrega',
    cep VARCHAR(10),
    logradouro VARCHAR(200),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    pais VARCHAR(80) DEFAULT 'Brasil',
    endereco_principal BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_endereco_cliente FOREIGN KEY (cliente_id)
        REFERENCES cliente(cliente_id) ON DELETE CASCADE
);

-- =======================================
-- TABELA CATEGORIA DO PRODUTO
-- =======================================
CREATE TABLE IF NOT EXISTS categoria_produto (
    categoria_id SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(120) NOT NULL,
    descricao TEXT,
    categoria_pai_id INT,
    ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_categoria_pai FOREIGN KEY (categoria_pai_id)
        REFERENCES categoria_produto(categoria_id) ON DELETE SET NULL
);

-- =======================================
-- TABELA PRODUTO
-- =======================================
CREATE TABLE IF NOT EXISTS produto (
    produto_id SERIAL PRIMARY KEY,
    categoria_id INT NOT NULL,
    nome_produto VARCHAR(200) NOT NULL,
    descricao TEXT,
    preco_unitario NUMERIC(12,2) NOT NULL CHECK (preco_unitario >= 0),
    preco_custo NUMERIC(12,2),
    estoque_quantidade INT NOT NULL DEFAULT 0 CHECK (estoque_quantidade >= 0),
    peso_kg NUMERIC(8,3),
    dimensoes VARCHAR(80),
    marca VARCHAR(80),
    sku VARCHAR(80) UNIQUE,
    imagem_url TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT now(),
    destaque BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id)
        REFERENCES categoria_produto(categoria_id) ON DELETE RESTRICT
);

-- =======================================
-- TABELA CARRINHO DE COMPRAS
-- =======================================
CREATE TABLE IF NOT EXISTS carrinho_compras (
    carrinho_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_criacao TIMESTAMP WITH TIME ZONE DEFAULT now(),
    data_ultima_modificacao TIMESTAMP WITH TIME ZONE DEFAULT now(),
    status VARCHAR(20) DEFAULT 'ativo',
    CONSTRAINT fk_carrinho_cliente FOREIGN KEY (cliente_id)
        REFERENCES cliente(cliente_id) ON DELETE CASCADE,
    CONSTRAINT uc_carrinho_ativo UNIQUE (cliente_id, status)
);

-- =======================================
-- TABELA ITEM DO CARRINHO
-- =======================================
CREATE TABLE IF NOT EXISTS item_carrinho (
    item_carrinho_id SERIAL PRIMARY KEY,
    carrinho_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario_momento NUMERIC(12,2) NOT NULL CHECK (preco_unitario_momento >= 0),
    data_adicao TIMESTAMP WITH TIME ZONE DEFAULT now(),
    CONSTRAINT fk_itemcarrinho_carrinho FOREIGN KEY (carrinho_id)
        REFERENCES carrinho_compras(carrinho_id) ON DELETE CASCADE,
    CONSTRAINT fk_itemcarrinho_produto FOREIGN KEY (produto_id)
        REFERENCES produto(produto_id) ON DELETE RESTRICT,
    CONSTRAINT uc_item_carrinho UNIQUE (carrinho_id, produto_id)
);

-- =======================================
-- TABELA PEDIDO
-- =======================================
CREATE TABLE IF NOT EXISTS pedido (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    endereco_entrega_id INT NOT NULL,
    numero_pedido VARCHAR(30) UNIQUE,
    data_pedido TIMESTAMP WITH TIME ZONE DEFAULT now(),
    status_pedido VARCHAR(30) DEFAULT 'pendente',
    valor_subtotal NUMERIC(12,2) DEFAULT 0 CHECK (valor_subtotal >= 0),
    valor_frete NUMERIC(12,2) DEFAULT 0 CHECK (valor_frete >= 0),
    valor_desconto NUMERIC(12,2) DEFAULT 0 CHECK (valor_desconto >= 0),
    valor_total NUMERIC(12,2) DEFAULT 0 CHECK (valor_total >= 0),
    observacoes TEXT,
    data_entrega_prevista DATE,
    data_entrega_real DATE,
    codigo_rastreio VARCHAR(80),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id)
        REFERENCES cliente(cliente_id) ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_endereco FOREIGN KEY (endereco_entrega_id)
        REFERENCES endereco(endereco_id) ON DELETE RESTRICT
);

-- =======================================
-- TABELA ITEM PEDIDO
-- =======================================
CREATE TABLE IF NOT EXISTS item_pedido (
    item_pedido_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(12,2) NOT NULL CHECK (preco_unitario >= 0),
    desconto_item NUMERIC(12,2) DEFAULT 0 CHECK (desconto_item >= 0),
    subtotal NUMERIC(14,2) DEFAULT 0 CHECK (subtotal >= 0),
    CONSTRAINT fk_itempedido_pedido FOREIGN KEY (pedido_id)
        REFERENCES pedido(pedido_id) ON DELETE CASCADE,
    CONSTRAINT fk_itempedido_produto FOREIGN KEY (produto_id)
        REFERENCES produto(produto_id) ON DELETE RESTRICT,
    CONSTRAINT uc_item_pedido UNIQUE (pedido_id, produto_id)
);

-- =======================================
-- TABELA PAGAMENTO
-- =======================================
CREATE TABLE IF NOT EXISTS pagamento (
    pagamento_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL UNIQUE,
    metodo_pagamento VARCHAR(30),
    status_pagamento VARCHAR(30) DEFAULT 'pendente',
    valor_pago NUMERIC(12,2) DEFAULT 0 CHECK (valor_pago >= 0),
    data_pagamento TIMESTAMP WITH TIME ZONE,
    data_aprovacao TIMESTAMP WITH TIME ZONE,
    numero_parcelas INT DEFAULT 1,
    codigo_transacao VARCHAR(200),
    dados_pagamento_hash TEXT,
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (pedido_id)
        REFERENCES pedido(pedido_id) ON DELETE CASCADE
);

-- =======================================
-- TABELA AVALIACAO DO PRODUTO
-- =======================================
CREATE TABLE IF NOT EXISTS avaliacao_produto (
    avaliacao_id SERIAL PRIMARY KEY,
    produto_id INT NOT NULL,
    cliente_id INT NOT NULL,
    pedido_id INT,
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    titulo VARCHAR(200),
    comentario TEXT,
    data_avaliacao TIMESTAMP WITH TIME ZONE DEFAULT now(),
    verificado BOOLEAN DEFAULT FALSE,
    util_positivo INT DEFAULT 0,
    util_negativo INT DEFAULT 0,
    CONSTRAINT fk_avaliacao_produto FOREIGN KEY (produto_id)
        REFERENCES produto(produto_id) ON DELETE CASCADE,
    CONSTRAINT fk_avaliacao_cliente FOREIGN KEY (cliente_id)
        REFERENCES cliente(cliente_id) ON DELETE CASCADE,
    CONSTRAINT fk_avaliacao_pedido FOREIGN KEY (pedido_id)
        REFERENCES pedido(pedido_id) ON DELETE SET NULL
);

-- =======================================
-- ÍNDICES
-- =======================================
CREATE INDEX IF NOT EXISTS idx_cliente_email ON cliente(email);
CREATE INDEX IF NOT EXISTS idx_cliente_cpf ON cliente(cpf);
CREATE INDEX IF NOT EXISTS idx_produto_sku ON produto(sku);
CREATE INDEX IF NOT EXISTS idx_produto_categoria ON produto(categoria_id);
CREATE INDEX IF NOT EXISTS idx_pedido_cliente ON pedido(cliente_id);
CREATE INDEX IF NOT EXISTS idx_pedido_data ON pedido(data_pedido);
CREATE INDEX IF NOT EXISTS idx_avaliacao_produto ON avaliacao_produto(produto_id);
