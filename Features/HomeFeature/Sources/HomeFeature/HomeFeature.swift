import SwiftUI
import ComposableArchitecture

public struct HomeEntryView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        @Bindable var store = self.store
        
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            HomeRootScreen(store: store)
                .navigationTitle("Home")
                .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        } destination: { store in
            switch store.case {
            case let .detail1(store):
                HomeDetail1Screen(store: store)
            case let .detail2(store):
                HomeDetail2Screen(store: store)
            }
        }
    }
}

// Root view of the Home feature
struct HomeRootScreen: View {
    @Bindable var store: StoreOf<HomeFeature>
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Go to Home Detail 1") {
                store.send(.goToDetail1)
            }
            .buttonStyle(.borderedProminent)
            
            Button("Go to deep in Profile") {
                if let url = URL(string: "navexpo://navexpo/profile/detail1/detail2") {
                    openURL(url)
                }
            }
            .padding(.top, 12)
            
            Button("Show Alert") {
                store.send(.showAlert)
            }
            .padding(.top, 12)
            
            Spacer()
        }
    }
}

struct HomeDetail1Screen: View {
    @Bindable var store: StoreOf<HomeDetail1Feature>
    
    var body: some View {
        @Bindable var store = self.store
        
        VStack {
            Spacer()
            
            Button("Go to Home Detail 2") {                
                store.send(.goToDetail2)
            }
            .buttonStyle(.borderedProminent)
            
            Button("Show Bottom Sheet") {
                store.send(.toggleSheet)
            }
            .padding(.top, 12)
            
            Spacer()
        }
        .navigationTitle("Home Detail 1")
        .sheet(
            item: $store.scope(state: \.bottomSheet, action: \.bottomSheet)
        ) { store in
            VStack(spacing: 16) {
                Text("Home Bottom Sheet")
                    .font(.headline)
                Text("This is a modal sheet presented from Home Detail 1.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button("Dismiss") {
                    store.send(.dismiss)
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

struct HomeDetail2Screen: View {
    let store: StoreOf<HomeDetail2Feature>
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Back to Home Root") {
                store.send(.popToRoot)
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .navigationTitle("Home Detail 2")
    }
}
