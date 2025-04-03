#!/usr/bin/env python3

import os
import json
import csv
import re

# TODO: there are 4 files that we are adding that are not in the token registry!
# check this validation 

# 01fb761b09aec85a63fb742c4dab2b72499bca6a6006b7594de6cb95          // Nice coin lot's of duplicates with filenames with sequence numbers
# 4bfe7acae1bd2599649962b146a1e47d2e14933809b367e804c61f86          // KoalaCoin
# 19309eb9c066253cede617dc635223ace320ae0bbdd5bd1968439cd0          // ギル The currency in all of the Final Fantasy games.
# 7f71940915ea5fe85e840f843c929eba467e6f050475bad1f10b9c274d1888c0  // SteveToken

# Folder containing JSON files
folder_path = "../../metadata-registry-testnet/registry"
metadata_output_file = "cip-26-metadata.csv"
logodata_output_file = "cip-26-logodata.csv"

# Maximum subject length
MAX_SUBJECT_LENGTH = 255

# List to store all rows
metadata_rows = []
metadata_rows_multi = []

multi_list = []
logodata_rows = []
i = 0
# Loop through all JSON files in the folder
for filename in os.listdir(folder_path):
    if filename.endswith(".json"):
        file_path = os.path.join(folder_path, filename)

        with open(file_path, "r", encoding="utf-8") as f:
            json_data = json.load(f)

        # Extract subject from JSON
        subject = json_data.get("subject", "")

        # Skip if subject length exceeds the limit
        if len(subject) > MAX_SUBJECT_LENGTH:
            print(f"Skipping {filename}: Subject length exceeds {MAX_SUBJECT_LENGTH} characters.")
            continue  # Skip this file

        # Extract sequence number from filename (assuming a pattern like "12345-something.json")
        print("1: " + filename)
        filename_no_extension = filename[:-5]
 
        if subject == filename_no_extension:
  
            row = {
                "subject": subject,
                # "sequence_number": sequence_number,
                "policy": json_data.get("policy", ""),
                "name": json_data.get("name", {}).get("value", ""),           
                "ticker": json_data.get("ticker", {}).get("value", ""),
                "url": json_data.get("url", {}).get("value", ""),
                "description": json_data.get("description", {}).get("value", ""),
                "decimals": json_data.get("decimals", {}).get("value", ""),
                "updated": "",
                "updated_by": "",
                "properties": "",
                "textsearch": ""
            }

            metadata_rows.append(row)
        else:
            if subject not in multi_list:
                multi_list.append(subject)
        
        
        logo_row = {
            "subject": subject,
            # "sequence_number": sequence_number,
            "logo": json_data.get("logo", {}).get("value", ""),
        }
        
        logodata_rows.append(logo_row)

print(multi_list)

# Write to CSV
with open(metadata_output_file, "w", newline="", encoding="utf-8") as csvfile:
    fieldnames = ["subject", "policy", "name", "ticker", "url", "description", "decimals", "updated", "updated_by", "properties", "textsearch"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    # Write header
    writer.writeheader()

    # Write all rows
    writer.writerows(metadata_rows)

with open(logodata_output_file, "w", newline="", encoding="utf-8") as csvfile:
    fieldnames = ["subject", "logo"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    # Write header
    writer.writeheader()

    # Write all rows
    writer.writerows(logodata_rows)

print(f"Metadata has been written to {metadata_output_file}")
print(f"Logo data has been written to {logodata_output_file}")
