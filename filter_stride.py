#!/usr/bin/env python3
import sys
import re
from pathlib import Path

REPO_DIR = Path("known-cyber-attacks")

if len(sys.argv) != 2:
    print("Usage: python3 filter_stride.py <STRIDE category>")
    print("Example: python3 filter_stride.py Tampering")
    sys.exit(1)

category = sys.argv[1].strip().lower()
matches = []

# iterate through all README.md files in subfolders
for readme in REPO_DIR.glob("*/README.md"):
    text = readme.read_text(encoding="utf-8", errors="ignore")
    # find if the STRIDE category is mentioned (case-insensitive)
    if re.search(rf"\b{re.escape(category)}\b", text, re.IGNORECASE):
        attack_name = readme.parent.name
        matches.append(attack_name)

if matches:
    print(f"Attacks matching STRIDE category '{category.capitalize()}':")
    for m in matches:
        print(f" - {m}")
else:
    print(f"No attacks found for category '{category.capitalize()}'.")

