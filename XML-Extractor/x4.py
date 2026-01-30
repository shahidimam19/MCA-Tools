import os
import shutil
import hashlib
import fitz  # PyMuPDF

# === Setup folders ===
base_folder = os.path.dirname(os.path.abspath(__file__))
pdf_folder = base_folder
output_folder = os.path.join(base_folder, "Extracted_XML")
os.makedirs(output_folder, exist_ok=True)

# Only create OLD and NEW. Error is for the PDF files.
for cat in ["OLD", "NEW"]:
    os.makedirs(os.path.join(output_folder, cat), exist_ok=True)

def get_content_hash(data):
    """Creates a unique fingerprint to avoid saving the same XML twice."""
    return hashlib.md5(data).hexdigest()

def detect_taxonomy_from_xml(xml_bytes):
    """Strict detection for MCA XBRL taxonomies."""
    try:
        content = ""
        # Try different encodings to ensure the text is readable
        for encoding in ['utf-8', 'utf-16', 'latin-1']:
            try:
                content = xml_bytes.decode(encoding).lower()
                break
            except:
                continue
        
        if not content: return None

        if any(x in content for x in ["taxonomy/ind", "/ind-as", "ind-as"]):
            return "NEW"
        if any(x in content for x in ["taxonomy/cni", "/cni-as", "cni"]):
            return "OLD"
        
        return None # Not classified
    except:
        return None

def extract_xml_refined(pdf_path):
    try:
        doc = fitz.open(pdf_path)
        pdf_name = os.path.basename(pdf_path)
    except Exception:
        return

    saved_hashes = set()
    successfully_classified_any = False

    # Get list of all embedded files
    entry_list = doc.embfile_names()

    for entry in entry_list:
        try:
            info = doc.embfile_info(entry)
            filename = info["filename"]
            
            if not filename.lower().endswith(".xml"):
                continue

            data = doc.embfile_get(entry)
            if not data: continue

            # Detect Taxonomy
            taxonomy = detect_taxonomy_from_xml(data)
            
            # CHANGE: If not OLD or NEW, we ignore this XML entirely
            if taxonomy is None:
                continue

            # DUPLICATION CHECK (only for classified files)
            file_hash = get_content_hash(data)
            if file_hash in saved_hashes:
                continue 
            
            # Save the file into OLD or NEW
            target_path = os.path.join(output_folder, taxonomy, filename)
            
            # Handle filename collisions from different PDFs
            if os.path.exists(target_path):
                base, ext = os.path.splitext(filename)
                target_path = os.path.join(output_folder, taxonomy, f"{base}_{file_hash[:6]}{ext}")

            with open(target_path, "wb") as f:
                f.write(data)
            
            saved_hashes.add(file_hash)
            successfully_classified_any = True
            print(f"✅ Extracted {taxonomy}: {filename} from {pdf_name}")

        except Exception as e:
            print(f"⚠️ Error processing entry in {pdf_name}: {e}")

    # If NO XML was classified as OLD or NEW, move the PDF to Error
    if not successfully_classified_any:
        print(f"❌ No valid taxonomy found. Moving PDF to Error: {pdf_name}")
        error_dir = os.path.join(output_folder, "Error")
        os.makedirs(error_dir, exist_ok=True)
        shutil.copy(pdf_path, os.path.join(error_dir, pdf_name))

    doc.close()

# === Process all PDFs ===
for file in os.listdir(pdf_folder):
    if file.lower().endswith(".pdf"):
        extract_xml_refined(os.path.join(pdf_folder, file))

print(f"\n🎯 Process Complete. Results are in: {output_folder}")