#!/bin/bash
# Compile, installe dans /Applications (ou ~/Applications) et lance l'app. Arguments transmis à l'app.
set -e
cd "$(dirname "$0")"
NAME=SymbolPill
pkill -x "$NAME" 2>/dev/null || true
BUILD="$(mktemp -d)/$NAME.app"
mkdir -p "$BUILD/Contents/MacOS"
swiftc -O -parse-as-library SymbolPill.swift -o "$BUILD/Contents/MacOS/$NAME"
cat > "$BUILD/Contents/Info.plist" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleName</key><string>$NAME</string>
<key>CFBundleIdentifier</key><string>local.symbolpill</string>
<key>CFBundleExecutable</key><string>$NAME</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>2.0</string>
<key>CFBundleVersion</key><string>2</string>
<key>LSUIElement</key><true/>
</dict></plist>
PL
codesign --force --sign - "$BUILD"
DEST=/Applications
[ -w "$DEST" ] || { DEST="$HOME/Applications"; mkdir -p "$DEST"; }
rm -rf "$DEST/$NAME.app"
ditto "$BUILD" "$DEST/$NAME.app"
rm -rf "$(dirname "$BUILD")"
rm -rf "$NAME.app"   # ancienne copie locale : une seule app à trouver dans Spotlight
echo "Installée : $DEST/$NAME.app"
[ -n "$NO_OPEN" ] || open "$DEST/$NAME.app" --args "$@"
