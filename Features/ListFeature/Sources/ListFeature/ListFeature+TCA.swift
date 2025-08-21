import SwiftUI
import ComposableArchitecture
import NavigationKit

@Reducer
struct ListFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var items: [Item] = []
    }
    
    struct Item: Equatable, Identifiable {
        let id: UUID
        let title: String
        
        init(id: UUID = UUID(), title: String) {
            self.id = id
            self.title = title
        }
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case itemTapped(Item)
        case loadItems
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case let .itemTapped(item):
                state.path.append(.detail(ListDetailFeature.State(item: item)))
                return .none
                
            case .loadItems:
                // Sample items - will be replaced with actual data fetching
                state.items = [
                    Item(title: "Item 1"),
                    Item(title: "Item 2"),
                    Item(title: "Item 3"),
                    Item(title: "Item 4"),
                    Item(title: "Item 5")
                ]
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
            case detail(ListDetailFeature.State)
        }
        
        enum Action {
            case detail(ListDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.detail, action: /Action.detail) {
                ListDetailFeature()
            }
        }
    }
}

@Reducer
struct ListDetailFeature {
    @ObservableState
    struct State: Equatable {
        let item: ListFeature.Item
    }
    
    enum Action {}
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
