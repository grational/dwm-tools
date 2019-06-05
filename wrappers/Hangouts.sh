#!/usr/bin/env bash
set -euo pipefail

# old chrome app handler
# ----------------------
# app='google hangouts'
# handler="${HOME}/bin/dwm/dwm-tools/wrappers/browser-app.sh"
# ${handler}" "${app}"

google-chrome --new-window --app=http://hangouts.google.com &
