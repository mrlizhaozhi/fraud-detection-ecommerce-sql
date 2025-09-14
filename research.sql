-- Author: Li Zhao-Zhi
-- Analyse the Fraud Detection in E-Commerce Dataset on Kaggle

-- Total number of transactions, total revenue, and average transaction amount.
SELECT
	COUNT(transaction_id) AS total_transactions,
	SUM(transaction_amount) AS total_revenue,
	AVG(transaction_amount) AS average_transaction
FROM transactions;

-- How many unique customers made transactions?
SELECT
	COUNT(DISTINCT customer_id) AS unique_customers
FROM transactions;

-- Percentage of fraudulent transactions.
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

-- Top 10 customers by total spend.
SELECT
	c.customer_id,
	SUM(t.transaction_amount) AS total_spend
FROM customers AS c
JOIN transactions AS t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id
ORDER BY total_spend DESC
LIMIT 10;

-- Customers who used more than one distinct device.
SELECT c.customer_id, COUNT(DISTINCT device_used) AS distinct_devices
FROM customers AS c
JOIN transactions AS t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT device_used) > 1;

-- Find IP addresses shared between multiple customers.
SELECT 
    ip_address,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM transactions
GROUP BY ip_address
HAVING COUNT(DISTINCT customer_id) > 1
ORDER BY unique_customers DESC;

-- Rolling average transaction amount over 3 days of each customer.
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

-- Fraudulent transactions above $1000, sorted by amount.
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

-- Customers whose fraud rate is higher than the overall average fraud rate.
SELECT customer_id
FROM (
    SELECT customer_id,
           AVG(is_fraudulent::int) AS customer_fraud_rate
    FROM transactions
    GROUP BY customer_id
) AS cust_fraud
WHERE customer_fraud_rate > (
    SELECT AVG(is_fraudulent::int) FROM transactions
);

-- Customer’s fraud rate above 5%.
WITH customer_fraud AS (
    SELECT customer_id,
           AVG(is_fraudulent::int) * 100 AS fraud_rate
    FROM transactions
    GROUP BY customer_id
)
SELECT *
FROM customer_fraud
WHERE fraud_rate > 5
ORDER BY fraud_rate DESC;
