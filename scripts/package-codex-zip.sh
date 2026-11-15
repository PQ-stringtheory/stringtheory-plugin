#!/usr/bin/env bash
set -euo pipefail

# Deterministically package the OpenAI ChatGPT & Codex plugin bundle (.zip)
# Usage:
#   ./scripts/package-codex-zip.sh [output-zip-path]
# Defaults to: <repo-root>/dist/stringtheory-codex-plugin-v1.0.0.zip

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(python3 -c "import json, pathlib; print(json.loads((pathlib.Path('$REPO_ROOT') / '.codex-plugin/plugin.json').read_text())['version'])")"
DEFAULT_OUT="${REPO_ROOT}/dist/stringtheory-codex-plugin-v${VERSION}.zip"
OUT_ZIP="${1:-$DEFAULT_OUT}"

# Resolve relative output path against caller's working directory before cd
mkdir -p "$(dirname "$OUT_ZIP")"
OUT_DIR="$(cd "$(dirname "$OUT_ZIP")" && pwd)"
OUT_FILE="${OUT_DIR}/$(basename "$OUT_ZIP")"

STAGE_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$STAGE_DIR"
}
trap cleanup EXIT

# Copy exact required Codex plugin contents cleanly (no .git or .DS_Store)
cp -R "${REPO_ROOT}/.codex-plugin" "${STAGE_DIR}/.codex-plugin"
cp "${REPO_ROOT}/.mcp.json" "${STAGE_DIR}/.mcp.json"
cp -R "${REPO_ROOT}/skills" "${STAGE_DIR}/skills"
cp -R "${REPO_ROOT}/assets" "${STAGE_DIR}/assets"
cp "${REPO_ROOT}/README.md" "${STAGE_DIR}/README.md"
cp "${REPO_ROOT}/LICENSE" "${STAGE_DIR}/LICENSE"

# Strip any accidental OS metadata files
find "$STAGE_DIR" \( -name '.DS_Store' -o -name 'Thumbs.db' -o -name '._*' \) -delete

rm -f "$OUT_FILE"
(
  cd "$STAGE_DIR"
  COPYFILE_DISABLE=1 zip -r -q -X "$OUT_FILE" \
    .codex-plugin \
    .mcp.json \
    skills \
    assets \
    README.md \
    LICENSE
)

echo "Packaged OpenAI/Codex plugin archive: ${OUT_FILE}"
