library(robyn)

create_files <- TRUE
robyn_directory <- "~/Desktop"

InputCollect_9 <- robyn_inputs(
  dt_input = df,
  dt_holidays = dt_prophet_holidays,
  date_var = "DATE", 
  dep_var = "revenue", 
  dep_var_type = "revenue",
  prophet_vars = c("trend", "season", "holiday"), 
  prophet_country = "IT", 
  paid_media_spends = c("facebook_cost", "search_cost", "shopping_cost","bingS_cost","tv_cost","rtg_cost","trova_cost"), 
  paid_media_vars = c("facebook_impression", "search_impression", "shopping_impression", "bingS_click","tv_grp","rtg_impression","trova_click"), 
  window_start = "2020-05-11",
  window_end = "2024-05-13",
  adstock = "geometric" 
  )
print(InputCollect_9)
hyper_names(adstock = InputCollect_9$adstock, all_media = InputCollect_9$all_media)

hyperparameters_9 <- list(
 bingS_cost_alphas = c(0.5, 3),
 bingS_cost_gammas = c(0.3, 1),
 bingS_cost_thetas = c(0.02, 0.10),
 facebook_cost_alphas = c(0.5, 3),
 facebook_cost_gammas = c(0.3, 1),
 facebook_cost_thetas = c(0.10, 0.30),
 search_cost_alphas = c(0.5, 3),
 search_cost_gammas = c(0.3, 1),
 search_cost_thetas = c(0.02, 0.10),
 shopping_cost_alphas = c(0.5, 3),
 shopping_cost_gammas = c(0.3, 1),
 shopping_cost_thetas = c(0.01, 0.10),
 tv_cost_alphas = c(0.5, 3),
 tv_cost_gammas = c(0.3, 1),
 tv_cost_thetas = c(0.20, 0.3),
 rtg_cost_alphas = c(0.5, 3),
 rtg_cost_gammas = c(0.3, 1),
 rtg_cost_thetas = c(0.02, 0.10),
 trova_cost_alphas = c(0.5, 3),
 trova_cost_gammas = c(0.3, 1),
 trova_cost_thetas = c(0.02, 0.10),
 train_size = c(0.5, 0.8)
 )

InputCollect_9 <- robyn_inputs(InputCollect = InputCollect_9, hyperparameters = hyperparameters_9)

OutputModels_9 <- robyn_run(
 InputCollect = InputCollect_9, 
 iterations = 2000, 
 trials = 5, 
 ts_validation = F, 
 add_penalty_factor = FALSE 
) 

OutputCollect_9 <- robyn_outputs(
  InputCollect_9, OutputModels_9,
  pareto_fronts = "auto", 
  csv_out = "pareto", 
  clusters = TRUE, 
  plot_pareto = create_files 
)

print(OutputCollect_9)

select_model <- "3_235_3"

ExportedModel <- robyn_write(InputCollect_9, OutputCollect_9, select_model, export = create_files)
print(ExportedModel)


AllocatorCollect9 <- robyn_allocator(
  InputCollect = InputCollect_9,
  OutputCollect = OutputCollect_9,
  select_model = select_model,
  # date_range = "all", # Default to "all"
  # total_budget = NULL, # When NULL, default is total spend in date_range
  channel_constr_low = 0.7,
  channel_constr_up = c(1.5, 1.6, 1.7, 1.2, 1.1,1.1,1.9),
  # channel_constr_multiplier = 3,
  scenario = "max_response",
  export = create_files
)
