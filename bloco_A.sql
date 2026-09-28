-- ============================================================================
-- DESAFIO GROWMARKET - OLIST DATASET
-- Arquivo: bloco_A.sql
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Questão 1: Listar os 20 pedidos com status delivered mais recentes,
-- ordenados pela data de entrega.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais são os pedidos entregues mais recentemente aos clientes,
-- permitindo ao time de operações acompanhar as entregas concluídas mais atuais?
SELECT
   order_id,
   customer_id,
   order_status,
   order_delivered_customer_date
FROM olist_orders_dataset
WHERE order_status = 'delivered'
ORDER BY order_delivered_customer_date DESC NULLS LAST
LIMIT 20;



-- ----------------------------------------------------------------------------
-- Questão 2: Listar todos os produtos de uma categoria específica (usando a
-- tabela de tradução para filtrar pelo nome em português).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais produtos pertencem a uma categoria específica em português,
-- utilizando a tabela de tradução para mapear o segmento sem realizar JOINs?
SELECT
   product_id,
   product_category_name,
   product_weight_g
FROM olist_products_dataset
WHERE product_category_name IN (
   SELECT product_category_name
   FROM product_category_name_translation
   WHERE product_category_name = 'perfumaria'
);


-- ----------------------------------------------------------------------------
-- Questão 3: Listar os métodos de pagamento distintos utilizados na base.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais são as diferentes formas de pagamento oferecidas e
-- utilizadas pelos clientes na plataforma para o mapeamento de parcerias financeiras?
SELECT DISTINCT
   payment_type
FROM olist_order_payments_dataset;


-- ----------------------------------------------------------------------------
-- Questão 4: Listar os produtos com peso (product_weight_g) acima de 10kg,
-- ordenados do mais pesado para o mais leve.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais são os produtos mais pesados do catálogo (acima de 10kg),
-- informação essencial para planeamento logístico e estratégias de frete especial?
SELECT
   product_id,
   product_category_name,
   product_weight_g
FROM olist_products_dataset
WHERE product_weight_g > 10000
ORDER BY product_weight_g DESC;
