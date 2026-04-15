# Create PDF from Markdown

Generate a PDF from a markdown document using `convertproj.sh`.

## Usage
- `/create-pdf <file>` — generate PDF from a specific markdown file
- Also triggered by natural language: "create PDF for ...", "generate PDF from ...", etc.

## Instructions

1. Find the markdown file in the current project (use glob if path not given, don't guess)
2. Run: `convertproj.sh -f pdf -t bespoke.docx <path-to-markdown>`
3. Output goes to `dist/` under the project root
4. Report the output path to the user
