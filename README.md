### Data
This project uses the [Swiggy Restaurants Dataset](https://www.kaggle.com/datasets/ashishjangra27/swiggy-restaurants-dataset) from Kaggle (~148K rows). 
Download it and place it at `data/raw/swiggy.csv` before running `scripts/01_clean.R`.
(Files were too huge to include)

Data Cleaning & Preparation

The raw dataset (148,541 rows) required several corrections before analysis:

Ratings used "--" to denote restaurants not yet rated, rather than a blank value — converted to NA and confirmed this affects ~58% of rows, aligning almost exactly with restaurants marked "Too Few Ratings." This missingness is structural, not random, and is handled explicitly in the analysis rather than dropped.

Rating counts were provided as bucketed labels (e.g., "20+ ratings", "1K+ ratings") rather than exact numbers. A numeric estimate was derived from each bucket to support demand-based scoring later, while preserving the original label for reference.

Cost values were stored as text with a currency symbol, and contained a small number of implausible outliers (one listing exceeded ₹300,000 for a two-person meal). Values above the 99th percentile were treated as likely data-entry errors and set to NA, preserving the rest of each affected row.

City values inconsistently combined locality and city (e.g., "Vastrapur,Ahmedabad"), including some with multiple comma-separated segments. These were split into distinct city and locality fields for accurate city-level aggregation.

