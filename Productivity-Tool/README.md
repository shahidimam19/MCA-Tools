# Folder File Counter

This Python script recursively counts the number of files inside specific subfolders in a given folder structure. The result is saved as an Excel file, with each subfolder's file count recorded for every main folder in the root directory.

### Purpose

The script is designed to:

* Traverse through each **Main Folder**.
* For each **Main Folder**, it checks any **subfolders** inside it (which could contain the 8 specified subfolders).
* Counts the number of files in the 8 specified subfolders:

  * "Annual Returns and Balance Sheet eForms"
  * "Certificates"
  * "Change in Directors"
  * "Charge Documents"
  * "Incorporation Documents"
  * "LLP Forms (Conversion of company to LLP)"
  * "Other Attachments"
  * "Other eForm Documents"
* If any subfolder is missing, it appends `0` to the result.
* Outputs the results to an **Excel file**.

---

## Features

* **Recursive folder traversal** to count files inside nested subfolders.
* **Handles missing subfolders** by placing `0` in the corresponding column.
* **Excel output** for easy viewing and further processing.
* **Dynamic folder handling**: Works with any "Main Folder" and its subfolders, regardless of the names.

---

## Requirements

Before running the script, make sure you have the following dependencies installed:

* **Python** (version 3.x or later)
* **pandas**: A data manipulation library.
* **openpyxl**: Required for saving Excel files in `.xlsx` format.

### Install Dependencies

You can install the necessary libraries using `pip`. Open your terminal or command prompt and run:

```bash
pip install pandas openpyxl
```

---

## Setup

1. **Place the Script in the Folder**:

   * Put the `productivity.py` script in the **root directory** where your main folders are located.
   * The directory structure should look something like this:

     ```
     root_folder
     │
     ├── Main Folder 1
     │   ├── Subfolder A
     │   │   ├── Annual Returns and Balance Sheet eForms
     │   │   ├── Certificates
     │   │   └── ...
     │   └── ...
     ├── Main Folder 2
     │   └── ...
     └── ...
     ```

---

## Usage

1. **Run the Script**:

   Open your terminal or command prompt, navigate to the directory where the script is located, and run:

   ```bash
   python productivity.py
   ```

2. **Output**:

   The script will create a file called `productivity.xlsx` in the same directory as the script. This Excel file will contain the following columns:

   * **Main Folder**: The name of the main folder.
   * **Subfolder Names**: The 8 subfolders you are counting files for, with the file counts in the corresponding columns.

   If a subfolder is missing, the script will append `0` in the corresponding column.

   Example output (Excel):

   | Main Folder   | Annual Returns and Balance Sheet eForms | Certificates | Change in Directors | Charge Documents | Incorporation Documents | LLP Forms(Conversion of company to LLP) | Other Attachments | Other eForm Documents |
   | ------------- | --------------------------------------- | ------------ | ------------------- | ---------------- | ----------------------- | --------------------------------------- | ----------------- | --------------------- |
   | Main Folder 1 | 12                                      | 5            | 0                   | 8                | 3                       | 10                                      | 0                 | 7                     |
   | Main Folder 2 | 10                                      | 4            | 3                   | 6                | 0                       | 5                                       | 0                 | 0                     |
   | Main Folder 3 | 7                                       | 6            | 2                   | 3                | 5                       | 4                                       | 9                 | 6                     |

---

