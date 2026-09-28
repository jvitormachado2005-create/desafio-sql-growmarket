-- ============================================================================
-- DESAFIO GROWMARKET - OLIST DATASET
-- Arquivo: bloco_H.sql
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Questão 1: Criar a procedure/function sp_relatorio_vendedor(id_vendedor, data_inicio, data_fim), que retorna faturamento, ticket médio e nota média de avaliação do vendedor no período informado — sem alterar nenhum dado.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Como consultar dinamicamente o faturamento total, ticket médio e –nota média de avaliação de um vendedor em um período específico, -- permitindo à equipe de –gestão acompanhar a performance individual dos parceiros sem modificar a base de dados? 




CREATE OR REPLACE FUNCTION sp_relatorio_vendedor(
   p_id_vendedor VARCHAR,
   p_data_inicio DATE,
   p_data_fim DATE
)
RETURNS TABLE (
   vendedor_id VARCHAR,
   faturamento NUMERIC,
   ticket_medio NUMERIC,
   nota_media NUMERIC
)
LANGUAGE sql
AS $$
   WITH vendas_periodo AS (
       SELECT
           olist_order_items_dataset.seller_id,
           olist_order_items_dataset.order_id,
           olist_order_items_dataset.price
       FROM olist_order_items_dataset
       INNER JOIN olist_orders_dataset
           ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
       WHERE olist_order_items_dataset.seller_id = p_id_vendedor
         AND NULLIF(olist_orders_dataset.order_purchase_timestamp, '') IS NOT NULL
         AND olist_orders_dataset.order_purchase_timestamp::timestamp::date BETWEEN p_data_inicio AND p_data_fim
   ),
   avaliacoes_periodo AS (
       SELECT
           AVG(olist_order_reviews_dataset.review_score::numeric) AS media_score
       FROM olist_order_reviews_dataset
       WHERE olist_order_reviews_dataset.order_id IN (SELECT vendas_periodo.order_id FROM vendas_periodo)
   )
   SELECT
       vendas_periodo.seller_id,
       ROUND(SUM(vendas_periodo.price)::numeric, 2) AS faturamento,
       ROUND(AVG(vendas_periodo.price)::numeric, 2) AS ticket_medio,
       ROUND((SELECT avaliacoes_periodo.media_score FROM avaliacoes_periodo)::numeric, 2) AS nota_media
   FROM vendas_periodo
   GROUP BY vendas_periodo.seller_id;
$$;



-- ----------------------------------------------------------------------------
-- Questão 2: Criar a procedure/function sp_relatorio_categoria(categoria, data_inicio, data_fim), que retorna faturamento total e ticket médio da categoria de produto no período informado.
-- ----------------------------------------------------------------------------
-- Pergunta de Negócio: Como calcular dinamicamente o faturamento total e o ticket médio de –uma categoria de produto em um período específico, -- permitindo aos gestores de produto –avaliar o desempenho de mercado e a receita gerada por segmento sem alterar os dados? 




CREATE OR REPLACE FUNCTION sp_relatorio_categoria(
   p_categoria VARCHAR,
   p_data_inicio DATE,
   p_data_fim DATE
)
RETURNS TABLE (
   categoria_nome VARCHAR,
   faturamento_total NUMERIC,
   ticket_medio NUMERIC
)
LANGUAGE sql
AS $$
   SELECT
       olist_products_dataset.product_category_name,
       ROUND(SUM(olist_order_items_dataset.price)::numeric, 2) AS faturamento_total,
       ROUND(AVG(olist_order_items_dataset.price)::numeric, 2) AS ticket_medio
   FROM olist_order_items_dataset
   INNER JOIN olist_products_dataset
       ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
   INNER JOIN olist_orders_dataset
       ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
   WHERE olist_products_dataset.product_category_name = p_categoria
     AND NULLIF(olist_orders_dataset.order_purchase_timestamp, '') IS NOT NULL
     AND olist_orders_dataset.order_purchase_timestamp::timestamp::date BETWEEN p_data_inicio AND p_data_fim
   GROUP BY olist_products_dataset.product_category_name;
$$;
