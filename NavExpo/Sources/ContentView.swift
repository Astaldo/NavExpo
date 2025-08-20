import SwiftUI
import HomeFeature
import ListFeature
import ProfileFeature
import NavigationKit

public struct ContentView: View {
    @StateObject private var tabState = TabNavigationState()
    @StateObject private var homeNavigator = HomeNavigator()
    @StateObject private var listNavigator = ListNavigator()
    @StateObject private var profileNavigator = ProfileNavigator()

    public init() {}

    public var body: some View {
        TabView(selection: $tabState.selectedTab) {
            HomeEntryView(navigator: homeNavigator)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            ListEntryView(navigator: listNavigator)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(1)

            ProfileEntryView(navigator: profileNavigator)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
        }
        .onOpenURL { url in
            handleDeepLink(url: url)
        }
    }

    private func handleDeepLink(url: URL) {
        guard let deeplink = DeepLink(from: url) else { return }

        switch deeplink {
        case .home:
            tabState.selectTab(0)
            homeNavigator.popToRoot()

        case .list:
            tabState.selectTab(1)
            listNavigator.popToRoot()

        case .profile:
            tabState.selectTab(2)
            profileNavigator.popToRoot()

        case .profileDetail1:
            tabState.selectTab(2)
            profileNavigator.setPath([.detail1])

        case .profileDetail2:
            tabState.selectTab(2)
            profileNavigator.setPath([.detail1, .detail2])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
