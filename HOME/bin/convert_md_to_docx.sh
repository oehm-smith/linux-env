#!/usr/bin/env bash
#
# build-resume.sh
#
# Converts Markdown to Word .docx using Pandoc.
# Input can come from -i <file.md> or STDIN if -i not provided.
# Output defaults to "Brooke Benjamin Oehm Smith - customised - YYYYMMDD-HHMM.docx"
# unless -o <file.docx> is specified.
#
# === Dependencies ===
# pandoc
#   macOS:   brew install pandoc
#   Ubuntu:  sudo apt-get install pandoc
#   Windows: choco install pandoc
#
# reference-a4.docx (optional)
#   Create in Word: Layout → Size → A4 → Save as reference-a4.docx
#

set -euo pipefail

INPUT_FILE=""
OUTPUT_FILE=""
TEMP_INPUT=""

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--input)
      INPUT_FILE="$2"
      shift 2
      ;;
    -o|--output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [-i input.md] [-o output.docx]"
      echo "If -i is omitted, reads from STDIN."
      echo "If -o is omitted, output is timestamped docx."
      exit 0
      ;;
    *)
      echo "❌ Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Handle input
if [[ -n "$INPUT_FILE" ]]; then
  if [[ ! -f "$INPUT_FILE" ]]; then
    echo "❌ Error: Input file '$INPUT_FILE' not found."
    exit 1
  fi
else
  if [ -t 0 ]; then
    echo "❌ Error: No input provided. Use -i <file.md> or pipe markdown via STDIN."
    exit 1
  fi
  TEMP_INPUT="$(mktemp -t resume_md_XXXXXX.md)"
  cat - > "$TEMP_INPUT"
  INPUT_FILE="$TEMP_INPUT"
fi

# Handle output
if [[ -z "$OUTPUT_FILE" ]]; then
  TS="$(date '+%Y%m%d-%H%M')"   # ISO-like, safe for filenames
  OUTPUT_FILE="Brooke Benjamin Oehm Smith - customised - ${TS}.docx"
fi

# Safety: prompt before overwrite
if [[ -f "$OUTPUT_FILE" ]]; then
  read -r -p "⚠️  Output file '$OUTPUT_FILE' exists. Overwrite? (y/N) " CONFIRM
  case "$CONFIRM" in
    y|Y ) echo "➡️  Overwriting $OUTPUT_FILE...";;
    * ) echo "❌ Aborted."; [[ -n "$TEMP_INPUT" ]] && rm -f "$TEMP_INPUT"; exit 1;;
  esac
fi

# Reference template for A4
REFERENCE_DOC="reference-a4.docx"

if [[ -f "$REFERENCE_DOC" ]]; then
  pandoc "$INPUT_FILE" \
    --from markdown \
    --to docx \
    --output "$OUTPUT_FILE" \
    --reference-doc="$REFERENCE_DOC"
else
  pandoc "$INPUT_FILE" \
    --from markdown \
    --to docx \
    --output "$OUTPUT_FILE"
fi

# Cleanup temp input if we created one
[[ -n "$TEMP_INPUT" ]] && rm -f "$TEMP_INPUT"

# Copy output filename to clipboard (macOS)
if command -v pbcopy >/dev/null 2>&1; then
  echo -n "$OUTPUT_FILE" | pbcopy
  echo "✅ Built: $OUTPUT_FILE (path saved to clipboard)"
else
  echo "✅ Built: $OUTPUT_FILE"
  echo "ℹ️  Install pbcopy (macOS) or xclip/wl-copy (Linux) to auto-copy the filename."
fi
