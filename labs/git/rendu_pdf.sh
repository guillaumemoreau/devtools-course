#!/usr/bin/env bash

# Output directory is configure here
OUTPUT_DIR="Rendus"

# Render markdown files using pandoc
for md_file in TP*.md; do
    pdf_file="${OUTPUT_DIR}/${md_file%.md}.pdf"
    echo "convert ${md_file} -> ${pdf_file} using pandoc"
    pandoc -f markdown -t latex -o "${pdf_file}" "${md_file}"
done

# Render slides using LibreOffice
#loimpress --convert-to pdf --outdir "${OUTPUT_DIR}" *.odp
