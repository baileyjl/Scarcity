# ======================== Lemmatize Text =============================

# Load libraries
library(dplyr)
library(tidytext)
library(textstem)
library(here)

source(here("functions", "lemmatize_text.R"))

# Load cleaned data
cleaned_data <- readRDS(here("data", "processed", "cleaned_text.rds"))

# Apply lemmatization
lemmatized_data <- lemmatize_text_column(cleaned_data, text_col = "cleaned_text_processed")

# Add lemmatized text back to main data
cleaned_data$processed_text <- lemmatized_data$lemma
cleaned_data$processed_text2 <- lemmatized_data$lemma

# Save output
saveRDS(cleaned_data, file = here("data", "processed", "lemmatized_text.rds"))