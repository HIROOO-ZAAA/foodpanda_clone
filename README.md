# Foodpanda-style Flutter Starter

Flutter port of the Lovable React demo (Splash, Login, Home, Restaurant, Food Detail,
Cart, Order Confirmation, Order Tracking, Profile, Edit Profile, Addresses, Ratings, About).

## Setup

```bash
flutter create .            # in this folder, to generate android/ios/web/ platform shells
flutter pub get
flutter run
```

If `flutter create .` complains the folder isn't empty, just answer `y` — it will only
add platform folders and won't overwrite `lib/` or `pubspec.yaml`.

## Notes

- State managed with `provider` (CartProvider, ProfileProvider, PromoProvider).
- Routing uses `go_router`.
- Icons are Material Icons (closest equivalents to lucide-react).
- Promo logic mirrors the web app: percent-off, free-delivery, BOGO (50%).
- This is a starter — visuals are approximate, not pixel-perfect.
