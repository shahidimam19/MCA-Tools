# MCA Tools

A collection of tools to help process files downloaded from the **MCA (Ministry of Corporate Affairs, India)** portal.

## 📌 Tools Included

### 1. File Separation Tool (PowerShell)
- Extracts **Form AOC** and **Form MGT** from "Annual Returns and Balance Sheet eForms".
- Handles missing extensions (assumes `.pdf`).
- Handles duplicate filenames.
- Saves everything inside `AOC/` folder.

👉 [File-Separation/](File-Separation)

---

### 2. XML Extractor Tool (Python)
- Extracts **embedded XML attachments** from MCA's **XBRL AOC PDFs**.
- Detects **taxonomy type**:
  - `OLD` (if contains `taxonomy/cni`)
  - `NEW` (if contains `taxonomy/ind`)
- Saves extracted XML into folders: `OLD/`, `NEW/`, `Error/`.

👉 [XML-Extractor/](XML-Extractor)

---

## 🚀 Getting Started

### Clone the repo
```bash
git clone https://github.com/yourusername/MCA-Tools.git
cd MCA-Tools
