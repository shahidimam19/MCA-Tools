# MCA File Separation Tool (PowerShell)

This PowerShell script helps extract **Form AOC** and **Form MGT** files from MCA's  
**"Annual Returns and Balance Sheet eForms"** folder structure.  

It automatically copies the files into a single folder named **`AOC/`** for easy access.

---

## 📂 Features
- Recursively searches inside **"Annual Returns and Balance Sheet eForms"** folders.  
- Extracts files named:
  - `Form AOC*`
  - `Form MGT*`  
- Handles files **without extensions** (assumes `.pdf`).  
- Handles **duplicate filenames** by appending `(1), (2), ...`.  
- Saves everything into a new folder called `AOC/`.

---

## ⚙️ Requirements
- **Windows PowerShell 5.1** or **PowerShell 7+**  
- No external dependencies  

---

## 🚀 Usage

1. Place this script (`MCA-File-Separation.ps1`) in the folder that contains your **MCA downloads**.  
   (The folder should have subfolders like `Annual Returns and Balance Sheet eForms`.)  

2. Open **PowerShell** in that folder.  

3. Run the script:
   ```powershell
   .\MCA-File-Separation.ps1
