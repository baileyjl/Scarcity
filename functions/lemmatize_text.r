# ======================== Lemmatize Function =================

# Load libraries
library(dplyr)
library(tidytext)
library(textstem)

# Function to lemmatize text
lemmatize_text_column <- function(data, text_col = "cleaned_text") {


  data$row_id <- seq_len(nrow(data))

  tokens <- data %>%
    select(row_id, !!sym(text_col)) %>%
    unnest_tokens(word, !!sym(text_col))

  tokens$lemma <- lemmatize_words(tokens$word)

  lemmatized_docs <- tokens %>%
    group_by(row_id) %>%
    summarise(lemma = paste(lemma, collapse = " "), .groups = "drop")

  data <- data %>%
    left_join(lemmatized_docs, by = "row_id") %>%
    select(-row_id)

  return(data)
}