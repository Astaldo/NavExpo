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
                    .navigationTitle("List")
        }
    }
}

public struct ListRootScreen: View {
    let navigator: AppNavigator
    @State private var showAlert: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
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

public struct ListDetail1Screen: View {
    let navigator: AppNavigator
    @State private var showSheet: Bool = false

    public init(navigator: AppNavigator) {
        self.navigator = navigator
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
        .navigationTitle("List Detail 1")
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

public struct ListDetail2Screen: View {
    let navigator: AppNavigator

    public init(navigator: AppNavigator) {
        self.navigator = navigator
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
        .navigationTitle("List Detail 2")
    }
}
