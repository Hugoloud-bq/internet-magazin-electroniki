
-- 1. Количество товаров по категориям
SELECT 
    c.name AS category_name,
    COUNT(p.product_id) AS product_count
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.name
ORDER BY product_count DESC;
GO

-- 2. Товары с полной информацией
SELECT 
    p.product_id AS 'ID товара',
    p.name AS 'Название товара',
    p.price AS 'Цена',
    c.name AS 'Категория',
    m.name AS 'Производитель',
    w.quantity AS 'Количество на складе',
    p.sku AS 'Артикул'
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
JOIN Manufacturers m ON p.manufacturer_id = m.manufacturer_id
JOIN Warehouse w ON p.product_id = w.product_id
ORDER BY p.price DESC;
GO

-- 3. Структура таблицы товаров
SELECT 
    COLUMN_NAME AS 'Имя столбца',
    DATA_TYPE AS 'Тип данных',
    IS_NULLABLE AS 'Может быть NULL',
    COLUMN_DEFAULT AS 'Значение по умолчанию'
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;
GO

-- 4. Данные пользователей
SELECT 
    user_id AS 'ID пользователя',
    first_name AS 'Имя',
    last_name AS 'Фамилия', 
    email AS 'Email',
    phone AS 'Телефон',
    role AS 'Роль',
    created_at AS 'Дата регистрации'
FROM Users
ORDER BY role, user_id;
GO

-- 5. Заказы с информацией о клиентах
SELECT 
    o.order_number AS 'Номер заказа',
    u.first_name + ' ' + u.last_name AS 'Клиент',
    o.total_amount AS 'Сумма заказа',
    o.status AS 'Статус',
    o.created_at AS 'Дата заказа',
    COUNT(oi.order_item_id) AS 'Количество товаров'
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
LEFT JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY o.order_number, u.first_name, u.last_name, o.total_amount, o.status, o.created_at
ORDER BY o.created_at DESC;
GO

-- 6. Топ товаров по отзывам
SELECT 
    p.name AS 'Товар',
    m.name AS 'Производитель',
    AVG(r.rating) AS 'Средний рейтинг',
    COUNT(r.review_id) AS 'Количество отзывов'
FROM Products p
JOIN Manufacturers m ON p.manufacturer_id = m.manufacturer_id
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.name, m.name
HAVING COUNT(r.review_id) > 0
ORDER BY AVG(r.rating) DESC, COUNT(r.review_id) DESC;
GO