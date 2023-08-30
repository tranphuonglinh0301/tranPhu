install.packages("rlang")
install.packages("tidymodels")

library("tidymodels")
library("tidyverse")
library("stringr")

dataset_url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing_converted_normalized.csv"
bike_sharing_df <- read_csv(dataset_url)
spec(bike_sharing_df)
bike_sharing_df <- bike_sharing_df %>% 
  select(-DATE, -FUNCTIONING_DAY)

set.seed(1234)
bike_split <- initial_split(bike_sharing_df, prop = 3/4)
train_data <- training(bike_split)
test_data <- testing(bike_split)

lm_spec <- linear_reg() %>%
  set_engine(engine = "lm") 

lm_model_weather <- lm_spec %>% fit(RENTED_BIKE_COUNT ~ TEMPERATURE + HUMIDITY + WIND_SPEED + 
                   VISIBILITY + DEW_POINT_TEMPERATURE + SOLAR_RADIATION + RAINFALL + SNOWFALL, data = train_data)
lm_model_weather

print(lm_model_weather$fit)
#Task
lm_model_all <- lm_spec %>% fit(RENTED_BIKE_COUNT ~ ., data = train_data)
summary(lm_model_all$fit)

test_result_weather <- lm_model_weather %>% 
  predict(new_data = test_data) %>%
  mutate(truth = test_data$RENTED_BIKE_COUNT)

head(test_result_weather)

test_result_all <- lm_model_all %>% 
  predict(new_data = test_data) %>%
  mutate(truth = test_data$RENTED_BIKE_COUNT)

head(test_result_all)

rsq_weather <- rsq(test_result_weather, truth = truth, estimate = .pred)
rsq_all <- rsq(test_result_all, truth = truth, estimate = .pred)

rmse_weather <- rmse(test_result_weather, truth = truth, estimate = .pred)
rmse_all <- rmse(test_result_all, truth = truth, estimate = .pred)

install.packages("ggplot2")
library(gglot2)

sorted_coefficients <- sort(abs(lm_model_all$coefficients), decreasing = TRUE)
coefficients_df <- as.data.frame(sorted_coefficients)
coefficients_df$variable <- row.names(coefficients_df)





ggplot(lm_model_all) %>% geom_bar(aes(x = ))


















































