# Retail Sales Data Analysis – Reckitt (Vanish & Lysol)

## Project Overview
This Data Science work is the final project of EBAC "Profesión Científico de Datos" program, which is part of a collaboration with **Retail / FMCG industry**, using real-world data related to the **Fabric Treatment and Laundry Sanitizer** category in Mexico. The analysis is framed around the brands **Vanish** and **Lysol**, both part of Reckitt.

The main goal of the project is to **prepare, clean, and explore sales data** in order to understand market behavior, brand performance, regional trends, and temporal patterns. This repository documents the **data preprocessing and exploratory data analysis (EDA)** stages of a larger end-to-end Data Science project.

At its current stage, the project focuses on:
- Data cleaning and transformation
- Data integration from multiple sources
- Exploratory data analysis
- Time series and categorical data visualization

Future stages (not yet implemented) include clustering, predictive modeling, SQL integration, and dashboarding.

---

## Business Context
Reckitt is a global leader in health, hygiene, and nutrition products. Within the Mexican market, the **Fabric Treatment and Laundry Sanitizer** category is strategically important but highly competitive.

This project aims to support business questions such as:
- Brand performance across segments and regions
- Identification of key competitors
- Sales trends over time
- Detection of opportunities for market growth

---

## Data Science Workflow
The project follows a structured Data Science workflow:

1. Data ingestion from multiple tables and file formats  
2. Data cleaning and validation  
3. Data transformation and feature preparation  
4. Exploratory data analysis (EDA)  
5. Data visualization focused on trends, distributions, and comparisons  

---

## Tools and Technologies
- **Python**
- **Pandas** (data manipulation and preprocessing)
- **NumPy** (numerical operations)
- **Matplotlib** (base plotting)
- **Seaborn** (statistical data visualization)
- **Jupyter Notebook**
- **CSV and Excel data handling**

---

## Data Cleaning and Transformation
Key preprocessing steps include:
- Handling missing values and undefined categories
- Removing duplicate records
- Standardizing categorical variables
- Converting weekly identifiers into datetime format
- Merging multiple dimension and fact tables into a single analytical dataset
- Exporting a consolidated dataset for downstream analysis

The final cleaned dataset is stored as a CSV file and used as input for the exploratory analysis phase.

---

## Exploratory Data Analysis (EDA)
The EDA focuses on understanding sales behavior across:
- Brands
- Product segments
- Geographic regions
- Time (weekly sales trends)

Visualizations include:
- Boxplots to analyze sales distributions
- Bar charts for regional comparisons
- Line plots for time series analysis
- Faceted plots to compare brands, segments, and regions simultaneously

These visualizations help identify trends, variability, and potential outliers in weekly sales performance.

---

## Documentation
The project is organized into the following folders:

### 1. Data Cleaning and Transformation
**Path:** `1-Limpieza-y-Transformación-de-Datos/`  
**Notebook:** `EBAC Proyecto Parte 1.ipynb`

This notebook contains:
- Data loading from CSV and Excel files
- Data quality checks
- Cleaning of missing and inconsistent values
- Deduplication of records
- Data merging and transformation
- Creation of a final consolidated dataset for analysis

---

### 2. Exploratory Data Analysis and Visualization
**Path:** `2-Visualización-y-Analisis-Exploratorio-de-Datos/`  
**Notebook:** `EBAC Proyecto Parte 2.ipynb`

This notebook includes:
- Exploratory analysis of the cleaned dataset
- Conversion of time variables to datetime format
- Analysis by brand, segment, and region
- Time series visualizations
- Multiple comparative and faceted plots using Seaborn and Matplotlib

---

## Key Data Science Skills Demonstrated
- Data cleaning and preprocessing
- Data integration from multiple sources
- Exploratory data analysis (EDA)
- Time series analysis
- Data visualization and storytelling
- Working with structured business data
- Translating business context into analytical insights

---

## Project Status
**In Progress**

Completed:
- Data cleaning and transformation
- Exploratory data analysis and visualization

Planned next steps:
- SQL database integration
- Clustering analysis
- Sales forecasting models
- Interactive dashboard development