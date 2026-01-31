# VolteecShared

**v1.0.0 (2026-01-31)** — Swift 6.2 — Shared models and utilities for Volteec App, Backend, and Notification Service Extension.

This package provides canonical notification payload models, shared localization helpers, and alias storage utilities. It is intentionally UI-agnostic and safe to reuse across targets.

**README language:** English only. All shared text, comments, and commit messages must be English.

## Status

Current version: v1.0.0 (2026-01-31).  
Current content: notification payload models, validation helpers, localization utilities, alias stores (App Group).

### Patch History

**v1.0.0 (2026-01-31) — initial public release**  
- Canonical notification payload + validation  
- Shared localization bundle helpers  
- Alias storage utilities (UPS + server aliases)

## Principles

- **Canonical data models** for notification payloads
- **UI-agnostic** utilities only (safe for App + NSE + Backend)
- **App Group aware** storage (shared defaults + file store)

## Platforms

- iOS 26 (as defined in `Package.swift`)

## Modules

### Notification Payload
- `NotificationEvent` — canonical event model
- `NotificationPayload` — wrapper for decoding APNs `userInfo`
- `NotificationValidationError` — optional validation errors

### Localization
- `SharedLocalization` — resolves app language and bundle lookups
- `NotificationStrings` — localized status strings

### Alias Storage
- `AliasStore` — UPS alias storage (App + NSE sync via App Group)
- `ServerAliasStore` — server alias storage
- `UPSDisplayName` — resolves user-visible UPS name

## Usage

### Decode APNs userInfo
```swift
let payload = try NotificationPayload.decode(from: userInfo)
try payload.event.validate()
```

### Resolve display name
```swift
let display = UPSDisplayName(upsId: "ups1", alias: "Office UPS").resolved
```

### Localized notification body
```swift
let body = NotificationStrings.statusBody(displayName: display, status: "on_battery")
```

## Sources

- Used by Volteec App, Volteec Backend, and Volteec Push Relay.

## Version

- **Current**: v1.0.0 (2026-01-31)
- **Swift tools**: 6.2

## Build Status

Not configured.
