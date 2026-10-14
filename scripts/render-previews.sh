#!/usr/bin/env bash
set -euo pipefail

# Render the bundled template for the README. Install the local Typst package first.
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
preview_dir="$project_dir/docs/images"
for tool in typst pdfinfo pdftoppm awk; do
    command -v "$tool" >/dev/null || { echo "Missing required tool: $tool" >&2; exit 1; }
done

cd "$project_dir/template"
mkdir -p dist/spiral dist/library dist/paperback "$preview_dir"
typst compile --font-path assets/fonts main.typ dist/spiral/thesis-spiral.pdf
typst compile --font-path assets/fonts --input binding=library main.typ dist/library/thesis.pdf
typst compile --font-path assets/fonts --input binding=paperback main.typ dist/paperback/thesis-body.pdf
body_pages="$(pdfinfo dist/paperback/thesis-body.pdf | awk '/^Pages:/ {print $2}')"
typst compile --font-path assets/fonts --input "page_count=$body_pages" cover.typ dist/paperback/thesis-cover.pdf

render_page() {
    pdftoppm -f "$2" -l "$2" -singlefile -scale-to "$4" -png "$1" "$3"
}

spiral_pdf=dist/spiral/thesis-spiral.pdf
last_page="$(pdfinfo "$spiral_pdf" | awk '/^Pages:/ {print $2}')"
# These page numbers refer to the bundled template. Update them if its structure changes.
render_page "$spiral_pdf" 1 "$project_dir/thumbnail" 1400
render_page dist/library/thesis.pdf 1 "$preview_dir/library-cover" 1400
render_page "$spiral_pdf" 3 "$preview_dir/examination-committee" 1400
render_page "$spiral_pdf" 13 "$preview_dir/contents" 1400
render_page "$spiral_pdf" 17 "$preview_dir/chapter-opening" 1400
render_page "$spiral_pdf" "$last_page" "$preview_dir/back-cover" 1400
render_page dist/paperback/thesis-cover.pdf 1 "$preview_dir/paperback-spread" 1800

echo "README previews written to docs/images/ and thumbnail.png"
