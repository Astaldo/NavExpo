import SwiftUI
import NavigationKit

public enum HomeRoute: Hashable {
    case detail1
    case detail2
}

public typealias HomeNavigator = FeatureNavigator<HomeRoute>

public struct HomeEntryView: View {
    @ObservedObject private var navigator: HomeNavigator

    public init(navigator: HomeNavigator) {
        self.navigator = navigator
    }

    public var body: some View {
        NavigationStack(path: $navigator.path) {
            HomeRootScreen(
                navigator: navigator
            )
            .navigationTitle("Home")
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .detail1:
                    HomeDetail1Screen(navigator: self.navigator)
                case .detail2:
                    HomeDetail2Screen(navigator: self.navigator)
                }
            }
        }
    }
}

struct HomeRootScreen: View {
    let navigator: HomeNavigator
    @Environment(\.openURL) private var openURL
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            Spacer()

            Button("Go to Home Detail 1") {
                navigator.push(.detail1)
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

struct HomeDetail1Screen: View {
    let navigator: HomeNavigator
    @State private var showSheet: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Button("Go to Home Detail 2") {
                navigator.push(.detail2)
            }
            .buttonStyle(.borderedProminent)
            Button("Show Bottom Sheet") {
                showSheet = true
            }
            .padding(.top, 12)
            Spacer()
        }
        .navigationTitle("Home Detail 1")
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

struct HomeDetail2Screen: View {
    let navigator: HomeNavigator

    var body: some View {
        VStack {
            Spacer()
            Button("Back to Home Root") {
                navigator.popToRoot()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .navigationTitle("Home Detail 2")
    }
}
