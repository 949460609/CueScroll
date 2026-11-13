# CueScroll

English-first iOS teleprompter for overseas App Store (US / UK / EU / AU).

## Why this product

Indie App Store data (2025–2026) shows utilities that do one job well — teleprompters, fasting trackers, scanners — convert better than broad “AI everything” apps. Teleprompter niche has proven indie revenue (examples in the $10K–$100K/mo band for leaders; smaller indies still monetize). CueScroll differentiates on:

- On-device scripts (no account / no tracking)
- Clean recording flow (countdown, speed, mirror)
- Simple Free → Pro monetization

## Stack

- SwiftUI, iOS 17+
- Local JSON persistence
- StoreKit 2 subscriptions + lifetime

## Open in Xcode

```bash
open "CueScroll.xcodeproj"
```

1. Select your Development Team
2. Attach `Products.storekit` as the scheme’s StoreKit Configuration
3. Run on simulator or device

## Monetization IDs

| Product | ID |
|---|---|
| Monthly | `com.cuescroll.pro.monthly` |
| Yearly | `com.cuescroll.pro.yearly` |
| Lifetime | `com.cuescroll.pro.lifetime` |

## App Store package

See `AppStore/` for privacy policy HTML, English listing copy, and submission checklist.

## Force Pro in debug

In Xcode scheme environment variables, add:

`CUE_SCROLL_FORCE_PRO` = `1`
