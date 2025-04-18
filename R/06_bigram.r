# ======================== Create Bigrams =============================

# Load libraries
library(dplyr)
library(tidytext)
library(here)

# Load lemmatized data
lemmatized_data <- readRDS(here("data", "processed", "lemmatized_text.rds"))

#  Filter out empty, NA, or zero-length posts
cleaned_for_bigrams <- lemmatized_data %>%
  filter(!is.na(processed_text2), nchar(processed_text2) > 0)

# Tokenize bigrams
bigrams <- cleaned_for_bigrams %>%
  unnest_tokens(bigram, processed_text2, token = "ngrams", n = 2)

# Save raw bigrams
saveRDS(bigrams, file = here("data", "processed", "bigrams.rds"))