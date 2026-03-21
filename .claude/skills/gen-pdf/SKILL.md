# gen-pdf

Generate the PDF from the literate noweb document.

## Instructions

Run these commands from the project root.

If any of these steps fail, stop and inform the user.

1. Tangle: `python weave.py main.nw output`
2. Generate font_data.tex: `python font_data.py 83A5 92A4 font_data.tex`
3. Ensure the output directory exists, creating it if it doesn't: `mkdir -p output`
4. Run pdflatex once: `pdflatex --output-directory=. output/main.tex`
5. Run pdflatex again (to resolve references): `pdflatex --output-directory=. output/main.tex`
