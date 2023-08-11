#Import required modules
install.packages("rlang")
install.packages("tidymodels")
library(tidymodels)
library(tidyverse)
#Download dataset
URL <- 'https://dax-cdn.cdn.appdomain.cloud/dax-noaa-weather-data-jfk-airport/1.1.4/noaa-weather-sample-data.tar.gz'
download.file(URL, destfile = "noaa-weather-sample-data.tar.gz")
untar("noaa-weather-sample-data.tar.gz")
#Extract and read
sub_weather <- read_csv("noaa-weather-sample-data/jfk_weather_sample.csv")
head(sub_weather)
#Select subset
subset_weather <- sub_weather %>% select(HOURLYRelativeHumidity, HOURLYDRYBULBTEMPF, HOURLYPrecip, HOURLYWindSpeed, HOURLYStationPressure)
head(subset_weather, 10)
#Clean up columns
unique(subset_weather$HOURLYPrecip)
cleaned_data <- subset_weather %>%
  mutate(HOURLYPrecip = ifelse(HOURLYPrecip == "T", "0.0", HOURLYPrecip)) %>%
  mutate(HOURLYPrecip = str_remove(HOURLYPrecip, "s$"))
glimpse(cleaned_data$HOURLYPrecip)
head(cleaned_data$HOURLYPrecip)
cleaned_data$HOURLYPrecip
cleaned_data_1 <- cleaned_data %>% drop_na(HOURLYPrecip)
#Convert
cleaned_data_1$HOURLYPrecip <- as.numeric(cleaned_data_1$HOURLYPrecip)
glimpse(cleaned_data_1$HOURLYPrecip)
#Rename
library(dplyr)
analysis_data <- cleaned_data_1 %>% rename(relative_humidity = HOURLYRelativeHumidity,
                                           dry_bulb_temp_f = HOURLYDRYBULBTEMPF,
                                           precip = HOURLYPrecip,
                                           wind_speed = HOURLYWindSpeed,
                                           station_pressure = HOURLYStationPressure)
#Exploratory Data Analysis
set.seed(1234)
weather_split <- initial_split(analysis_data, prop = 0.8)
train_data_weather <- training(weather_split)
test_data_weather <- testing(weather_split)
library(ggplot2)
ggplot(data = train_data_weather, mapping = aes(x = relative_humidity))
       geom_histogram(bins = 20, color = "white", fill = "blue")
       coord_cartesian(xlim = NULL)
       
ggplot(data = train_data_weather, mapping = aes(x = dry_bulb_temp_f))
       geom_histogram(bins = 10, color = "white", fill = "red")
       coord_cartesian(xlim = NULL)
train_data_weather$relative_humidity
sapply(train_data_weather$relative_humidity, typeof)
as.numeric(train_data_weather$relative_humidity)
#Linear regression
lm_spec <- linear_reg() %>%
set_engine(engine = "lm")
train_fit_hum <- lm_spec %>% 
  fit(precip ~ relative_humidity, data = train_data_weather)
train_results1 <- train_fit_hum %>% 
  predict(new_data = train_data_weather) %>%
  mutate(truth = train_data_weather$precip)
train_results1
test_results1 <- train_fit_hum %>%
  predict(new_data = test_data_weather) %>%
  mutate(truth = test_data_weather$precip)
test_results1
test_results1 %>%
  mutate(train = "testing") %>%
  bind_rows(train_results1 %>% mutate(train = "training")) %>%
  ggplot(aes(truth, .pred)) +
  geom_abline(lty = 2, color = "orange", 
              size = 1.5) +
  geom_point(color = '#006EA1', 
             alpha = 0.5) +
  facet_wrap(~train) +
  labs(x = "Relative Humidity", 
       y = "Precipitation")

train_fit_dry <- lm_spec %>% 
  fit(precip ~ dry_bulb_temp_f, data = train_data_weather)
train_results2 <- train_fit_dry %>% 
  predict(new_data = train_data_weather) %>%
  mutate(truth = train_data_weather$precip)
train_results2
test_results2 <- train_fit_dry %>%
  predict(new_data = test_data_weather) %>%
  mutate(truth = test_data_weather$precip)
test_results2
test_results2 %>%
  mutate(train = "testing") %>%
  bind_rows(train_results2 %>% mutate(train = "training")) %>%
  ggplot(aes(truth, .pred)) +
  geom_abline(lty = 2, color = "orange", 
              size = 1.5) +
  geom_point(color = '#006EA1', 
             alpha = 0.5) +
  facet_wrap(~train) +
  labs(x = "Dry Bulb Temp F", 
       y = "Precipitation")


train_fit_wind <- lm_spec %>% 
  fit(precip ~ wind_speed, data = train_data_weather)
train_results3 <- train_fit_wind %>% 
  predict(new_data = train_data_weather) %>%
  mutate(truth = train_data_weather$precip)
train_results3
test_results3<- train_fit_wind %>%
  predict(new_data = test_data_weather) %>%
  mutate(truth = test_data_weather$precip)
test_results3
test_results3 %>%
  mutate(train = "testing") %>%
  bind_rows(train_results3 %>% mutate(train = "training")) %>%
  ggplot(aes(truth, .pred)) +
  geom_abline(lty = 2, color = "orange", 
              size = 1.5) +
  geom_point(color = '#006EA1', 
             alpha = 0.5) +
  facet_wrap(~train) +
  labs(x = "Wind Speed", 
       y = "Precipitation")

train_fit_station <- lm_spec %>% 
  fit(precip ~ station_pressure, data = train_data_weather)
train_results4 <- train_fit_station %>% 
  predict(new_data = train_data_weather) %>%
  mutate(truth = train_data_weather$precip)
train_results4
test_results4 <- train_fit_wind %>%
  predict(new_data = test_data_weather) %>%
  mutate(truth = test_data_weather$precip)
test_results4
test_results4 %>%
  mutate(train = "testing") %>%
  bind_rows(train_results4 %>% mutate(train = "training")) %>%
  ggplot(aes(truth, .pred)) +
  geom_abline(lty = 2, color = "orange", 
              size = 1.5) +
  geom_point(color = '#006EA1', 
             alpha = 0.5) +
  facet_wrap(~train) +
  labs(x = "Station Pressure", 
       y = "Precipitation")
#Improve the model
weather_recipe <-
  recipe(precip ~ ., data = train_data_weather) %>%   step_naomit(all_predictors())
ridge_spec <- linear_reg(penalty = 0.1, mixture = 0) %>%
  set_engine("glmnet")
ridge_wf <- workflow() %>%
  add_recipe(weather_recipe)
ridge_fit <- ridge_wf %>%
  add_model(ridge_spec) %>%
  fit(data = train_data_weather)
ridge_fit %>%
  pull_workflow_fit() %>%
  tidy()

elasticnet_spec <- linear_reg(penalty = 0.1, mixture = 0.3) %>%
  set_engine("glmnet")

elasticnet_wf <- workflow() %>%
  add_recipe(weather_recipe)

elasticnet_fit <- elasticnet_wf %>%
  add_model(elasticnet_spec) %>%
  fit(data = train_data_weather)
elasticnet_fit %>% 
  pull_workflow_fit() %>%
  tidy()

tune_spec <- linear_reg(penalty = tune(), mixture = 1) %>% 
  set_engine("glmnet")

lasso_wf <- workflow() %>%
  add_recipe(weather_recipe)

weather_cvfolds <- vfold_cv(train_data_weather)
lambda_grid <- grid_regular(levels = 50,
                            penalty(range = c(-3, 0.3)))

lasso_grid <- tune_grid(
  lasso_wf %>% add_model(tune_spec), 
  resamples = weather_cvfolds, 
  grid = lambda_grid)
show_best(lasso_grid, metric = "rmse")
lasso_grid %>%
  collect_metrics() %>%
  filter(.metric == "rmse") %>%
  ggplot(aes(penalty, mean)) +
  geom_line(size=1, color="red") +
  scale_x_log10() +
  ggtitle("RMSE")





