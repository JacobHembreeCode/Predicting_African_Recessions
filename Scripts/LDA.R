##########################################
### LINEAR DISCRIMINANT ANALYSIS MODEL ###
##########################################

load("RDA/Model_Prep.rda")

set.seed(1000)

# Set up LDA Model
recession_lda_model <- discrim_linear() %>% 
  set_mode("classification") %>% 
  set_engine("MASS")

#Set up LDA workflow
recession_lda_wkflw <- workflow() %>% 
  add_model(recession_lda_model) %>% 
  add_recipe(recession_recipe)

# Fit model to training data
lda_fit <- fit(recession_lda_wkflw, recession_train)
predict(lda_fit, new_data = recession_train, type="prob")

# Fit model to folds
lda_kfold_fit <- fit_resamples(recession_lda_wkflw, recession_folds)
collect_metrics(lda_kfold_fit)

# Use augment to get the ROC curve
lda_roc <- augment(lda_fit, recession_train)

# Save data to RDA
save(lda_fit, lda_kfold_fit, lda_roc, file = "RDA/LDA.rda")
