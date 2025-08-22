import SwiftUI
import ComposableArchitecture

public struct ListEntryView: View {
    @Bindable var store: StoreOf<ListFeature>
    
    public init(store: StoreOf<ListFeature>) {
        self.store = store
    }
    
    public var body: some View {        
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ListRootView(store: store)
                .navigationTitle("List")
        } destination: { store in
            switch store.case {
            case let .detail(store):
                ListDetailView(store: store)
            }
        }
    }
}

struct ListRootView: View {
    @Bindable var store: StoreOf<ListFeature>
    
    var body: some View {
        List {
            ForEach(store.items) { item in
                Button {
                    store.send(.itemTapped(item))
                } label: {
                    Text(item.title)
                }
            }
        }
        .onAppear {
            store.send(.loadItems)
        }
    }
}

struct ListDetailView: View {
    let store: StoreOf<ListDetailFeature>
    
    var body: some View {
        let state = store.state
        
        VStack {
            Text(state.item.title)
                .font(.largeTitle)
                .padding()
            
            Text("Item Detail Screen")
                .font(.headline)
            
            Button("Back to Root") {
                store.send(.backToRoot)
            }
            .buttonStyle(.bordered)
            .padding(.top, 20)
        }
        .navigationTitle(state.item.title)
    }
}
