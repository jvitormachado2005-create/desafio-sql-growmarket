-- ============================================================================
-- DESAFIO GROWMARKET - OLIST DATASET
-- Arquivo: bloco_E.sql
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Questão 1: Classificar pedidos por prazo de entrega: "adiantado", "no prazo" ou "atrasado" (comparando data real x estimada).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Como os pedidos entregues são classificados em relação ao prazo –estimado de entrega (adiantado, no prazo ou atrasado), -- permitindo à equipe de operações –monitorar a eficiência logística e o nível de serviço percebido pelo cliente? 


SELECT
   olist_orders_dataset.order_id,
   olist_orders_dataset.order_delivered_customer_date,
   olist_orders_dataset.order_estimated_delivery_date,
   CASE
       WHEN NULLIF(olist_orders_dataset.order_delivered_customer_date, '') IS NULL THEN 'sem informação de entrega'
       WHEN DATE(NULLIF(olist_orders_dataset.order_delivered_customer_date, '')::timestamp) < DATE(NULLIF(olist_orders_dataset.order_estimated_delivery_date, '')::timestamp) THEN 'adiantado'
       WHEN DATE(NULLIF(olist_orders_dataset.order_delivered_customer_date, '')::timestamp) = DATE(NULLIF(olist_orders_dataset.order_estimated_delivery_date, '')::timestamp) THEN 'no prazo'
       WHEN DATE(NULLIF(olist_orders_dataset.order_delivered_customer_date, '')::timestamp) > DATE(NULLIF(olist_orders_dataset.order_estimated_delivery_date, '')::timestamp) THEN 'atrasado'
       ELSE 'sem informação de entrega'
   END AS status_entrega
FROM olist_orders_dataset;


-- ----------------------------------------------------------------------------
-- Questão 2: Classificar clientes por faixa de gasto total: "bronze", "prata", "ouro".
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Como os clientes são segmentados em categorias de valor (bronze, –prata e ouro) com base no total gasto, -- permitindo ao time de marketing direcionar –campanhas e benefícios personalizados para cada faixa? 


SELECT
   olist_orders_dataset.customer_id,
   SUM(olist_order_items_dataset.price) AS total_gasto,
   CASE
       WHEN SUM(olist_order_items_dataset.price) < 100 THEN 'bronze'
       WHEN SUM(olist_order_items_dataset.price) BETWEEN 100 AND 500 THEN 'prata'
       WHEN SUM(olist_order_items_dataset.price) > 500 THEN 'ouro'
       ELSE 'sem gasto'
   END AS faixa_cliente
FROM olist_orders_dataset
INNER JOIN olist_order_items_dataset
   ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
GROUP BY olist_orders_dataset.customer_id;


-- ----------------------------------------------------------------------------
-- Questão 3: Classificar produtos por faixa de peso: "leve", "médio", "pesado" (com base em product_weight_g).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Como os produtos catalogados se distribuem em faixas de peso (leve, –médio e pesado), -- auxiliando o setor de logística no planejamento de armazenamento e na –definição de estratégias de envio? SELECT 


SELECT
   olist_products_dataset.product_id,
   olist_products_dataset.product_weight_g,
   CASE
       WHEN olist_products_dataset.product_weight_g IS NULL THEN 'sem informação'
       WHEN olist_products_dataset.product_weight_g < 1000 THEN 'leve'
       WHEN olist_products_dataset.product_weight_g BETWEEN 1000 AND 5000 THEN 'médio'
       WHEN olist_products_dataset.product_weight_g > 5000 THEN 'pesado'
   END AS faixa_peso
FROM olist_products_dataset;


-- ----------------------------------------------------------------------------
-- Questão 4: Classificar pagamentos como "à vista" ou "parcelado", e dentro de parcelado sinalizar parcelamentos longos (payment_installments > 6).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Como as transações se dividem entre pagamentos à vista, –parcelamentos padrão e parcelamentos longos, -- auxiliando o time financeiro a mensurar a –dependência do crédito e o impacto na liquidez? 


SELECT
   olist_order_payments_dataset.order_id,
   olist_order_payments_dataset.payment_installments,
   CASE
       WHEN olist_order_payments_dataset.payment_installments = 1 THEN 'à vista'
       WHEN olist_order_payments_dataset.payment_installments BETWEEN 2 AND 6 THEN 'parcelado '
       WHEN olist_order_payments_dataset.payment_installments > 6 THEN 'parcelado longo (> 6x)'
       ELSE 'sem informação'
   END AS classificacao_pagamento
FROM olist_order_payments_dataset;
