# ======================== Language Detection ==========================

# Load the filtered dataset from the previous step
scarcity_data <- readRDS(here("data", "processed", "scarcity_filtered.rds"))

# Detect language of each post using cleaned_text
scarcity_data$languages <- detect_language(scarcity_data$cleaned_text)

# Flag non-English posts for review
non_english_posts <- scarcity_data %>%
  filter(languages != "en" | is.na(languages))

# Manually remove specific known non-english doc_ids with NA language
doc_ids_to_remove <- c(556515, 234794, 373325, 416213, 575705, 104483, 242419)

# Filter to keep only English or acceptable NA
filtered_data <- scarcity_data %>%
  filter(
    languages == "en" |
    (is.na(languages) & !(doc_id %in% doc_ids_to_remove))
  )

# Save filtered dataset
saveRDS(filtered_data, file = here("data", "processed", "language_filtered.rds"))
