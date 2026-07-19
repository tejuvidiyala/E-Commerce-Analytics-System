PRAGMA foreign_keys = ON;

CREATE TABLE customers (
    customer_id        INTEGER PRIMARY KEY,
    customer_name       TEXT NOT NULL,
    email               TEXT NOT NULL,
    registration_date   TEXT,
    customer_type       TEXT CHECK (customer_type IN ('REGULAR','PREMIUM','VIP'))
);

CREATE TABLE products (
    product_id      INTEGER PRIMARY KEY,
    product_name    TEXT NOT NULL,
    category        TEXT NOT NULL,
    subcategory     TEXT,
    cost_price      REAL CHECK (cost_price >= 0)
);

CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY,
    customer_id     INTEGER,                 -- nullable: guest/unknown customer
    order_date      TEXT NOT NULL,
    status          TEXT CHECK (status IN ('PLACED','SHIPPED','DELIVERED','CANCELLED','RETURNED')),
    region_code     TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id             INTEGER PRIMARY KEY,
    order_id            INTEGER NOT NULL,
    product_id          INTEGER NOT NULL,
    quantity            INTEGER NOT NULL,      -- can be negative (return)
    unit_price          REAL NOT NULL CHECK (unit_price >= 0),
    discount_percent    REAL CHECK (discount_percent BETWEEN 0 AND 100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_items_order ON order_items(order_id);
CREATE INDEX idx_items_product ON order_items(product_id);