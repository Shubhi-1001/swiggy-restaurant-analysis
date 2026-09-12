library(tidyverse)

clean <- read_csv("data/clean/swiggy_clean.csv")

cuisine_long <- clean %>%
  separate_rows(cuisine, sep = ",\\s*")


##we define opportunity as per the following methodologies::
##a cuisine/city combination scores high when it
##has strong average demand and rating relative to how few restaurants currently serve it
opportunity <- cuisine_long %>%
  group_by(city, cuisine) %>%
  summarise(
    n_restaurants = n(),
    avg_rating = mean(rating, na.rm = TRUE),
    avg_demand = mean(rating_count_est, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(n_restaurants >= 20) %>%              # ignore tiny, unreliable samples
  mutate(
    avg_rating = replace_na(avg_rating, 0),   # cuisines with zero rated restaurants score as 0, not NA
    opportunity_score = (avg_rating * avg_demand) / n_restaurants
  ) %>%
  arrange(desc(opportunity_score))

opportunity %>% slice_head(n = 20)

##top opportunities per city
top_per_city <- opportunity %>%
  group_by(city) %>%
  slice_max(opportunity_score, n = 1) %>%
  ungroup() %>%
  arrange(desc(opportunity_score))

top_per_city %>% slice_head(n = 15)

##visualise
top_per_city %>%
  slice_head(n = 10) %>%
  ggplot(aes(x = reorder(city, opportunity_score), y = opportunity_score, fill = cuisine)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top Expansion Opportunity by City",
       x = NULL, y = "Opportunity Score", fill = "Cuisine") +
  theme_minimal()

##metro vs emerging market
opportunity_metro <- opportunity %>%
  semi_join(city_summary %>% filter(n_restaurants >= 1000), by = "city")

opportunity_emerging <- opportunity %>%
  anti_join(city_summary %>% filter(n_restaurants >= 1000), by = "city")

opportunity_metro %>% slice_max(opportunity_score, n = 10)
opportunity_emerging %>% slice_max(opportunity_score, n = 10)
