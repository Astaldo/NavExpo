import SwiftUI
import ComposableArchitecture
import NavigationKit

@Reducer
struct ProfileFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var username = "User123"
        var bio = "iOS Developer"
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case goToDetail1
        case setPath([PathItem])
    }
    
    enum PathItem: Equatable {
        case detail1
        case detail2
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case .goToDetail1:
                state.path.append(.detail1(ProfileDetail1Feature.State()))
                return .none
                
            case let .setPath(items):
                state.path = StackState()
                
                for item in items {
                    switch item {
                    case .detail1:
                        state.path.append(.detail1(ProfileDetail1Feature.State()))
                    case .detail2:
                        state.path.append(.detail2(ProfileDetail2Feature.State()))
                    }
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
            case detail1(ProfileDetail1Feature.State)
            case detail2(ProfileDetail2Feature.State)
        }
        
        enum Action {
            case detail1(ProfileDetail1Feature.Action)
            case detail2(ProfileDetail2Feature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.detail1, action: /Action.detail1) {
                ProfileDetail1Feature()
            }
            Scope(state: /State.detail2, action: /Action.detail2) {
                ProfileDetail2Feature()
            }
        }
    }
}

@Reducer
struct ProfileDetail1Feature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case goToDetail2
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .goToDetail2:
                return .none
            }
        }
    }
}

@Reducer
struct ProfileDetail2Feature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {}
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
