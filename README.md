## 🚀 Project: Building a Data Warehouse

### 🎯 Objective
The objective of this project is to design and develop a modern **Data Warehouse using SQL Server** to consolidate sales data from multiple source systems. The solution aims to provide a centralized, clean, and structured dataset that enables:

- Efficient analytical reporting  
- Better data visibility  
- Faster decision-making  
- Improved business insights  

---

### 📥 Data Sources

Data for this project will be collected from two primary business systems:

#### 1. ERP (Enterprise Resource Planning)
- Contains structured operational data  
- Examples:
  - Orders and transactions  
  - Product details  
  - Inventory data  
  - Financial records  

#### 2. CRM (Customer Relationship Management)
- Contains customer-related data  
- Examples:
  - Customer profiles  
  - Sales interactions  
  - Leads and opportunities  

#### 📄 Data Format
- All source data will be provided in **CSV (Comma-Separated Values)** format  
- Files will be ingested into the system using ETL processes  

---

### ⚙️ Data Processing

Data processing will involve two major steps:

#### 🔹 1. Data Cleansing
The goal is to improve data quality and ensure consistency across datasets.

Key activities include:
- Identifying and fixing data quality issues  
- Removing duplicate records  
- Handling missing values (nulls)  
- Correcting invalid or inconsistent data  
- Standardizing formats (e.g., date formats, naming conventions)  

---

#### 🔹 2. Data Integration
The goal is to combine data from multiple sources into a unified structure.

Key activities include:
- Merging ERP and CRM datasets  
- Resolving schema differences between sources  
- Creating relationships between entities (e.g., customers, products, sales)  
- Designing a simple and user-friendly data model for analysis  
- Ensuring consistency and accuracy across integrated data  

---

### 📌 Scope

This project has a clearly defined scope to maintain focus and simplicity:

- ✔️ Only the **latest available dataset** will be used  
- ✔️ Focus on building a clean and usable analytical model  
- ❌ Historical data tracking (**historization**) is **not included**  
- ❌ No implementation of Slowly Changing Dimensions (SCD)  

---

### 📈 Expected Outcome

- Centralized and integrated data repository  
- Clean, consistent, and analysis-ready datasets  
- Simplified data model for reporting and dashboards  
- Improved support for business decision-making  
