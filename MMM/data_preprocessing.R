create_files <- TRUE
robyn_directory <- "~/Desktop"
file_path <- "/Users/digitalangels/Desktop/Dataset Yeppon MMM (Simone).xlsx"  
df <- read_excel(file_path, sheet = 1)

#righe con almeno un NA
num_rows_with_na <- sum(apply(df, 1, function(row) any(is.na(row)))) 

print(paste("Numero di righe con almeno un NA:", num_rows_with_na))
#righe con più di un NA
num_rows_with_multiple_nas <- sum(apply(df, 1, function(row) sum(is.na(row)) > 1))
print(paste("Numero di righe con più di un NA:", num_rows_with_multiple_nas))

# revenue ha valori NA dalla riga 223 fino alla fine del dataset 
df <- df[1:222, ]

#ripropongo 
num_rows_with_multiple_nas <- sum(apply(df, 1, function(row) sum(is.na(row)) > 1))
print(paste("Numero di righe con più di un NA:", num_rows_with_multiple_nas))

# matrice di correlazione
library(reshape2)
library(ggplot2)
matrix_data <- df[, c("facebook_cost", "search_cost", "shopping_cost", "bingS_cost", "trova_cost","display_cost","discovery_cost","youtube_cost","bingP_cost","rtg_cost","rtbhouse_cost","criteo_cost","tv_cost","banner_cost","radio_cost","ctv_cost")]
correlation_matrix <- cor(matrix_data)
print(correlation_matrix)
melted_cor_matrix <- melt(correlation_matrix)
ggplot(data = melted_cor_matrix, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name = "Correlazione") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  coord_fixed()

# trovare automaticamente le variabili che hanno una correlazione >70%
threshold <- 0.7
high_cor_pairs <- which(abs(correlation_matrix) > threshold & abs(correlation_matrix) < 1, arr.ind = TRUE)
high_cor_pairs_df <- data.frame(
  Var1 = rownames(correlation_matrix)[high_cor_pairs[, 1]],
  Var2 = colnames(correlation_matrix)[high_cor_pairs[, 2]],
  Correlation = correlation_matrix[high_cor_pairs]
)
high_cor_pairs_df <- high_cor_pairs_df[!duplicated(t(apply(high_cor_pairs_df, 1, sort))), ]
print(high_cor_pairs_df)
