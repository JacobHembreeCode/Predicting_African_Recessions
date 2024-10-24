#############################################
### QUADRATIC DISCRIMINANT ANALYSIS MODEL ###
#############################################

load("RDA/Model_Prep.rda")

set.seed(1000)

# Set up QDA model
recession_qda_model <- discrim_quad() %>%
  set_mode("classification") %>% 
  set_engine("MASS")

# Set up QDA workflow
recession_qda_wkflw <- workflow() %>%
  add_model(recession_qda_model) %>%
  add_recipe(recession_recipe)

# Fit model to training data
qda_fit <- fit(recession_qda_wkflw, recession_train)
predict(qda_fit, new_data = recession_train, type="prob")

#Fit model to the folds
qda_kfold_fit <- fit_resamples(recession_qda_wkflw, recession_folds, control = control_grid(save_pred = TRUE))
collect_metrics(qda_kfold_fit)

#Use augment to get the roc curve
qda_roc <- augment(qda_fit, recession_train)

#save data to RDA
save(qda_fit, qda_kfold_fit, qda_roc, file = "RDA/QDA.rda")
