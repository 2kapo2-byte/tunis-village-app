#!/usr/bin/env bash
set -euo pipefail

fail=0

# No real environment files may be committed. The template is explicitly allowed.
while IFS= read -r -d '' file; do
  case "$file" in
    .env.example) ;;
    *) echo "ERROR: tracked environment file detected: $file"; fail=1 ;;
  esac
done < <(git ls-files -z -- '.env' '.env.*')

# Scan tracked source/config text for actual privileged credential assignments or
# private-key/token payloads. Documentation and this checker intentionally mention
# security marker names, so they are excluded from the payload scan.
while IFS= read -r -d '' file; do
  case "$file" in
    .env.example|*.md|*.png|*.jpg|*.jpeg|*.gif|*.webp|*.pdf|*.apk|*.aab|tool/check_public_config.sh) continue ;;
  esac
  if grep -IEn '(SUPABASE_SERVICE_ROLE|service[_-]?role)[[:space:]]*[:=][[:space:]]*["'"']?[A-Za-z0-9._-]{20,}|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{20,}' "$file" >/dev/null 2>&1; then
    echo "ERROR: possible privileged secret payload found in tracked file: $file"
    grep -IEn '(SUPABASE_SERVICE_ROLE|service[_-]?role)[[:space:]]*[:=][[:space:]]*["'"']?[A-Za-z0-9._-]{20,}|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{20,}' "$file" || true
    fail=1
  fi
done < <(git ls-files -z)

# Public runtime configuration must remain limited to the documented variables.
if ! grep -q '^SUPABASE_URL=' .env.example || ! grep -q '^SUPABASE_ANON_KEY=' .env.example; then
  echo 'ERROR: .env.example is missing the documented public Supabase variables.'
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  exit 1
fi

echo 'Public configuration and secret hygiene checks passed.'
