#!/usr/bin/env bash
set -euo pipefail

# Generates missing or incomplete native platform scaffolding without touching
# a complete platform directory. Run from repository root with Flutter on PATH.

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is required to bootstrap Android/iOS platforms." >&2
  exit 1
fi

if [[ ! -f android/app/build.gradle || ! -f android/settings.gradle ]]; then
  echo "Generating Android platform scaffolding"
  flutter create --platforms=android --org=com.tunisvillage .
fi

if [[ ! -f ios/Runner/Info.plist || ! -f ios/Runner.xcodeproj/project.pbxproj ]]; then
  echo "Generating iOS platform scaffolding"
  flutter create --platforms=ios --org=com.tunisvillage .
fi

echo "Platform bootstrap complete. Review native identifiers/signing before store release."
