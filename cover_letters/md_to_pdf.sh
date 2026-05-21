#!/usr/bin/env bash
# Convert a Markdown cover letter to PDF using pandoc + xelatex in Docker.
#
# Usage:
#   cover_letters/md_to_pdf.sh <path-to-cover-letter.md> [output.pdf]
#
# If no output path is given, the PDF is written to output/<basename>.pdf
# at the repository root.

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <path-to-cover-letter.md> [output.pdf]" >&2
  exit 1
fi

INPUT="$1"

if [[ ! -f "$INPUT" ]]; then
  echo "Error: input file '$INPUT' does not exist" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

INPUT_ABS="$(cd "$(dirname "$INPUT")" && pwd)/$(basename "$INPUT")"

case "$INPUT_ABS" in
  "$REPO_ROOT"/*) ;;
  *)
    echo "Error: input file must live inside the repo ($REPO_ROOT)" >&2
    exit 1
    ;;
esac

INPUT_REL="${INPUT_ABS#"$REPO_ROOT"/}"

if [[ $# -eq 2 ]]; then
  OUTPUT="$2"
  mkdir -p "$(dirname "$OUTPUT")"
  OUTPUT_ABS="$(cd "$(dirname "$OUTPUT")" && pwd)/$(basename "$OUTPUT")"
else
  BASENAME="$(basename "$INPUT" .md)"
  mkdir -p "$REPO_ROOT/output"
  OUTPUT_ABS="$REPO_ROOT/output/${BASENAME}.pdf"
fi

case "$OUTPUT_ABS" in
  "$REPO_ROOT"/*) ;;
  *)
    echo "Error: output file must live inside the repo ($REPO_ROOT)" >&2
    exit 1
    ;;
esac

OUTPUT_REL="${OUTPUT_ABS#"$REPO_ROOT"/}"

PANDOC_IMAGE="${PANDOC_IMAGE:-pandoc/latex:latest}"
# The official pandoc/latex image ships amd64 only, so force the platform
# for users on arm64 hosts (e.g. Apple Silicon). Override with
# PANDOC_PLATFORM="" to opt out.
PANDOC_PLATFORM="${PANDOC_PLATFORM:-linux/amd64}"

echo "Converting $INPUT_REL -> $OUTPUT_REL"

PLATFORM_ARGS=()
if [[ -n "$PANDOC_PLATFORM" ]]; then
  PLATFORM_ARGS=(--platform "$PANDOC_PLATFORM")
fi

docker run --rm \
  "${PLATFORM_ARGS[@]}" \
  -v "$REPO_ROOT:/data" \
  -w /data \
  "$PANDOC_IMAGE" \
  "$INPUT_REL" \
  -o "$OUTPUT_REL" \
  --pdf-engine=xelatex \
  -V geometry:a4paper \
  -V geometry:margin=2.2cm \
  -V fontsize=11pt \
  -V linkcolor=black

echo "Wrote $OUTPUT_REL"
