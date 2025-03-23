# Behavioral Data CSV Files for Stress x Environment Study

This repository contains the processed CSV files for the behavioral (bhv) group data from our stress x environment experiment. These files were generated using MATLAB scripts that read and process raw `.bhv` files with the `bhv_read.m` function. 

## Repository Contents

- **CSV Files:**  
  - `48238_prestress_processed.csv` – Processed CSV for subject 48238 under the pre-stress condition.
  - Same is done for other files also.

## Data Description

Each CSV file includes the following columns:
- **subid:** Subject identifier.
- **stress_cond:** Stress condition (e.g., pre, post).
- **env:** Environment label (e.g., short travel time, long travel time).
- **trial_time:** Timestamp of when the trial started.
- **reaction_time:** Reaction time recorded for the trial.
- **reward:** Reward received (aligned with good trials).

## Processing Pipeline

The CSV files were generated using the following steps:
1. **Data Import:**  
   - The `bhv_read.m` function reads raw `.bhv` files into a MATLAB structure.
2. **Environment Separation:**  
   - The reaction time vector contains a `NaN` that separates the short and long travel time environments, with extra trailing `NaN` values for bad trials ignored.
3. **Reward Alignment:**  
   - The reward data (from the `RewardRecord` field) is aligned with the valid trials, ensuring rewards correspond only to good trials.
4. **Table Creation and Export:**  
   - The processed data is organized into a MATLAB table with the columns `[subid, stress_cond, env, trial_time, reaction_time, reward]` and then exported as a CSV file.



