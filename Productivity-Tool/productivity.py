import os
import pandas as pd

# Get the current directory where the script is located
root_folder = os.getcwd()

# List of subfolder names to look for
subfolder_names = [
    "Annual Returns and Balance Sheet eForms", "Certificates", "Change in Directors", 
    "Charge Documents", "Incorporation Documents", "LLP Forms(Conversion of company to LLP)", 
    "Other Attachments", "Other eForm Documents"
]

# List to hold the data for the final sheet
data = []

# Traverse each main folder in the root folder
for main_folder in os.listdir(root_folder):
    main_folder_path = os.path.join(root_folder, main_folder)
    
    if os.path.isdir(main_folder_path):  # Check if it's a folder
        print(f"Processing Main Folder: {main_folder}")  # Debugging
        
        # Traverse each subfolder inside the main folder
        for subfolder in os.listdir(main_folder_path):
            inner_folder_path = os.path.join(main_folder_path, subfolder)
            
            if os.path.isdir(inner_folder_path):  # Check if it's a subfolder
                print(f"  Found Subfolder: {subfolder}")  # Debugging
                row = [main_folder]  # Start the row with the main folder name
                
                # Check each required subfolder and count the files
                for required_subfolder in subfolder_names:
                    required_subfolder_path = os.path.join(inner_folder_path, required_subfolder)
                    
                    if os.path.isdir(required_subfolder_path):  # If subfolder exists
                        # Count the files in the subfolder
                        file_count = len([f for f in os.listdir(required_subfolder_path) if os.path.isfile(os.path.join(required_subfolder_path, f))])
                        row.append(file_count)
                        print(f"    {required_subfolder}: {file_count} files")  # Debugging
                    else:
                        # If subfolder does not exist, append 0
                        row.append(0)
                        print(f"    {required_subfolder}: 0 (subfolder missing)")  # Debugging
                
                # Append the row to the data
                data.append(row)

# Check if any data was collected
if data:
    # Create a DataFrame and write it to an Excel file
    df = pd.DataFrame(data, columns=["Main Folder"] + subfolder_names)
    df.to_excel("folder_file_counts.xlsx", index=False)
    print("Excel file created successfully!")
else:
    print("No data was collected. Please check folder paths and names.")
