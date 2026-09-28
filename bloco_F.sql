-- ============================================================================
-- DESAFIO GROWMARKET - OLIST DATASET
-- Arquivo: bloco_F.sql
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Questão 1: Construir uma CTE de faturamento mensal por estado e, a partir dela, calcular a variação percentual de um mês para o outro.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é a variação percentual do faturamento mensal por estado em –relação ao mês anterior, -- permitindo identificar tendências regionais de crescimento ou –retratação nas vendas do marketplace? 


WITH faturamento_mensal_estado AS (
   SELECT
       olist_customers_dataset.customer_state,
       DATE_TRUNC('month', olist_orders_dataset.order_purchase_timestamp::timestamp) AS mes,
       SUM(olist_order_items_dataset.price) AS faturamento
   FROM olist_orders_dataset
   INNER JOIN olist_customers_dataset
       ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
   INNER JOIN olist_order_items_dataset
       ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
   WHERE NULLIF(olist_orders_dataset.order_purchase_timestamp, '') IS NOT NULL
   GROUP BY
       olist_customers_dataset.customer_state,
       DATE_TRUNC('month', olist_orders_dataset.order_purchase_timestamp::timestamp)
)
SELECT
   faturamento_mensal_estado.customer_state,
   faturamento_mensal_estado.mes,
   faturamento_mensal_estado.faturamento,
   LAG(faturamento_mensal_estado.faturamento) OVER (
       PARTITION BY faturamento_mensal_estado.customer_state
       ORDER BY faturamento_mensal_estado.mes
   ) AS faturamento_mes_anterior,
   ROUND(
       (
           ((faturamento_mensal_estado.faturamento - LAG(faturamento_mensal_estado.faturamento) OVER (
               PARTITION BY faturamento_mensal_estado.customer_state
               ORDER BY faturamento_mensal_estado.mes
           )) / NULLIF(LAG(faturamento_mensal_estado.faturamento) OVER (
               PARTITION BY faturamento_mensal_estado.customer_state
               ORDER BY faturamento_mensal_estado.mes
           ), 0)) * 100
       )::numeric, 2
   ) AS variacao_percentual
FROM faturamento_mensal_estado
ORDER BY
   faturamento_mensal_estado.customer_state,
   faturamento_mensal_estado.mes;


-- ----------------------------------------------------------------------------
-- Questão 2: Construir uma CTE com volume de avaliações e nota média por categoria de produto, usada para identificar as categorias com pior reputação (nota média mais baixa e volume relevante de avaliações).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais categorias de produto possuem a menor nota média de –avaliação com um volume mínimo de 50 reviews, -- permitindo identificar os segmentos com –gargalos críticos de qualidade ou insatisfação dos consumidores? 


WITH avaliacoes_por_categoria AS (
   SELECT
       olist_products_dataset.product_category_name,
       COUNT(olist_order_reviews_dataset.review_id) AS total_avaliacoes,
       AVG(olist_order_reviews_dataset.review_score::numeric) AS nota_media
   FROM olist_order_items_dataset
   INNER JOIN olist_products_dataset
       ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
   INNER JOIN olist_order_reviews_dataset
       ON olist_order_items_dataset.order_id = olist_order_reviews_dataset.order_id
   WHERE olist_products_dataset.product_category_name IS NOT NULL
   GROUP BY olist_products_dataset.product_category_name
)
SELECT
   avaliacoes_por_categoria.product_category_name,
   avaliacoes_por_categoria.total_avaliacoes,
   ROUND(avaliacoes_por_categoria.nota_media, 2) AS nota_media
FROM avaliacoes_por_categoria
WHERE avaliacoes_por_categoria.total_avaliacoes >= 50
ORDER BY avaliacoes_por_categoria.nota_media ASC;



-- ----------------------------------------------------------------------------
-- Questão 3: Construir uma CTE de frete médio por estado do cliente, usada para comparar cada estado com a média geral de frete.
-- ----------------------------------------------------------------------------




-- Pergunta de Negócio: Qual é o valor médio do frete cobrado por estado do cliente e qual a –sua diferença em relação à média nacional, -- permitindo identificar os estados com maiores –custos logísticos e subsidiar estratégias de frete regionalizadas? 
WITH frete_medio_por_estado AS (
   SELECT
       olist_customers_dataset.customer_state,
       AVG(olist_order_items_dataset.freight_value) AS frete_medio_estado
   FROM olist_orders_dataset
   INNER JOIN olist_customers_dataset
       ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
   INNER JOIN olist_order_items_dataset
       ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
   GROUP BY olist_customers_dataset.customer_state
)
SELECT
   frete_medio_por_estado.customer_state,
   ROUND(frete_medio_por_estado.frete_medio_estado::numeric, 2) AS frete_medio_estado,
   ROUND((SELECT AVG(olist_order_items_dataset.freight_value) FROM olist_order_items_dataset)::numeric, 2) AS frete_medio_geral,
   ROUND((frete_medio_por_estado.frete_medio_estado - (SELECT AVG(olist_order_items_dataset.freight_value) FROM olist_order_items_dataset))::numeric, 2) AS diferenca_para_media_geral
FROM frete_medio_por_estado
ORDER BY frete_medio_por_estado.frete_medio_estado DESC;
