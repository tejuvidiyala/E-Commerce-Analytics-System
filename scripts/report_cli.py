import argparse
import sqlite3
import sys
from datetime import datetime, timedelta

REPORTS = {
    'revenue': """
        SELECT p.category, ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)),2) AS revenue
        FROM orders o JOIN order_items oi ON o.order_id=oi.order_id
        JOIN products p ON oi.product_id=p.product_id
        WHERE o.order_date BETWEEN ? AND ?
        GROUP BY p.category ORDER BY revenue DESC
    """,
    'top_customers': """
        SELECT o.customer_id, c.customer_name,
               ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)),2) AS total_value
        FROM orders o JOIN order_items oi ON o.order_id=oi.order_id
        JOIN customers c ON o.customer_id=c.customer_id
        WHERE o.order_date BETWEEN ? AND ?
        GROUP BY o.customer_id ORDER BY total_value DESC LIMIT 10
    """,
    'retention': """
        SELECT strftime('%Y-%m', registration_date) AS cohort_month, COUNT(*) AS size
        FROM customers
        WHERE registration_date BETWEEN ? AND ?
        GROUP BY cohort_month ORDER BY cohort_month
    """,
}

def print_table(rows, headers):
    if not rows:
        print("No data found for the given filters.")
        return
    widths = [max(len(str(h)), *(len(str(r[i])) for r in rows)) for i, h in enumerate(headers)]
    print(" | ".join(h.ljust(w) for h, w in zip(headers, widths)))
    print("-+-".join("-"*w for w in widths))
    for r in rows:
        print(" | ".join(str(v).ljust(w) for v, w in zip(r, widths)))

def main():
    parser = argparse.ArgumentParser(description="E-commerce analytics CLI")
    parser.add_argument('--report', required=True, choices=list(REPORTS.keys()))
    parser.add_argument('--start', help='Start date YYYY-MM-DD', default=None)
    parser.add_argument('--end', help='End date YYYY-MM-DD', default=None)
    parser.add_argument('--db', default='ecommerce.db')
    args = parser.parse_args()

    end = args.end or datetime.now().strftime('%Y-%m-%d')
    start = args.start or (datetime.now() - timedelta(days=30)).strftime('%Y-%m-%d')

    try:
        conn = sqlite3.connect(args.db)
    except sqlite3.Error as e:
        print(f"Database connection error: {e}")
        sys.exit(1)

    cur = conn.cursor()
    try:
        cur.execute(REPORTS[args.report], (start, end))
        rows = cur.fetchall()
        headers = [d[0] for d in cur.description]
        print(f"\nReport: {args.report}  |  Period: {start} to {end}\n")
        print_table(rows, headers)
    except sqlite3.Error as e:
        print(f"Query failed: {e}")
    finally:
        conn.close()

if __name__ == '__main__':
    main()