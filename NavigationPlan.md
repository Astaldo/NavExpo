# Navigation Implementation Plan using The Composable Architecture

## Current Structure
- HomeFeature
- ListFeature
- ProfileFeature
- NavigationKit (contains TCA dependencies)
- FoundationKit (utility code)

## Implementation Phases

### Phase 1: Foundation Setup ✅
1. Set up core TCA infrastructure
   - [x] Add TCA dependency to Package.swift
   - [x] Add TCA dependency to NavigationKit's Project.swift
   - [x] Keep NavigationKit module for now as it contains DeepLink functionality
   - [x] Update all feature dependencies to use NavigationKit
   - [x] Add TCA dependency to all feature modules
   - [x] Project generated successfully with TCA dependencies

### Phase 2: Root Navigation ✅
1. Create AppFeature in NavExpo/Sources
   ```swift
   @Reducer
   struct AppFeature {
     @ObservableState
     struct State {
       var selectedTab: Tab
       var path: StackState<Path.State>
       var home: HomeFeature.State
       var list: ListFeature.State
       var profile: ProfileFeature.State
     }
     
     enum Tab {
       case home
       case list
       case profile
     }
     
     enum Action {
       case selectedTab(Tab)
       case path(StackAction<Path.State, Path.Action>)
       case home(HomeFeature.Action)
       case list(ListFeature.Action)
       case profile(ProfileFeature.Action)
     }

     enum Path: Reducer {
       enum State: Equatable {
         case detail(ItemDetailFeature.State)
         case settings(SettingsFeature.State)
       }
       
       enum Action {
         case detail(ItemDetailFeature.Action)
         case settings(SettingsFeature.Action)
       }
     }
   }
   ```
   - [x] Create AppFeature with basic structure
   - [x] Update all feature projects to include TCA dependency
   - [x] Create skeleton implementations for TCA-based features
   - [x] Create AppView with TabView navigation
   - [x] Update NavExpoApp to use TCA architecture

### Phase 3: Feature Migration
Convert each feature to TCA pattern in this order:
1. HomeFeature
   - [x] Create Feature.State
   - [x] Create Feature.Action
   - [x] Implement Reducer (skeleton)
   - [ ] Convert View to use Store

2. ListFeature
   - [x] Create Feature.State
   - [x] Create Feature.Action
   - [x] Implement Reducer (skeleton)
   - [ ] Convert View to use Store

3. ProfileFeature
   - [x] Create Feature.State
   - [x] Create Feature.Action
   - [x] Implement Reducer (skeleton)
   - [ ] Convert View to use Store

### Phase 4: Deep Navigation
1. Implement deep navigation patterns
   - [ ] Set up StackState for navigation paths in each feature
   - [ ] Implement path-based navigation in features that need it
   - [ ] Create common navigation patterns in FoundationKit
   - [ ] Set up URL-based deep linking

### Phase 5: Testing
1. Set up testing infrastructure
   - [ ] Create test stores for features
   - [ ] Write navigation test cases
   - [ ] Test deep linking
   - [ ] Test state restoration

## Implementation Details

### Feature Structure
Each feature will follow this structure:
```swift
struct SomeFeature: Reducer {
  struct State: Equatable {
    var path: StackState<Path.State>
    // feature-specific state
  }

  enum Action {
    case path(StackAction<Path.State, Path.Action>)
    // feature-specific actions
  }

  enum Path: Reducer {
    enum State: Equatable {
      case detail(DetailFeature.State)
      // other navigation states
    }
    enum Action {
      case detail(DetailFeature.Action)
      // other navigation actions
    }
  }
}
```

### Navigation Patterns
1. Tab-based navigation using AppFeature's selectedTab
2. Stack-based navigation using StackState for hierarchical navigation
3. Sheet presentations using @Presents for modal screens
4. Deep linking support through URL handling

## Next Steps
1. ✅ Add TCA dependency to Package.swift
2. ✅ Restore NavigationKit module and add TCA dependency to it
3. ✅ Add TCA dependencies to each feature module
4. ✅ Create AppFeature in NavExpo as the root coordinator
5. ✅ Set up basic TCA architecture structure for all features
6. [ ] Complete HomeFeature with new navigation
   - Convert HomeFeature.swift to use TCA-based implementation
   - Update HomeEntryView to use Store
   - Connect HomeNavigator with TCA path-based navigation
7. [ ] Complete ListFeature migration to TCA
8. [ ] Complete ProfileFeature migration to TCA
9. [ ] Implement deep linking using TCA
10. [ ] Add tests
11. [ ] Final testing and commit changes

Please review this plan and let me know if you'd like to make any adjustments or have specific requirements for any of these phases.
