-- Пример уникальности и проверки
ALTER TABLE Customers
ADD CONSTRAINT UQ_Customers_Email UNIQUE(email);

ALTER TABLE Products
ADD CONSTRAINT CHK_Products_Price CHECK (price >= 0);
