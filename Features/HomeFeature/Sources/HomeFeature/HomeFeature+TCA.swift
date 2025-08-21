import SwiftUI
import ComposableArchitecture
import NavigationKit

// Keeping the existing HomeRoute enum for compatibility during migration
// public enum HomeRoute: Hashable {
//     case detail1
//     case detail2
// }

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        // Additional state will be added during migration
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case goToDetail1
        case goToDetail2
        // Additional actions will be added during migration
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case .goToDetail1:
                state.path.append(.detail1(HomeDetail1Feature.State()))
                return .none
                
            case .goToDetail2:
                state.path.append(.detail2(HomeDetail2Feature.State()))
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
            case detail1(HomeDetail1Feature.State)
            case detail2(HomeDetail2Feature.State)
        }
        
        enum Action {
            case detail1(HomeDetail1Feature.Action)
            case detail2(HomeDetail2Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.detail1, action: /Action.detail1) {
                HomeDetail1Feature()
            }
            Scope(state: /State.detail2, action: /Action.detail2) {
                HomeDetail2Feature()
            }
        }
    }
}

// Placeholder for detail screens
@Reducer
struct HomeDetail1Feature {
    @ObservableState
    struct State: Equatable {
        var showSheet = false
    }
    
    enum Action {
        case toggleSheet
        case goToDetail2
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleSheet:
                state.showSheet.toggle()
                return .none
                
            case .goToDetail2:
                return .none
            }
        }
    }
}

@Reducer
struct HomeDetail2Feature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {}
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
