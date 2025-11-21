
USE master;
GO

IF EXISTS(SELECT name FROM sys.databases WHERE name = 'InternetShopElectronics')
    DROP DATABASE InternetShopElectronics;
GO

CREATE DATABASE InternetShopElectronics 
COLLATE Cyrillic_General_CI_AS;
GO

USE InternetShopElectronics;
GO

CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    email NVARCHAR(255) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    role NVARCHAR(20) DEFAULT 'customer' CHECK (role IN ('customer', 'admin', 'manager')),
    created_at DATETIME2 DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);
GO

CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(500),
    parent_category_id INT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (parent_category_id) REFERENCES Categories(category_id)
);
GO

CREATE TABLE Manufacturers (
    manufacturer_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(500),
    website NVARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(1000),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    old_price DECIMAL(10,2) NULL,
    category_id INT NOT NULL,
    manufacturer_id INT NOT NULL,
    sku NVARCHAR(100) UNIQUE,
    specifications NVARCHAR(MAX),
    image_url NVARCHAR(500),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (manufacturer_id) REFERENCES Manufacturers(manufacturer_id)
);
GO

CREATE TABLE Warehouse (
    warehouse_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    reserved_quantity INT DEFAULT 0 CHECK (reserved_quantity >= 0),
    location NVARCHAR(100),
    last_restocked DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
GO

CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    order_number NVARCHAR(50) UNIQUE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status NVARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled')),
    shipping_address NVARCHAR(500) NOT NULL,
    billing_address NVARCHAR(500) NOT NULL,
    customer_notes NVARCHAR(500),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
GO

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
GO

CREATE TABLE Cart (
    cart_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    added_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
GO

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    payment_method NVARCHAR(50) NOT NULL CHECK (payment_method IN ('credit_card', 'debit_card', 'paypal', 'bank_transfer')),
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    status NVARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    transaction_id NVARCHAR(255) UNIQUE,
    payment_date DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
GO

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(1000),
    is_approved BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
GO