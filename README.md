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

