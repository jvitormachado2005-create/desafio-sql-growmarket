-- ============================================================================ -- DESAFIO GROWMARKET - OLIST DATASET -- Arquivo: bloco_D.sql -- ============================================================================

-- ----------------------------------------------------------------------------
-- Questão 1: Clientes cujo gasto total está acima da média geral de gasto por cliente.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais clientes possuem um gasto total superior à média geral de –gastos por cliente na plataforma, -- permitindo identificar o segmento de clientes de alto –valor (High-Value Customers) para estratégias de fidelização? 


SELECT
   olist_orders_dataset.customer_id,
   SUM(olist_order_items_dataset.price)
FROM olist_orders_dataset
INNER JOIN olist_order_items_dataset
   ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
GROUP BY olist_orders_dataset.customer_id
HAVING SUM(olist_order_items_dataset.price) > (
   SELECT
       AVG(gasto_por_cliente.total_gasto)
   FROM (
       SELECT
           SUM(olist_order_items_dataset.price) AS total_gasto
       FROM olist_orders_dataset
       INNER JOIN olist_order_items_dataset
           ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
       GROUP BY olist_orders_dataset.customer_id
   ) AS gasto_por_cliente
);


-- ----------------------------------------------------------------------------
-- Questão 2: Produtos que nunca receberam avaliação (NOT EXISTS / NOT IN).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais produtos cadastrados na plataforma nunca receberam –nenhuma avaliação dos compradores, -- permitindo identificar itens sem feedback do –consumidor para ações de incentivo a reviews ou revisão do catálogo? 


SELECT
   olist_products_dataset.product_id
FROM olist_products_dataset
WHERE olist_products_dataset.product_id NOT IN (
   SELECT
       olist_order_items_dataset.product_id
   FROM olist_order_items_dataset
   INNER JOIN olist_order_reviews_dataset
       ON olist_order_items_dataset.order_id = olist_order_reviews_dataset.order_id
);



-- ----------------------------------------------------------------------------
-- Questão 3: Vendedores que venderam produtos de mais de 5 categorias diferentes (subquery com COUNT(DISTINCT ...)).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais vendedores comercializam produtos em mais de 5 categorias –distintas, -- permitindo identificar os parceiros com alta diversificação de portfólio no –marketplace? 


SELECT
   vendedores_categorias.seller_id
FROM (
   SELECT
       olist_order_items_dataset.seller_id,
       COUNT(DISTINCT olist_products_dataset.product_category_name) AS qtd_categorias
   FROM olist_order_items_dataset
   INNER JOIN olist_products_dataset
       ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
   GROUP BY olist_order_items_dataset.seller_id
) AS vendedores_categorias
WHERE vendedores_categorias.qtd_categorias > 5;


-- ----------------------------------------------------------------------------
-- Questão 4: Pedidos cujo valor de frete (freight_value) é maior que o valor total dos itens do próprio pedido (subquery correlacionada comparando as duas somas).
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Quais pedidos possuem o valor total do frete superior ao valor total —dos produtos comprados, -- auxiliando o time de logística e precificação a identificar –discrepâncias na relação custo-frete? 


SELECT
   totais_por_pedido.order_id
FROM (
   SELECT
       olist_order_items_dataset.order_id,
       SUM(olist_order_items_dataset.freight_value) AS total_frete,
       SUM(olist_order_items_dataset.price) AS total_produtos
   FROM olist_order_items_dataset
   GROUP BY olist_order_items_dataset.order_id
) AS totais_por_pedido
WHERE totais_por_pedido.total_frete > totais_por_pedido.total_produtos;
