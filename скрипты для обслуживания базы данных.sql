-- Создание индексов для оптимизации
CREATE INDEX IX_Users_Email ON Users(email);
CREATE INDEX IX_Products_Category ON Products(category_id);
CREATE INDEX IX_Products_Manufacturer ON Products(manufacturer_id);
CREATE INDEX IX_Products_Price ON Products(price);
CREATE INDEX IX_Orders_User ON Orders(user_id);
CREATE INDEX IX_Orders_Status ON Orders(status);
CREATE INDEX IX_Orders_CreatedAt ON Orders(created_at);
CREATE INDEX IX_OrderItems_Order ON OrderItems(order_id);
CREATE INDEX IX_OrderItems_Product ON OrderItems(product_id);
CREATE INDEX IX_Cart_User ON Cart(user_id);
CREATE INDEX IX_Payments_Order ON Payments(order_id);
CREATE INDEX IX_Reviews_Product ON Reviews(product_id);
CREATE INDEX IX_Reviews_Rating ON Reviews(rating);
GO

-- Проверка целостности базы данных
DBCC CHECKDB ('InternetShopElectronics') WITH NO_INFOMSGS;
GO

-- Статистика по таблицам
SELECT 
    t.name AS TableName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 AS TotalSpaceKB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.name NOT LIKE 'dt%' AND i.object_id > 255 AND i.index_id <= 1
GROUP BY t.name, p.rows
ORDER BY RowCounts DESC;
GO