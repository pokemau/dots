#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <executable_path> <desktop_name>"
    exit 1
fi

EXEC_PATH="$1"
DESKTOP_NAME="$2"
DESKTOP_FILE="$HOME/.local/share/applications/${DESKTOP_NAME}.desktop"
APP_DIR="$(dirname "$EXEC_PATH")"
APP_EXEC="$(basename "$EXEC_PATH")"

mkdir -p "$HOME/.local/share/applications"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${DESKTOP_NAME}
Exec=bash -c 'cd "${APP_DIR}" && "./${APP_EXEC}"'
Icon=utilities-terminal
Terminal=false
Categories=Utility;
EOF

chmod +x "$DESKTOP_FILE"

echo "✅ Desktop entry created at: $DESKTOP_FILE"
