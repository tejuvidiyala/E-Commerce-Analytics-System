import pandas as pd
import re

RAW = 'data/raw'
CLEAN = 'data/cleaned'

def clean_orders(df: pd.DataFrame) -> tuple[pd.DataFrame, dict]:
    """Fix mixed date formats, flag/handle NULL customer_ids."""
    df = df.copy()

    def parse_date(x):
        for fmt in ('%Y-%m-%d %H:%M:%S', '%d-%m-%Y %H:%M:%S', '%d-%m-%Y', '%Y-%m-%d'):
            try:
                return pd.to_datetime(x, format=fmt)
            except (ValueError, TypeError):
                continue
        return pd.NaT

    df['order_date'] = df['order_date'].apply(parse_date)
    n_missing_cust = int(df['customer_id'].isna().sum())          # 215 on real data
    df['customer_id'] = pd.array(df['customer_id'], dtype='Int64') # nullable int, keeps NaN as <NA>
    df['has_missing_customer'] = df['customer_id'].isna()
    n_bad_dates = int(df['order_date'].isna().sum())
    df = df.dropna(subset=['order_date'])                          # drop truly unparseable dates

    report = {
        'missing_customer_id': n_missing_cust,
        'unparseable_dates_dropped': n_bad_dates,
    }
    return df, report

def clean_order_items(df: pd.DataFrame, valid_order_ids: pd.Series) -> tuple[pd.DataFrame, dict]:
    """Drop orphan rows and zero-quantity rows; cap discounts at 100; keep negative qty (returns)."""
    df = df.copy()
    n_orphans = int((~df['order_id'].isin(valid_order_ids)).sum())  # 130 on real data
    df = df[df['order_id'].isin(valid_order_ids)]
    n_zero_qty = int((df['quantity'] == 0).sum())                  # 123 on real data
    df = df[df['quantity'] != 0]
    n_capped = int((df['discount_percent'] > 100).sum())           # 231 on real data
    df['discount_percent'] = df['discount_percent'].clip(lower=0, upper=100)
    report = {
        'orphan_items_dropped': n_orphans,
        'zero_quantity_dropped': n_zero_qty,
        'discount_over_100_capped': n_capped,
        'negative_quantity_kept_as_returns': int((df['quantity'] < 0).sum()),
    }
    return df, report

def clean_products(df: pd.DataFrame) -> tuple[pd.DataFrame, dict]:
    """Trim whitespace, collapse internal spaces, title-case product names."""
    df = df.copy()
    before = df['product_name'].copy()
    df['product_name'] = (
        df['product_name'].str.strip()
        .str.replace(r'\s+', ' ', regex=True)
        .str.title()
    )
    n_changed = int((before != df['product_name']).sum())
    n_dupes = int(df.duplicated(subset=['product_id']).sum())
    df = df.drop_duplicates(subset=['product_id'])
    return df, {'names_normalized': n_changed, 'duplicate_products_removed': n_dupes}

def clean_customers(df: pd.DataFrame) -> tuple[pd.DataFrame, dict]:
    df = df.copy()
    n_missing_name = int(df['customer_name'].isna().sum())         # 14 on real data
    df['customer_name'] = df['customer_name'].fillna('Unknown')
    df['registration_date'] = pd.to_datetime(
        df['registration_date'], format='%d-%m-%Y %H:%M', errors='coerce'
    )
    return df, {'missing_names_filled': n_missing_name}

def validate_emails(df: pd.DataFrame) -> tuple[list, int]:
    """Return customer_ids with malformed emails (missing @ or domain)."""
    pattern = re.compile(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
    invalid_mask = ~df['email'].astype(str).apply(lambda e: bool(pattern.match(e)))
    return df.loc[invalid_mask, 'customer_id'].tolist(), int(invalid_mask.sum())  # 11 on real data

def check_referential_integrity(orders_df: pd.DataFrame, items_df: pd.DataFrame) -> tuple[pd.DataFrame, int]:
    """Find order_items rows whose order_id has no matching order."""
    orphan_mask = ~items_df['order_id'].isin(orders_df['order_id'])
    return items_df.loc[orphan_mask], int(orphan_mask.sum())

def main():
    orders = pd.read_csv(f'{RAW}/orders.csv')
    items = pd.read_csv(f'{RAW}/order_items.csv')
    products = pd.read_csv(f'{RAW}/products.csv')
    customers = pd.read_csv(f'{RAW}/customers.csv')

    orphans_before, orphan_count = check_referential_integrity(orders, items)
    invalid_email_ids, invalid_email_count = validate_emails(customers)

    orders_clean, order_report = clean_orders(orders)
    items_clean, item_report = clean_order_items(items, orders_clean['order_id'])
    products_clean, product_report = clean_products(products)
    customers_clean, cust_report = clean_customers(customers)

    orders_clean.to_csv(f'{CLEAN}/orders_clean.csv', index=False)
    items_clean.to_csv(f'{CLEAN}/order_items_clean.csv', index=False)
    products_clean.to_csv(f'{CLEAN}/products_clean.csv', index=False)
    customers_clean.to_csv(f'{CLEAN}/customers_clean.csv', index=False)

    print("=== DATA QUALITY REPORT ===")
    print("Orders:", order_report)
    print("Order items:", item_report)
    print("Products:", product_report)
    print("Customers:", cust_report)
    print(f"Referential integrity check (pre-clean): {orphan_count} orphan order_items found")
    print(f"Invalid emails: {invalid_email_count} customer_ids -> {invalid_email_ids[:5]}...")

if __name__ == '__main__':
    main()