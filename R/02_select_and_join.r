# ======================== Select & Join Data ==========================

# Select variables of interest
ai_labelled <- final_labelled %>%
  select(doc_id, product_scarcity_gpt, financial_scarcity_gpt, cleaned_text)

ml_labelled <- df %>%
  select(doc_id, prod_class, fin_class)

# Inner join to align on doc_id
joined_labelled <- inner_join(ai_labelled, ml_labelled, by = "doc_id")

# Filter to scarcity-related rows
scarcity_data <- joined_labelled %>%
  filter(prod_class == 1 | fin_class == 1 | product_scarcity_gpt == 1 | financial_scarcity_gpt == 1)

# Save as intermediate file 
saveRDS(scarcity_data, file = here::here("data", "processed", "scarcity_filtered.rds"))

