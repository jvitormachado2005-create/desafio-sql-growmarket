-- ============================================================================
-- DESAFIO GROWMARKET - OLIST DATASET
-- Arquivo: bloco_G.sql
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Questão 1: Criar a view vw_pedidos_completos, consolidando pedido, cliente, itens, pagamento e vendedor, para servir de base a consultas analíticas futuras.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Como consolidar os dados essenciais de pedidos, clientes, itens, –vendedores e pagamentos em uma única estrutura unificada, -- simplificando consultas –analíticas recorrentes e servindo de base para dashboards de desempenho do marketplace? 


CREATE VIEW vw_pedidos_completos AS
SELECT
   olist_orders_dataset.order_id,
   olist_customers_dataset.customer_id,
   olist_order_items_dataset.order_item_id,
   olist_order_items_dataset.price,
   olist_sellers_dataset.seller_id,
   olist_order_payments_dataset.payment_value
FROM olist_orders_dataset
INNER JOIN olist_customers_dataset
   ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
INNER JOIN olist_order_items_dataset
   ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
INNER JOIN olist_sellers_dataset
   ON olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id
LEFT JOIN olist_order_payments_dataset
   ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id;


-- ----------------------------------------------------------------------------
-- Questão 2: Criar a view vw_avaliacoes_categoria, consolidando nota média e volume de avaliações por categoria de produto.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Como disponibilizar de forma centralizada o volume total e a nota –média de avaliações por categoria de produto, -- permitindo monitorar continuamente a –satisfação do cliente em cada segmento sem a necessidade de reprocessar joins –complexos? 




CREATE VIEW vw_avaliacoes_categoria AS
SELECT
   olist_products_dataset.product_category_name,
   COUNT(olist_order_reviews_dataset.review_id) AS total_avaliacoes,
   ROUND(AVG(olist_order_reviews_dataset.review_score::numeric), 2) AS nota_media
FROM olist_order_items_dataset
INNER JOIN olist_products_dataset
   ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
INNER JOIN olist_order_reviews_dataset
   ON olist_order_items_dataset.order_id = olist_order_reviews_dataset.order_id
WHERE olist_products_dataset.product_category_name IS NOT NULL
GROUP BY olist_products_dataset.product_category_name;
