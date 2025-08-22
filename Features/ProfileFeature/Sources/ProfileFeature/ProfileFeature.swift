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

public struct ProfileRootScreen: View {
    let navigator: AppNavigator
    @State private var showAlert: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
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

public struct ProfileDetail1Screen: View {
    let navigator: AppNavigator
    @State private var showSheet: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
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

public struct ProfileDetail2Screen: View {
    let navigator: AppNavigator

    public init(navigator: AppNavigator) {
        self.navigator = navigator
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
