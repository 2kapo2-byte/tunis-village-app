#!/usr/bin/env bash
set -euo pipefail

# Generates missing native platform scaffolding without overwriting an existing
# platform directory. Run from repository root with Flutter on PATH.
APP_ID="${TUNIS_VILLAGE_APP_ID:-com.tunisvillage.tunis_village_app}"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is required to bootstrap Android/iOS platforms." >&2
  exit 1
fi

if [[ ! -d android || ! -f android/app/src/main/AndroidManifest.xml ]]; then
  echo "Generating Android platform scaffolding with ${APP_ID}"
  flutter create --platforms=android --org=com.tunisvillage .
fi

if [[ ! -d ios || ! -f ios/Runner/Info.plist ]]; then
  echo "Generating iOS platform scaffolding"
  flutter create --platforms=ios --org=com.tunisvillage .
fi

echo "Platform bootstrap complete. Review native identifiers/signing before store release."
