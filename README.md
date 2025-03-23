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
