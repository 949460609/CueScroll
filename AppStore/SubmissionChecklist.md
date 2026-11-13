# Overseas Apple App Store — Submission Checklist

## Before you start
- [ ] Apple Developer Program membership ($99/year) — personal or company
- [ ] Decide legal entity name shown on App Store (individual vs company)
- [ ] Domain for privacy policy (GitHub Pages is fine): host `PrivacyPolicy.html`
- [ ] Support email that you monitor (`support@…`)

## Xcode project
- [ ] Open `CueScroll.xcodeproj`
- [ ] Set **Team** (Signing & Capabilities) to your Apple Developer team
- [ ] Confirm Bundle ID `com.cuescroll.app` is unique (or change it)
- [ ] Add 1024×1024 App Icon in Assets
- [ ] Scheme → Edit Scheme → Run → Options → StoreKit Configuration = `Products.storekit`
- [ ] Run on iPhone simulator + a real device
- [ ] Test: create script → play → mirror → paywall (StoreKit config)

## App Store Connect
- [ ] Create new app: name CueScroll, primary language English (U.S.), bundle ID match
- [ ] Availability: select US, UK, CA, AU, DE, FR, and other markets you want
- [ ] Pricing: Free
- [ ] In-App Purchases:
  - `com.cuescroll.pro.monthly` (auto-renewable)
  - `com.cuescroll.pro.yearly` (auto-renewable)
  - `com.cuescroll.pro.lifetime` (non-consumable)
- [ ] Subscription group: CueScroll Pro
- [ ] Fill listing from `Listing_EN.md`
- [ ] Upload screenshots (iPhone 6.7" + 6.1" minimum; iPad if supporting)
- [ ] Privacy nutrition label: **Data Not Collected** (if you keep zero analytics SDKs)
- [ ] Privacy Policy URL (must be live HTTPS)
- [ ] App Review notes: explain Free vs Pro; provide demo script steps

## Archive & submit
- [ ] Xcode → Product → Archive
- [ ] Distribute App → App Store Connect
- [ ] Wait for processing, then select build in version
- [ ] Submit for Review
- [ ] Typical first review: 24–48 hours (can vary)

## After approval
- [ ] Soft launch in US + UK first, watch crash reports in Xcode Organizer
- [ ] ASO: iterate subtitle/keywords weekly based on App Store Connect search terms
- [ ] Optional: add German/Spanish localization for EU ASO gap
