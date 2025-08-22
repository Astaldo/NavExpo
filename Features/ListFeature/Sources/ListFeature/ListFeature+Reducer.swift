import SwiftUI
import ComposableArchitecture
import NavigationKit

@Reducer
public struct ListFeature {
    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        public var items: [Item] = []
        
        public init() {}
    }
    
    public struct Item: Equatable, Identifiable {
        public let id: UUID
        public let title: String
        
        public init(id: UUID = UUID(), title: String) {
            self.id = id
            self.title = title
        }
    }
    
    public enum Action {
        case path(StackActionOf<Path>)
        case itemTapped(Item)
        case loadItems
    }
    
    @Reducer
    public enum Path {
        case detail(ListDetailFeature)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: .detail(.backToRoot))):
                state.path.removeAll()
                return .none

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
        .forEach(\.path, action: \.path)
    }
}

extension ListFeature.Path.State: Equatable {}

@Reducer
public struct ListDetailFeature {
    @ObservableState
    public struct State: Equatable {
        public let item: ListFeature.Item
        
        public init(item: ListFeature.Item) {
            self.item = item
        }
    }
    
    public enum Action {
        case backToRoot
    }
    
    public var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
