import SwiftUI
import ComposableArchitecture
import HomeFeature
import ListFeature
import ProfileFeature

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        TabView(selection: $store.selectedTab) {
            HomeEntryView(store: store.scope(state: \.home, action: \.home))
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(AppFeature.Tab.home)
            
            ListEntryView(store: store.scope(state: \.list, action: \.list))
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            .tag(AppFeature.Tab.list)
            
            ProfileEntryView(store: store.scope(state: \.profile, action: \.profile))
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
