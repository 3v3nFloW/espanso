#!/bin/bash
# Replaces /Applications/Espanso.app with this fork (target/mac/Espanso.app).
# Backup of the original: ~/Applications/Espanso-original-<version>.app — revert with kappa1/revert.sh
set -euo pipefail
cd "$(dirname "$0")/.."
NEW=target/mac/Espanso.app
[ -x "$NEW/Contents/MacOS/espanso" ] || { echo "Fork not built ($NEW missing)"; exit 1; }
OLD=/Applications/Espanso.app
old_version=$( ("$OLD/Contents/MacOS/espanso" --version 2>/dev/null || true) | awk 'NR==1 {print $NF}')
old_version=${old_version:-unknown}
BACKUP="$HOME/Applications/Espanso-original-${old_version}.app"

echo "1/4 stopping espanso"
"$OLD/Contents/MacOS/espanso" stop 2>/dev/null || true
sleep 1

echo "2/4 backing up the original → $BACKUP"
mkdir -p "$HOME/Applications"
if [[ "$old_version" != *kappa1* ]]; then
  [ -e "$BACKUP" ] || ditto "$OLD" "$BACKUP"
fi

echo "3/4 installing the fork ($("$NEW/Contents/MacOS/espanso" --version))"
rm -rf "$OLD"
ditto "$NEW" "$OLD"
xattr -cr "$OLD"

# The Accessibility entry stores the code signature. An old entry (official espanso = team 6424323YUH, or an earlier
# fork build with a different cdhash) does not match and cannot be fixed by toggling it off and on → reset it;
# macOS creates a matching one on the next start (just switch it on).
tccutil reset Accessibility com.federicoterzi.espanso >/dev/null 2>&1 || true

echo "4/4 starting"
"$OLD/Contents/MacOS/espanso" service register >/dev/null 2>&1 || true
"$OLD/Contents/MacOS/espanso" start || true
echo
echo "NOW BY HAND: in the macOS prompt choose “Open System Settings” → Accessibility → switch Espanso on."
echo "Check: sqlite3 \"/Library/Application Support/com.apple.TCC/TCC.db\" \"select auth_value from access where client='com.federicoterzi.espanso'\"  → 2"
echo "Then: espanso status  → “espanso is running”"
