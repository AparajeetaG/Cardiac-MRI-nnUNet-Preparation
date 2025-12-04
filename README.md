# Cardiac-MRI-nnUNet-Preparation
Automated MATLAB-to-nnU-Net pipeline for converting raw cardiac MRI data into 3D, multi-modal, segmentation-ready NIfTI volumes with standardized labels.
# 🫀 Cardiac MRI nnU-Net Preparation Pipeline

This repository demonstrates a **complete end-to-end image preprocessing pipeline** that transforms raw cardiac MRI `.mat` data into standardized **3D NIfTI volumes** ready for deep learning segmentation using **nnU-Net**.  

Developed in MATLAB and Python, this workflow showcases:
- Multi-modal medical image data engineering (magnitude + T2* mapping)
- Automated slice stacking and 3D volume synthesis
- Structured label generation and integrity validation
- Cross-platform dataset preparation (MATLAB → Python → nnU-Net)

---

## 🧠 Project Motivation

Medical imaging datasets often exist as complex multi-slice `.mat` structures containing multiple modalities and time-phases per subject.  
This project automates:
- **Loading and interpreting MATLAB-based imaging structures**
- **Reformatting data** into the `.nii.gz` format compatible with nnU-Net
- **Generating standardized dataset metadata** (`dataset.json`)
- Ensuring consistency and reproducibility across large multi-phase MRI studies.

This work demonstrates my ability to handle complex data pipelines — from signal-level MATLAB structures to standardized AI-ready data formats.

---

## ⚙️ Pipeline Overview

| Stage | Description | Tools Used |
|--------|--------------|-------------|
| 1️⃣ Data extraction | Load `.mat` MRI data, isolate `Mag_all`, `Mask_myo`, `T2Map_all` | MATLAB |
| 2️⃣ Conversion | Convert to `.nii` / `.nii.gz` format | MATLAB NIfTI Toolbox |
| 3️⃣ Stacking | Combine multi-slice 2D images into 3D volumes | MATLAB |
| 4️⃣ Label alignment | Ensure image–mask alignment per cardiac phase | MATLAB |
| 5️⃣ Verification | Validate shape, naming, and modality integrity | MATLAB |
| 6️⃣ Dataset definition | Create `dataset.json` and folder structure for nnU-Net | Python |
| 7️⃣ Training ready | Data fully structured under `nnUNet_raw_data/Dataset501_MVD` | nnU-Net |

---

## 🧩 Repository Structure
Cardiac-MRI-nnUNet-Preparation/
│
├── MATLAB/
│ ├── convert_mat_to_nifti.m # Extracts and converts .mat to NIfTI
│ ├── stack_slices_to_3D.m # Stacks 2D slices into 3D volumes
│ ├── stack_labels_to_3D.m # Creates 3D label masks
│ ├── consistency_check.m # Checks shape, modality, and label alignment
│
├── dataset_setup/
│ └── make_dataset_json.py # Generates nnU-Net dataset.json automatically
│
├── notes/
│ └── data_structure_explained.md # Documentation of data hierarchy and mapping
│
├── README.md
└── .gitignore





---

## 🧰 Technologies and Skills Demonstrated

- **MATLAB (Advanced):**  
  Structured data handling, volumetric reconstruction, and automated file generation  
  (includes scripting for multi-phase cardiac MRI).

- **Medical Image Processing:**  
  Multi-modal data normalization, 3D stack synthesis, and label integrity checking.

- **Python (Intermediate):**  
  Dataset configuration automation for nnU-Net (`dataset.json` generation).

- **Deep Learning Data Management:**  
  Understanding and implementing nnU-Net dataset standards for multi-channel inputs.

- **Cross-platform Workflow:**  
  MATLAB (Windows) → Linux/WSL (Python + nnU-Net).

---

## 🧠 Example Workflow

1. Convert `.mat` → `.nii`:
   ```matlab
   convert_mat_to_nifti.m


Stack slices → 3D:
stack_slices_to_3D.m

stack_labels_to_3D.m

Verify dataset:
consistency_check.m

 Resulting Dataset Structure

 Dataset501_MVD/
├── imagesTr/
│   ├── subj001_phase01_0000.nii.gz  # Modality 1 (Magnitude)
│   ├── subj001_phase01_0001.nii.gz  # Modality 2 (T2* Map)
│   └── ...
├── labelsTr/
│   ├── subj001_phase01.nii.gz
│   └── ...
└── dataset.json


📊 Demonstrated Abilities
**3D medical image reconstruction from multi-dimensional MATLAB matrices
Automated multimodal dataset generation for segmentation models
Data validation and sanity checks
Building reproducible, research-grade data preparation pipelines**




👩‍💻 Author

A. Guha
Biomedical Engineering | Cedars-Sinai Health System
MRI Data Processing • Deep Learning • Image Segmentation • Automation
