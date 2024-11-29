Create Table Orders(
o_id SERIAL PRIMARY KEY,
order_date date not null
);

CREATE TABLE Products (
p_name VARCHAR(50) PRIMARY KEY,
price NUMERIC(10, 2) not null
);

CREATE TABLE Order_Items (
order_id INT NOT NULL,
product_name VARCHAR(50) NOT NULL,
amount INT NOT NULL DEFAULT 1 CHECK (amount > 0),
PRIMARY KEY (order_id, product_name),
FOREIGN KEY (order_id) REFERENCES Orders(o_id) ON DELETE CASCADE,
FOREIGN KEY (product_name) REFERENCES Products(p_name) ON DELETE CASCADE
);

INSERT INTO Orders (order_date)
VALUES
('2024-11-25'),
    ('2024-11-26');

INSERT INTO Products (p_name, price)
VALUES
('p1', 10.00),
    ('p2', 20.00);

INSERT INTO Order_Items (order_id, product_name)
VALUES
(1, 'p1'),
    (1, 'p2');

INSERT INTO Order_Items (order_id, product_name, amount)
VALUES
(2, 'p1', 3),
    (2, 'p2', 2);


ALTER TABLE Products DROP CONSTRAINT products_pkey CASCADE;

ALTER TABLE Products ADD COLUMN p_id SERIAL PRIMARY KEY;
ALTER TABLE Products ADD CONSTRAINT unique_p_name UNIQUE (p_name);

ALTER TABLE Order_Items ADD COLUMN price NUMERIC(10, 2);
ALTER TABLE Order_Items ADD COLUMN total NUMERIC(10, 2);

UPDATE Order_Items
SET price = (SELECT price FROM Products WHERE Products.p_name = Order_Items.product_name);

UPDATE Order_Items
SET total = amount * price;

ALTER TABLE Order_Items ALTER COLUMN price SET NOT NULL;
ALTER TABLE Order_Items ALTER COLUMN total SET NOT NULL;

ALTER TABLE Order_Items ADD CONSTRAINT total_check CHECK (total = amount * price);


UPDATE Products
SET p_name = 'product1'
WHERE p_name = 'p1';

DELETE FROM Order_Items
WHERE order_id = 1 AND product_name = 'p2';

DELETE FROM Orders
WHERE o_id = 2;

UPDATE Products
SET price = 5.00
WHERE p_name = 'product1';

UPDATE Order_Items
SET price = 5.00,
total = amount * price
WHERE product_name = 'product1';

INSERT INTO Orders (order_date) VALUES (CURRENT_DATE);

INSERT INTO Order_Items (order_id, product_name, amount, price, total)
VALUES
((SELECT MAX(o_id) FROM Orders), 'product1', 3, 5.00, 3 * 5.00);

SELECT * FROM Orders, Order_Items, Products