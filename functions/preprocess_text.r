# ======================== Text Preprocessing Function =================

# Load libraries
library(dplyr)
library(stringr)
library(cleanTextNLP)

# Function to preprocess text
preprocess_text_data <- function(data,
                                 extra_stopwords,
                                 stanford_stopwords,
                                 number_placeholder = "vnumericv") {
  # Expand contractions
  data2 <- expand_contractions(data$cleaned_text)

  # Remove possessive 's
  data2 <- remove_possessive_s(data2$cleaned_text)

  # Convert to lowercase
  data2 <- convert_to_lowercase(data2$cleaned_text)

  # Replace numbers with placeholder
  data2 <- remove_numbers(data2$cleaned_text, placeholder = number_placeholder)

  # Replace '&' with 'and'
  data2$cleaned_text <- gsub("&", "and", data2$cleaned_text)

  # Remove punctuation (except £ and #)
  data2$cleaned_text <- gsub("[^[:alnum:] £#]", " ", data2$cleaned_text)

  # Combine stopwords
  all_stopwords <- unique(c(as.character(extra_stopwords), as.character(stanford_stopwords)))

  # Remove stopwords
  remove_stopwords <- function(text, stopwords) {
    words <- unlist(strsplit(text, "\\s+"))
    filtered_words <- words[!(words %in% stopwords)]
    paste(filtered_words, collapse = " ")
  }

  data2 <- data2 %>%
    mutate(cleaned_text = sapply(cleaned_text, remove_stopwords, stopwords = all_stopwords))

  # Remove dangling #
  data2$cleaned_text <- gsub("#(\\s|$)", "", data2$cleaned_text)

  # Final whitespace cleanup
  data2 <- remove_whitespace(data2$cleaned_text)

  return(data2)
}
