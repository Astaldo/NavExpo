import SwiftUI
import NavigationKit

public struct ProfileEntryView: View {
    @ObservedObject private var navigator: AppNavigator
    private let desinationRouter: any DestinationRouterProtocol
    private let navigationMode: NavigationMode
 
    public init(
        navigator: AppNavigator,
        desinationRouter: any DestinationRouterProtocol,
        navigationMode: NavigationMode
    ) {
        self.navigator = navigator
        self.desinationRouter = desinationRouter
        self.navigationMode = navigationMode
    }

    public var body: some View {
        UINavigationStack(
            navigator: self.navigator,
            desinationRouter: self.desinationRouter,
            configuration: .init(mode: self.navigationMode)) {
                ProfileRootScreen(navigator: navigator)
                    .uiNavigationTitle("Profile")
        }
    }
}

public struct ProfileRootScreen: View, NavigationConfigurable {
    let navigator: AppNavigator
    @State private var showAlert: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var navigationConfiguration: NavigationBarData {
        var config = NavigationBarData()
        config.title = "👤 My Profile"
        config.titleDisplayMode = .always
        config.prefersLargeTitles = true
        config.applyPresetTheme(.purple)
        
        let settingsButton = UIBarButtonItem(
            systemItem: .edit,
            primaryAction: UIAction { _ in
                print("Edit profile settings")
            }
        )
        let notificationButton = UIBarButtonItem(
            systemItem: .reply,
            primaryAction: UIAction { _ in
                print("Profile notifications")
            }
        )
        config.leftBarButtonItems = [notificationButton]
        config.rightBarButtonItems = [settingsButton]
        
        return config
    }
    
    public var body: some View {
        VStack {
            Spacer()

            Button("Go to Profile Detail 1") {
                navigator.push(.profileDetail1)
            }
            .buttonStyle(.borderedProminent)

            Button("Show Alert") {
                showAlert = true
            }
            .padding(.top, 12)

            Spacer()
        }
        .alert("Profile Alert", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This is an alert on the Profile root screen.")
        }
    }
}

public struct ProfileDetail1Screen: View, NavigationConfigurable {
    let navigator: AppNavigator
    @State private var showSheet: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var navigationConfiguration: NavigationBarData {
        var config = NavigationBarData()
        config.title = "Account Info"
        config.titleDisplayMode = .never
        config.prefersLargeTitles = false
        config.backgroundColor = .systemIndigo
        config.foregroundColor = .white
        
        let securityButton = UIBarButtonItem(
            systemItem: .search,
            primaryAction: UIAction { _ in
                print("Security settings")
            }
        )
        config.rightBarButtonItems = [securityButton]
        
        return config
    }
    
    public var body: some View {
        VStack {
            Spacer()

            Button("Go to Profile Detail 2") {
                navigator.push(.profileDetail2)
            }
            .buttonStyle(.borderedProminent)

            Button("Show Bottom Sheet") {
                showSheet = true
            }
            .padding(.top, 12)

            Spacer()
        }
        .uiNavigationTitle("Profile Detail 1")
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 16) {
                Text("Profile Bottom Sheet")
                    .font(.headline)

                Text("This is a modal sheet presented from Profile Detail 1.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Dismiss") {
                    showSheet = false
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

public struct ProfileDetail2Screen: View, NavigationConfigurable {
    let navigator: AppNavigator

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var navigationConfiguration: NavigationBarData {
        var config = NavigationBarData()
        config.title = "Profile Detail 2"
        config.titleDisplayMode = .always
        config.prefersLargeTitles = true
        config.backgroundColor = .systemGray
        config.foregroundColor = .white
        
        let exportButton = UIBarButtonItem(
            systemItem: .action,
            primaryAction: UIAction { _ in
                print("Export profile data")
            }
        )
        let deleteButton = UIBarButtonItem(
            systemItem: .trash,
            primaryAction: UIAction { _ in
                print("Delete account (careful!)")
            }
        )
        
        config.rightBarButtonItems = [exportButton, deleteButton]
        
        return config
    }
    
    public var body: some View {
        VStack {
            Spacer()

            Button("Back to Profile Root") {
                navigator.popToRoot()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .uiNavigationTitle("Profile Detail 2")
    }
}
