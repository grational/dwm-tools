#!/usr/bin/env bash
set -euo pipefail

app='google keep'
handler="${HOME}/bin/dwm/dwm-tools/wrappers/browser-app.sh"

"${handler}" "${app}"
