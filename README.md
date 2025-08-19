## NavExpo

A SwiftUI playground app for exploring navigation patterns and trade‑offs in iOS.

### Goals
- Compare multiple navigation approaches in SwiftUI from a common baseline
- Exercise per‑feature stack navigation, cross‑feature deep links, and modals
- Keep features modular via local SPM packages
- Automate project generation with Tuist

### Baseline app
- iOS 18+
- Tabs: Home, List, Profile
- Each tab is a separate SPM package:
  - `Features/HomeFeature`
  - `Features/ListFeature`
  - `Features/ProfileFeature`
- Shared packages:
  - `Shared/NavigationKit` (generic `FeatureNavigator`, deep link utilities)
  - `Shared/FoundationKit` (utilities)
- Deep links: custom scheme `navexpo://navexpo/...` handled in `ContentView`
  - Examples:
    - `navexpo://navexpo/home`
    - `navexpo://navexpo/list`
    - `navexpo://navexpo/profile`
    - `navexpo://navexpo/profile/detail1`
    - `navexpo://navexpo/profile/detail1/detail2`

### Branches
The `main` branch contains the Vanilla SwiftUI implementation. Create additional branches for experiments.

### Requirements
- Xcode 16.x
- Tuist (4.x)

### Setup
```bash
tuist generate
open NavExpo.xcworkspace
```

### Run
- Select the `NavExpo` scheme and run on an iOS 18 simulator/device.
- Trigger deep links (Simulator):
```bash
xcrun simctl openurl "navexpo://navexpo/profile/detail1/detail2"
```

### Concurrency
- Strict concurrency flags enabled everywhere

### License
MIT © 2025


