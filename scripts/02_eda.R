library(tidyverse)
library(scales)

clean <- read_csv("data/clean/swiggy_clean.csv")


#city overview 
city_summary <- clean %>%
  group_by(city) %>%
  summarise(
    n_restaurants = n(),
    avg_rating = mean(rating, na.rm = TRUE),
    avg_cost = mean(cost, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(n_restaurants))

city_summary %>% slice_head(n = 15)

##bikaner has exceptionally high cost for a small no.of restauranants
clean %>% filter(city == "Bikaner") %>%
  summarise(n = n(), avg_cost = mean(cost, na.rm = TRUE), max_cost = max(cost, na.rm = TRUE))

city_summary %>%
  slice_max(n_restaurants, n = 15) %>%
  ggplot(aes(x = reorder(city, n_restaurants), y = n_restaurants)) +
  geom_col(fill = "#fc8019") +
  coord_flip() +
  labs(title = "Top 15 Cities by Restaurant Count", x = NULL, y = "Number of Restaurants") +
  theme_minimal()

##overview of cuisines
cuisine_long <- clean %>%
  separate_rows(cuisine, sep = ",\\s*")

cuisine_long %>%
  count(cuisine, sort = TRUE) %>%
    slice_head(n = 15)

cuisine_long %>%
  count(cuisine, sort = TRUE) %>%
  slice_max(n, n = 15) %>%
  ggplot(aes(x = reorder(cuisine, n), y = n)) +
  geom_col(fill = "#fc8019") +
  coord_flip() +
  labs(title = "Top 15 Cuisines by Restaurant Count", x = NULL, y = "Number of Restaurants") +
  theme_minimal()


##visualize ratings' distribution (those who have ratings)
clean %>%
  filter(!is.na(rating)) %>%
  ggplot(aes(x = rating)) +
  geom_histogram(binwidth = 0.2, fill = "#fc8019", color = "white") +
  labs(title = "Rating Distribution (Rated Restaurants Only)",
       subtitle = paste0(scales::percent(mean(is.na(clean$rating)), accuracy = 1),
                         " of restaurants have no rating yet and are excluded here"),
       x = "Rating", y = "Count") +
  theme_minimal()

##visualising distribution of cost

clean %>%
  filter(!is.na(cost)) %>%
  ggplot(aes(x = cost)) +
  geom_histogram(binwidth = 25, fill = "#fc8019", color = "white") +
  labs(title = "Cost Distribution", x = "Cost (₹)", y = "Count") +
  theme_minimal()

##relationship between cost and ratings 
clean %>%
  filter(!is.na(rating), !is.na(cost)) %>%
  ggplot(aes(x = cost, y = rating)) +
  geom_point(alpha = 0.05, color = "#fc8019") +
  geom_smooth(method = "lm", color = "black") +
  labs(title = "Cost vs. Rating", x = "Cost (₹)", y = "Rating") +
  theme_minimal()

cor(clean$cost, clean$rating, use = "complete.obs")
##no significant linear relationship is thus found


