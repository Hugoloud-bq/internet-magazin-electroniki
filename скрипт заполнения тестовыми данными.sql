USE InternetShopElectronics;
GO

DELETE FROM Reviews;
DELETE FROM Cart;
DELETE FROM Payments;
DELETE FROM OrderItems;
DELETE FROM Orders;
DELETE FROM Warehouse;
DELETE FROM Products;
DELETE FROM Categories;
DELETE FROM Manufacturers;
DELETE FROM Users;
GO

DBCC CHECKIDENT ('Users', RESEED, 0);
DBCC CHECKIDENT ('Categories', RESEED, 0);
DBCC CHECKIDENT ('Manufacturers', RESEED, 0);
DBCC CHECKIDENT ('Products', RESEED, 0);
DBCC CHECKIDENT ('Warehouse', RESEED, 0);
DBCC CHECKIDENT ('Orders', RESEED, 0);
DBCC CHECKIDENT ('OrderItems', RESEED, 0);
DBCC CHECKIDENT ('Cart', RESEED, 0);
DBCC CHECKIDENT ('Payments', RESEED, 0);
DBCC CHECKIDENT ('Reviews', RESEED, 0);
GO

INSERT INTO Users (email, password_hash, first_name, last_name, phone, role) VALUES
(N'admin@shop.ru', N'hash123', N'Иван', N'Петров', N'+79161234567', N'admin'),
(N'customer@mail.ru', N'hash456', N'Мария', N'Сидорова', N'+79167654321', N'customer'),
(N'manager@shop.ru', N'hash789', N'Алексей', N'Иванов', N'+79165554433', N'manager');
GO

INSERT INTO Categories (name, description, parent_category_id) VALUES
(N'Смартфоны', N'Мобильные телефоны и смартфоны', NULL),
(N'Ноутбуки', N'Портативные компьютеры', NULL),
(N'Телевизоры', N'Телевизоры и мониторы', NULL),
(N'Android', N'Смартфоны на Android', 1),
(N'iOS', N'Смартфоны Apple', 1);
GO

INSERT INTO Manufacturers (name, description, website) VALUES
(N'Samsung', N'Южнокорейская компания', N'samsung.com'),
(N'Apple', N'Американская компания', N'apple.com'),
(N'Xiaomi', N'Китайская компания', N'mi.com'),
(N'LG', N'Южнокорейская компания', N'lg.com'),
(N'Sony', N'Японская компания', N'sony.com');
GO

INSERT INTO Products (name, description, price, category_id, manufacturer_id, sku) VALUES
(N'iPhone 15 Pro', N'Флагманский смартфон Apple с процессором A17 Pro', 99999.00, 5, 2, 'IP15PRO256'),
(N'Samsung Galaxy S24', N'Флагманский смартфон Samsung с камерой 200 МП', 89999.00, 4, 1, 'SGS24128'),
(N'MacBook Air M2', N'Ультрабук от Apple с чипом M2', 129999.00, 2, 2, 'MBAM213'),
(N'Xiaomi Redmi Note 13', N'Бюджетный смартфон с AMOLED дисплеем', 25999.00, 4, 3, 'XRN135'),
(N'LG OLED TV 55"', N'Телевизор с OLED матрицей 55 дюймов', 89999.00, 3, 4, 'LGOLED55'),
(N'Sony WH-1000XM5', N'Беспроводные наушники с шумоподавлением', 29999.00, NULL, 5, 'SONYWHXM5');
GO

INSERT INTO Warehouse (product_id, quantity, location) VALUES
(1, 50, N'Склад А'),
(2, 30, N'Склад А'),
(3, 20, N'Склад Б'),
(4, 100, N'Склад В'),
(5, 15, N'Склад Б'),
(6, 75, N'Склад Г');
GO

INSERT INTO Orders (user_id, order_number, total_amount, shipping_address, billing_address, status) VALUES
(2, 'ORD-001', 89999.00, N'Москва, ул. Ленина, д. 1, кв. 5', N'Москва, ул. Ленина, д. 1, кв. 5', 'delivered'),
(2, 'ORD-002', 25999.00, N'Москва, пр. Мира, д. 15, кв. 12', N'Москва, пр. Мира, д. 15, кв. 12', 'processing'),
(3, 'ORD-003', 29999.00, N'Санкт-Петербург, Невский пр., д. 25', N'Санкт-Петербург, Невский пр., д. 25', 'confirmed');
GO

INSERT INTO OrderItems (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 2, 1, 89999.00, 89999.00),
(2, 4, 1, 25999.00, 25999.00),
(3, 6, 1, 29999.00, 29999.00);
GO

INSERT INTO Cart (user_id, product_id, quantity) VALUES
(2, 1, 1),
(2, 3, 1),
(3, 5, 2);
GO

INSERT INTO Payments (order_id, payment_method, amount, status, transaction_id, payment_date) VALUES
(1, 'credit_card', 89999.00, 'completed', 'TXN-001-2024', GETDATE()),
(2, 'debit_card', 25999.00, 'completed', 'TXN-002-2024', GETDATE()),
(3, 'paypal', 29999.00, 'pending', 'TXN-003-2024', NULL);
GO

INSERT INTO Reviews (user_id, product_id, rating, comment, is_approved) VALUES
(2, 2, 5, N'Отличный телефон! Камера просто супер.', 1),
(2, 4, 4, N'Хороший телефон за свои деньги. Батарея держит долго.', 1),
(3, 6, 5, N'Наушники великолепные! Шумоподавление на высоте.', 1);
GO