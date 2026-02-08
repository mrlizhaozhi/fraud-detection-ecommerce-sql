--- Project: Design a store database ---
--- Author: Li Zhaozhi ---

---create database table---
CREATE TABLE IF NOT EXISTS beverages (id INTEGER PRIMARY KEY, name TEXT, price NUMERIC, shelf INTEGER, quantity INTEGER); 
/*a table with five attributes*/

---insert values---
INSERT INTO beverages (id, name, price, shelf, quantity) VALUES 
(1, "apple", 3, 1, 20), 
(2, "orange", 3, 2, 20),
(3, "tomato", 2, 3, 15),
(4, "banana", 3, 4, 20),
(5, "grape", 3, 5, 20),
(6, "cherry", 3, 6, 10),
(7, "carrot", 2, 6, 17),
(8, "pineapple", 5, 7, 20),
(9, "lemonade", 2, 8, 20),
(10, "strawberry", 5, 9, 10),
(11, "watermelon", 3, 10, 20),
(12, "coconut", 3, 11, 20),
(13, "mango", 4, 12, 22),
(14, "milk", 3, 13, 25),
(15, "coke", 3.5, 14, 20);
/*selling fifteen items*/

--- order by price ---
SELECT name, quantity, price FROM beverages WHERE price > 3 ORDER BY price;
/*display names, quantities, and prices of items with price above 3*/

--- show one statistic: min quant ---
SELECT name, quantity, price, MIN(quantity) FROM beverages WHERE price > 3 ORDER BY price;

/*write-up: 
This database is designed for a store that only sells beverages including fifteen (15) items -- apple, orange, tomato, banana, grape, cherry, carrot, pineapple, lemonade, strawberry, watermelon, coconut, mango, milk, and coke. 
Among these items, coke, mango, pineapple, and strawberry are sold at prices higher than 3 where coke is sold at the lowest (3) among these items. 
In these four items, strawberry has the least quantity available.
*/