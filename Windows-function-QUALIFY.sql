the QUALIFY clause is used to filter results based on the outcome of window functions (also known as analytic functions) in a query. 
It’s similar to WHERE or HAVING, but it applies specifically to the results of window functions. 
This allows you to keep or exclude rows based on conditions applied to the output of a window function.

SELECT
    region,
    salesperson,
    sales_amount,
    RANK() OVER (PARTITION BY region ORDER BY sales_amount DESC) AS sales_rank
FROM
    sales
QUALIFY sales_rank <= 3;




SELECT
    customer_id,
    transaction_date,
    amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date DESC) AS row_num
FROM
    transactions
QUALIFY row_num = 1;


SELECT
    customer_id,
    order_id,
    order_value,
    SUM(order_value) OVER (PARTITION BY customer_id ORDER BY order_id) AS cumulative_order_value
FROM
    orders
QUALIFY cumulative_order_value > 5000;
