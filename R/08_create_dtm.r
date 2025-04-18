# ======================== Create DTM Matrices ========================

# Load libraries
library(dplyr)
library(tm)
library(tidytext)
library(here)

# Load filtered bigram data
ml_bigrams <- readRDS(here("data", "processed", "ml_bigrams_filtered.rds"))
ai_bigrams <- readRDS(here("data", "processed", "ai_bigrams_filtered.rds"))

# Convert bigrams to underscore format
ml_bigrams <- ml_bigrams %>%
  mutate(bigram = gsub(" ", "_", bigram))

ai_bigrams <- ai_bigrams %>%
  mutate(bigram = gsub(" ", "_", bigram))

# Create document-term matrices
matrix_ml <- ml_bigrams %>%
  count(doc_id, bigram) %>%
  cast_dtm(document = doc_id, term = bigram, value = n, weighting = tm::weightTf)

matrix_ai <- ai_bigrams %>%
  count(doc_id, bigram) %>%
  cast_dtm(document = doc_id, term = bigram, value = n, weighting = tm::weightTf)

#  Save DTM and filtered bigrams
save(
  matrix_ml,
  matrix_ai,
  ml_bigrams,
  ai_bigrams,
  file = here("data", "processed", "filtered_bigrams_and_matrices.RData")
)