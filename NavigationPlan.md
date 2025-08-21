# Navigation Implementation Plan using The Composable Architecture

## Current Structure
- HomeFeature
- ListFeature
- ProfileFeature
- FoundationKit (contains TCA dependencies)

## Implementation Phases

### Phase 1: Foundation Setup ✅
1. Set up core TCA infrastructure
   - [x] Add TCA dependency to Package.swift
   - [x] Add TCA dependency to FoundationKit's Project.swift
   - [x] Remove NavigationKit module
   - [x] Update all feature dependencies to use FoundationKit

### Phase 2: Root Navigation
1. Create AppFeature in FoundationKit
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

### Phase 3: Feature Migration
Convert each feature to TCA pattern in this order:
1. HomeFeature
   - [ ] Create Feature.State
   - [ ] Create Feature.Action
   - [ ] Implement Reducer
   - [ ] Convert View to use Store

2. ListFeature
   - [ ] Create Feature.State
   - [ ] Create Feature.Action
   - [ ] Implement Reducer
   - [ ] Convert View to use Store

3. ProfileFeature
   - [ ] Create Feature.State
   - [ ] Create Feature.Action
   - [ ] Implement Reducer
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
1. ✅ Remove NavigationKit module
2. ✅ Add TCA dependency to FoundationKit
3. [ ] Create shared navigation utilities in FoundationKit
4. [ ] Create AppFeature as the root coordinator
5. [ ] Implement HomeFeature with new navigation
6. [ ] Add remaining features
7. [ ] Implement deep linking
8. [ ] Add tests
9. [ ] Final testing and commit changes

Please review this plan and let me know if you'd like to make any adjustments or have specific requirements for any of these phases.
