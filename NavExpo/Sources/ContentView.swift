import SwiftUI
import HomeFeature
import ListFeature
import ProfileFeature
import NavigationKit

public struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var navigationMode: NavigationMode = .uikit // Toggle for navigation mode
    @StateObject private var appNavigator = AppNavigator()
    private let screenFactory = ScreenFactory()

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeEntryView(
                navigator: self.appNavigator,
                desinationRouter: DestinationRouter(navigator: self.appNavigator, screenFactory: self.screenFactory),
                navigationMode: self.navigationMode
            )
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            ListEntryView(
                navigator: self.appNavigator,
                desinationRouter: DestinationRouter(navigator: self.appNavigator, screenFactory: self.screenFactory),
                navigationMode: self.navigationMode
            )
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(1)

            ProfileEntryView(
                navigator: self.appNavigator,
                desinationRouter: DestinationRouter(navigator: self.appNavigator, screenFactory: self.screenFactory),
                navigationMode: self.navigationMode
            )
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
            
            ModeToggleView(
                navigationMode: self.$navigationMode
            )
                .tabItem {
                    Label("NavMode", systemImage: "gearshape")
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
            self.appNavigator.popToRoot()

        case .list:
            self.selectedTab = 1
            self.appNavigator.popToRoot()

        case .profile:
            self.selectedTab = 2
            self.appNavigator.popToRoot()

        case .profileDetail1:
            self.selectedTab = 2
            self.appNavigator.setPath(deeplink.toAppRoutes())

        case .profileDetail2:
            self.selectedTab = 2
            self.appNavigator.setPath(deeplink.toAppRoutes())
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
