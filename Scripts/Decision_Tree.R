###########################
### DECISION TREE MODEL ###
###########################

load("RDA/Model_Prep.rda")

set.seed(1000)

# Set up Decision Tree Model
recession_dec_tree_spec <- decision_tree() %>%
  set_mode("classification") %>%
  set_engine("rpart")

#Set up workflow tuning the cost-complexity hyper parameter
recession_dec_tree_wkflw <- workflow() %>%
  add_recipe(recession_recipe) %>%
  add_model(recession_dec_tree_spec %>% set_args(cost_complexity = tune()))

# Set up a tuning grid with complexity ranging from 10^-3 to 10^-1
dt_grid <- grid_regular(cost_complexity(range = c(-3, -1)), levels = 10)

# Fit the models to folds using tune_grid
dt_tune_res <- tune_grid(
  recession_dec_tree_wkflw, 
  resamples = recession_folds, 
  grid = dt_grid, 
  metrics = metric_set(yardstick::roc_auc)
)

# Select the decision tree with optimal complexity based on best ROC AUC
dt_optimal_complexity <- select_best(dt_tune_res)

# Finalize the workflow with the optimal complexity data
dt_final <- finalize_workflow(recession_dec_tree_wkflw, dt_optimal_complexity)

# Fit the model to the entire training set
dt_final_fit <- fit(dt_final, data = recession_train)

# Save data to RDA file
save(dt_tune_res, dt_final_fit, file = "RDA/Decision_Tree.rda")
