# ======================== Vocab Filtering ============================

# Load libraries
library(dplyr)
library(here)

# Load functions
source(here("functions", "evaluate_vocab.R"))
source(here("functions", "filter_bigrams.R"))

# Load bigrams + lemmatized text data
bigrams <- readRDS(here("data", "processed", "bigrams.rds"))
lemmatized_data <- readRDS(here("data", "processed", "lemmatized_text.rds"))

# Reattach labels
bigrams <- bigrams %>%
  left_join(
    lemmatized_data %>% select(doc_id, prod_class, fin_class, product_scarcity_gpt, financial_scarcity_gpt),
    by = "doc_id"
  )

# Split into ML vs AI labelled sets
data_ml <- bigrams %>% filter(prod_class == 1 | fin_class == 1)
data_ai <- bigrams %>% filter(product_scarcity_gpt == 1 | financial_scarcity_gpt == 1)

# Evaluate vocabulary coverage
ml_vocab_eval <- evaluate_vocab_limits(data_ml, label = "ML", min_df = 3, target_retention = 95)
ai_vocab_eval <- evaluate_vocab_limits(data_ai, label = "AI", min_df = 3, target_retention = 95)

# Use best-fit vocab size from result
ml_vocab_size <- max(ml_vocab_eval$results$vocab_limit_numeric[ml_vocab_eval$results$pct_retained >= 95])
ai_vocab_size <- max(ai_vocab_eval$results$vocab_limit_numeric[ai_vocab_eval$results$pct_retained >= 95])

#  Filter by vocab size
data_ml_filtered <- filter_bigrams_by_vocab(data_ml, vocab_size = ml_vocab_size, min_df = 3)
data_ai_filtered <- filter_bigrams_by_vocab(data_ai, vocab_size = ai_vocab_size, min_df = 3)

# Save for downstream DTM creation
saveRDS(data_ml_filtered, here("data", "processed", "ml_bigrams_filtered.rds"))
saveRDS(data_ai_filtered, here("data", "processed", "ai_bigrams_filtered.rds"))
