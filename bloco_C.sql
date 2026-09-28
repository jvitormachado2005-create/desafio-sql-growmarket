-- ============================================================================ -- DESAFIO GROWMARKET - OLIST DATASET -- Arquivo: bloco_C.sql -- ============================================================================
-- ----------------------------------------------------------------------------
-- Questão 1: Faturamento total por estado do cliente.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é o faturamento total gerado por cada estado do cliente, –permitindo identificar os mercados regionais mais rentáveis para a empresa? 


SELECT
   olist_customers_dataset.customer_state,
   SUM(olist_order_items_dataset.price)
FROM olist_orders_dataset
INNER JOIN olist_customers_dataset
   ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
INNER JOIN olist_order_items_dataset
   ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
GROUP BY olist_customers_dataset.customer_state;



-- ----------------------------------------------------------------------------
-- Questão 2: Top 10 vendedores por faturamento.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais são os 10 principais vendedores em volume de faturamento –total,  auxiliando na identificação dos parceiros comerciais de maior impacto na plataforma? 


SELECT
   olist_order_items_dataset.seller_id,
   SUM(olist_order_items_dataset.price)
FROM olist_order_items_dataset
GROUP BY olist_order_items_dataset.seller_id
ORDER BY SUM(olist_order_items_dataset.price) DESC
LIMIT 10;


-- ----------------------------------------------------------------------------
-- Questão 3: Ticket médio por categoria de produto.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é o ticket médio das vendas por categoria de produto, —permitindo analisar a rentabilidade e o valor médio de compra de cada segmento? 




SELECT
   olist_products_dataset.product_category_name,
   AVG(olist_order_items_dataset.price)
FROM olist_order_items_dataset
INNER JOIN olist_products_dataset
   ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
GROUP BY olist_products_dataset.product_category_name;


-- ----------------------------------------------------------------------------
-- Questão 4: Vendedores com nota média de avaliação abaixo de 3 (HAVING AVG(...) < 3).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais vendedores possuem avaliação média inferior a 3 estrelas, -- –permitindo ao time de qualidade identificar e atuar na gestão de parceiros com baixo –desempenho? 


SELECT
   olist_order_items_dataset.seller_id,
   AVG(olist_order_reviews_dataset.review_score)
FROM olist_order_items_dataset
INNER JOIN olist_order_reviews_dataset
   ON olist_order_items_dataset.order_id = olist_order_reviews_dataset.order_id
GROUP BY olist_order_items_dataset.seller_id
HAVING AVG(olist_order_reviews_dataset.review_score) < 3;



-- ----------------------------------------------------------------------------
-- Questão 5: Quantidade de pedidos por forma de pagamento (GROUP BY payment_type).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é o volume total de pedidos realizados por cada tipo de –pagamento, -- ajudando a mapear as preferências financeiras dos consumidores da –plataforma? 


SELECT
   olist_order_payments_dataset.payment_type,
   COUNT(DISTINCT olist_order_payments_dataset.order_id)
FROM olist_order_payments_dataset
GROUP BY olist_order_payments_dataset.payment_type;


-- ----------------------------------------------------------------------------
-- Questão 6: Peso médio dos produtos por categoria.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é o peso médio dos produtos por categoria catalogada, -- –auxiliando o time de logística na negociação de fretes e na gestão de transporte? 


SELECT
   olist_products_dataset.product_category_name,
   AVG(olist_products_dataset.product_weight_g)
FROM olist_products_dataset
GROUP BY olist_products_dataset.product_category_name;

-- ----------------------------------------------------------------------------
-- Questão 7: Número médio de parcelas (AVG(payment_installments)) por categoria de produto.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é o número médio de parcelas escolhidas pelos clientes por –categoria de produto, -- auxiliando a equipe financeira no planejamento de fluxo de caixa e –opções de parcelamento? 


SELECT
   olist_products_dataset.product_category_name,
   AVG(olist_order_payments_dataset.payment_installments)
FROM olist_products_dataset
INNER JOIN olist_order_items_dataset
   ON olist_products_dataset.product_id = olist_order_items_dataset.product_id
INNER JOIN olist_order_payments_dataset
   ON olist_order_items_dataset.order_id = olist_order_payments_dataset.order_id
GROUP BY olist_products_dataset.product_category_name;
