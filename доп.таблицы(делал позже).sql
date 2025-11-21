-- Для Notification Service
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    type NVARCHAR(50) NOT NULL,
    title NVARCHAR(255) NOT NULL,
    message NVARCHAR(1000) NOT NULL,
    is_read BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Для Reporting Service (агрегированные данные)
CREATE TABLE SalesReports (
    report_id INT PRIMARY KEY IDENTITY(1,1),
    period_date DATE NOT NULL,
    total_orders INT NOT NULL,
    total_revenue DECIMAL(15,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE()
);