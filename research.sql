
-- Find the total number of transactions, total revenue, and average transaction amount.
SELECT
	COUNT(transaction_id) AS total_transactions,
	SUM(transaction_amount) AS total_revenue,
	AVG(transaction_amount) AS average_transaction
FROM transactions;

-- How many unique customers made transactions?
SELECT
	COUNT(DISTINCT customer_id) AS unique_customers
FROM transactions;

-- Calculate the percentage of fraudulent transactions.
SELECT
    ROUND(SUM(CASE WHEN is_fraudulent = true THEN 1 ELSE 0 END)::decimal / COUNT(*) * 100, 2) AS fraud_percentage
FROM transactions;

-- Which payment method has the highest fraud rate?
SELECT 
	payment_method, 
	ROUND(SUM(CASE WHEN is_fraudulent = true THEN 1 ELSE 0 END)::decimal / COUNT(*) * 100, 2) AS fraud_rate
FROM transactions
GROUP BY payment_method
ORDER BY fraud_rate DESC
LIMIT 1;

-- List the top 10 customers by total spend.
SELECT
	c.customer_id,
	SUM(t.transaction_amount) AS total_spend
FROM customers AS c
JOIN transactions AS t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id
ORDER BY total_spend DESC
LIMIT 10;

-- Find customers who used more than one distinct device.
SELECT c.customer_id, COUNT(DISTINCT device_used) AS distinct_devices
FROM customers AS c
JOIN transactions AS t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT device_used) > 1;

-- Find IP addresses that are linked to multiple customers.

SELECT 
    ip_address,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM transactions
GROUP BY ip_address
HAVING COUNT(DISTINCT customer_id) > 1
ORDER BY unique_customers DESC;

-- For each customer, calculate the rolling average transaction amount over 3 days.
SELECT 
    customer_id,
    AVG(transaction_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY transaction_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_last3
FROM transactions;

-- Are newer accounts more likely to be fraudulent?
SELECT 
    c.account_age_days,
    ROUND(100.0 * SUM(CASE WHEN is_fraudulent THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_rate
FROM customers AS c
JOIN transactions AS t
ON c.customer_id = t.customer_id
GROUP BY c.account_age_days
ORDER BY c.account_age_days;

-- Find fraudulent transactions above $1000, sorted by amount.
SELECT 
    transaction_id,
    customer_id,
    transaction_amount,
    transaction_date,
    payment_method
FROM transactions
WHERE is_fraudulent = TRUE
  AND transaction_amount > 1000
ORDER BY transaction_amount DESC;

