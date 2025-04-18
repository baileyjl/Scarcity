# ======================== Filter bigrams by vocab function =================

# Load libraries
library(dplyr)
library(tidytext)

filter_bigrams_by_vocab <- function(data, vocab_size, min_df = 3) {

  bigram_freq <- data %>% count(bigram, sort = TRUE)
  top_bigrams <- bigram_freq %>% top_n(vocab_size, n) %>% pull(bigram)

  frequent_bigrams <- data %>%
    count(bigram, doc_id) %>%
    group_by(bigram) %>%
    summarise(n_docs = n(), .groups = "drop") %>%
    filter(n_docs >= min_df) %>%
    pull(bigram)

  valid_bigrams <- intersect(top_bigrams, frequent_bigrams)

  data %>% filter(bigram %in% valid_bigrams)
}