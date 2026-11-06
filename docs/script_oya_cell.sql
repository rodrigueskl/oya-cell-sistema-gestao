-- Entrega 2 — Oya Cell
-- SGBD: MySQL 8.0+
-- Dados fictícios, sem uso de dados pessoais reais.

DROP DATABASE IF EXISTS oya_cell;
CREATE DATABASE oya_cell CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE oya_cell;

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  cpf_cnpj VARCHAR(18) NOT NULL UNIQUE,
  contato VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(30) NOT NULL UNIQUE,
  descricao VARCHAR(150) NOT NULL,
  categoria VARCHAR(60) NOT NULL,
  preco DECIMAL(10,2) NOT NULL,
  quantidade_estoque INT NOT NULL DEFAULT 0,
  estoque_minimo INT NOT NULL DEFAULT 5,
  CONSTRAINT ck_produto_preco CHECK (preco > 0),
  CONSTRAINT ck_produto_estoque CHECK (quantidade_estoque >= 0),
  CONSTRAINT ck_produto_minimo CHECK (estoque_minimo >= 0)
) ENGINE=InnoDB;

CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  funcao VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  data_pedido DATETIME NOT NULL,
  valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,
  status ENUM('EM_SEPARACAO','SAIU_PARA_ENTREGA','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'EM_SEPARACAO',
  forma_recebimento ENUM('BALCAO','ENTREGA') NOT NULL,
  id_cliente INT NOT NULL,
  data_cancelamento DATETIME NULL,
  motivo_cancelamento VARCHAR(255) NULL,
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  CONSTRAINT ck_pedido_valor CHECK (valor_total >= 0),
  CONSTRAINT ck_pedido_cancelamento CHECK ((status <> 'CANCELADO') OR (data_cancelamento IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE item_pedido (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) AS (quantidade * preco_unitario) STORED,
  CONSTRAINT uq_item_pedido_produto UNIQUE (id_pedido, id_produto),
  CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
  CONSTRAINT ck_item_quantidade CHECK (quantidade > 0),
  CONSTRAINT ck_item_preco CHECK (preco_unitario > 0)
) ENGINE=InnoDB;

CREATE TABLE pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  forma_pagamento ENUM('PIX','CARTAO_DEBITO','CARTAO_CREDITO','BOLETO') NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  data_pagamento DATETIME NOT NULL,
  status_pagamento ENUM('PENDENTE','CONFIRMADO','ESTORNADO') NOT NULL DEFAULT 'PENDENTE',
  CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  CONSTRAINT ck_pagamento_valor CHECK (valor > 0)
) ENGINE=InnoDB;

CREATE TABLE funcionario_pedido (
  id_funcionario INT NOT NULL,
  id_pedido INT NOT NULL,
  participacao VARCHAR(80) NOT NULL,
  PRIMARY KEY (id_funcionario, id_pedido),
  CONSTRAINT fk_fp_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
  CONSTRAINT fk_fp_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
) ENGINE=InnoDB;

CREATE TABLE movimentacao_estoque (
  id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT NOT NULL,
  id_funcionario INT NOT NULL,
  id_pedido INT NULL,
  tipo_movimentacao ENUM('ENTRADA','SAIDA') NOT NULL,
  quantidade INT NOT NULL,
  data_movimentacao DATETIME NOT NULL,
  CONSTRAINT fk_me_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
  CONSTRAINT fk_me_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
  CONSTRAINT fk_me_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  CONSTRAINT ck_me_quantidade CHECK (quantidade > 0),
  CONSTRAINT ck_me_pedido_saida CHECK ((tipo_movimentacao = 'ENTRADA' AND id_pedido IS NULL) OR (tipo_movimentacao = 'SAIDA'))
) ENGINE=InnoDB;

CREATE TABLE estorno (
  id_estorno INT AUTO_INCREMENT PRIMARY KEY,
  id_pagamento INT NOT NULL,
  valor_estornado DECIMAL(10,2) NOT NULL,
  percentual_estorno DECIMAL(5,2) NOT NULL,
  data_estorno DATETIME NOT NULL,
  CONSTRAINT fk_estorno_pagamento FOREIGN KEY (id_pagamento) REFERENCES pagamento(id_pagamento),
  CONSTRAINT ck_estorno_valor CHECK (valor_estornado > 0),
  CONSTRAINT ck_estorno_percentual CHECK (percentual_estorno IN (60.00, 100.00))
) ENGINE=InnoDB;

-- Massa fictícia: 12 clientes, 16 produtos, 7 funcionários, 18 pedidos.
INSERT INTO cliente (nome, cpf_cnpj, contato) VALUES
('Alpha Assistência Móvel','00.000.000/0001-01','11990000001'),('Beta Celulares','00.000.000/0001-02','11990000002'),('Casa do Reparo','00.000.000/0001-03','11990000003'),('Conecta Tech','00.000.000/0001-04','11990000004'),('Digital Mix','00.000.000/0001-05','11990000005'),('Eletrônica Central','00.000.000/0001-06','11990000006'),('Futura Mobile','00.000.000/0001-07','11990000007'),('Giga Smart','00.000.000/0001-08','11990000008'),('Help Phone','00.000.000/0001-09','11990000009'),('Inova Cell','00.000.000/0001-10','11990000010'),('Jota Eletrônicos','00.000.000/0001-11','11990000011'),('Kappa Assistência','00.000.000/0001-12','11990000012');

INSERT INTO produto (codigo, descricao, categoria, preco, quantidade_estoque, estoque_minimo) VALUES
('TEL-IP11','Tela compatível iPhone 11','COMPONENTE',320.00,4,5),('TEL-A54','Tela compatível Galaxy A54','COMPONENTE',185.00,18,8),('BAT-IPX','Bateria compatível iPhone X','COMPONENTE',95.00,3,5),('BAT-A32','Bateria compatível Galaxy A32','COMPONENTE',72.00,21,8),('TAMPA-S20','Tampa traseira Galaxy S20','COMPONENTE',88.00,6,5),('CAPA-UNI','Capa protetora universal','ACESSORIO',22.00,35,10),('PEL-3D','Película 3D universal','ACESSORIO',15.00,7,10),('FONE-BT','Fone Bluetooth','ACESSORIO',49.90,14,6),('CAR-PD20','Carregador PD 20W','ACESSORIO',69.90,19,8),('CABO-TC1','Cabo USB-C 1 metro','ACESSORIO',25.00,40,12),('CABO-LIG','Cabo Lightning 1 metro','ACESSORIO',29.90,11,8),('PLACA-J7','Placa principal Galaxy J7','COMPONENTE',210.00,2,3),('CONEC-C','Conector de carga USB-C','COMPONENTE',38.00,17,6),('CAM-IP8','Câmera traseira iPhone 8','COMPONENTE',115.00,5,4),('SUP-CAR','Suporte veicular','ACESSORIO',32.00,13,5),('PEL-IP14','Película iPhone 14','ACESSORIO',18.00,9,8);

INSERT INTO funcionario (nome, funcao) VALUES
('Ana Lima','Atendimento'),('Bruno Reis','Estoque'),('Carla Nunes','Atendimento'),('Diego Alves','Separação'),('Elisa Moraes','Caixa'),('Fabio Costa','Entrega'),('Gabi Torres','Gerência');

INSERT INTO pedido (data_pedido, valor_total, status, forma_recebimento, id_cliente, data_cancelamento, motivo_cancelamento) VALUES
('2026-09-01 09:10:00',0,'FINALIZADO','BALCAO',1,NULL,NULL),('2026-09-01 10:30:00',0,'FINALIZADO','ENTREGA',2,NULL,NULL),('2026-09-02 11:00:00',0,'FINALIZADO','BALCAO',3,NULL,NULL),('2026-09-03 13:20:00',0,'SAIU_PARA_ENTREGA','ENTREGA',4,NULL,NULL),('2026-09-04 15:00:00',0,'CANCELADO','BALCAO',5,'2026-09-04 16:00:00','Cliente desistiu antes da separação'),('2026-09-05 09:40:00',0,'FINALIZADO','BALCAO',6,NULL,NULL),('2026-09-06 10:15:00',0,'FINALIZADO','ENTREGA',7,NULL,NULL),('2026-09-08 14:00:00',0,'EM_SEPARACAO','BALCAO',8,NULL,NULL),('2026-09-09 16:20:00',0,'FINALIZADO','BALCAO',9,NULL,NULL),('2026-09-10 09:00:00',0,'CANCELADO','ENTREGA',10,'2026-09-10 12:00:00','Cancelamento após saída'),('2026-09-11 11:25:00',0,'FINALIZADO','ENTREGA',11,NULL,NULL),('2026-09-12 12:30:00',0,'FINALIZADO','BALCAO',12,NULL,NULL),('2026-09-15 10:10:00',0,'FINALIZADO','BALCAO',1,NULL,NULL),('2026-09-16 15:30:00',0,'FINALIZADO','ENTREGA',2,NULL,NULL),('2026-09-18 09:50:00',0,'FINALIZADO','BALCAO',3,NULL,NULL),('2026-09-20 13:10:00',0,'FINALIZADO','ENTREGA',4,NULL,NULL),('2026-09-22 10:45:00',0,'FINALIZADO','BALCAO',6,NULL,NULL),('2026-09-25 16:00:00',0,'EM_SEPARACAO','ENTREGA',7,NULL,NULL);

INSERT INTO item_pedido (id_pedido,id_produto,quantidade,preco_unitario) VALUES
(1,1,1,320.00),(1,10,2,25.00),(2,2,2,185.00),(2,9,1,69.90),(3,6,5,22.00),(3,7,5,15.00),(4,3,2,95.00),(4,8,2,49.90),(5,12,1,210.00),(6,4,3,72.00),(6,13,2,38.00),(7,5,2,88.00),(7,16,3,18.00),(8,14,1,115.00),(8,15,2,32.00),(9,10,4,25.00),(9,11,2,29.90),(10,1,1,320.00),(11,2,1,185.00),(11,9,2,69.90),(12,6,3,22.00),(12,8,1,49.90),(13,3,1,95.00),(13,4,1,72.00),(14,7,4,15.00),(14,16,2,18.00),(15,5,1,88.00),(15,13,3,38.00),(16,10,5,25.00),(16,9,1,69.90),(17,11,3,29.90),(17,15,1,32.00),(18,2,1,185.00),(18,6,2,22.00);

UPDATE pedido p SET valor_total=(SELECT COALESCE(SUM(i.subtotal),0) FROM item_pedido i WHERE i.id_pedido=p.id_pedido);

INSERT INTO pagamento (id_pedido,forma_pagamento,valor,data_pagamento,status_pagamento) VALUES
(1,'PIX',370.00,'2026-09-01 09:15:00','CONFIRMADO'),(2,'CARTAO_CREDITO',439.90,'2026-09-01 10:35:00','CONFIRMADO'),(3,'PIX',185.00,'2026-09-02 11:05:00','CONFIRMADO'),(4,'BOLETO',289.80,'2026-09-03 13:25:00','CONFIRMADO'),(5,'PIX',210.00,'2026-09-04 15:05:00','ESTORNADO'),(6,'CARTAO_DEBITO',292.00,'2026-09-05 09:45:00','CONFIRMADO'),(7,'PIX',230.00,'2026-09-06 10:20:00','CONFIRMADO'),(8,'PIX',179.00,'2026-09-08 14:05:00','CONFIRMADO'),(9,'CARTAO_CREDITO',159.80,'2026-09-09 16:25:00','CONFIRMADO'),(10,'PIX',320.00,'2026-09-10 09:05:00','ESTORNADO'),(11,'BOLETO',324.80,'2026-09-11 11:30:00','CONFIRMADO'),(12,'PIX',115.90,'2026-09-12 12:35:00','CONFIRMADO'),(13,'PIX',167.00,'2026-09-15 10:15:00','CONFIRMADO'),(14,'CARTAO_DEBITO',96.00,'2026-09-16 15:35:00','CONFIRMADO'),(15,'PIX',202.00,'2026-09-18 09:55:00','CONFIRMADO'),(16,'CARTAO_CREDITO',194.90,'2026-09-20 13:15:00','CONFIRMADO'),(17,'PIX',121.70,'2026-09-22 10:50:00','CONFIRMADO'),(18,'PIX',229.00,'2026-09-25 16:05:00','CONFIRMADO');

INSERT INTO funcionario_pedido VALUES
(1,1,'atendimento'),(5,1,'pagamento'),(3,2,'atendimento'),(4,2,'separacao'),(2,3,'estoque'),(1,4,'atendimento'),(6,4,'entrega'),(3,5,'atendimento'),(5,5,'estorno'),(1,6,'atendimento'),(2,6,'separacao'),(4,7,'separacao'),(6,7,'entrega'),(3,8,'atendimento'),(1,9,'atendimento'),(5,10,'estorno'),(6,11,'entrega'),(3,12,'atendimento'),(1,13,'atendimento'),(4,14,'separacao'),(6,14,'entrega'),(1,15,'atendimento'),(6,16,'entrega'),(3,17,'atendimento'),(4,18,'separacao');

INSERT INTO movimentacao_estoque (id_produto,id_funcionario,id_pedido,tipo_movimentacao,quantidade,data_movimentacao) VALUES
(1,2,NULL,'ENTRADA',12,'2026-08-25 08:00:00'),(2,2,NULL,'ENTRADA',30,'2026-08-25 08:00:00'),(3,2,NULL,'ENTRADA',10,'2026-08-25 08:00:00'),(4,2,NULL,'ENTRADA',30,'2026-08-25 08:00:00'),(6,2,NULL,'ENTRADA',50,'2026-08-25 08:00:00'),(7,2,NULL,'ENTRADA',25,'2026-08-25 08:00:00'),(10,2,NULL,'ENTRADA',60,'2026-08-25 08:00:00'),(1,4,1,'SAIDA',1,'2026-09-01 09:20:00'),(10,4,1,'SAIDA',2,'2026-09-01 09:20:00'),(2,4,2,'SAIDA',2,'2026-09-01 10:40:00'),(9,4,2,'SAIDA',1,'2026-09-01 10:40:00'),(3,4,4,'SAIDA',2,'2026-09-03 13:30:00'),(8,4,4,'SAIDA',2,'2026-09-03 13:30:00'),(4,4,6,'SAIDA',3,'2026-09-05 09:50:00'),(13,4,6,'SAIDA',2,'2026-09-05 09:50:00'),(5,4,7,'SAIDA',2,'2026-09-06 10:25:00'),(16,4,7,'SAIDA',3,'2026-09-06 10:25:00'),(14,4,8,'SAIDA',1,'2026-09-08 14:10:00'),(15,4,8,'SAIDA',2,'2026-09-08 14:10:00'),(10,4,9,'SAIDA',4,'2026-09-09 16:30:00'),(11,4,9,'SAIDA',2,'2026-09-09 16:30:00'),(1,4,10,'SAIDA',1,'2026-09-10 09:10:00'),(2,4,11,'SAIDA',1,'2026-09-11 11:35:00'),(9,4,11,'SAIDA',2,'2026-09-11 11:35:00'),(6,4,12,'SAIDA',3,'2026-09-12 12:40:00'),(8,4,12,'SAIDA',1,'2026-09-12 12:40:00'),(3,4,13,'SAIDA',1,'2026-09-15 10:20:00'),(4,4,13,'SAIDA',1,'2026-09-15 10:20:00'),(7,4,14,'SAIDA',4,'2026-09-16 15:40:00'),(16,4,14,'SAIDA',2,'2026-09-16 15:40:00'),(5,4,15,'SAIDA',1,'2026-09-18 10:00:00'),(13,4,15,'SAIDA',3,'2026-09-18 10:00:00'),(10,4,16,'SAIDA',5,'2026-09-20 13:20:00'),(9,4,16,'SAIDA',1,'2026-09-20 13:20:00'),(11,4,17,'SAIDA',3,'2026-09-22 10:55:00'),(15,4,17,'SAIDA',1,'2026-09-22 10:55:00'),(2,4,18,'SAIDA',1,'2026-09-25 16:10:00'),(6,4,18,'SAIDA',2,'2026-09-25 16:10:00');

INSERT INTO estorno (id_pagamento,valor_estornado,percentual_estorno,data_estorno) VALUES
(5,210.00,100.00,'2026-09-04 16:10:00'),(10,192.00,60.00,'2026-09-10 12:10:00');

-- SELECT com JOIN: pedidos detalhados
SELECT p.id_pedido,c.nome AS cliente,p.data_pedido,p.status,pr.descricao,i.quantidade,i.preco_unitario,i.subtotal
FROM pedido p JOIN cliente c ON c.id_cliente=p.id_cliente JOIN item_pedido i ON i.id_pedido=p.id_pedido JOIN produto pr ON pr.id_produto=i.id_produto
ORDER BY p.data_pedido;

-- UPDATE demonstrativo: reajuste controlado de um produto
UPDATE produto SET preco = ROUND(preco * 1.05, 2) WHERE codigo='CAPA-UNI';

-- DELETE demonstrativo seguro: remove somente cliente sem pedido (a massa não possui tal registro)
DELETE FROM cliente WHERE id_cliente=999 AND NOT EXISTS (SELECT 1 FROM pedido WHERE pedido.id_cliente=cliente.id_cliente);

-- G01 — Qual foi o faturamento por período e status?
-- Atende: P1 (organização dos pedidos) e KPI de faturamento mensal.
SELECT DATE_FORMAT(data_pedido,'%Y-%m') AS mes, status, COUNT(*) AS quantidade_pedidos, SUM(valor_total) AS valor_total
FROM pedido GROUP BY DATE_FORMAT(data_pedido,'%Y-%m'),status ORDER BY mes,status;

-- G02 — Quais produtos estão abaixo do estoque mínimo?
-- Atende: P2 (controle de estoque).
SELECT codigo,descricao,quantidade_estoque,estoque_minimo,(estoque_minimo-quantidade_estoque) AS reposicao_sugerida
FROM produto WHERE quantidade_estoque < estoque_minimo ORDER BY reposicao_sugerida DESC;

-- G03 — Qual é o ticket médio por forma de recebimento?
-- Atende: KPI de ticket médio.
SELECT forma_recebimento,COUNT(*) AS pedidos,ROUND(AVG(valor_total),2) AS ticket_medio
FROM pedido WHERE status <> 'CANCELADO' GROUP BY forma_recebimento;

-- G04 — Qual a taxa de cancelamento e o valor estornado?
-- Atende: KPI de cancelamento e RN17/RN18.
SELECT COUNT(*) AS total_pedidos,SUM(status='CANCELADO') AS cancelados,ROUND(100*SUM(status='CANCELADO')/COUNT(*),2) AS taxa_cancelamento,
(SELECT COALESCE(SUM(valor_estornado),0) FROM estorno) AS total_estornado FROM pedido;

-- G05 — Quais clientes realizaram pedidos e qual o total comprado?
-- Atende: gestão de relacionamento e P1.
SELECT c.nome,COUNT(p.id_pedido) AS pedidos,SUM(p.valor_total) AS total_comprado
FROM cliente c LEFT JOIN pedido p ON p.id_cliente=c.id_cliente AND p.status <> 'CANCELADO'
GROUP BY c.id_cliente,c.nome ORDER BY total_comprado DESC;

-- G06 — Quais produtos mais saíram do estoque?
-- Atende: P2 e apoio à reposição.
SELECT pr.codigo,pr.descricao,SUM(m.quantidade) AS unidades_saida
FROM movimentacao_estoque m JOIN produto pr ON pr.id_produto=m.id_produto
WHERE m.tipo_movimentacao='SAIDA' GROUP BY pr.id_produto,pr.codigo,pr.descricao ORDER BY unidades_saida DESC;

-- A01 — Existem itens com quantidade ou preço inválidos?
-- Verifica: RN03 e integridade de ITEM_PEDIDO.
SELECT * FROM item_pedido WHERE quantidade <= 0 OR preco_unitario <= 0;

-- A02 — Existem pedidos cancelados sem data ou motivo?
-- Verifica: RN17/RN18 e regra de histórico de cancelamento.
SELECT * FROM pedido WHERE status='CANCELADO' AND (data_cancelamento IS NULL OR motivo_cancelamento IS NULL OR motivo_cancelamento='');

-- A03 — Existem pagamentos sem pedido ou com valor incompatível?
-- Verifica: RN05 e consistência de pagamentos.
SELECT pg.* FROM pagamento pg LEFT JOIN pedido p ON p.id_pedido=pg.id_pedido
WHERE p.id_pedido IS NULL OR pg.valor <= 0;

-- A04 — Existem saídas de estoque sem pedido de origem?
-- Verifica: RN10 e rastreabilidade das saídas.
SELECT * FROM movimentacao_estoque WHERE tipo_movimentacao='SAIDA' AND id_pedido IS NULL;

-- A05 — O valor do pedido coincide com a soma dos itens?
-- Verifica: RN04.
SELECT p.id_pedido,p.valor_total,COALESCE(SUM(i.subtotal),0) AS soma_itens
FROM pedido p LEFT JOIN item_pedido i ON i.id_pedido=p.id_pedido
GROUP BY p.id_pedido,p.valor_total HAVING p.valor_total <> COALESCE(SUM(i.subtotal),0);

-- A06 — Há estoque negativo ou tipos de movimentação fora do domínio?
-- Verifica: RN12/RN13.
SELECT * FROM produto WHERE quantidade_estoque < 0;
