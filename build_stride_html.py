#!/usr/bin/env python3
from pathlib import Path
import re
import html
from datetime import datetime

REPO_DIR = Path("known-cyber-attacks")
OUTPUT = Path("attacks_by_stride.html")
STRIDE = [
    "Spoofing", "Tampering", "Repudiation",
    "Information Disclosure", "Denial of Service",
    "Elevation of Privilege"
]

def slugify(s): return re.sub(r'\W+', '-', s.strip().lower())

def detect_stride_categories(text):
    found = []
    for cat in STRIDE:
        if re.search(rf'\b{re.escape(cat)}\b', text, re.I):
            found.append(cat)
    return found

def read_attacks():
    attacks = []
    for d in sorted(REPO_DIR.iterdir()):
        if not d.is_dir() or d.name.lower() == "template":
            continue
        f = d / "README.md"
        if f.exists():
            text = f.read_text(encoding="utf-8", errors="ignore")
            cats = detect_stride_categories(text)
            attacks.append({
                "name": d.name, "text": text, "cats": cats, "anchor": slugify(d.name)
            })
    return attacks

def build_html(attacks):
    cat_map = {c: [] for c in STRIDE}
    cat_map["Uncategorized"] = []
    for a in attacks:
        if a["cats"]:
            for c in a["cats"]:
                cat_map.setdefault(c, []).append(a)
        else:
            cat_map["Uncategorized"].append(a)

    head = f"""<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>Known Cyber Attacks</title></head>
<body>
<h1>Known Cyber Attacks — STRIDE</h1>
<div id="menu">
"""
    for cat, items in cat_map.items():
        head += f"<h2>{cat} ({len(items)})</h2><ul>"
        for a in items:
            head += f'<li><a href="#{a["anchor"]}">{html.escape(a["name"])}</a></li>'
        head += "</ul>\n"
    head += "</div>\n<div id='content'>\n"
    for a in attacks:
        head += f'<h2 id="{a["anchor"]}">{html.escape(a["name"])}</h2>\n'
        head += f"<pre>{html.escape(a['text'])}</pre>\n"
    tail = """
</div>
<footer>Generated on {date}</footer>
</body>
</html>
""".format(date=datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC"))
    return head + tail

def main():
    attacks = read_attacks()
    if not attacks:
        print("No attacks found in 'known-cyber-attacks'")
        return
    html_out = build_html(attacks)
    OUTPUT.write_text(html_out, encoding="utf-8")
    print(f"HTML file generated: {OUTPUT} ({len(attacks)} attacks)")

if __name__ == "__main__":
    main()

