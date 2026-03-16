-- Monthly Sales
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS monthly_sales
FROM public.orders
GROUP BY month
ORDER BY month;


-- Product wise Profit
SELECT
    p.product_name,
    SUM(o.profit) AS total_profit
FROM public.orders o
JOIN public.products p
  ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC
LIMIT 10;

-- repeat customer

SELECT
    COUNT(*) FILTER (WHERE order_count = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_customers
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM public.orders
    GROUP BY customer_id
) t;


-- regional performance

SELECT
    g.region,
    SUM(o.sales) AS total_sales,
    SUM(o.profit) AS total_profit
FROM public.orders o
JOIN public.geography g
  ON o.geo_id = g.geo_id
GROUP BY g.region
ORDER BY total_profit DESC;

--sub-category wise

SELECT
    p.sub_category,
    ROUND(SUM(o.sales),2) AS sales,
    ROUND(SUM(o.profit),2) AS profit,
    ROUND(AVG(o.discount),2) AS avg_discount,
    ROUND(SUM(o.profit)/SUM(o.sales)*100,2) AS margin_pct
FROM public.orders o
JOIN public.products p
  ON o.product_id = p.product_id
GROUP BY p.sub_category
ORDER BY profit;

