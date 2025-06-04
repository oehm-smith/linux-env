# Diff-Copy Script Templates

This directory contains template files for generating customized diff and copy utilities.

## Template Files

### `template_diff-copy_docopy.sh`
Template for generating `docopy.sh` scripts that copy files from a source directory to a destination directory with automatic backup functionality.

**Features:**
- Copies single files or entire directories
- Recursive directory copying with `-r` flag
- Automatic backup of existing files (numbered: `-orig`, `-orig.1`, `-orig.2`, etc.)
- Parses diff "Only in" output for workflow integration
- Strips directory prefixes automatically
- Comprehensive help with `-h/--help`

### `template_diff-copy_dodiff.sh`
Template for generating `dodiff.sh` scripts that show differences between files in two directories.

**Features:**
- Side-by-side diff view (default)
- Inline diff mode with `--inline` flag
- Automatic directory prefix stripping
- Comprehensive help with `-h/--help`

## Placeholders

Both templates use the following placeholders that get replaced during generation:

- `{{SOURCE_DIR}}` - The source directory (where files are copied FROM)
- `{{DEST_DIR}}` - The destination directory (where files are copied TO)

## Usage

These templates are used by the `generate-diff-copy.sh` script to create customized utilities for specific directory pairs.

```bash
# Generate scripts for specific directories
../generate-diff-copy.sh /path/to/source /path/to/destination ./output

# Creates:
./output/docopy.sh  # Configured for your directories
./output/dodiff.sh  # Configured for your directories
