USE online_store;
GO

-- Customers
CREATE TABLE Customers (
    customer_id INT IDENTITY PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    created_at DATETIME2 DEFAULT SYSDATETIME()
);
GO

-- Categories
CREATE TABLE Categories (
    category_id INT IDENTITY PRIMARY KEY,
    category_name NVARCHAR(150) NOT NULL,
    parent_category_id INT NULL
);
GO

-- Products
CREATE TABLE Products (
    product_id INT IDENTITY PRIMARY KEY,
    category_id INT NOT NULL,
    product_name NVARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    is_active BIT DEFAULT 1,

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
);
GO
