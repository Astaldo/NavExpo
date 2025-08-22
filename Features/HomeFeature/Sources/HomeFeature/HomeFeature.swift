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
