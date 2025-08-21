import SwiftUI
import ComposableArchitecture
import HomeFeature
import ListFeature
import ProfileFeature

@Reducer
struct AppFeature {
    @ObservableState
    struct State {
        var selectedTab: Tab = .home
        var path = StackState<Path.State>()
        var home = HomeFeature.State()
        var list = ListFeature.State()
        var profile = ProfileFeature.State()
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
        case handleDeepLink(URL)
    }

    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectedTab(tab):
                state.selectedTab = tab
                return .none
                
            case let .path(action):
                return .none
                
            case .home:
                return .none
                
            case .list:
                return .none
                
            case .profile:
                return .none
                
            case let .handleDeepLink(url):
                guard let deeplink = DeepLink(from: url) else { return .none }
                
                switch deeplink {
                case .home:
                    state.selectedTab = .home
                    state.path = StackState()
                    
                case .list:
                    state.selectedTab = .list
                    state.path = StackState()
                    
                case .profile:
                    state.selectedTab = .profile
                    state.path = StackState()
                    
                case .profileDetail1:
                    state.selectedTab = .profile
                    // Navigation handling will be implemented when Profile feature is migrated
                    
                case .profileDetail2:
                    state.selectedTab = .profile
                    // Navigation handling will be implemented when Profile feature is migrated
                }
                
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
    
    @Reducer
    enum Path {
        enum State: Equatable {
            // These cases will be filled when implementing each feature
            // case detail(ItemDetailFeature.State)
            // case settings(SettingsFeature.State)
        }
        
        enum Action {
            // These cases will be filled when implementing each feature
            // case detail(ItemDetailFeature.Action)
            // case settings(SettingsFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            EmptyReducer()
        }
    }
}

// Keep DeepLink enum from original NavigationKit
// This will be migrated into a TCA pattern once all features are converted
