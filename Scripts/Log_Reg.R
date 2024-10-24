#################################
### LOGISTIC REGRESSION MODEL ###
#################################

load("RDA/Model_Prep.rda")

set.seed(1000)

# Set up logistic regression model
recession_log_reg <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

# Set up logistic regression workflow
recession_wkflw <- workflow() %>%
  add_model(recession_log_reg) %>%
  add_recipe(recession_recipe)

# Fit the model to the training data
log_reg_fit <- fit(recession_wkflw, recession_train)
predict(log_reg_fit, new_data = recession_train, type =  "prob")

# Fit model to the folds
log_reg_kfold_fit <- fit_resamples(recession_wkflw, recession_folds)
collect_metrics(log_reg_kfold_fit)

# Create ROC curve using augment
log_reg_roc <- augment(log_reg_fit, recession_train)

# Save to RDA file
save(log_reg_fit, log_reg_kfold_fit, log_reg_roc, file = "RDA/Log_Reg.rda")
