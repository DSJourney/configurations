#!/usr/bin/env python

import PyPDF2
import os

# Get all the PDF files in the current directory
pdf_files = [f for f in os.listdir('.') if f.endswith('.pdf')]

# Sort the files alphabetically
pdf_files.sort()

# print the files
[print(file) for file in pdf_files]

# Create a new PDF file
merged_pdf = PyPDF2.PdfWriter()

# Iterate over all the PDF files
for pdf_file in pdf_files:
    # Open the PDF file
    with open(pdf_file, 'rb') as f:
        # Read the PDF file
        reader = PyPDF2.PdfReader(f)
        # Iterate over all the pages in the PDF file
        for page in reader.pages:
            # Add the page to the merged PDF file
            merged_pdf.add_page(page)

# Write the merged PDF file to a new file
with open('merged.pdf', 'wb') as f:
    merged_pdf.write(f)
