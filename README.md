# 🛒 Zepto SQL Data Analysis

A structured SQL project that performs data cleaning, exploration, and business analysis on a Zepto grocery dataset using PostgreSQL.

---

## 📁 Project Structure

```
zepto-sql-analysis/
│
├── README.md               # Project documentation
├── zepto_analysis.sql      # Main SQL script (DDL + DML + Analysis)
└── zepto_v2.csv            # Raw dataset (not included in repo)
```
   
---

## 🗄️ Dataset

The dataset contains product-level data from Zepto, an instant grocery delivery platform.

| Column | Type | Description |
|---|---|---|
| `sku_id` | SERIAL | Unique product identifier |
| `category` | VARCHAR | Product category |
| `name` | VARCHAR | Product name |
| `mrp` | NUMERIC | Maximum Retail Price (in ₹) |
| `discountPercent` | NUMERIC | Discount offered (%) |
| `availableQuantity` | INTEGER | Stock available |
| `discountSellingPrice` | NUMERIC | Final selling price (in ₹) |
| `weightInGrams` | INTEGER | Product weight |
| `outOfStock` | BOOLEAN | Stock availability status |
| `quantity` | INTEGER | Quantity unit |

---

## 🧹 Data Cleaning Steps

- Removed rows with **NULL values** across critical columns
- Deleted products where **MRP = 0** (invalid entries)
- Converted **MRP and selling price from paise to rupees** (divided by 100)
- Identified products with **multiple SKUs**

---

## 📊 Analysis Queries

### Business Questions Answered

| # | Question |
|---|---|
| Q1 | Top 10 best-value products based on discount percentage |
| Q2 | High MRP products that are currently out of stock |
| Q3 | Estimated revenue per category |
| Q4 | Products with MRP > ₹500 and discount < 10% |
| Q5 | Top 5 categories by average discount |
| Q6 | Price per gram for products above 100g (best value) |
| Q7 | Products grouped into Low / Medium / Bulk by weight |
| Q8 | Total inventory weight per category |

---

## 📈 Dashboard Queries

- Total revenue by category
- Total revenue by product
- Out of stock products list
- Top revenue-generating product per category (using Window Functions)
- Products with the highest discounts

---

## 🛠️ Tech Stack

- **Database:** PostgreSQL
- **Language:** SQL
- **Concepts Used:** DDL, DML, Aggregations, CASE statements, CTEs, Window Functions (`ROW_NUMBER`, `PARTITION BY`)

---

## 🚀 How to Run

1. Make sure PostgreSQL is installed and running
2. Create a database and connect to it
3. Update the file path in the `COPY` command to match your local CSV location:
   ```sql
   COPY zepto(...) FROM 'your/local/path/zepto_v2.csv' DELIMITER ',' CSV HEADER;
   ```
4. Run the full `zepto_analysis.sql` script in order

---

## 💡 Key Insights

- Price conversion was necessary as raw data stored prices in **paise** (1 ₹ = 100 paise)
- Several SKUs share the same product name — useful for inventory deduplication
- Window functions were used to rank top products within each category efficiently

---

## 👤 Author

**Vasu**  
SQL Data Analyst | Passionate about turning raw data into business insights  

---

