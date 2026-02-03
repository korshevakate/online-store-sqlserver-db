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

-- CustomerAddresses
CREATE TABLE CustomerAddresses (
    address_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    city NVARCHAR(100),
    street NVARCHAR(200),
    postal_code NVARCHAR(20),

    CONSTRAINT FK_Address_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
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

-- ProductImages изображение товара
CREATE TABLE ProductImages (
    image_id INT IDENTITY PRIMARY KEY,
    product_id INT NOT NULL,
    image_url NVARCHAR(500),

    CONSTRAINT FK_Images_Product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);
GO

-- Carts корзина
CREATE TABLE Carts (
    cart_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    created_at DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Cart_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);
GO

-- CartItems товары в корзине
CREATE TABLE CartItems (
    cart_item_id INT IDENTITY PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT FK_CartItems_Cart
        FOREIGN KEY (cart_id)
        REFERENCES Carts(cart_id),

    CONSTRAINT FK_CartItems_Product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);
GO

-- Orders заказы
CREATE TABLE Orders (
    order_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME2 DEFAULT SYSDATETIME(),
    status NVARCHAR(50),

    CONSTRAINT FK_Orders_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);
GO

-- OrderItems товары в заказе
CREATE TABLE OrderItems (
    order_item_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_OrderItems_Order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT FK_OrderItems_Product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);
GO

-- Payments оплата
CREATE TABLE Payments (
    payment_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATETIME2 DEFAULT SYSDATETIME(),
    amount DECIMAL(10,2),
    payment_method NVARCHAR(50),

    CONSTRAINT FK_Payment_Order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);
GO


-- Shipments доставка
CREATE TABLE Shipments (
    shipment_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    shipped_date DATETIME2,
    delivery_status NVARCHAR(50),

    CONSTRAINT FK_Shipment_Order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);
GO