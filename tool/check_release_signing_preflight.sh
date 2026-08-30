#!/usr/bin/env bash
set -euo pipefail

# Preflight only: production signing secrets are intentionally NOT required here.
# This gate ensures signing material is not committed before CI signing is enabled.

if find . -type f \( -name '*.jks' -o -name '*.keystore' \) -not -path './.git/*' | grep -q .; then
  echo 'ERROR: keystore material must never be committed to the repository.'
  exit 1
fi

if find . -type f -name 'key.properties' -not -path './.git/*' | grep -q .; then
  echo 'ERROR: key.properties must remain local/secret-managed and must not be committed.'
  exit 1
fi

required_docs=(
  'docs/R8-PRODUCTION-READINESS-GATE.md'
  'docs/RELEASE_PLATFORM_SECURITY_REQUIREMENTS.md'
)
for file in "${required_docs[@]}"; do
  test -f "$file" || { echo "ERROR: missing release security document: $file"; exit 1; }
done

echo 'Release signing preflight: PASS'
echo 'Production signing credentials are intentionally not required by this preflight.'
