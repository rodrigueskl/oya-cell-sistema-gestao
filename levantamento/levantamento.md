# Levantamento de Requisitos — Oya Cell

> Documento baseado no material existente no repositório e na caracterização registrada pelo grupo. Campos entre colchetes devem ser confirmados com o responsável antes da entrega final.

## 1. Identificação

- **Organização:** Oya Cell
- **Natureza:** empresa comercial de acessórios e componentes para celulares, com atendimento principalmente a outras empresas.
- **Endereço registrado:** Rua Barão de Duplat, 389.
- **Contato registrado:** (11) 98387-1006.
- **Porte informado:** aproximadamente 7 funcionários e média de 25 atendimentos por dia.
- **Canais de pedido:** balcão, telefone e WhatsApp.
- **Responsável entrevistado:** Nader — Gerente.
- **Telefone:** (11) 95389-9241.
- **E-mail corporativo:** oyacell@icloud.com.
- **Data:** 19/09/2026.
- **Local:** dependências da Oya Cell.
- **Participantes:** Lucas Gabriel Roman Martins, Gabriel Arnaldo da Silva, Emily Mayara Matos Moreira e Kauã Gomes da Silva.

## 2. Problemas identificados

- **P1 — Pedidos pouco estruturados:** os pedidos podem chegar por diferentes canais e precisam ser organizados com cliente, itens, quantidades, valores, pagamento, recebimento e status.
- **P2 — Estoque sem rastreabilidade suficiente:** em algumas situações a disponibilidade é verificada por contagem informal, dificultando acompanhar entradas, saídas e necessidade de reposição.
- **P3 — Cancelamentos e estornos sem histórico padronizado:** é necessário manter o pedido, a situação do pagamento, o motivo e o valor estornado, sem apagar o histórico.

## 3. Processos observados ou informados

### 3.1 Pedido e venda

O cliente solicita um ou mais produtos no balcão, por telefone ou pelo WhatsApp. O atendente identifica o cliente, registra os itens e quantidades, calcula o total, registra o pagamento e define se o pedido será retirado no balcão ou entregue. Após a confirmação do pagamento, os produtos são separados. O pedido pode ser finalizado, sair para entrega ou permanecer em separação.

### 3.2 Estoque

O recebimento de mercadorias gera uma entrada. A venda gera saídas vinculadas ao pedido. Cada movimentação identifica o produto, o funcionário responsável, a quantidade, o tipo e a data. O produto mantém quantidade atual e estoque mínimo para apoiar a reposição.

### 3.3 Cancelamento e estorno

O pedido cancelado permanece no banco. Se o cancelamento ocorre antes da saída, o modelo registra estorno integral; se a regra da organização permitir cancelamento após a saída, registra-se estorno de 60%. Os percentuais devem ser confirmados com o responsável.

## 4. Requisitos funcionais

- **RF01:** cadastrar cliente com nome, CPF/CNPJ e contato.
- **RF02:** cadastrar produto com código, descrição, categoria, preço, estoque atual e estoque mínimo.
- **RF03:** cadastrar funcionário com nome e função.
- **RF04:** registrar pedido com data, cliente, forma de recebimento e status.
- **RF05:** incluir no pedido produtos, quantidade, preço praticado e subtotal.
- **RF06:** calcular o valor total do pedido pela soma dos subtotais.
- **RF07:** registrar um ou mais pagamentos, com forma, valor, data e status.
- **RF08:** registrar a participação dos funcionários no pedido.
- **RF09:** registrar entradas e saídas de estoque, com funcionário e data.
- **RF10:** vincular a saída de estoque ao pedido de origem quando se tratar de venda.
- **RF11:** registrar cancelamento com data e motivo, preservando o pedido.
- **RF12:** registrar estorno e percentual aplicado.
- **RF13:** consultar pedidos detalhados, estoque abaixo do mínimo, faturamento, cancelamentos e produtos mais vendidos.

## 5. Requisitos não funcionais

- **RNF01 — Usabilidade:** operação simples para uso durante o atendimento.
- **RNF02 — Integridade:** PKs, FKs, `NOT NULL`, `UNIQUE`, `CHECK` e domínios controlados.
- **RNF03 — Rastreabilidade:** pedidos, pagamentos e movimentações devem manter data e responsáveis.
- **RNF04 — Privacidade:** a massa de teste não utiliza dados reais de clientes.
- **RNF05 — Desempenho:** consultas de atendimento devem cruzar pedidos, clientes e produtos sem depender de planilhas manuais.
- **RNF06 — Disponibilidade:** o sistema deve estar disponível no horário de funcionamento, conforme a infraestrutura adotada.

## 6. Regras de negócio

- **RN01:** um cliente pode realizar vários pedidos; cada pedido pertence a um cliente.
- **RN02:** cada pedido possui um ou mais itens; cada item referencia um produto.
- **RN03:** quantidade de item e quantidade de movimentação devem ser maiores que zero.
- **RN04:** valor total do pedido corresponde à soma dos subtotais.
- **RN05:** todo pagamento pertence a um pedido.
- **RN06:** um pedido pode ter mais de um pagamento.
- **RN07:** formas de pagamento permitidas: PIX, cartão de débito, cartão de crédito e boleto.
- **RN08:** o pedido só deve ser liberado após confirmação do pagamento.
- **RN09:** funcionários podem participar de vários pedidos e um pedido pode envolver vários funcionários.
- **RN10:** venda gera saída de estoque vinculada ao pedido.
- **RN11:** entrada de mercadoria gera movimentação de entrada sem pedido de venda.
- **RN12:** toda movimentação registra produto, funcionário, tipo, quantidade e data.
- **RN13:** estoque não pode ser negativo e produtos abaixo do mínimo devem ser identificáveis.
- **RN14:** forma de recebimento é balcão ou entrega.
- **RN15:** cancelamento não apaga o pedido; registra data e motivo.
- **RN16:** estorno permitido pelo modelo é de 100% ou 60%, conforme a situação confirmada pela organização.

## 7. Confirmações pendentes

Antes da submissão, confirmar com o responsável: nome e função, ano da entrevista, participantes, existência de boleto, pagamentos múltiplos, regra de estorno de 60%, existência de entrega própria e valores aproximados de clientes, produtos e pedidos mensais. A foto da visita deve permanecer em `Evidencias/` e ser referenciada com a extensão real `.jpeg`.
