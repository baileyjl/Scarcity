# ======================== Text Cleaning ===============================

# Source the cleaning function
source(here("functions", "preprocess_text.R"))

# Load language-filtered data
filtered_data <- readRDS(here("data", "processed", "language_filtered.rds"))

# Load stopword lists
load(here("data", "raw", "stopwords.RData"))

# Apply cleaning
cleaned_data <- preprocess_text_data(
  data = filtered_data,
  extra_stopwords = extraStopword_df$stopwords1,
  stanford_stopwords = stanf_stopwords$stopwords1
)

# Add cleaned text back to main data
filtered_data$cleaned_text_processed <- cleaned_data$cleaned_text

# Save result
saveRDS(filtered_data, file = here("data", "processed", "cleaned_text.rds"))