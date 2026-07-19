#  E-Commerce Order Analytics System

##  Project Overview

The **E-Commerce Order Analytics System** is an end-to-end Data Engineering and SQL Analytics project developed using **Python, Pandas, SQLite, and SQL**.

The objective of this project is to simulate a real-world e-commerce analytics pipeline that transforms raw transactional data into meaningful business insights.

In many organizations, raw sales data often contains inconsistencies such as duplicate records, missing values, invalid dates, incorrect foreign keys, and formatting issues. Before meaningful analysis can be performed, the data must be cleaned, validated, and stored in a structured database.

This project demonstrates the complete ETL (Extract, Transform, Load) workflow by:

- Extracting raw CSV datasets
- Cleaning and validating the data using Pandas
- Loading cleaned data into a normalized SQLite database
- Performing advanced SQL analytics
- Building a command-line reporting tool
- Handling common edge cases found in production datasets

The project is designed to replicate a simplified real-world analytics pipeline used by Data Engineers and Data Analysts in e-commerce organizations.

---

#  Problem Statement

E-commerce companies generate millions of transactions every day.

However, raw transactional datasets usually contain several data quality issues:

- Duplicate customer records
- Missing customer IDs
- Invalid email addresses
- Incorrect date formats
- Future order dates
- Invalid discounts
- Orphan records
- Duplicate products
- Invalid foreign key relationships

Such issues lead to inaccurate reports and poor business decisions.

The goal of this project is to clean these datasets, enforce relational integrity, and generate reliable business reports using SQL.

---

#  Project Objectives

The primary objectives of this project are:

###  Generate realistic e-commerce datasets

Create datasets representing:

- Customers
- Products
- Orders
- Order Items

with intentionally introduced inconsistencies.

---

###  Perform Data Cleaning

Implement an automated cleaning pipeline that:

- Removes duplicate records
- Handles missing values
- Standardizes text fields
- Fixes inconsistent date formats
- Validates email addresses
- Validates primary and foreign keys
- Handles invalid discounts
- Produces cleaned datasets

---

###  Design a Relational Database

Design a normalized SQLite database using:

- Primary Keys
- Foreign Keys
- NOT NULL Constraints
- CHECK Constraints
- Indexes

---

### Perform Business Analytics

Generate meaningful reports including:

- Revenue Analysis
- Product Analysis
- Customer Analysis
- Sales Trends
- Return Analysis
- Cohort Analysis
- Customer Segmentation

using advanced SQL techniques.

---

###  Build a Command-Line Reporting Tool

Create a reusable reporting tool that allows users to generate reports directly from the terminal using command-line arguments.

---

#  Key Features

This project includes the following features:

###  Data Processing

- CSV file ingestion
- Data validation
- Missing value handling
- Duplicate removal
- Data normalization
- Data quality reporting

---

###  Database

- SQLite database
- Normalized schema
- Foreign key relationships
- Indexes for optimized queries

---

###  SQL Analytics

- Aggregations
- JOIN operations
- Window Functions
- Common Table Expressions (CTEs)
- Cohort Analysis
- Revenue Analytics
- Customer Segmentation

---

###  Reporting

- Command-line interface (CLI)
- Dynamic SQL execution
- Formatted tabular reports

---

###  Testing

The project also includes tests covering multiple edge cases to improve reliability.

---

#  Project Architecture

The project follows a standard ETL pipeline.

```
                RAW CSV FILES
                       │
                       ▼
             Data Cleaning (Pandas)
                       │
                       ▼
          Cleaned CSV Files Generated
                       │
                       ▼
           SQLite Database Loading
                       │
                       ▼
             SQL Analytics Engine
                       │
                       ▼
             Command Line Reports
```

---

#  Project Structure

```
ecommerce-analytics-system/
│
├── data/
│   │
│   ├── raw/
│   │   ├── customers.csv
│   │   ├── products.csv
│   │   ├── orders.csv
│   │   └── order_items.csv
│   │
│   └── cleaned/
│       ├── customers_clean.csv
│       ├── products_clean.csv
│       ├── orders_clean.csv
│       └── order_items_clean.csv
│
├── database/
│   └── ecommerce.db
│
├── scripts/
│   ├── clean_data.py
│   ├── load_database.py
│   └── report_cli.py
│
├── sql/
│   ├── schema.sql
│   ├── aggregations.sql
│   ├── window_functions.sql
│   └── cohort_analysis.sql
│
├── sample_outputs/
│
├── README.md
├── requirements.txt
```

---

# Folder Description

## data/

Stores all datasets used in the project.

### raw/

Contains the original datasets before cleaning.

These files may contain:

- Duplicate records
- Invalid emails
- Missing values
- Incorrect dates
- Invalid discounts
- Foreign key issues

These datasets remain unchanged throughout the project.

---

### cleaned/

Contains the cleaned versions of all datasets.

These files are generated automatically by **clean_data.py** after validation and cleaning.

These datasets are later loaded into SQLite.

---

## database/

Contains the SQLite database.

```
ecommerce.db
```

This database stores all cleaned data using normalized relational tables.

---

## scripts/

Contains all Python scripts used in the project.

- clean_data.py
- load_database.py
- report_cli.py

Each script performs a specific stage of the ETL pipeline.

---

## sql/

Contains all SQL scripts.

Each file focuses on a specific type of business analytics.

---

## output/

Stores generated reports and screenshots.

This folder can be used to save exported reports from the CLI tool.

# Dataset Description

This project uses four relational datasets that simulate a real-world e-commerce system. Each dataset represents a different business entity, and all datasets are linked using primary and foreign key relationships.

The datasets are stored in the following directory:

```
data/
└── raw/
    ├── customers.csv
    ├── products.csv
    ├── orders.csv
    └── order_items.csv
```

After cleaning, the processed datasets are stored in:

```
data/
└── cleaned/
    ├── customers_clean.csv
    ├── products_clean.csv
    ├── orders_clean.csv
    └── order_items_clean.csv
```

---

# Dataset Details

## 1. Customers Dataset

The customers dataset stores information about registered customers.

Columns:

| Column | Description |
|---------|-------------|
| customer_id | Unique identifier for each customer |
| customer_name | Name of the customer |
| email | Customer email address |
| registration_date | Date the customer registered |
| customer_type | REGULAR, PREMIUM or VIP |

Example:

| customer_id | customer_name | email | registration_date | customer_type |
|--------------|--------------|--------------------|--------------------|---------------|
| 101 | Rahul Sharma | rahul@gmail.com | 2024-01-15 | PREMIUM |

---

## 2. Products Dataset

The products dataset stores product information.

Columns:

| Column | Description |
|---------|-------------|
| product_id | Unique product identifier |
| product_name | Product name |
| category | Product category |
| subcategory | Product subcategory |
| cost_price | Product cost price |

Example:

| product_id | product_name | category | subcategory | cost_price |
|-------------|--------------|-----------|--------------|------------|
| 501 | Samsung Galaxy S24 | Electronics | Mobile | 52000 |

---

## 3. Orders Dataset

The orders dataset stores customer orders.

Columns:

| Column | Description |
|---------|-------------|
| order_id | Unique order identifier |
| customer_id | Customer who placed the order |
| order_date | Date of order |
| status | Order status |
| region_code | Customer region |

Example:

| order_id | customer_id | order_date | status | region_code |
|-----------|-------------|------------|---------|-------------|
| 7001 | 101 | 2024-08-20 | DELIVERED | SOUTH |

---

## 4. Order Items Dataset

Each order may contain multiple products.

This dataset stores product-level transactions.

Columns:

| Column | Description |
|---------|-------------|
| item_id | Unique item identifier |
| order_id | Related order |
| product_id | Purchased product |
| quantity | Number of units purchased |
| unit_price | Selling price |
| discount_percent | Discount applied |

Example:

| item_id | order_id | product_id | quantity | unit_price | discount_percent |
|----------|----------|------------|-----------|-------------|------------------|
| 1 | 7001 | 501 | 2 | 59999 | 10 |

---

# Data Quality Issues Introduced

To simulate real-world business data, several intentional inconsistencies were introduced into the raw datasets.

These inconsistencies allow the cleaning pipeline to demonstrate practical ETL operations.

The following issues were included:

### Customers

- Duplicate customer records
- Missing customer names
- Invalid email addresses

---

### Products

- Extra spaces in product names
- Mixed uppercase and lowercase names
- Duplicate product records

---

### Orders

- Missing customer IDs
- Mixed date formats
- Future order dates
- Duplicate orders

---

### Order Items

- Invalid order IDs
- Quantity equal to zero
- Negative quantity (returns)
- Discounts greater than 100%
- Duplicate rows

---

# Data Cleaning Process

The cleaning process is implemented in:

```
scripts/
└── clean_data.py
```

The objective of this script is to transform inconsistent raw datasets into clean datasets suitable for analysis.

The cleaning pipeline follows these stages.

```
Raw CSV Files

        │

        ▼

Load DataFrames using Pandas

        │

        ▼

Validate Data

        │

        ▼

Remove Duplicates

        │

        ▼

Handle Missing Values

        │

        ▼

Standardize Formats

        │

        ▼

Validate Relationships

        │

        ▼

Generate Data Quality Report

        │

        ▼

Export Clean CSV Files
```

---

# Cleaning Performed on Customers

The customer dataset undergoes the following cleaning operations.

### Duplicate Removal

Duplicate customer records are removed using the customer ID.

---

### Missing Customer Names

Missing customer names are replaced with:

```
Unknown
```

---

### Email Validation

Email addresses are validated using regular expressions.

Examples of invalid emails:

```
abcgmail.com

john@

example.com
```

These records are identified and reported.

---

### Registration Date Validation

Registration dates are converted into a standard datetime format.

Invalid dates are removed.

---

# Cleaning Performed on Products

Product names are standardized by:

- Removing leading spaces
- Removing trailing spaces
- Removing multiple spaces
- Converting names to Title Case

Example

Before

```
   SAMSUNG    GALAXY S24
```

After

```
Samsung Galaxy S24
```

Duplicate products are removed based on Product ID.

---

# Cleaning Performed on Orders

The following operations are performed.

### Date Parsing

Multiple date formats are converted into a common datetime format.

Supported formats include:

```
YYYY-MM-DD

DD-MM-YYYY

YYYY-MM-DD HH:MM:SS

DD-MM-YYYY HH:MM:SS
```

---

### Missing Customer IDs

Orders without customer IDs are preserved because guest checkouts may exist.

A flag is generated for reporting purposes.

---

### Future Dates

Future order dates are detected and flagged.

These dates are excluded from time-based analytics where appropriate.

---

# Cleaning Performed on Order Items

Several business rules are applied.

### Invalid Order IDs

Rows referencing orders that do not exist are removed.

---

### Quantity Equal to Zero

Items with zero quantity are removed because they do not contribute to sales.

---

### Negative Quantity

Negative quantities represent returned products.

These records are preserved for return analysis.

---

### Invalid Discounts

Discount values greater than 100% are capped at 100%.

Negative discounts are converted to zero.

---

# Referential Integrity Validation

Relationships between tables are verified.

The following checks are performed.

Orders

```
customer_id

↓

customers.customer_id
```

Order Items

```
order_id

↓

orders.order_id
```

Order Items

```
product_id

↓

products.product_id
```

Any orphan records are identified and removed before loading data into the database.

---

# Data Quality Report

After cleaning, a summary report is generated.

Example:

```
Orders

Missing Customer IDs : 215

Invalid Dates : 0

Products

Normalized Product Names : 161

Customers

Missing Names Filled : 14

Order Items

Orphan Records Removed : 130

Zero Quantity Removed : 121

Discounts Corrected : 227

Negative Returns Preserved : 381

Invalid Emails : 11
```

This report helps verify the quality of the cleaned datasets before database loading.

---

# Cleaned Data Output

After the cleaning process completes successfully, the following files are generated automatically.

```
data/
└── cleaned/

    customers_clean.csv

    products_clean.csv

    orders_clean.csv

    order_items_clean.csv
```

These datasets are then loaded into the SQLite database for further SQL analysis.

# Database Design and ETL Process

## Introduction

After the raw datasets are cleaned and validated, the next stage of the project is to load the processed data into a relational database.

A relational database provides several advantages over CSV files:

- Maintains data consistency
- Enforces relationships between tables
- Prevents duplicate records
- Enables efficient SQL queries
- Supports business analytics and reporting

For this project, **SQLite** is used because it is lightweight, portable, requires no server installation, and is widely used for learning SQL and prototyping data engineering projects.

The database file is stored in:

```
database/
└── ecommerce.db
```

---

# ETL Workflow

The project follows a standard ETL (Extract, Transform, Load) pipeline.

```
                 RAW DATASETS

customers.csv
products.csv
orders.csv
order_items.csv

          │

          ▼

Extract using Pandas

          │

          ▼

Data Cleaning & Validation

          │

          ▼

Generate Clean CSV Files

          │

          ▼

Create SQLite Database

          │

          ▼

Load Clean Data

          │

          ▼

Business Analytics using SQL

          │

          ▼

CLI Reports
```

This workflow separates data preparation from data analysis, making the project modular and easier to maintain.

---

# Database Schema

The database consists of four normalized tables.

```
Customers

        │

        │ customer_id

        ▼

Orders

        │

        │ order_id

        ▼

Order Items

        ▲

        │ product_id

Products
```

The relationships ensure referential integrity between the datasets.

---

# Table 1 : Customers

The Customers table stores customer profile information.

Primary Key

```
customer_id
```

Columns

| Column | Description |
|---------|-------------|
| customer_id | Unique customer identifier |
| customer_name | Customer name |
| email | Email address |
| registration_date | Registration date |
| customer_type | REGULAR / PREMIUM / VIP |

Business Rules

- Customer ID must be unique.
- Customer name cannot be NULL.
- Customer type must belong to predefined categories.

---

# Table 2 : Products

Stores product catalog information.

Primary Key

```
product_id
```

Columns

| Column | Description |
|---------|-------------|
| product_id | Unique product identifier |
| product_name | Product name |
| category | Product category |
| subcategory | Product subcategory |
| cost_price | Product cost price |

Business Rules

- Cost price cannot be negative.
- Product name cannot be NULL.
- Category cannot be NULL.

---

# Table 3 : Orders

Stores order-level information.

Primary Key

```
order_id
```

Foreign Key

```
customer_id

↓

customers.customer_id
```

Columns

| Column | Description |
|---------|-------------|
| order_id | Unique order ID |
| customer_id | Customer placing the order |
| order_date | Date of order |
| status | Order status |
| region_code | Customer region |

Business Rules

Valid order status values include:

```
PLACED

SHIPPED

DELIVERED

CANCELLED

RETURNED
```

Guest orders are supported by allowing NULL customer IDs.

---

# Table 4 : Order Items

Stores product-level order information.

Primary Key

```
item_id
```

Foreign Keys

```
order_id

↓

orders.order_id
```

```
product_id

↓

products.product_id
```

Columns

| Column | Description |
|---------|-------------|
| item_id | Unique item ID |
| order_id | Related order |
| product_id | Purchased product |
| quantity | Purchased quantity |
| unit_price | Selling price |
| discount_percent | Applied discount |

Business Rules

- Discount must be between 0 and 100.
- Unit price cannot be negative.
- Negative quantity represents returned products.

---

# Constraints Used

Several database constraints are used to improve data integrity.

## Primary Keys

Every table contains a unique primary key.

```
customers.customer_id

products.product_id

orders.order_id

order_items.item_id
```

These keys uniquely identify each record.

---

## Foreign Keys

Foreign keys establish relationships between tables.

```
orders.customer_id

↓

customers.customer_id
```

```
order_items.order_id

↓

orders.order_id
```

```
order_items.product_id

↓

products.product_id
```

These constraints prevent invalid references.

---

## NOT NULL Constraints

Critical columns cannot contain NULL values.

Examples include:

- product_name
- customer_name
- order_date
- quantity
- unit_price

---

## CHECK Constraints

CHECK constraints enforce business rules.

Examples

Customer Type

```
REGULAR

PREMIUM

VIP
```

Order Status

```
PLACED

SHIPPED

DELIVERED

RETURNED

CANCELLED
```

Discount

```
0 ≤ discount ≤ 100
```

Cost Price

```
cost_price >= 0
```

These constraints improve database reliability.

---

# Database Indexes

Indexes are created on frequently queried columns.

Examples include:

```
customer_id

order_date

product_id

category

status
```

Indexes improve query performance by reducing search time.

---

# Loading Data into SQLite

The cleaned datasets are loaded into SQLite using the script:

```
scripts/
└── load_database.py
```

The script performs the following operations.

### Step 1

Create a SQLite database.

```
database/ecommerce.db
```

---

### Step 2

Execute

```
sql/schema.sql
```

to create all database tables.

---

### Step 3

Read all cleaned CSV files using Pandas.

```
customers_clean.csv

products_clean.csv

orders_clean.csv

order_items_clean.csv
```

---

### Step 4

Remove duplicate primary keys before insertion.

Examples

Duplicate customer IDs

Duplicate product IDs

Duplicate order IDs

Duplicate item IDs

---

### Step 5

Validate foreign key relationships.

Examples

Orders with invalid customer IDs are removed.

Order items referencing invalid orders are removed.

Order items referencing invalid products are removed.

---

### Step 6

Insert data into SQLite.

The cleaned DataFrames are inserted using the Pandas `to_sql()` function.

---

### Step 7

Verify successful loading.

The script prints the number of records loaded into each table.

Example

```
Data Loaded Successfully!

customers      : 1000

products       : 500

orders         : 3964

order_items    : 11646

SQLite connection closed.
```

The row counts confirm that the ETL process completed successfully.

---

# Benefits of Using SQLite

SQLite was selected for the following reasons.

- Lightweight
- No server installation required
- Cross-platform
- Easy integration with Python
- Excellent for SQL learning
- Suitable for small and medium-sized analytics projects

---

# ETL Validation

Before beginning SQL analysis, the following validations were performed.

- Duplicate records removed
- Missing values handled
- Product names standardized
- Email addresses validated
- Date formats standardized
- Foreign key relationships validated
- Database constraints enforced
- Successful insertion verified through row counts

These validation steps ensure that all subsequent SQL analyses are performed on consistent and reliable data.

# SQL Analytics

## Introduction

Once the cleaned datasets are successfully loaded into the SQLite database, the next stage of the project focuses on generating business insights using SQL.

SQL is used to answer common business questions that help organizations understand customer behavior, product performance, revenue trends, and sales patterns.

All SQL queries are organized into separate files based on their purpose.

```
sql/

├── schema.sql

├── aggregations.sql

├── window_functions.sql

└── cohort_analysis.sql
```

Organizing SQL queries into separate files improves readability, maintainability, and makes the project easier to extend.

---

# Business Analytics Performed

The project focuses on four major analytical areas.

1. Revenue Analytics

2. Customer Analytics

3. Product Analytics

4. Retention Analytics

---

# Revenue Analytics

Revenue is one of the most important business metrics in an e-commerce platform.

The project calculates revenue using the following formula.

```
Revenue

=

Quantity × Unit Price × (1 − Discount / 100)
```

The SQL queries use this formula to calculate sales across different business dimensions.

---

# Revenue by Category

Purpose

This query calculates the total revenue generated by each product category.

Business Value

It helps answer questions such as:

- Which product category generates the highest revenue?
- Which categories require more marketing investment?
- Which categories should receive more inventory?

Example Output

| Category | Revenue |
|-----------|----------|
| Electronics | 4,530,245 |
| Fashion | 3,862,415 |
| Home & Kitchen | 2,917,810 |

Business Insight

Management can prioritize high-performing categories while improving low-performing ones.

---

# Revenue by Customer

Purpose

Calculate total spending by every customer.

Business Value

Helps identify:

- High-value customers
- Premium customers
- Customer Lifetime Value (CLV)

Example Output

| Customer ID | Customer Name | Revenue |
|--------------|---------------|-----------|
| 205 | Rahul Sharma | 145000 |
| 481 | Sneha Reddy | 134500 |

Business Insight

These customers can be targeted for loyalty programs and premium memberships.

---

# Revenue by Month

Purpose

Analyze monthly sales trends.

Business Value

Useful for identifying:

- Seasonal demand
- Sales growth
- Peak shopping periods

Example Output

| Month | Revenue |
|---------|----------|
| 2024-01 | 654000 |
| 2024-02 | 712000 |
| 2024-03 | 893000 |

Business Insight

This report helps businesses forecast future sales and plan inventory.

---

# Top Products by Revenue

Purpose

Identify products generating the highest revenue.

Business Value

Allows management to:

- Promote best-selling products
- Optimize inventory
- Plan marketing campaigns

Example Output

| Product | Revenue |
|-----------|-----------|
| iPhone 15 | 824000 |
| Samsung TV | 615000 |

---

# Top Products by Quantity Sold

Purpose

Identify products sold in the highest quantities.

Unlike revenue, this report measures popularity.

Business Value

Useful for inventory management.

---

# Average Order Value (AOV)

Purpose

Calculate the average value of customer orders.

Formula

```
Average Order Value

=

Total Revenue

÷

Number of Orders
```

Business Value

Higher AOV generally indicates better customer purchasing behavior.

---

# Return Analytics

Returns directly affect business profitability.

The project includes multiple return-related analyses.

Examples

- Return Rate
- Returned Products
- Products with More Returns than Purchases

Business Value

These reports help identify:

- Product quality issues
- Logistics problems
- Customer dissatisfaction

---

# Products Frequently Bought Together

Purpose

Identify products commonly purchased together.

Technique Used

Self Join

Business Value

Useful for:

- Product Bundling
- Recommendation Systems
- Cross Selling

Example

```
Laptop

+

Wireless Mouse
```

These products can be recommended together.

---

# Customer Analytics

Several customer-focused reports are generated.

These include:

- Top Customers
- Purchase Frequency
- Customer Revenue
- Repeat Customers
- Customer Lifetime Value

Business Value

Helps identify valuable customers and improve retention.

---

# Window Functions

Modern SQL provides analytical functions that perform calculations without collapsing rows.

This project implements multiple window functions.

---

# RANK()

Purpose

Ranks customers based on revenue.

Business Use

Identify the highest-value customers.

Example

| Customer | Revenue | Rank |
|-----------|-----------|------|
| A | 52000 | 1 |
| B | 51000 | 2 |
| C | 47000 | 3 |

---

# DENSE_RANK()

Purpose

Ranks products within each category.

Difference

Unlike RANK(), DENSE_RANK() does not skip rank numbers.

Business Use

Ranking products inside individual categories.

---

# ROW_NUMBER()

Purpose

Assign a unique sequential number to each row.

Business Use

Useful for removing duplicates and pagination.

---

# SUM() OVER()

Purpose

Calculate running totals.

Business Example

Daily cumulative revenue.

```
Day 1

Revenue

1000

Running Total

1000

--------

Day 2

Revenue

1200

Running Total

2200

--------

Day 3

Revenue

900

Running Total

3100
```

Business Value

Useful for dashboards.

---

# AVG() OVER()

Purpose

Calculate moving averages.

Business Value

Helps smooth daily sales fluctuations.

Useful for trend analysis.

---

# LAG()

Purpose

Compare current values with previous records.

Business Use

Calculate days between consecutive customer orders.

Identify inactive customers.

---

# LEAD()

Purpose

Compare current rows with future rows.

Business Use

Forecast customer purchasing intervals.

---

# NTILE()

Purpose

Divide customers into equal groups.

Example

```
Quartile 1

Highest Spending Customers

Quartile 2

High Spending

Quartile 3

Medium Spending

Quartile 4

Low Spending
```

Business Value

Customer segmentation.

---

# Common Table Expressions (CTEs)

The project makes extensive use of CTEs.

Advantages

- Improves readability
- Simplifies complex SQL
- Enables multi-step calculations
- Avoids repeated code

Example

```
Monthly Revenue

↓

Growth Calculation

↓

Final Report
```

---

# SQL Files

## schema.sql

Purpose

Creates all database tables.

Includes

- Primary Keys
- Foreign Keys
- CHECK Constraints
- NOT NULL Constraints
- Indexes

---

## aggregations.sql

Contains

- Revenue by Category
- Revenue by Customer
- Revenue by Month
- Top Products
- Average Order Value
- Return Analysis

---

## window_functions.sql

Contains

- RANK()
- DENSE_RANK()
- ROW_NUMBER()
- LAG()
- LEAD()
- SUM() OVER()
- AVG() OVER()
- NTILE()
- Running Totals
- Customer Ranking

---

## cohort_analysis.sql

Contains

- Customer Cohorts
- First Purchase Month
- Monthly Retention
- Churn Analysis
- Repeat Customer Analysis

---# Command Line Reporting Tool

## Overview

The project includes a Command Line Interface (CLI) that allows users to generate business reports directly from the terminal.

Instead of manually writing SQL queries every time, users can execute predefined reports using simple command-line arguments.

The CLI connects to the SQLite database, executes the required SQL query, and displays the results in a formatted table.

The CLI script is located at:

```
scripts/
└── report_cli.py
```

---

# Available Reports

The following reports are currently supported.

| Report | Description |
|---------|-------------|
| revenue | Revenue by product category |
| top_customers | Top customers based on revenue |
| retention | Customer retention summary |

Additional reports can easily be added by extending the REPORTS dictionary inside `report_cli.py`.

---

# Running Reports

Generate Revenue Report

```bash
python scripts/report_cli.py --report revenue
```

Generate Top Customers Report

```bash
python scripts/report_cli.py --report top_customers
```

Generate Customer Retention Report

```bash
python scripts/report_cli.py --report retention
```

---

# Report Output

The CLI displays reports in a formatted table.

Example

```
+---------------+------------+
| Category      | Revenue    |
+---------------+------------+
| Electronics   | 4530245.20 |
| Fashion       | 3862415.80 |
| Grocery       | 2519620.45 |
+---------------+------------+
```

This provides a quick overview of business performance without opening the database manually.

---

# Testing

The project includes a testing module to validate important edge cases.

Testing file

```
scripts/
└── tests.py
```

The tests help ensure that the ETL pipeline behaves correctly under different scenarios.

---

# Edge Cases Covered

The following edge cases are tested.

### Empty Tables

Ensures SQL queries handle empty datasets without errors.

---

### Invalid Foreign Keys

Verifies that orphan records are detected and removed before loading into the database.

---

### Duplicate IDs

Ensures duplicate primary keys are removed before insertion.

---

### Future Dates

Checks that future order dates are identified and handled appropriately.

---

### Zero Quantity

Ensures transactions with zero quantity do not affect revenue calculations.

---

### Discount Greater Than 100%

Validates that discounts above 100% are capped before revenue calculations.

---

### Single Customer

Verifies that reports still execute correctly even when only one customer exists.

---

### No Orders

Ensures analytics queries return meaningful results even when there are no transactions.

---

# How to Execute the Project

## Step 1

Clone the repository.

```bash
git clone <repository_url>
```

---

## Step 2

Navigate to the project directory.

```bash
cd ecommerce-analytics-system
```

---

## Step 3

Install project dependencies.

```bash
pip install -r requirements.txt
```

---

## Step 4

Clean the raw datasets.

```bash
python scripts/clean_data.py
```

This script:

- Cleans raw datasets
- Removes duplicates
- Validates emails
- Fixes dates
- Handles missing values
- Generates cleaned CSV files

---

## Step 5

Load cleaned data into SQLite.

```bash
python scripts/load_database.py
```

Successful execution displays:

```
Data Loaded Successfully!

customers      : 1000

products       : 500

orders         : 3964

order_items    : 11646

SQLite connection closed.
```

---

## Step 6

Run SQL analytics.

Open any SQL file.

Examples

```
sql/aggregations.sql

sql/window_functions.sql

sql/cohort_analysis.sql
```

Execute the queries using DB Browser for SQLite or any SQLite client.

---

## Step 7

Generate reports using the CLI.

Example

```bash
python scripts/report_cli.py --report revenue
```

---

# Project Outcomes

This project successfully demonstrates an end-to-end data analytics workflow.

The following objectives were achieved.

- Generated and organized realistic e-commerce datasets
- Cleaned inconsistent data using Pandas
- Validated referential integrity
- Loaded data into a normalized SQLite database
- Performed business analytics using SQL
- Implemented advanced SQL techniques
- Built a reusable command-line reporting system
- Validated the system using unit tests

---

# Skills Demonstrated

This project demonstrates knowledge of the following technical skills.

Programming

- Python

Data Processing

- Pandas
- CSV Handling

Database

- SQLite
- Database Design
- Relational Modeling

SQL

- JOINs
- Aggregations
- GROUP BY
- HAVING
- CASE
- Common Table Expressions (CTEs)
- Window Functions
- Ranking Functions
- Cohort Analysis

Software Engineering

- Modular Project Structure
- Error Handling
- Data Validation
- Testing
- Documentation

---

# Future Enhancements

The project can be extended in several ways.

- Develop an interactive dashboard using Power BI or Tableau
- Build a Streamlit web application
- Replace SQLite with PostgreSQL or MySQL
- Automate ETL workflows using Apache Airflow
- Deploy the project on a cloud platform
- Integrate REST APIs for real-time order ingestion
- Implement machine learning models for sales forecasting
- Build customer recommendation systems
- Add automated email reporting
- Export reports to PDF and Excel

---

# Conclusion

The E-Commerce Order Analytics System demonstrates the complete lifecycle of an analytics project, starting from raw transactional data and ending with business-ready insights.

The project combines Python, Pandas, SQLite, and SQL to implement a complete ETL pipeline, database design, advanced analytics, and reporting solution.

By incorporating data cleaning, relational modeling, SQL analytics, testing, and documentation, this project reflects the practical workflow followed by data analysts and data engineers in real-world organizations.

The modular architecture also makes the system scalable and easy to extend with additional datasets, analytics, and reporting capabilities.

---
