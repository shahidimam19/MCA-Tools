
# PowerShell Folder Restructurer & XBRL Sorter

This PowerShell script automates the complex reorganization of corporate filing folders. It merges duplicate directories, enforces a standardized folder structure, resolves filename conflicts, and categorizes folders based on file content (XBRL vs. non-XBRL).

---

## 🚀 Features

### 🔹 Smart Folder Merging

* Detects folders with the same base name that differ only by trailing numbers
  (e.g., `Company Name` and `Company Name 2`).
* Automatically merges them into a single folder.

### 🔹 Automatic Conflict Resolution

* If duplicate filenames are encountered during merging, the script appends a numeric suffix
  (e.g., `document.pdf` → `document_1.pdf`) to prevent overwriting.

### 🔹 V3 Standardized Directory Structure

* Creates the following nested path inside each company folder:

  ```
  V3/
  └── Annual Returns and Balance Sheet eForms/
  ```
* Moves all files into this standardized location.

### 🔹 Automated XBRL Sorting

* Scans all files within a company folder.
* If **any** file contains the keyword `xbrl` (case-insensitive):

  * The entire folder is moved to the `XBRL` root directory.
* Otherwise:

  * The folder is moved to the `Normal` root directory.

### 🔹 Robust Error Handling

* Verifies paths before performing operations to prevent *File Not Found* errors.
* Gracefully handles *Access Denied* scenarios without terminating execution.

---

## 📂 Folder Structure Transformation

### **Before**

```
Main Folder/
├── ALCODES MOBILITY PRIVATE LIMITED/
│   └── doc1.pdf
├── ALCODES MOBILITY PRIVATE LIMITED2/
│   └── doc1.pdf
└── ARISTO DEVELOPER/
    └── xbrl_report.zip
```

### **After**

```
Main Folder/
├── Normal/
│   └── ALCODES MOBILITY PRIVATE LIMITED/
│       └── V3/
│           └── Annual Returns and Balance Sheet eForms/
│               ├── doc1.pdf
│               └── doc1_1.pdf
└── XBRL/
    └── ARISTO DEVELOPER/
        └── V3/
            └── Annual Returns and Balance Sheet eForms/
                └── doc1_xbrl.pdf
```

---

## 🛠️ How to Use

### 1️⃣ Download

Copy the script **`organize_folders.ps1`** into your **Main Folder** (the directory containing all company folders).

### 2️⃣ Execute

**Option A:**

* Right-click the script
* Select **Run with PowerShell**

**Option B (Execution Policy Restricted):**

1. Open PowerShell in the Main Folder
2. Run:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\organize_folders.ps1
   ```

### 3️⃣ Review

* Once the script finishes, a success message will appear.
* Press **Enter** to exit.

---
