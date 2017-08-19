#!/usr/bin/env bash
set -euo pipefail

app="${@}"
app_dir="${HOME}/.local/share/applications"
app_file="$(grep -Rli "${app}" "${app_dir}")"
wrapper_cmd=$(grep -oP 'Exec=\K.*' "${app_file}")

eval $wrapper_cmd
