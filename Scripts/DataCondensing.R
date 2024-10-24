#####################################################
### Selecting Predictors from the Kaggle Data Set ###
#####################################################

full_data <-  read.csv("data/africa_recession.csv")

project_data <- data.frame(population = full_data$pop,
                           emp_to_pop = full_data$emp_to_pop_ratio,
                           hci = full_data$hc,
                           consumption_hg = full_data$ccon,
                           absorption = full_data$cda,
                           tfp = full_data$ctfp,
                           labor_share = full_data$labsh,
                           irr = full_data$irr,
                           depreciation = full_data$delta,
                           exchange = full_data$xr,
                           share_house = full_data$csh_c,
                           share_gov = full_data$csh_g,
                           share_exports = full_data$csh_x,
                           share_imports = full_data$csh_m,
                           cpi = full_data$total,
                           cpi_change = full_data$total_change,
                           recession = full_data$growthbucket)

head(project_data)

write.csv(project_data, file = "project_data.csv")
