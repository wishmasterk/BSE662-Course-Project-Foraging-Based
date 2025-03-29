# EEG and behavioral analysis of foraging under stress.

## Week 1

### EEG Foraging Task Preprocessing and Analysis

This project focuses on preprocessing EEG data collected during a foraging task involving different stress and environment conditions. The data is provided in EEGLAB `.set` format and includes event markers indicating various task phases such as prestress/poststress and short/long environment trials.

## 📁 Dataset

The dataset consists of six EEG recordings in `.set` format:

- `31730.set`
- `43000.set`
- `47131.set`
- `47204.set`
- `47324.set`
- `48328.set`

Each file contains annotations in the form of "TRIGGER EVENT X", where `X` is one of the following:

| Marker | Meaning                              |
|--------|---------------------------------------|
| B      | Start of prestress block              |
| I      | Start of poststress block             |
| M      | Fixation shape appears                |
| N      | Fixation shape turns green            |
| R      | Select leave option                   |
| T      | Travel time ~5s (short environment)   |
| U      | Travel time ~20s (long environment)   |

---

## 📦 Dependencies

This project is built using Python < 3.11 and depends on the following packages:

- [MNE](https://mne.tools/stable/index.html) (v1.8.0) — for EEG loading, filtering, and annotation processing
- `matplotlib` — for visualization

### ✅ Recommended Python Version

Python **3.8 – 3.10** (MNE v1.8 does not support 3.11+ fully)

---

## 🛠️ Installation (Google Colab Recommended)

To run in Google Colab:

1. Upload your `.set` files to the runtime.
2. Copy and paste the full preprocessing and analysis code (`Foraging.ipynb`).
3. Run the notebook cells.

Install dependencies in Colab using:

```python
!pip install mne==1.8.0
```




## Week 2–3: Segmentation and FOOOF Analysis  

### Goals

In Week 2–3, the primary focus was on **segmenting** the EEG data into meaningful windows, performing **power spectral density (PSD)** analysis, and applying **FOOOF** to separate the **aperiodic** and **oscillatory** components of the EEG signal. This analysis helps in identifying stress-related changes in the brain's oscillatory activity.

Key tasks for Week 2–3:
- Segment the data into **trial**, **patch**, and **environmental** windows.
- Compute **power spectral density (PSD)** for each segment.
- Use **FOOOF** to separate **aperiodic** from **oscillatory** components of the PSD.

---

## 📂 Week 2–3 Deliverables

### 1. Segmentation Strategy

The EEG data was segmented into three primary levels:
- **Trial-Level Segmentation**: Focuses on small, decision-related windows of approximately **3 seconds** centered on event markers such as "N" (fixation shape turns green).
- **Patch-Level Segmentation**: Segments representing **15–30 seconds** corresponding to each foraging patch, capturing task-related behavior.
- **Environment-Level Segmentation**: Longer windows used for analyzing the **pre-stress** and **post-stress** states.

### 2. FOOOF Analysis

- **In Python**:
  - We computed the **Power Spectral Density (PSD)** for each segment using **MNE’s `psd_welch` method**.
  - **FOOOF** was then applied to extract:
    - **Aperiodic Exponent** and **Offset**
    - **Oscillatory Peaks**
  
- **In Brainstorm**:
  - We used the **Brainstorm GUI** to compute PSD and run preliminary power spectrum analysis.
  - After computing the power spectrum in Brainstorm, we exported the data to **Python** for further analysis using **FOOOF**.

### 3. Classifying Stress States

To analyze the effect of stress, we compared the **pre-stress** and **post-stress** segments using:
- **Aperiodic Exponent** (to detect changes in neural activity related to stress).
- **Band Power** (to measure the power in various frequency bands).

### 4. Deliverables

- **Python Scripts**: 
  - Scripts that compute the **PSD** using `mne.time_frequency.psd_welch` and perform **FOOOF** analysis to extract **aperiodic** and **oscillatory components**.
  
- **Preliminary Plots**:
  - Plots comparing **aperiodic exponent distributions** for **pre- vs. post-stress conditions**.
  
- **Documentation**:
  - Documentation of key parameter choices for **PSD** computation and **FOOOF analysis**.

---
