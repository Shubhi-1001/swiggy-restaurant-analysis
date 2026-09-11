### Data
This project uses the [Swiggy Restaurants Dataset](https://www.kaggle.com/datasets/ashishjangra27/swiggy-restaurants-dataset) from Kaggle (~148K rows). 
Download it and place it at `data/raw/swiggy.csv` before running `scripts/01_clean.R`.
(Files were too huge to include)

Data Cleaning & Preparation

1) The raw dataset (148,541 rows) required several corrections before analysis:

2) Ratings used "--" to denote restaurants not yet rated, rather than a blank value — converted to NA and confirmed this affects ~58% of rows, aligning almost exactly with restaurants marked "Too Few Ratings." This missingness is structural, not random, and is handled explicitly in the analysis rather than dropped.

3) Rating counts were provided as bucketed labels (e.g., "20+ ratings", "1K+ ratings") rather than exact numbers. A numeric estimate was derived from each bucket to support demand-based scoring later, while preserving the original label for reference.

4) Cost values were stored as text with a currency symbol, and contained a small number of implausible outliers (one listing exceeded ₹300,000 for a two-person meal). Values above the 99th percentile were treated as likely data-entry errors and set to NA, preserving the rest of each affected row.

5) City values inconsistently combined locality and city (e.g., "Vastrapur,Ahmedabad"), including some with multiple comma-separated segments. These were split into distinct city and locality fields for accurate city-level aggregation.

## Exploratory Data Analysis

**City Landscape**
Restaurant presence is heavily concentrated in major metros — Bangalore (14,943), Delhi (14,081), and Pune (12,441) lead by volume. Average ratings are remarkably consistent across all major cities (3.79–4.08), suggesting city alone does not meaningfully differentiate restaurant quality on the platform. Average cost varies more (₹247–₹358); notably, Bikaner shows the highest average cost (₹358) despite having far fewer restaurants (1,666) than the top metros. This is not a data artifact — Bikaner's maximum cost value is ₹1,000, well within normal range — and instead suggests a smaller, more premium-skewed restaurant base rather than a mass-market one. Mumbai is the only major metro with a notably elevated average cost (₹340) relative to its peers.

**Cuisine Landscape**
Chinese (36,464 listings) and North Indian (32,537) dominate nationally, followed by Indian, Snacks, and Biryani. Note: "Chinese" on Indian food delivery platforms typically refers to Indo-Chinese fusion cuisine (e.g., Gobi Manchurian, Hakka Noodles) rather than authentic Chinese cuisine — a distinction worth keeping in mind when interpreting cuisine-based recommendations.

**Rating Distribution**
Ratings are only available for 41% of restaurants; the remaining 59% are unrated ("Too Few Ratings"), a pattern established during cleaning as structural rather than random. Among rated restaurants, ratings cluster between 3.5–4.2, with very few restaurants below 2.5 or above 4.5.

**Cost Distribution**
Cost is right-skewed, with the bulk of restaurants priced between ₹100–₹350, and a long tail of higher-cost outliers beyond that.

**Cost vs. Rating**
A correlation of 0.136 between cost and rating indicates price is not a meaningful predictor of restaurant quality on this platform — higher-priced restaurants are not reliably better-rated than lower-priced ones.