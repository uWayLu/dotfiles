#!/usr/bin/env bash
set -u

usage() {
    cat <<'EOF'
Usage:
  classify_pdf.sh PDF_DIR

Description:
  Open PDFs in PDF_DIR one by one with zathura in two-page view.
  After choosing ok/nok in a GUI dialog, the PDF is moved to:
    PDF_DIR/ok/
    PDF_DIR/nok/

Requirements:
  zathura
  zenity

Example:
  classify_pdf.sh ~/Downloads/pdfs
EOF
}

case "${1:-}" in
    -h|--help|"")
        usage
        exit 0
        ;;
esac

pdf_dir="${1%/}"

if [ ! -d "$pdf_dir" ]; then
    echo "Error: not a directory: $pdf_dir" >&2
    exit 1
fi

mkdir -p "$pdf_dir/ok" "$pdf_dir/nok"

tmpconf="$(mktemp -d)"
trap 'rm -rf "$tmpconf"' EXIT

cat > "$tmpconf/zathurarc" <<'EOF'
set pages-per-row 2
set first-page-column 1
set adjust-open width
EOF

find "$pdf_dir" -maxdepth 1 -type f -name '*.pdf' -print0 |
while IFS= read -r -d '' f; do
    base="$(basename "$f")"

    setsid zathura -c "$tmpconf" "$f" >/dev/null 2>&1 &
    zpid=$!

    if zenity --question \
        --title="PDF 分類" \
        --text="這份 PDF 要放到 ok 嗎？\n\n$base" \
        --ok-label="Y / ok" \
        --cancel-label="N / nok"; then
        dest="$pdf_dir/ok"
    else
        dest="$pdf_dir/nok"
    fi

    kill -TERM "-$zpid" 2>/dev/null || kill -TERM "$zpid" 2>/dev/null || true
    wait "$zpid" 2>/dev/null || true

    mv -- "$f" "$dest/"
done
