import SwiftUI
import ComposableArchitecture
import HomeFeature
import ListFeature
import ProfileFeature

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        @Bindable var store = self.store
        
        TabView(selection: $store.selectedTab) {
            HomeView(
                store: store.scope(
                    state: \.home,
                    action: { .home($0) }
                )
            )
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(AppFeature.Tab.home)
            
            ListView(
                store: store.scope(
                    state: \.list,
                    action: { .list($0) }
                )
            )
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            .tag(AppFeature.Tab.list)
            
            ProfileView(
                store: store.scope(
                    state: \.profile,
                    action: { .profile($0) }
                )
            )
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(AppFeature.Tab.profile)
        }
        .onOpenURL { url in
            store.send(.handleDeepLink(url))
        }
    }
}

// Placeholder Views for the features - will be replaced when each feature is fully migrated

struct HomeView: View {
    let store: StoreOf<HomeFeature>
    
    var body: some View {
        @Bindable var store = self.store
        
        NavigationStack(path: $store.path) {
            VStack {
                Text("Home View")
                    .font(.largeTitle)
                
                Button("Go to Detail 1") {
                    store.send(.goToDetail1)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 20)
            }
            .navigationTitle("Home")
            .navigationDestination(for: HomeFeature.Path.State.self) { state in
                switch state {
                case let .detail1(state):
                    HomeDetail1View(
                        store: store.scope(
                            state: { _ in state },
                            action: { .path(.element(id: store.path.ids[store.path.count - 1], action: .detail1($0))) }
                        )
                    )
                case let .detail2(state):
                    HomeDetail2View(
                        store: store.scope(
                            state: { _ in state },
                            action: { .path(.element(id: store.path.ids[store.path.count - 1], action: .detail2($0))) }
                        )
                    )
                }
            }
        }
    }
}

struct HomeDetail1View: View {
    let store: StoreOf<HomeDetail1Feature>
    
    var body: some View {
        @Bindable var store = self.store
        
        VStack {
            Text("Home Detail 1")
                .font(.largeTitle)
            
            Button("Go to Detail 2") {
                store.send(.goToDetail2)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
            
            Button("Show Sheet") {
                store.send(.toggleSheet)
            }
            .padding(.top, 12)
        }
        .navigationTitle("Detail 1")
        .sheet(isPresented: $store.showSheet) {
            VStack(spacing: 16) {
                Text("Home Bottom Sheet")
                    .font(.headline)
                Text("This is a modal sheet presented from Home Detail 1.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button("Dismiss") {
                    store.send(.toggleSheet)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

struct HomeDetail2View: View {
    let store: StoreOf<HomeDetail2Feature>
    
    var body: some View {
        VStack {
            Text("Home Detail 2")
                .font(.largeTitle)
        }
        .navigationTitle("Detail 2")
    }
}

struct ListView: View {
    let store: StoreOf<ListFeature>
    
    var body: some View {
        @Bindable var store = self.store
        
        NavigationStack(path: $store.path) {
            List {
                ForEach(store.items) { item in
                    Button {
                        store.send(.itemTapped(item))
                    } label: {
                        Text(item.title)
                    }
                }
            }
            .navigationTitle("List")
            .onAppear {
                store.send(.loadItems)
            }
            .navigationDestination(for: ListFeature.Path.State.self) { state in
                switch state {
                case let .detail(state):
                    ListDetailView(
                        store: store.scope(
                            state: { _ in state },
                            action: { .path(.element(id: store.path.ids[store.path.count - 1], action: .detail($0))) }
                        )
                    )
                }
            }
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
        }
        .navigationTitle(state.item.title)
    }
}

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        @Bindable var store = self.store
        
        NavigationStack(path: $store.path) {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text(store.username)
                    .font(.title)
                
                Text(store.bio)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button("View Profile Details") {
                    store.send(.goToDetail1)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Profile")
            .navigationDestination(for: ProfileFeature.Path.State.self) { state in
                switch state {
                case let .detail1(state):
                    ProfileDetail1View(
                        store: store.scope(
                            state: { _ in state },
                            action: { .path(.element(id: store.path.ids[store.path.count - 1], action: .detail1($0))) }
                        )
                    )
                case let .detail2(state):
                    ProfileDetail2View(
                        store: store.scope(
                            state: { _ in state },
                            action: { .path(.element(id: store.path.ids[store.path.count - 1], action: .detail2($0))) }
                        )
                    )
                }
            }
        }
    }
}

struct ProfileDetail1View: View {
    let store: StoreOf<ProfileDetail1Feature>
    
    var body: some View {
        VStack {
            Text("Profile Detail 1")
                .font(.largeTitle)
            
            Button("Go to Detail 2") {
                store.send(.goToDetail2)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
        .navigationTitle("Profile Detail 1")
    }
}

struct ProfileDetail2View: View {
    let store: StoreOf<ProfileDetail2Feature>
    
    var body: some View {
        VStack {
            Text("Profile Detail 2")
                .font(.largeTitle)
        }
        .navigationTitle("Profile Detail 2")
    }
}
