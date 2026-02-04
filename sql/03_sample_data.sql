-- Добавляем категории
INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books');

-- Добавляем продукты
INSERT INTO Products (category_id, product_name, price, stock_quantity) VALUES
(1, 'Smartphone', 500.00, 50),
(1, 'Laptop', 1200.00, 20),
(2, 'T-Shirt', 25.00, 100),
(3, 'Novel', 15.00, 200);

-- Добавляем клиентов
INSERT INTO Customers (first_name, last_name, email) VALUES
('Ivan','Ivanov','ivan@mail.com'),
('Anna','Petrova','anna@mail.com');

-- Добавляем корзину
INSERT INTO Carts (customer_id) VALUES
(1),(2);

-- Добавляем товары в корзину
INSERT INTO CartItems (cart_id, product_id, quantity) VALUES
(1,1,1),
(1,3,2),
(2,2,1);
GO
