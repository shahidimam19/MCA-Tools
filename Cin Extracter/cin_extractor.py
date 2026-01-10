import pdfplumber
import re
import os
import csv

# Regex for Indian CIN
CIN_PATTERN = r'[LU]\d{5}[A-Z]{2}\d{4}[A-Z]{3}\d{6}'

def get_cin(pdf_path):
    try:
        with pdfplumber.open(pdf_path) as pdf:
            text = ""
            # Check the first 2 pages
            for page in pdf.pages[:2]:
                page_text = page.extract_text()
                if page_text:
                    text += page_text
            
            match = re.search(CIN_PATTERN, text)
            return match.group(0) if match else "Not Found"
    except Exception:
        return "Error Reading File"

# Main execution
results = []
seen_cins = set() # To track duplicates
current_folder = os.getcwd()

print("--- Starting Extraction (Skipping Duplicates only) ---")

for root, dirs, files in os.walk(current_folder):
    for file in files:
        if file.lower().endswith(".pdf"):
            full_path = os.path.join(root, file)
            cin = get_cin(full_path)
            
            # Logic:
            # 1. If not found or error, always record it.
            if cin == "Not Found" or cin == "Error Reading File":
                results.append({"FileName": file, "CIN": cin})
                print(f"Recorded: {file} -> {cin}")
            
            # 2. If CIN is found, check if it's a duplicate.
            else:
                if cin not in seen_cins:
                    seen_cins.add(cin)
                    results.append({"FileName": file, "CIN": cin})
                    print(f"Added Unique: {cin} (from {file})")
                else:
                    # 3. Skip only if it is a duplicate CIN
                    print(f"Skipped Duplicate CIN: {cin} in {file}")

# Save results
csv_file = "extracted_cins.csv"
with open(csv_file, mode='w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=["FileName", "CIN" ])
    writer.writeheader()
    writer.writerows(results)


input("\nPress Enter to close...")