import SwiftUI
import NavigationKit

@CasePathable
public enum HomeRoute: String, Hashable, CaseIterable {
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
            HomeRootScreen(navigator: navigator)
                .navigationTitle("Home")
                .navigationDestination(for: HomeRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .detail1:
            HomeDetail1Screen(navigator: navigator)
        case .detail2:
            HomeDetail2Screen(navigator: navigator)
        }
    }
}

struct HomeRootScreen: View {
    let navigator: HomeNavigator
    @Environment(\.openURL) private var openURL
    @State private var destination: HomeDestination?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Button("Go to Home Detail 1") {
                    navigator.push(.detail1)
                }
                .buttonStyle(.borderedProminent)

                Button("Go to deep in Profile") {
                    if let url = URL(string: "navexpo://navexpo/profile/detail1/detail2") {
                        openURL(url)
                    }
                }
                .buttonStyle(.bordered)

                Button("Show Alert") {
                    destination = .alert
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .alert("Home Alert", isPresented: .init(
            get: { destination == .alert },
            set: { _ in destination = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This is an alert on the Home root screen.")
        }
    }
}

// MARK: - Home Destinations

@CasePathable
enum HomeDestination {
    case alert
}

struct HomeDetail1Screen: View {
    let navigator: HomeNavigator
    @State private var destination: HomeDetail1Destination?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Button("Go to Home Detail 2") {
                    navigator.push(.detail2)
                }
                .buttonStyle(.borderedProminent)

                Button("Show Bottom Sheet") {
                    destination = .sheet
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .navigationTitle("Home Detail 1")
        .sheet(isPresented: .init(
            get: { destination == .sheet },
            set: { _ in destination = nil }
        )) {
            HomeBottomSheetView()
        }
    }
}

// MARK: - Home Detail 1 Destinations

@CasePathable
enum HomeDetail1Destination {
    case sheet
}

struct HomeBottomSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Home Bottom Sheet")
                .font(.headline)
            Text("This is a modal sheet presented from Home Detail 1.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Dismiss") {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct HomeDetail2Screen: View {
    let navigator: HomeNavigator

    var body: some View {
        VStack(spacing: 20) {
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
