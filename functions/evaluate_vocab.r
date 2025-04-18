# ======================== Evaluating Vocab Function =================

# Load libraries
library(dplyr)
library(purrr)
library(tibble)
library(glue)

evaluate_vocab_limits <- function(data,
                                  label = "dataset",
                                  vocab_sizes = c(500, 1000, 2000, 3000, 5000, 7500, 10000),
                                  min_df = 3,
                                  target_retention = NULL,
                                  search_exact = TRUE) {

  bigram_freq <- data %>%
    count(bigram, sort = TRUE)

  bigrams_min_df <- data %>%
    count(bigram, doc_id) %>%
    group_by(bigram) %>%
    summarise(n_docs = n(), .groups = "drop") %>%
    filter(n_docs >= min_df)

  frequent_bigrams <- bigrams_min_df$bigram
  max_vocab_size <- length(frequent_bigrams)
  full_vocab_sizes <- unique(c(vocab_sizes, max_vocab_size))

  evaluate_limit <- function(vocab_limit) {
    top_bigrams <- bigram_freq %>%
      top_n(vocab_limit, n) %>%
      pull(bigram)

    valid_bigrams <- intersect(top_bigrams, frequent_bigrams)

    filtered <- data %>%
      filter(bigram %in% valid_bigrams)

    docs_with_bigram <- filtered %>%
      distinct(doc_id) %>%
      nrow()

    total_docs <- data %>%
      distinct(doc_id) %>%
      nrow()

    actual_vocab_used <- length(valid_bigrams)

    tibble(
      dataset = label,
      vocab_limit_requested = ifelse(vocab_limit == max_vocab_size, "MAX", vocab_limit),
      actual_vocab_used = actual_vocab_used,
      docs_retained = docs_with_bigram,
      total_docs = total_docs,
      pct_retained = round(100 * docs_with_bigram / total_docs, 1),
      vocab_limit_numeric = vocab_limit
    )
  }

  results <- map_dfr(full_vocab_sizes, evaluate_limit)
  return(list(results = results))
}