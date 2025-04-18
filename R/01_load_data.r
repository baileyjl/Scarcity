# ======================== Load Libraries ============================
library(here)
library(dplyr)

# ======================== Define File Paths =========================

# Define file paths
raw_data_path <- here("data", "raw")
processed_data_path <- here("data", "processed")

# ======================== Load Raw Data =============================

# Load required datasets
load(file.path(raw_data_path, "scarcity_project.RData"))
load(file.path(raw_data_path, "class_labelled_dataset RF.RData"))
load(file.path(raw_data_path, "stopwords.RData"))