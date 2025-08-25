import SwiftUI
import NavigationKit

public struct ListEntryView: View {
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
                ListRootScreen(navigator: self.navigator)
                    .uiNavigationTitle("List")
        }
    }
}

public struct ListRootScreen: View, NavigationConfigurable {
    let navigator: AppNavigator
    @State private var showAlert: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var navigationConfiguration: NavigationBarDataFactory {
        return {
            var config = NavigationBarData()
            config.title = "📋 Lists Central"
            config.titleDisplayMode = .always
            config.prefersLargeTitles = true
            config.applyPresetTheme(.green)
            
            let addButton = UIBarButtonItem(
                systemItem: .add,
                primaryAction: UIAction { _ in
                    print("Add new list item")
                }
            )
            let searchButton = UIBarButtonItem(
                systemItem: .search,
                primaryAction: UIAction { _ in
                    print("Search lists")
                }
            )
            config.rightBarButtonItems = [searchButton, addButton]
            
            return config
        }
    }
    
    public var body: some View {
        VStack {
            Spacer()

            Button("Go to List Detail 1") {
                navigator.push(.listDetail1)
            }
            .buttonStyle(.borderedProminent)

            Button("Show Alert") {
                showAlert = true
            }
            .padding(.top, 12)

            Spacer()
        }
        .alert("List Alert", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This is an alert on the List root screen.")
        }
    }
}

public struct ListDetail1Screen: View, NavigationConfigurable {
    let navigator: AppNavigator
    @State private var showSheet: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var navigationConfiguration: NavigationBarDataFactory {
        return {
            var config = NavigationBarData()
            config.title = "List Items"
            config.titleDisplayMode = .never
            config.prefersLargeTitles = false
            config.backgroundColor = .systemTeal
            config.foregroundColor = .black
            
            let editButton = UIBarButtonItem(
                systemItem: .edit,
                primaryAction: UIAction { _ in
                    print("Edit list items")
                }
            )
            config.rightBarButtonItems = [editButton]
            
            return config
        }
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Button("Go to List Detail 2") {
                navigator.push(.listDetail2)
            }
            .buttonStyle(.borderedProminent)
            Button("Show Bottom Sheet") {
                showSheet = true
            }
            .padding(.top, 12)
            Spacer()
        }
        .uiNavigationTitle("List Detail 1")
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 16) {
                Text("List Bottom Sheet")
                    .font(.headline)
                Text("This is a modal sheet presented from List Detail 1.")
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

public struct ListDetail2Screen: View, NavigationConfigurable {
    let navigator: AppNavigator

    public init(navigator: AppNavigator) {
        self.navigator = navigator
    }
    
    public var navigationConfiguration: NavigationBarDataFactory {
        return {
            var config = NavigationBarData()
            config.title = "✨ List Details"
            config.titleDisplayMode = .always
            config.prefersLargeTitles = true
            config.applyPresetTheme(.red)
            
            let refreshButton = UIBarButtonItem(
                systemItem: .refresh,
                primaryAction: UIAction { _ in
                    print("Refresh list details")
                }
            )
            let moreButton = UIBarButtonItem(
                systemItem: .reply,
                primaryAction: UIAction { _ in
                    print("More options for list")
                }
            )
            config.leftBarButtonItems = [moreButton]
            config.rightBarButtonItems = [refreshButton]
            
            return config
        }
    }
    
    public var body: some View {
        VStack {
            Spacer()

            Button("Back to List Root") {
                navigator.popToRoot()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .uiNavigationTitle("List Detail 2")
    }
}
