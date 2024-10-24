###########################
### RANDOM FOREST MODEL ###
###########################

load("RDA/Model_Prep.rda")

set.seed(1000)

# Set up the random forest model tuning mtry, trees, and min_n. We set importance = impurity
recession_rf_spec <- rand_forest(mtry = tune(),
                                 trees = tune(),
                                 min_n = tune()) %>%
  set_engine("ranger", importance = "impurity") %>%
  set_mode("classification")

# Make the random forest workflow
recession_rf_wkflw <- workflow() %>%
  add_recipe(recession_recipe) %>%
  add_model(recession_rf_spec)
  
# Create a tuning grid to tune the hyper parameters mtry, trees, and min_n
rf_grid <- grid_regular(mtry(range = c(1, 16)), trees(range = c(5, 500)), min_n(range = c(1, 20)), levels = 8)

# Fit the model to the folds using tune_grid
rf_tune_res <- tune_grid(
  recession_rf_wkflw, 
  resamples = recession_folds, 
  grid = rf_grid, 
  metrics = metric_set(yardstick::roc_auc)
)

# Get the random forest model with the best roc_auc
rf_optimal  <- select_best(rf_tune_res)

# Finalize the workflow to the optimal model tuning
rf_final <- finalize_workflow(recession_rf_wkflw, rf_optimal)

# Fit the optimized model to the entire training set
rf_final_fit <- fit(rf_final, data = recession_train)

#Save data to RDA file
save(rf_tune_res, rf_final_fit, file = "RDA/Random_Forest.rda")
