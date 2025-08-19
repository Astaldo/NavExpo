import SwiftUI
import HomeFeature
import ListFeature
import ProfileFeature
import NavigationKit

public struct ContentView: View {
    @State private var selectedTab: Int = 0
    @StateObject private var homeNavigator = HomeNavigator()
    @StateObject private var listNavigator = ListNavigator()
    @StateObject private var profileNavigator = ProfileNavigator()

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeEntryView(navigator: self.homeNavigator)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            ListEntryView(navigator: self.listNavigator)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(1)

            ProfileEntryView(navigator: self.profileNavigator)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
        }
        .onOpenURL { url in
            self.handleDeepLink(url: url)
        }
    }

    private func handleDeepLink(url: URL) {
        guard let deeplink = DeepLink(from: url) else { return }

        switch deeplink {
        case .home:
            self.selectedTab = 0
            self.homeNavigator.popToRoot()

        case .list:
            self.selectedTab = 1
            self.listNavigator.popToRoot()

        case .profile:
            self.selectedTab = 2
            self.profileNavigator.popToRoot()

        case .profileDetail1:
            self.selectedTab = 2
            self.profileNavigator.setPath([.detail1])

        case .profileDetail2:
            self.selectedTab = 2
            self.profileNavigator.setPath([.detail1, .detail2])
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
