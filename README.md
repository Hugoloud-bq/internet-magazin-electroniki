# Интернет-магазин электроники

## Описание проекта
Проект интернет-магазина электроники с микросервисной архитектурой для практической работы.

## Архитектура системы

### 3.1. Общая архитектурная схема

```mermaid
graph TB
    subgraph "Клиентские приложения"
        WEB[Веб-браузер]
        MOB[Мобильное приложение]
        ADMIN[Админ-панель]
    end

    subgraph "Уровень шлюза"
        GW[API Gateway<br/>Spring Cloud Gateway]
    end

    subgraph "Бизнес-сервисы"
        AUTH[Сервис аутентификации]
        PROD[Сервис товаров]
        ORDER[Сервис заказов]
        PAY[Сервис платежей]
        CART[Сервис корзины]
        NOTIFY[Сервис уведомлений]
    end

    subgraph "База данных"
        DB[SQL Server<br/>InternetShopElectronics]
    end

    subgraph "Внешние сервисы"
        PAY_EXT[Платежные шлюзы]
        EMAIL[Email сервис]
        SMS[SMS сервис]
    end

    WEB --> GW
    MOB --> GW
    ADMIN --> GW

    GW --> AUTH
    GW --> PROD
    GW --> ORDER
    GW --> PAY
    GW --> CART

    AUTH --> DB
    PROD --> DB
    ORDER --> DB
    PAY --> DB
    CART --> DB

    PAY --> PAY_EXT
    ORDER --> NOTIFY
    NOTIFY --> EMAIL
    NOTIFY --> SMS
```

### 3.2. Схема базы данных (ER-диаграмма)

```mermaid
erDiagram
    Users ||--o{ Orders : "оформляет"
    Users ||--o{ Reviews : "оставляет"
    Users ||--o{ Cart : "добавляет_в"
    Users {
        int user_id PK
        string email UK
        string password_hash
        string first_name
        string last_name
        string role
        datetime created_at
    }

    Categories ||--o{ Products : "содержит"
    Categories {
        int category_id PK
        string name
        string description
        int parent_category_id FK
    }

    Manufacturers ||--o{ Products : "производит"
    Manufacturers {
        int manufacturer_id PK
        string name
        string website
    }

    Products ||--o{ OrderItems : "включается_в"
    Products ||--o{ Reviews : "имеет"
    Products ||--o{ Cart : "находится_в"
    Products ||--|| Warehouse : "хранится_на"
    Products {
        int product_id PK
        string name
        string description
        decimal price
        int category_id FK
        int manufacturer_id FK
        string sku UK
    }

    Orders ||--o{ OrderItems : "содержит"
    Orders ||--|| Payments : "имеет"
    Orders {
        int order_id PK
        int user_id FK
        string order_number UK
        string status
        decimal total_amount
        datetime created_at
    }

    OrderItems {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
        decimal total_price
    }

    Payments {
        int payment_id PK
        int order_id FK
        string payment_method
        decimal amount
        string status
        datetime payment_date
    }

    Cart {
        int cart_id PK
        int user_id FK
        int product_id FK
        int quantity
        datetime added_at
    }

    Warehouse {
        int warehouse_id PK
        int product_id FK
        int quantity
        int reserved_quantity
        string location
    }

    Reviews {
        int review_id PK
        int user_id FK
        int product_id FK
        int rating
        string comment
        datetime created_at
    }
```

### 4.1. Процесс оформления заказа

```mermaid
sequenceDiagram
    participant C as Клиент
    participant G as API Gateway
    participant Cart as Cart Service
    participant Prod as Product Service
    participant Order as Order Service
    participant Pay as Payment Service
    participant Notify as Notification Service
    participant Wh as Warehouse

    Note over C, Wh: Фаза 1: Добавление в корзину
    C->>G: POST /api/cart/add
    G->>Cart: Добавить товар в корзину
    Cart->>Prod: Проверить наличие товара
    Prod-->>Cart: Подтверждение наличия
    Cart-->>G: Товар добавлен
    G-->>C: Успешно

    Note over C, Wh: Фаза 2: Оформление заказа
    C->>G: POST /api/orders
    G->>Order: Создать заказ
    Order->>Cart: Получить корзину
    Cart-->>Order: Данные корзины
    Order->>Prod: Зарезервировать товары
    Prod->>Wh: Резервирование
    Wh-->>Prod: Товары зарезервированы
    Prod-->>Order: Резервирование подтверждено
    Order-->>G: Заказ создан (статус: pending)
    G-->>C: Заказ №123 создан

    Note over C, Wh: Фаза 3: Оплата
    C->>G: POST /api/payments/process
    G->>Pay: Обработать платеж
    Pay->>Pay: Интеграция с платежным шлюзом
    Pay-->>G: Платеж успешен
    G-->>C: Оплата подтверждена
    Pay->>Order: Обновить статус заказа
    Order->>Order: Статус изменен на "paid"

    Note over C, Wh: Фаза 4: Уведомления и склад
    Order->>Notify: Отправить уведомления
    Notify->>Notify: Email клиенту
    Notify->>Notify: SMS подтверждение
    Order->>Wh: Подтвердить резервирование
    Wh->>Wh: Уменьшить остатки
```

## Документация

- [Техническое задание](Техническое%20задание%20(ЧСИ).docx)
- [Архитектура ИС](Архитектура%20ИС%20(1).odt) 
- [База данных](База%20Данных.docx)
- [SQL скрипты](sql/)

## Технологии

- **Backend:** Java Spring Boot, Node.js
- **Frontend:** React
- **Базы данных:** SQL Server
- **Архитектура:** Микросервисы
- **Инфраструктура:** Docker, Kubernetes

## Разработчик
Чуляков Семён Игоревич  
Группа: 11/2-РПО-24/2
