# Boston Metro Apparel — Retail Profitability & Customer Satisfaction Analysis

**End-to-end retail analytics combining descriptive statistics, hypothesis testing, and regression modeling to uncover drivers of gross margin and customer behavior.**

This project analyzes transaction, customer, and store data for a Boston-area apparel retailer. It covers data profiling and cleaning, exploratory analysis, ANOVA-based hypothesis testing, and a multivariate regression model that explains 72.75% of gross margin variance — with actionable recommendations for pricing strategy, seasonal planning, and customer loyalty programs.

---

## Business Problem

The retailer faced inconsistent gross margin performance across seasons, product categories, and store locations. Without a clear understanding of what drives profitability, pricing and inventory decisions were largely reactive. This analysis identifies the key variables affecting gross margin and equips the management team with data-driven strategies to improve financial performance.

---

## Dataset

Three relational datasets joined for analysis:

| Dataset | Key Fields |
|---------|-----------|
| **Sales** | Transaction number, SKU, category, quantity, unit cost, sale amount, gross margin, price category, loyalty member |
| **Customers** | Customer ID, state, age, birthday month, years as member, in-store experience score, selection score |
| **Stores** | Store ID, city, state, store tier |

**Data Cleaning Highlights:**
- Standardized inconsistent state abbreviations (e.g., "Massachusetts", "Mass.", "Massachusets" → "MA")
- Replaced missing satisfaction scores with NA
- Removed invalid birthday month values (e.g., 0)
- Excluded rows with missing critical fields

---

## Analysis

### Descriptive Analytics

| Metric | Value |
|--------|-------|
| Mean Sale Amount | $60.60 |
| Median Sale Amount | $56.20 |
| Std Deviation | $36.26 |
| Skewness | 1.01 (right-skewed) |

**Outlier Detection:** 25 outliers identified in sale amount out of 10,172 records using both boxplot and Z-score methods.

**Gross Margin by Category:**

| Category | Blended Gross Margin % |
|----------|----------------------|
| Men's Apparel | 65.53% |
| Accessories | 62.41% |
| Footwear | 63.40% |
| Women's Apparel | 63.31% |
| Childrens | 63.09% |
| Gifts & Lifestyle | 57.73% |

---

### Hypothesis Testing (ANOVA)

**Question:** Does gross margin percentage (GM%) differ significantly across seasons?

- **H₀:** No significant difference in GM% across Winter, Spring, Summer, Fall
- **Hₐ:** Significant difference exists across seasons

**Result:** Null hypothesis rejected — seasonal variation in GM% is statistically significant.

---

### Regression Model

**Dependent Variable:** Gross Margin | **R² = 0.7275**

| Factor | Direction | Interpretation |
|--------|-----------|---------------|
| Sale Amount | ↑ Positive | Higher revenue improves margin |
| Ext. Cost | ↓ Negative | Higher external costs reduce margin |
| Full Price | ↑ Strong positive | Full-price sales drive highest margin |
| Markdown | ↑ Positive | Better margin than clearance |
| Women's Apparel | ↓ Negative | Lower margin vs. baseline |
| Footwear | ↓ Negative | Lower margin vs. baseline |
| Loyalty Member | Minimal | Limited direct margin impact |

---

## Recommendations

1. **Seasonal Strategy** — Adjust inventory and promotions around high-margin seasons
2. **Category Pricing** — Review cost structures for Women's Apparel and Footwear
3. **Dynamic Pricing** — Use markdowns strategically; default to full-price positioning
4. **Loyalty Optimization** — Redesign incentives to steer members toward high-margin categories

---

## Tools & Technologies

![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=flat&logo=microsoft-excel&logoColor=white)

**Methods:** Descriptive statistics, ANOVA hypothesis testing, multivariate linear regression, outlier detection (boxplot + Z-score)  
**Packages:** ggplot2, dplyr, stats  
**Domain:** Retail analytics, pricing strategy, customer behavior
