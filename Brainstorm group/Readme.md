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

Updates made on 4th april 2025(night)

These are updated csv files with reward column
Extra description of data:-
>> bhv_data_processing
Environment labels — long: 32, short: 41, separator: 1, bad: 1
✅ CSV file saved as 31730_prestress_processed.csv
>> bhv_data_processing
Environment labels — long: 42, short: 39, separator: 1, bad: 1
✅ CSV file saved as 43000_prestress_processed.csv
>> bhv_data_processing
Environment labels — long: 44, short: 39, separator: 1, bad: 1
✅ CSV file saved as 47131_prestress_processed.csv
>> bhv_data_processing
Environment labels — long: 28, short: 40, separator: 1, bad: 1
✅ CSV file saved as 47324_prestress_processed.csv
>> bhv_data_processing
Environment labels — long: 32, short: 37, separator: 1, bad: 1
✅ CSV file saved as 47204_prestress_processed.csv
>> bhv_data_processing
Environment labels — long: 38, short: 41, separator: 1, bad: 2
✅ CSV file saved as 48238_prestress_processed.csv
>> bhv_data_processing
Environment labels — long: 34, short: 42, separator: 1, bad: 1
✅ CSV file saved as 31730_poststress_processed.csv
>> bhv_data_processing
Environment labels — long: 39, short: 44, separator: 1, bad: 2
✅ CSV file saved as 43000_poststress_processed.csv
>> bhv_data_processing
Environment labels — long: 44, short: 39, separator: 1, bad: 1
✅ CSV file saved as 47131_poststress_processed.csv
>> bhv_data_processing
Environment labels — long: 38, short: 43, separator: 1, bad: 2
✅ CSV file saved as 47204_poststress_processed.csv
>> bhv_data_processing
Environment labels — long: 40, short: 23, separator: 1, bad: 3
✅ CSV file saved as 47324_poststress_processed.csv
>> bhv_data_processing
Environment labels — long: 39, short: 45, separator: 1, bad: 1
✅ CSV file saved as 48238_poststress_processed.csv

There are 2-3 cases where no. of trials does match(out of 12 files) by factor of 1. Rest all matched exactly. Probable description of mismatch is occurence of more bad trails.

Thanks

