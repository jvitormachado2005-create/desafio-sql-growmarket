-- ============================================================================
-- DESAFIO GROWMARKET - OLIST DATASET
-- Arquivo: bloco_I.sql
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Questão 1: Ranking (RANK()) dos vendedores por faturamento dentro de cada estado.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é a posição (ranking) de cada vendedor em termos de –faturamento dentro do seu respectivo estado, -- permitindo identificar os líderes de vendas –regionais e premiar os principais parceiros comerciais do marketplace? 


SELECT
   olist_sellers_dataset.seller_state,
   olist_sellers_dataset.seller_id,
   ROUND(SUM(olist_order_items_dataset.price)::numeric, 2) AS faturamento,
   RANK() OVER (
       PARTITION BY olist_sellers_dataset.seller_state
       ORDER BY SUM(olist_order_items_dataset.price) DESC
   ) AS ranking_faturamento
FROM olist_order_items_dataset
INNER JOIN olist_sellers_dataset
   ON olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id
GROUP BY
   olist_sellers_dataset.seller_state,
   olist_sellers_dataset.seller_id
ORDER BY
   olist_sellers_dataset.seller_state,
   ranking_faturamento;



-- ----------------------------------------------------------------------------
-- Questão 2: Faturamento mensal acumulado (SUM(...) OVER (ORDER BY ...)) por vendedor.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é a evolução do faturamento mensal acumulado de cada –vendedor ao longo do tempo, -- permitindo acompanhar a curva de crescimento e a retenção –financeira dos parceiros comerciais na plataforma? 




WITH faturamento_mensal_vendedor AS (
   SELECT
       olist_order_items_dataset.seller_id,
       TO_CHAR(olist_orders_dataset.order_purchase_timestamp::timestamp, 'YYYY-MM') AS ano_mes,
       SUM(olist_order_items_dataset.price) AS faturamento_mes
   FROM olist_order_items_dataset
   INNER JOIN olist_orders_dataset
       ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
   WHERE NULLIF(olist_orders_dataset.order_purchase_timestamp, '') IS NOT NULL
   GROUP BY
       olist_order_items_dataset.seller_id,
       TO_CHAR(olist_orders_dataset.order_purchase_timestamp::timestamp, 'YYYY-MM')
)
SELECT
   faturamento_mensal_vendedor.seller_id,
   faturamento_mensal_vendedor.ano_mes,
   ROUND(
       SUM(faturamento_mensal_vendedor.faturamento_mes) OVER (
           PARTITION BY faturamento_mensal_vendedor.seller_id
           ORDER BY faturamento_mensal_vendedor.ano_mes
       )::numeric,
       2
   ) AS faturamento_mensal_acumulado
FROM faturamento_mensal_vendedor
ORDER BY
   faturamento_mensal_vendedor.seller_id,
   faturamento_mensal_vendedor.ano_mes;


-- ----------------------------------------------------------------------------
-- Questão 3: Percentual de participação de cada vendedor no faturamento total do seu estado (SUM(...) OVER (PARTITION BY estado)).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é a porcentagem de contribuição de cada vendedor para o –faturamento total do seu estado, -- permitindo identificar o nível de concentração de vendas –por região e os parceiros estratégicos locais? 




WITH faturamento_vendedor AS (
   SELECT
       olist_sellers_dataset.seller_state,
       olist_sellers_dataset.seller_id,
       SUM(olist_order_items_dataset.price) AS faturamento_vendedor
   FROM olist_order_items_dataset
   INNER JOIN olist_sellers_dataset
       ON olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id
   GROUP BY
       olist_sellers_dataset.seller_state,
       olist_sellers_dataset.seller_id
)
SELECT
   faturamento_vendedor.seller_state,
   faturamento_vendedor.seller_id,
   ROUND(
       (faturamento_vendedor.faturamento_vendedor /
       SUM(faturamento_vendedor.faturamento_vendedor) OVER (
           PARTITION BY faturamento_vendedor.seller_state
       ) * 100)::numeric,
       2
   ) AS percentual_participacao_estado
FROM faturamento_vendedor
ORDER BY
   faturamento_vendedor.seller_state,
   percentual_participacao_estado DESC;



-- ----------------------------------------------------------------------------
-- Questão 4: Variação de faturamento de um mês para o outro por vendedor, usando LAG().
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é a variação absoluta do faturamento mensal de cada vendedor –em relação ao mês anterior, -- permitindo identificar picos ou quedas abruptas no –desempenho individual dos parceiros comerciais? 




WITH faturamento_mensal_vendedor AS (
   SELECT
       olist_order_items_dataset.seller_id,
       TO_CHAR(olist_orders_dataset.order_purchase_timestamp::timestamp, 'YYYY-MM') AS ano_mes,
       SUM(olist_order_items_dataset.price) AS faturamento_mes
   FROM olist_order_items_dataset
   INNER JOIN olist_orders_dataset
       ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
   WHERE NULLIF(olist_orders_dataset.order_purchase_timestamp, '') IS NOT NULL
   GROUP BY
       olist_order_items_dataset.seller_id,
       TO_CHAR(olist_orders_dataset.order_purchase_timestamp::timestamp, 'YYYY-MM')
)
SELECT
   faturamento_mensal_vendedor.seller_id,
   faturamento_mensal_vendedor.ano_mes,
   ROUND(
       (faturamento_mensal_vendedor.faturamento_mes -
       LAG(faturamento_mensal_vendedor.faturamento_mes) OVER (
           PARTITION BY faturamento_mensal_vendedor.seller_id
           ORDER BY faturamento_mensal_vendedor.ano_mes
       ))::numeric,
       2
   ) AS variacao_faturamento_mensal
FROM faturamento_mensal_vendedor
ORDER BY
   faturamento_mensal_vendedor.seller_id,
   faturamento_mensal_vendedor.ano_mes;
