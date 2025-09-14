-- Author: Li Zhao-Zhi
-- Create the database based on schema

-- create Fraud_Detection_eCommerce database
DROP DATABASE IF EXISTS "Fraud_Detection_eCommerce";
CREATE DATABASE "Fraud_Detection_eCommerce"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United Kingdom.936'
    LC_CTYPE = 'English_United Kingdom.936'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE "Fraud_Detection_eCommerce"
    IS 'Fraud Detection in e-Commerce Dataset: https://www.kaggle.com/datasets/kevinvagan/fraud-detection-dataset';

-- create CUSTOMERS table
CREATE TABLE IF NOT EXISTS customers(
	customer_id TEXT PRIMARY KEY NOT NULL,
	age TEXT --CHECK (age >= 0),
	customer_location VARCHAR(100),
	account_age_days INT --CHECK (account_age_days >=0)
);

-- create TRANSACTIONS table
CREATE TABLE IF NOT EXISTS transactions(
    transaction_id TEXT PRIMARY KEY,
    customer_id TEXT REFERENCES customers(customer_id),
    transaction_amount NUMERIC(10,2),
    transaction_date TIMESTAMP,
    payment_method VARCHAR(50),
    product_category VARCHAR(50),
    quantity INT,
    device_used VARCHAR(50),
    ip_address VARCHAR(50),
    shipping_address TEXT,
    billing_address TEXT,
    is_fraudulent BOOLEAN,
    transaction_hour INT
);