import SwiftUI
import NavigationKit

public struct HomeEntryView: View {
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
                HomeRootScreen(
                    navigator: navigator
                )
                .uiNavigationTitle("Home")
        }
    }
}

public struct HomeRootScreen: View {
    let navigator: AppNavigator
    @Environment(\.openURL) private var openURL
    @State private var showAlert: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var body: some View {
        VStack {
            Spacer()

            Button("Go to Home Detail 1") {
                navigator.push(.homeDetail1)
            }
            .buttonStyle(.borderedProminent)
            
            Button("NavigationConfigurable Demo") {
                navigator.uiNavigationProxy?.push(HomeConfigurableDetailScreen(navigator: navigator))
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 12)

            Button("Go to deep in Profile") {
                if let url = URL(string: "navexpo://navexpo/profile/detail1/detail2") {
                    openURL(url)
                }
            }
            .padding(.top, 12)

            Button("Show Alert") {
                showAlert = true
            }
            .padding(.top, 12)

            Spacer()
        }
        .alert("Home Alert", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This is an alert on the Home root screen.")
        }
    }
}

public struct HomeDetail1Screen: View {
    let navigator: AppNavigator
    @State private var showSheet: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Button("Go to Home Detail 2") {
                navigator.push(.homeDetail2)
            }
            .buttonStyle(.borderedProminent)
            Button("Show Bottom Sheet") {
                showSheet = true
            }
            .padding(.top, 12)
            Spacer()
        }
        .uiNavigationTitle("Home Detail 1")
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 16) {
                Text("Home Bottom Sheet")
                    .font(.headline)
                Text("This is a modal sheet presented from Home Detail 1.")
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

public struct HomeDetail2Screen: View {
    let navigator: AppNavigator

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Button("Back to Home Root") {
                navigator.popToRoot()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .uiNavigationTitle("Home Detail 2")
    }
}

public struct HomeConfigurableDetailScreen: View, NavigationConfigurable {
    let navigator: AppNavigator

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var navigationConfiguration: NavigationBarData {
        var config = NavigationBarData()
        config.title = "Configured Screen"
        config.titleDisplayMode = .never
        config.prefersLargeTitles = false
        
        // Add custom colors for Level 1 using preset theme
        config.applyPresetTheme(.red)
        
        // Right bar button item for Level 1
        let infoButton = UIBarButtonItem(
            systemItem: .bookmarks,
            primaryAction: UIAction { _ in
                print("Info button tapped on Level 1")
            }
        )
        config.rightBarButtonItems = [infoButton]
        
        return config
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("NavigationConfigurable Demo")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("This screen demonstrates the NavigationConfigurable protocol. The title and navigation settings are configured upfront, ensuring seamless transitions.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Configuration applied:")
                    .font(.headline)
                Text("• Title: 'Configured Screen'")
                Text("• Title Display Mode: Never")
                Text("• Prefers Large Titles: false")
                Text("• Background: Blue")
                Text("• Foreground: White")
                Text("• Right: Bookmarks button")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Button("Go to Level 2") {
                navigator.uiNavigationProxy?.push(HomeConfigurableDetailScreen2(navigator: navigator))
            }
            .buttonStyle(.borderedProminent)
            
            Button("Back to Home Root") {
                navigator.popToRoot()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 12)
            
            Spacer()
        }
        .padding()
    }
}

public struct HomeConfigurableDetailScreen2: View, NavigationConfigurable {
    let navigator: AppNavigator
    @State private var showAlert = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var navigationConfiguration: NavigationBarData {
        var config = NavigationBarData()
        config.title = "Level 2 Screen"
        config.titleDisplayMode = .always
        config.prefersLargeTitles = true
        
        // Add custom colors for Level 2 - different from Level 1 using preset theme
        config.applyPresetTheme(.green)
        
        // Left bar button item
        let leftButton = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { _ in
                // This would need to be handled differently in a real app
                // For demo purposes, we'll just print
                print("Add button tapped")
            }
        )
        config.leftBarButtonItems = [leftButton]
        
        // Right bar button items
        let editButton = UIBarButtonItem(
            systemItem: .edit,
            primaryAction: UIAction { _ in
                print("Edit button tapped")
            }
        )
        let shareButton = UIBarButtonItem(
            systemItem: .action,
            primaryAction: UIAction { _ in
                print("Share button tapped")
            }
        )
        config.rightBarButtonItems = [editButton, shareButton]
        
        return config
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Level 2 Demo")
                .font(.title)
                .fontWeight(.bold)
            
            Text("This screen demonstrates NavigationConfigurable with custom bar button items.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Navigation Configuration:")
                    .font(.headline)
                Text("• Title: 'Level 2 Screen'")
                Text("• Large Title Display Mode")
                Text("• Background: Green")
                Text("• Foreground: Black")
                Text("• Left: Add button")
                Text("• Right: Edit & Share buttons")
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            
            Text("Note: Bar button actions are logged to console in this demo.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Show Alert") {
                showAlert = true
            }
            .buttonStyle(.borderedProminent)
            
            Button("Back to Level 1") {
                navigator.pop()
            }
            .buttonStyle(.bordered)
            
            Button("Back to Home Root") {
                navigator.popToRoot()
            }
            .buttonStyle(.bordered)
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .alert("Level 2 Alert", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This alert demonstrates that the navigation bar configuration doesn't interfere with other SwiftUI functionality.")
        }
    }
}
