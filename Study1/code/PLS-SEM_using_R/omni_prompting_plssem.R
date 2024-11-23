library(plspm)

data_path <- "../../data/dv_total.csv"
idv_data_path <- "../../data/omni_prompting/llm_responses.csv" 
data <- read.csv(data_path)
idv_data <- read.csv(idv_data_path)

colnames(idv_data)[which(colnames(idv_data) %in% c("Q1", "Q2", "Q3", "Q4"))] <- c("aoa_1", "aoa_2", "aoa_3", "aoa_4")

merged_data <- cbind(data, idv_data)

merged_data_clean <- merged_data[, c("poa_1", "poa_2", "poa_3", "poa_4",
                                     "coa_1", "coa_2", "coa_3", "coa_4",
                                     "eoa_1", "eoa_2", "eoa_3",
                                     "ioa_1", "ioa_2", "ioa_3", "ioa_4",
                                     "oac_1", "oac_2", "oac_3", "oac_4",
                                     "aoa_1", "aoa_2", "aoa_3", "aoa_4")]

path_matrix <- rbind(
  c(0, 0, 0, 0, 0, 0),  # Pleasure -> Attitude_toward_ads
  c(0, 0, 0, 0, 0, 0),  # Credibility -> Attitude_toward_ads
  c(0, 0, 0, 0, 0, 0),  # Economic_evaluation -> Attitude_toward_ads
  c(0, 0, 0, 0, 0, 0),  # Perceived_intrusiveness -> Attitude_toward_ads
  c(0, 0, 0, 0, 0, 0),  # Perceived_clutter -> Attitude_toward_ads
  c(1, 1, 1, 1, 1, 0)   # Attitude_toward_ads <- Pleasure, Credibility, Economic_evaluation, Perceived_intrusiveness, Perceived_clutter
)

blocks <- list(
  c("poa_1", "poa_2", "poa_3", "poa_4"),  # Pleasure
  c("coa_1", "coa_2", "coa_3", "coa_4"),  # Credibility
  c("eoa_1", "eoa_2", "eoa_3"),            # Economic evaluation
  c("ioa_1", "ioa_2", "ioa_3", "ioa_4"),    # Perceived intrusiveness
  c("oac_1", "oac_2", "oac_3", "oac_4"),    # Perceived clutter
  c("aoa_1", "aoa_2", "aoa_3", "aoa_4")     # Attitude toward ads
)

pls_result <- plspm(merged_data_clean, path_matrix, blocks)

n_sample <- 5000

output_file_txt <- "../../analysis_result/PLS-SEM/omni_prompting_plssem.txt"  
output_file_csv <- "../../analysis_result/PLS-SEM/omni_prompting_plssem.csv"  

sink(output_file_txt)

cat("PLS-SEM Analysis Summary:\n", file = output_file_txt) 
set.seed(123)  
pls_bootstrap <- plspm(merged_data_clean, path_matrix, blocks, boot.val = TRUE, br = n_sample)

summary_output <- capture.output(summary(pls_bootstrap))
write.csv(summary_output, file = output_file_csv, row.names = FALSE)

mean <- pls_bootstrap$boot$paths$Mean.Boot
std <- pls_bootstrap$boot$paths$Std.Error
df <- n_sample - 1

p_values <- numeric(length(mean))  

t_values <- numeric(length(mean))  

for (i in 1:length(mean)) {
  t_value <- abs(mean[i]) / std[i]
  t_values[i] <- t_value
  p_value <- 2 * pt(t_value, df, lower.tail = FALSE)
  p_values[i] <- p_value
}

cat("\nP-values for paths from bootstrapping using t-test:\n", file = output_file_txt, append = TRUE)
cat(sprintf("%.5f\n", p_values), file = output_file_txt, append = TRUE)

sink()

cat("\nResults saved to ~.txt and ~.csv\n")
