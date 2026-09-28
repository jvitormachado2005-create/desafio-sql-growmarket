-- ============================================================================
-- DESAFIO GROWMARKET - OLIST DATASET
-- Arquivo: bloco_B.sql
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Questão 1: Relatório com a categoria do produto (traduzida),
-- o valor do item e a cidade do vendedor.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Qual é o valor praticado para cada item vendido, associando
-- a sua categoria em português e a cidade de origem do vendedor para análise logístico-comercial?
SELECT
   olist_products_dataset.product_category_name,
   olist_order_items_dataset.price,
   olist_sellers_dataset.seller_city
FROM olist_order_items_dataset
INNER JOIN olist_products_dataset
   ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
INNER JOIN olist_sellers_dataset
   ON olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id;



-- ----------------------------------------------------------------------------
-- Questão 2: Identificar pedidos com atraso na entrega, comparando data estimada
-- com data real de entrega (join entre orders e customers).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais pedidos foram entregues após a data estimada de entrega?
SELECT
   olist_orders_dataset.order_id,
   olist_orders_dataset.order_estimated_delivery_date,
   olist_orders_dataset.order_delivered_customer_date
FROM olist_orders_dataset
INNER JOIN olist_customers_dataset
   ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
WHERE olist_orders_dataset.order_status = 'delivered'
 AND olist_orders_dataset.order_delivered_customer_date > olist_orders_dataset.order_estimated_delivery_date;


-- ----------------------------------------------------------------------------
-- Questão 3: Listar pedidos e suas formas de pagamento, incluindo pedidos pagos
-- em mais de uma parcela (join entre orders e order_payments).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais são as formas de pagamento e número de parcelas
-- associadas a cada pedido realizado na plataforma?
SELECT
   olist_orders_dataset.order_id,
   olist_order_payments_dataset.payment_type,
   olist_order_payments_dataset.payment_installments
FROM olist_orders_dataset
INNER JOIN olist_order_payments_dataset
   ON olist_orders_dataset.order_id = olist_order_payments_dataset.order_id;

-- ----------------------------------------------------------------------------
-- Questão 4: Listar produtos junto com a categoria traduzida, incluindo produtos
-- cuja categoria não possui tradução cadastrada (LEFT JOIN com product_category_name_translation).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais são os produtos e as suas respetivas categorias traduzidas,
-- garantindo a exibição mesmo daqueles cuja categoria não possui tradução registada?
SELECT
   olist_products_dataset.product_id,
   olist_products_dataset.product_category_name,
   product_category_name_translation.product_category_name_english
FROM olist_products_dataset
LEFT JOIN product_category_name_translation
   ON olist_products_dataset.product_category_name = product_category_name_translation.product_category_name;

-- ----------------------------------------------------------------------------
-- Questão 5: Identificar pedidos em que o cliente e o vendedor são do mesmo estado
-- (join entre customers, orders, order_items e sellers).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais pedidos possuem o cliente e o vendedor localizados no mesmo estado?
SELECT
   olist_orders_dataset.order_id,
   olist_customers_dataset.customer_state,
   olist_sellers_dataset.seller_state
FROM olist_orders_dataset
INNER JOIN olist_customers_dataset
   ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
INNER JOIN olist_order_items_dataset
   ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
INNER JOIN olist_sellers_dataset
   ON olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id
WHERE olist_customers_dataset.customer_state = olist_sellers_dataset.seller_state;
