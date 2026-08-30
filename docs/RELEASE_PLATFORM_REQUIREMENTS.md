# Release Platform Requirements

## Customer App
- Android ID: `com.tunisvillage.customer`
- iOS bundle ID: `com.tunisvillage.customer`
- Release signing must be configured through secure CI secrets.

## Partner App
- Android ID: `com.tunisvillage.partner`
- iOS bundle ID: `com.tunisvillage.partner`
- Release signing must be configured through secure CI secrets.

## Acceptance
A production release is accepted only when platform configuration is checked into the appropriate app project, release signing is reproducible in CI without secrets in Git, and release artifacts are produced successfully.

## Do not commit
- `*.jks`
- `*.keystore`
- `*.p12`
- provisioning profiles
- private certificates
- passwords/tokens/API keys
