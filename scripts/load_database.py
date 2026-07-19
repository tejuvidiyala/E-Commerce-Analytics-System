import sqlite3
import pandas as pd
import os

# --------------------------------------------------
# Delete old database (optional but recommended)
# --------------------------------------------------

if os.path.exists("ecommerce.db"):
    os.remove("ecommerce.db")

# --------------------------------------------------
# Connect to SQLite
# --------------------------------------------------

conn = sqlite3.connect("ecommerce.db")

# Enable foreign keys
conn.execute("PRAGMA foreign_keys = ON;")

# Create tables
with open("sql/schema.sql", "r", encoding="utf-8") as f:
    conn.executescript(f.read())

# --------------------------------------------------
# Read cleaned CSVs
# --------------------------------------------------

customers = pd.read_csv("data/cleaned/customers_clean.csv")
products = pd.read_csv("data/cleaned/products_clean.csv")
orders = pd.read_csv("data/cleaned/orders_clean.csv")
order_items = pd.read_csv("data/cleaned/order_items_clean.csv")

# --------------------------------------------------
# Remove duplicate primary keys
# --------------------------------------------------

customers = customers.drop_duplicates(subset=["customer_id"])

products = products.drop_duplicates(subset=["product_id"])

orders = orders.drop_duplicates(subset=["order_id"])

order_items = order_items.drop_duplicates(subset=["item_id"])

# --------------------------------------------------
# Remove invalid foreign keys
# --------------------------------------------------

orders = orders[
    orders["customer_id"].isna() |
    orders["customer_id"].isin(customers["customer_id"])
]

order_items = order_items[
    order_items["order_id"].isin(orders["order_id"])
]

order_items = order_items[
    order_items["product_id"].isin(products["product_id"])
]

# --------------------------------------------------
# Load tables
# --------------------------------------------------

customers.to_sql(
    "customers",
    conn,
    if_exists="append",
    index=False
)

products.to_sql(
    "products",
    conn,
    if_exists="append",
    index=False
)

orders[
    [
        "order_id",
        "customer_id",
        "order_date",
        "status",
        "region_code"
    ]
].to_sql(
    "orders",
    conn,
    if_exists="append",
    index=False
)

order_items.to_sql(
    "order_items",
    conn,
    if_exists="append",
    index=False
)

conn.commit()

# --------------------------------------------------
# Verify row counts
# --------------------------------------------------

print("\nData Loaded Successfully!\n")

tables = [
    "customers",
    "products",
    "orders",
    "order_items"
]

for table in tables:
    count = conn.execute(
        f"SELECT COUNT(*) FROM {table}"
    ).fetchone()[0]

    print(f"{table:<15}: {count}")

conn.close()

print("\nSQLite connection closed.")