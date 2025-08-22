import SwiftUI
import ComposableArchitecture
import HomeFeature
import ListFeature
import ProfileFeature
import NavigationKit

@Reducer
struct AppFeature {
    @ObservableState
    struct State {
        var selectedTab: Tab = .home
        var home = HomeFeature.State()
        var list = ListFeature.State()
        var profile = ProfileFeature.State()
    }
    
    enum Tab {
        case home
        case list
        case profile
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case home(HomeFeature.Action)
        case list(ListFeature.Action)
        case profile(ProfileFeature.Action)
        case handleDeepLink(URL)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.list, action: \.list) {
            ListFeature()
        }
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        Reduce { state, action in
            switch action {                
            case .binding:
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
                    
                case .list:
                    state.selectedTab = .list
                    
                case .profile:
                    state.selectedTab = .profile
                    
                case .profileDetail1:
                    state.selectedTab = .profile
                    state.profile.path.append(.detail1(ProfileDetail1Feature.State()))
                    
                case .profileDetail2:
                    state.selectedTab = .profile
                    state.profile.path.append(.detail1(ProfileDetail1Feature.State()))
                    state.profile.path.append(.detail2(ProfileDetail2Feature.State()))
                }
                return .none
            }
        }
    }
}
