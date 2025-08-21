import SwiftUI
import ComposableArchitecture
import NavigationKit

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        var username = "User123"
        var bio = "iOS Developer"
        
        public init() {}
    }
    
    public enum Action {
        case path(StackActionOf<Path>)
        case goToDetail1
    }
    
    @Reducer
    public enum Path {
        case detail1(ProfileDetail1Feature)
        case detail2(ProfileDetail2Feature)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .path(action):
                switch action {
                case .element(id: _, action: .detail1(.goToDetail2)):
                    // Handle navigation from Detail1 to Detail2
                    state.path.append(.detail2(ProfileDetail2Feature.State()))
                    return .none
                case .element(id: _, action: .detail2(.popToRoot)):
                    state.path.removeAll()
                    return .none
                default:
                    return .none
                }
                
            case .goToDetail1:
                state.path.append(.detail1(ProfileDetail1Feature.State()))
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension ProfileFeature.Path.State: Equatable {}

@Reducer
public struct ProfileDetail1Feature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case goToDetail2
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .goToDetail2:
                return .none
            }
        }
    }
}

@Reducer
public struct ProfileDetail2Feature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case popToRoot
    }
    
    public var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
