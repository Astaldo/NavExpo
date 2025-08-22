import SwiftUI
import ComposableArchitecture
import NavigationKit

@Reducer
public struct HomeFeature {
    @ObservableState
    public struct State {
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
        
        public init() {}
    }
    
    public enum Action {
        case path(StackActionOf<Path>)
        case goToDetail1
        case goToDetail2
        case goToDeepInProfile
        case showAlert
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Reducer
    public enum Path {
        case detail1(HomeDetail1Feature)
        case detail2(HomeDetail2Feature)
    }
    
    @Reducer
    public enum Destination {
        case alert(AlertState<Alert>)
        
        @CasePathable
        public enum Alert {
            case okAction
        }
    }
    
    @Dependency(\.openURL) var openURL
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .path(action):
                switch action {
                case .element(id: _, action: .detail1(.goToDetail2)):
                    // Handle navigation from Detail1 to Detail2
                    state.path.append(.detail2(HomeDetail2Feature.State()))
                    return .none
                case .element(id: _, action: .detail2(.popToRoot)):
                    state.path.removeAll()
                    return .none
                default:
                    return .none
                }
                
            case .goToDetail1:
                state.path.append(.detail1(HomeDetail1Feature.State()))
                return .none
                
            case .goToDetail2:
                state.path.append(.detail2(HomeDetail2Feature.State()))
                return .none
                
            case .goToDeepInProfile:
                guard let url = URL(string: "navexpo://navexpo/profile/detail1/detail2") else {
                    assertionFailure("Invalid URL for deep link")
                    return .none
                }
                return .run { _ in
                    await openURL(url)
                }
                
            case .showAlert:
                let alertState = AlertState<Destination.Alert>(title: {
                    TextState("Home Alert")
                }, actions: {
                    ButtonState(action: .okAction) {
                        TextState("OK")
                    }
                }, message: {
                    TextState("This is an alert on the Home root screen.")
                })
                state.destination = .alert(alertState)
                return .none
                
            case .destination:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$destination, action: \.destination)
    }
}

// Placeholder for detail screens
@Reducer
public struct HomeDetail1Feature {
    @ObservableState
    public struct State: Equatable {
        @Presents var bottomSheet: BottomSheetState?
    }
    
    struct BottomSheetState: Equatable {}
    
    @CasePathable
    public enum Action {
        case toggleSheet
        case goToDetail2
        case bottomSheet(PresentationAction<BottomSheetAction>)
                
        public enum BottomSheetAction {
            case dismiss
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleSheet:
                state.bottomSheet = BottomSheetState()
                return .none
                
            case .goToDetail2:
                // This action will be handled by the parent reducer
                return .none
                
            case .bottomSheet(.presented(.dismiss)):
                state.bottomSheet = nil
                return .none
                
            case .bottomSheet:
                return .none
            }
        }
        .ifLet(\.$bottomSheet, action: \.bottomSheet) {
            EmptyReducer()
        }
    }
}

@Reducer
public struct HomeDetail2Feature {
    @ObservableState
    public struct State: Equatable {}
    
    public enum Action {
        case popToRoot
    }
    
    public var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
