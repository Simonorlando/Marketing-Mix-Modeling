library(googlesheets4)

create_files <- TRUE
robyn_directory <- "~/Desktop"
url <- ""
df <- read_sheet(url)

num_rows_with_na <- sum(apply(df, 1, function(row) any(is.na(row)))) 
print(paste("Numero di righe con almeno un NA:", num_rows_with_na))
num_rows_with_multiple_nas <- sum(apply(df, 1, function(row) sum(is.na(row)) > 1))
print(paste("Numero di righe con più di un NA:", num_rows_with_multiple_nas))
                                        
df <- df[1:236, ]
colSums(is.na(df))

df[is.na(df)] <- 0
print(df)

list_vars <- sapply(df, is.list)
print(list_vars)

df$Week<-as.numeric(df$Week)


json_file <- "~/Desktop/RobynModel-1_136_7.json"


RobynRefresh <- robyn_refresh(
  json_file = json_file,
  dt_input = df,
  dt_holidays = dt_prophet_holidays,
  window_start = "27-05-2024",
  refresh_steps = 13,
  refresh_iters = 1000, 
  refresh_trials = 1
)


InputCollectX <- RobynRefresh$listRefresh1$InputCollect
OutputCollectX <- RobynRefresh$listRefresh1$OutputCollect
select_modelX <- RobynRefresh$listRefresh1$OutputCollect$selectID



AllocatorCollect <- robyn_allocator(
  InputCollect = InputCollectX,
  OutputCollect = OutputCollectX,
  select_model = select_modelX,
  date_range = c("2023-10-02", "2023-12-25"),
  total_budget = 216660,
  channel_constr_low = c(0.88,0.0,0.0,0.6,0.0,0.3,0.52,0.48,0.0,0.65,1.03),
  channel_constr_up = c(1.65, 0.0, 0.0, 1.3, 0.0,0.6,0.82,0.63,0.0,1.15,1.03),
  scenario = "max_response",
  export = create_files
)

