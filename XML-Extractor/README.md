# MCA XML Extractor Tool (Python)

This tool extracts embedded **XML attachments** from MCA's **XBRL AOC PDF** files.  
It detects the taxonomy type and saves XMLs into separate folders for easy classification.

---

## 📂 Features
- Extracts embedded XMLs from MCA AOC PDFs.  
- Detects taxonomy type automatically:
  - **OLD** → if XML contains `taxonomy/cni`
  - **NEW** → if XML contains `taxonomy/ind`
- Saves extracted files into folders:
  - `OLD/`
  - `NEW/`
  - `Error/` → for corrupted PDFs or unknown taxonomy
- Prevents overwriting by renaming duplicates (`file_1.xml`, `file_2.xml`, etc.).

---

## ⚙️ Requirements

### Python
- **Python 3.8+** (recommended: Python 3.10 or above)

### Python Libraries
Install dependencies with:
```bash
pip install pymupdf
