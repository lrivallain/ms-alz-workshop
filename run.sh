#!/bin/bash
set -e

rm docs/index.md || true
ln -s ../README.md docs/index.md

echo "Starting MkDocs server..."
uv run mkdocs serve --dev-addr 0.0.0.0:8000 --config-file ./mkdocs.yml --verbose --livereload