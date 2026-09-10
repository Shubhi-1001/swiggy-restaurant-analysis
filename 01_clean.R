library(tidyverse)
library(skimr)
library(janitor)

raw <- read_csv("data/raw/swiggy.csv")
dim(raw)
glimpse(raw)

skim(raw)

raw %>% distinct(rating_count) %>% head(20)
raw %>% distinct(city)


clean <- raw %>%
  mutate(
    # rating: "--" means no rating yet, not a real value
    rating = na_if(rating, "--"),
    rating = as.numeric(rating),
    
    # cost: strip the ₹ symbol and space, keep as number
    cost = parse_number(cost),
    
    # rating_count: it's a bucket, not a count — keep the bucket as a category,
    # and also create a numeric lower-bound estimate for scoring later
    rating_bucket = rating_count,
    rating_count_est = case_when(
      rating_bucket == "Too Few Ratings" ~ 0,
      str_detect(rating_bucket, "K\\+") ~ parse_number(rating_bucket) * 1000,
      str_detect(rating_bucket, "\\+") ~ parse_number(rating_bucket),
      TRUE ~ NA_real_
    )
   
  )

# city sometimes contains "Locality,...,City" — split on the LAST comma
# so it's robust to rows with more than one comma

clean <- clean %>%
  mutate(
    locality = if_else(str_detect(city, ","),
                       str_trim(str_extract(city, "^.+(?=,[^,]*$)")),
                       NA_character_),
    city = if_else(str_detect(city, ","),
                   str_trim(str_extract(city, "[^,]+$")),
                   str_trim(city))
  )

clean %>% distinct(city) %>% arrange(city) %>% print(n = 554)
clean %>% count(rating_bucket, rating_count_est)

skim(clean %>% select(rating, cost, rating_count_est, city, locality))


clean %>% count(rating_bucket == "Too Few Ratings", is.na(rating))
# NOTE: rating is missing for restaurants with "Too Few Ratings" — this is
# structural, not random. These restaurants are analyzed separately in the
# opportunity-score step (Step 6), not dropped.




clean %>% filter(cost > 5000) %>% count()
clean %>% arrange(desc(cost)) %>% select(name, city, cost) %>% head(20)


cost_cap <- quantile(clean$cost, 0.99, na.rm = TRUE)
cost_cap  

clean <- clean %>%
  mutate(cost = if_else(cost > cost_cap, NA_real_, cost))
# NOTE: cost values above the 99th percentile (₹[whatever cost_cap printed])
# were treated as likely data-entry errors and set to NA, rather than
# dropped entirely, to preserve the rest of each restaurant's data.


write.csv(clean, "data/clean/swiggy_clean.csv")
