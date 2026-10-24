# Changelog

All notable changes to `ludus_adcs` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.7.0\] - 2026-10-24

### Fixed
- ESC user tasks now look up existing accounts by `sAMAccountName` (`identity`) instead of only `CN=<name>,CN=Users`. Previously, re-running the role after an ESC user had been moved to another OU failed with `New-ADUser failed: ... UPN value ... not unique forest-wide`.
- ESC users are created with a full UPN (`<user>@<domain fqdn>`) instead of a bare username, so they no longer collide on the forest-wide UPN uniqueness check with same-named users in other domains (PR #12). On existing ranges, the next run rewrites the UPN in place.
- The primary DC for the CA's domain is now matched on the exact domain FQDN. Previously, a prefix match on the first label could pick another domain's DC (for example, `ludus` matching `ludus2.domain`). The CA's own range config entry is also matched exactly on `vm_name`.

### Changed
- ESC user passwords use `update_password: when_changed`, so re-runs report `ok` unless the password has drifted from the configured value.
- `ludus_adcs_domain_fqdn` now comes from the CA's own range config entry, and `ludus_adcs_domain` is derived from it. Added the `ludus_adcs_vm_config` default.
- README documents the Ludus-supplied variables, and the variables to set when using the role outside of Ludus. Removed the unused `ludus_adcs_ca_web_enrollment` variable from the example playbook.

## [1.6.0] - 2026-03-20

### Added
- **ESC10 support** — Standalone ESC10 (Weak Certificate Binding) with Case 1 (`StrongCertificateBindingEnforcement=0`) and Case 2 (`CertificateMappingMethods=0x04`). Creates its own user, ACLs, and dedicated "ESC10" template with `NoSecurityExtension` so it can be deployed independently without enabling ESC9.
- **ESC14 support** — New ESC14 task for exploiting weak explicit certificate mappings.
- New defaults: `ludus_adcs_esc10`, `ludus_adcs_esc10_case1`, `ludus_adcs_esc10_case2`, `ludus_adcs_esc10_user`, `ludus_adcs_esc10_password`, `ludus_adcs_esc10_template_name`, `ludus_adcs_esc14`, and related ESC14 variables.
- `ludus_adcs_dc_config`, `ludus_adcs_dc_ip`, `ludus_adcs_domain_fqdn` defaults for improved DC targeting.
- `files/ESC10.json` — Dedicated template JSON for ESC10 (identical to ESC9 template attributes but with its own name/OID).
- `files/esc10.ps1` — PowerShell script to grant Domain Users GenericAll over the ESC10 user.

### Changed
- **CertSvc recovery logic** — Replaced simple install-then-start with robust recovery: try start → reboot → retry → if still broken, uninstall CA → reboot → reinstall with `-OverwriteExistingKey` → reboot → start. Handles fresh installs, idempotent re-runs, and corrupt CA states.
- `ludus_adcs_dc` now uses `vm_name` instead of `hostname` to fix Ansible `delegate_to` targeting.

### Improved
- ESC9 and ESC16 task improvements for reliability and idempotency.
- ESC5 improvements.

## [1.5.3] - 2026-01-22

### Fixed
- Do not rely on `ErrorID` in catch block of CA installation (PR #10).
- Correctly check if CA was installed (PR #8).
- Replace `Get-ADDomain` with filtering for i18n compatibility (PR #9).
- Correctly get local admins group name in ESC5 script.
- Correctly check if Web Enrollment was installed.

## [1.5.0] - 2025-12-05

### Fixed
- Internationalized PowerShell scripts and removed deprecation warnings (PR #7).

## [1.4.2] - 2025-10-31

### Fixed
- `[ERROR]: The 'loop' value must resolve to a 'list', not 'str'`.

## [1.4.1] - 2025-10-14

### Fixed
- Correct fix for FQDNs that are two elements and end in `.no`.

## [1.4.0] - 2025-10-14

### Fixed
- Force FQDN elements to string so `no` (Norwegian TLD) is not treated as a boolean.

### Added
- Template name customization support (PR #5).

## [1.3.0] - 2025-05-22

### Added
- ESC16 support with documentation.

## [1.2.1] - 2024-11-19

### Fixed
- Removed email from inclusion in SAN (PR #3).

## [1.2.0] - 2024-11-15

### Added
- ESC5, ESC7, ESC9, ESC11, and ESC15 support with documentation (PR #2).
- Weaponized ESC13 group for ESC13 abuse.
