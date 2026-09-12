### Data
This project uses the [Swiggy Restaurants Dataset](https://www.kaggle.com/datasets/ashishjangra27/swiggy-restaurants-dataset) from Kaggle (~148K rows). 
Download it and place it at `data/raw/swiggy.csv` before running `scripts/01_clean.R`.
(Files were too huge to include)

## Data Cleaning & Preparation

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



## Key Findings

1. **Price does not predict quality on this platform.** The correlation between cost and rating is just 0.136 — restaurants are not reliably better-rated because they charge more, undermining any expansion strategy based on a "premium = better" assumption.

2. **Ratings are remarkably consistent across major cities (3.79–4.08), while cost varies more** (₹247–₹358 average) — meaning city-level differences are driven more by pricing dynamics than by service quality.

3. **The two strongest expansion opportunities identified (n≥20 restaurants, ranked by opportunity score) span both established and emerging markets:**
   - **Metro markets:** Vizag stands out with two independent opportunities — Tandoor (score 55.5) and American cuisine (score 50.5) — suggesting broad, cuisine-agnostic room to grow rather than a one-off gap. Mumbai and Hyderabad both show strong, under-served demand for "Home Food"-style cuisine.
   - **Emerging markets:** Thiruvananthapuram shows the single strongest signal in the dataset (Arabian cuisine, score 54.4), and appears three times in the top 10 across different cuisines (Arabian, Indian, North Indian) — indicating the city as a whole may be under-penetrated relative to demand, not just one cuisine gap.

4. **Cuisine dominance is heavily skewed nationally** — Chinese (36,464 listings) and North Indian (32,537) account for a disproportionate share of all restaurants, while genuine local/regional cuisines (Kerala, Andhra, Arabian) show up as high-opportunity in specific cities precisely because they're under-represented relative to demand.

## Recommendations

1. **Prioritize Vizag for near-term metro expansion** — it shows strong, consistent opportunity signals across two distinct cuisines, suggesting the city broadly, not just one niche, is under-served.
2. **Treat Thiruvananthapuram as a strategic emerging-market bet** — its appearance across three separate cuisine categories in the top 10 suggests city-wide headroom rather than a narrow opportunity.
3. **Do not use price positioning as a differentiation strategy** — with a cost-rating correlation of just 0.136, competing on being "premium" is unlikely to translate into better ratings or customer perception on this platform.
4. **Treat single-cuisine, single-city findings (e.g., Indore/Mughlai, Surat/Mughlai) as secondary opportunities** worth monitoring, but not the primary basis for a first-wave expansion decision, since they represent isolated signals rather than city-wide patterns.

## Methodology Note

An initial version of this analysis used a minimum sample size of 5 restaurants per city-cuisine combination, which produced misleading results — small samples allowed a single high-demand restaurant to dominate the average for an entire cuisine category (e.g., one popular restaurant skewing an average across only 4-5 total listings). The threshold was raised to a minimum of 20 restaurants per combination, and results were additionally split between established metro markets (≥1,000 total restaurants) and emerging markets, since these represent meaningfully different expansion decisions with different risk profiles.
