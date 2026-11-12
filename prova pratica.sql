
CREATE TABLE investidores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    nivel_experiencia INT DEFAULT 0 CHECK (nivel_experiencia >= 0)
);

CREATE TABLE carteiras (
    id SERIAL PRIMARY KEY,
    investidor_id INT NOT NULL REFERENCES investidores(id),
    endereco_wallet VARCHAR(100) UNIQUE NOT NULL,
    rede_blockchain VARCHAR(50) NOT NULL,
    saldo_usd DECIMAL(15,2) NOT NULL CHECK (saldo_usd > 0),
    status VARCHAR(20) DEFAULT 'Ativa'
    CHECK (status IN ('Ativa', 'Em Analise', 'Bloqueada', 'Pausada'))
);

CREATE TABLE corretoras (
    id SERIAL PRIMARY KEY,
    nome_exchange VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    email_suporte VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE criptomoedas (
    id SERIAL PRIMARY KEY,
    corretora_id INT NOT NULL REFERENCES corretoras(id),
    nome_moeda VARCHAR(50) NOT NULL,
    preco_unitario_usd DECIMAL(15,2) NOT NULL CHECK (preco_unitario_usd > 0),
    categoria VARCHAR(20) DEFAULT 'Layer1'
    CHECK (categoria IN ('Layer1', 'DeFi', 'Memecoin', 'Stablecoin'))
);

CREATE TABLE transacoes_cripto (
    id SERIAL PRIMARY KEY,
    carteira_id INT NOT NULL REFERENCES carteiras(id),
    criptomoeda_id INT NOT NULL REFERENCES criptomoedas(id),
    quantidade DECIMAL(15,6) NOT NULL CHECK (quantidade > 0),
    valor_pago DECIMAL(15,2) NOT NULL CHECK (valor_pago > 0),
    data_transacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);



INSERT INTO investidores (nome, cpf, nivel_experiencia) VALUES
('Pedro Henrique', '63829147520', 3),
('Lucas Martins', '72938461503', 1),
('Rafael Almeida', '81527394602', 4),
('Bruno Ferreira', '49281637504', 2),
('Eduardo Rodrigues', '58392017461', 5);

INSERT INTO carteiras
(investidor_id, endereco_wallet, rede_blockchain, saldo_usd, status)
VALUES
(1, '0x82D101', 'Ethereum', 3200.00, 'Ativa'),
(2, '0x82D102', 'Bitcoin', 4500.00, 'Em Analise'),
(3, '0x82D103', 'Solana', 1800.00, 'Bloqueada'),
(4, '0x82D104', 'Ethereum', 2800.00, 'Pausada'),
(5, '0x82D105', 'Bitcoin', 5100.00, 'Ativa');

INSERT INTO corretoras (nome_exchange, cnpj, email_suporte) VALUES
('Bitget', '63829147000120', 'atendimento@bitget.com'),
('KuCoin', '72938461000130', 'suporte@kucoin.com'),
('Gate.io', '81527394000140', 'contato@gate.io'),
('Crypto.com', '49281637000150', 'suporte@crypto.com'),
('Gemini', '58392017000160', 'ajuda@gemini.com');

INSERT INTO criptomoedas
(corretora_id, nome_moeda, preco_unitario_usd, categoria)
VALUES
(1, 'Bitcoin', 97000.00, 'Layer1'),
(2, 'Ethereum', 3400.00, 'Layer1'),
(3, 'Solana', 195.00, 'Layer1'),
(4, 'Uniswap', 15.00, 'DeFi'),
(5, 'USDC', 1.00, 'Stablecoin');

INSERT INTO transacoes_cripto
(carteira_id, criptomoeda_id, quantidade, valor_pago)
VALUES
(1, 1, 0.03, 2910.00),
(2, 2, 0.40, 1360.00),
(3, 3, 6.00, 1170.00),
(4, 4, 50.00, 750.00),
(5, 5, 900.00, 900.00);



SELECT
    c.endereco_wallet,
    c.rede_blockchain,
    c.saldo_usd,
    i.nome,
    i.cpf
FROM carteiras c
INNER JOIN investidores i
ON c.investidor_id = i.id
WHERE c.status IN ('Ativa', 'Em Analise');



SELECT
    co.nome_exchange,
    SUM(t.valor_pago) AS total_movimentado
FROM transacoes_cripto t
INNER JOIN criptomoedas cr
ON t.criptomoeda_id = cr.id
INNER JOIN corretoras co
ON cr.corretora_id = co.id
GROUP BY co.nome_exchange
ORDER BY total_movimentado DESC;



SELECT
    c.endereco_wallet,
    cr.nome_moeda,
    t.quantidade,
    t.valor_pago,
    t.data_transacao
FROM transacoes_cripto t
INNER JOIN carteiras c
ON t.carteira_id = c.id
INNER JOIN criptomoedas cr
ON t.criptomoeda_id = cr.id
WHERE t.valor_pago > 500
ORDER BY t.valor_pago DESC;






CREATE VIEW vw_painel_carteiras AS
SELECT
    c.endereco_wallet,
    c.rede_blockchain,
    c.status,
    c.saldo_usd,
    i.nome AS nome_investidor,
    i.cpf
FROM carteiras c
INNER JOIN investidores i
ON c.investidor_id = i.id;



CREATE VIEW vw_investimento_total_carteiras AS
SELECT
    c.id AS id_carteira,
    c.endereco_wallet,
    c.saldo_usd,
    COUNT(t.id) AS quantidade_transacoes,
    COALESCE(SUM(t.valor_pago), 0) AS custo_total
FROM carteiras c
LEFT JOIN transacoes_cripto t
ON c.id = t.carteira_id
GROUP BY c.id, c.endereco_wallet, c.saldo_usd;




SELECT * FROM vw_painel_carteiras;

SELECT * FROM vw_investimento_total_carteiras;




UPDATE investidores
SET nivel_experiencia = 5
WHERE id = 1;




DELETE FROM transacoes_cripto
WHERE id = 5;



SELECT * FROM investidores;
SELECT * FROM carteiras;
SELECT * FROM corretoras;
SELECT * FROM criptomoedas;
SELECT * FROM transacoes_cripto;
