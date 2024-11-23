library(plspm)

given_data_path <- "../../given_latent_human.csv"
original_answer_path <- "../../original_answer_human.csv"

given_data <- read.csv(given_data_path)
original_answer <- read.csv(original_answer_path)

merged_data <- cbind(given_data, original_answer)

merged_data_clean <- merged_data[, c("LIKE_1", "LIKE_2",        # Likeability
                                     "COMP_1", "COMP_2", "COMP_3", # Competence
                                     "SAT_1", "SAT_2", "SAT_3",     # Satisfaction
                                     "LOY_1", "LOY_2", "LOY_3",     # Customer Loyalty
                                     "TRUST_1", "TRUST_2", "TRUST_3", "TRUST_4")]  # TRUST

path_matrix <- rbind(
  c(0, 0, 0, 0, 0),  # Likeability
  c(0, 0, 0, 0, 0),  # Competence 
  c(1, 1, 0, 0, 0),  # Trust <- Likeability Competence
  c(1, 1, 1, 0, 0),  # Satisfaction <- Likeability Competence Trust
  c(1, 1, 1, 1, 0)  # Customer Loyalty <- Likeability Competence Satisfaction Trust
)

blocks <- list(
  c("LIKE_1", "LIKE_2"),  # LIKEABILITY
  c("COMP_1", "COMP_2", "COMP_3"),  # COMPETENCE
  c("TRUST_1", "TRUST_2", "TRUST_3", "TRUST_4"),  # TRUST
  c("SAT_1", "SAT_2", "SAT_3"),     # SATISFACTION
  c("LOY_1", "LOY_2", "LOY_3")     # CUSTOMER_LOYALTY
)

n_sample <- 10000

output_file_txt <- "../../analysis_result/PLS-SEM/human_plssem.txt"  
output_file_csv <- "../../analysis_result/PLS-SEM/human_plssem.csv"  

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

for (i in 1:length(HTMT_values)) {
  cat(sprintf("%s : %.5f\n", names(HTMT_values)[i], HTMT_values[[i]]), file = output_file_txt, append = TRUE)
}

sink()

cat("\nResults saved\n")
