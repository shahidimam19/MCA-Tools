import os
import shutil
import fitz  # PyMuPDF

# === Setup folders ===
base_folder = os.path.dirname(os.path.abspath(__file__))
pdf_folder = base_folder
output_folder = os.path.join(base_folder, "Extracted_XML")
os.makedirs(output_folder, exist_ok=True)

# Create only OLD, NEW, and Error folders
categories = ["OLD", "NEW", "Error"]
for cat in categories:
    os.makedirs(os.path.join(output_folder, cat), exist_ok=True)

def detect_taxonomy_from_xml(xml_bytes):
    """Decide taxonomy type by scanning XML content"""
    try:
        xml_text = xml_bytes.decode("utf-8", errors="ignore").lower()
        if "taxonomy/cni" in xml_text:
            return "OLD"
        elif "taxonomy/ind" in xml_text:
            return "NEW"
        else:
            return None  # No known taxonomy
    except Exception:
        return None

def extract_xml_from_pdf(pdf_path):
    """Extract embedded XML attachments and classify by XML content"""
    try:
        doc = fitz.open(pdf_path)
    except Exception:
        print(f"⚠️ Damaged PDF: {pdf_path}")
        copy_to_error(pdf_path)
        return

    extracted_any = False

    try:
        for i in range(doc.embfile_count()):
            info = doc.embfile_info(i)
            name = info["filename"]  # keep original filename
            data = doc.embfile_get(i)

            if not data:
                continue
            if not name.lower().endswith(".xml"):
                continue

            taxonomy = detect_taxonomy_from_xml(data)
            if taxonomy is None:
                continue  # skip unknown taxonomy

            # Save with original filename in the right folder
            output_path = os.path.join(output_folder, taxonomy, name)

            # Prevent overwrite if same filename already exists
            base, ext = os.path.splitext(output_path)
            counter = 1
            while os.path.exists(output_path):
                output_path = f"{base}_{counter}{ext}"
                counter += 1

            with open(output_path, "wb") as f:
                f.write(data)

            extracted_any = True
            print(f"📄 {os.path.basename(pdf_path)} → {taxonomy} → {output_path}")

        # If no valid taxonomy found, mark PDF as error
        if not extracted_any:
            print(f"⚠️ No valid XML taxonomy in {pdf_path}")
            copy_to_error(pdf_path)

    except Exception as e:
        print(f"⚠️ Error extracting from {pdf_path}: {e}")
        copy_to_error(pdf_path)
    finally:
        doc.close()

def copy_to_error(pdf_path):
    """Copy problematic PDFs into Error folder"""
    try:
        dest_path = os.path.join(output_folder, "Error", os.path.basename(pdf_path))
        shutil.copy(pdf_path, dest_path)
        print(f"❌ Copied to Error folder: {dest_path}")
    except Exception as e:
        print(f"⚠️ Failed to copy {pdf_path} to Error folder: {e}")

# === Process all PDFs ===
for file in os.listdir(pdf_folder):
    if file.lower().endswith(".pdf"):
        pdf_path = os.path.join(pdf_folder, file)
        extract_xml_from_pdf(pdf_path)

print("\n🎯 Done. All XMLs saved in subfolders (OLD, NEW). Error PDFs saved in 'Error' folder inside:", output_folder)
