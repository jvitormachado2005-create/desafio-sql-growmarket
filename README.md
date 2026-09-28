Desafio GrowMarket - Olist Dataset (PostgreSQL)

Este repositorio contem as solucoes estruturadas para o desafio de analise de dados do dataset da Olist.

Estrutura dos Arquivos e Cobertura de Negocio

Bloco A - Consultas Basicas (Filtros e Ordenacao)
- Q1: 20 pedidos entregues mais recentes.
- Q2: Produtos da categoria 'perfumaria' (via subquery em traducao).
- Q3: Meios de pagamento distintos.
- Q4: Produtos com peso acima de 10kg.

Bloco B - Joins e Relacionamentos
- Q1: Categoria, preco e cidade do vendedor.
- Q2: Pedidos entregues com atraso (data estimada x data real).
- Q3: Formas de pagamento e parcelamento por pedido.
- Q4: Categorias e traducoes (incluindo sem traducao via LEFT JOIN).
- Q5: Pedidos onde cliente e vendedor sao do mesmo estado.

Bloco C - Agregacoes e Agrupamentos (GROUP BY)
- Q1: Faturamento total por estado do cliente.
- Q2: Top 10 vendedores em faturamento.
- Q3: Ticket medio por categoria.
- Q4: Vendedores com avaliacao media baixa (< 3).
- Q5: Total de pedidos por tipo de pagamento.
- Q6: Peso medio por categoria.
- Q7: Media de parcelas por categoria de produto.

Bloco D - Subqueries e Consultas Avancadas
- Q1: Clientes com gasto acima da media geral.
- Q2: Produtos sem nenhuma avaliacao registrada.
- Q3: Vendedores operando em mais de 5 categorias.
- Q4: Pedidos cujo frete superou o valor dos produtos.

Bloco E - Estruturas Condicionais (CASE WHEN)
- Q1: Status de entrega (adiantado, no prazo, atrasado).
- Q2: Segmentacao de clientes (bronze, prata, ouro).
- Q3: Classificacao de peso (leve, medio, pesado).
- Q4: Perfil de parcelamento (a vista, parcelado, parcelado longo).

Bloco F - Common Table Expressions (CTEs)
- Q1: Faturamento mensal por estado e variacao % mes a mes.
- Q2: Categorias com pior reputacao (nota media e volume >= 50).
- Q3: Comparativo do frete medio estadual contra a media nacional.

Bloco G - Views Relacionais
- Q1: vw_pedidos_completos - Consolidacao global de transacoes.
- Q2: vw_avaliacoes_categoria - Metrica consolidada de reputacao.

Bloco H - Stored Procedures / Functions Parametrizadas
- Q1: sp_relatorio_vendedor - Performance por vendedor e periodo.
- Q2: sp_relatorio_categoria - Faturamento e ticket medio por categoria/periodo.

Bloco I - Window Functions (Funcoes de Janela)
- Q1: Ranking (RANK()) de vendedores por faturamento em cada estado.
- Q2: Faturamento mensal acumulado por vendedor.
- Q3: Percentual de participacao do vendedor no estado (OVER (PARTITION BY ...)).
- Q4: Variacao mensal absoluta de vendas por vendedor (LAG()).

Como Executar
1. Certifique-se de possuir o banco PostgreSQL instalado com as tabelas do dataset Olist.
2. Execute os scripts .sql na ordem alfabetica (bloco_A.sql ate bloco_I.sql).
