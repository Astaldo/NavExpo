import SwiftUI
import SwiftNavigation
import NavigationKit

@CasePathable
public enum ProfileRoute: String, Hashable, CaseIterable {
    case detail1
    case detail2
}

public typealias ProfileNavigator = FeatureNavigator<ProfileRoute>

public struct ProfileEntryView: View {
    @ObservedObject private var navigator: ProfileNavigator

    public init(navigator: ProfileNavigator) {
        self.navigator = navigator
    }

    public var body: some View {
        NavigationStack(path: $navigator.path) {
            ProfileRootScreen(navigator: navigator)
                .navigationTitle("Profile")
                .navigationDestination(for: ProfileRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: ProfileRoute) -> some View {
        switch route {
        case .detail1:
            ProfileDetail1Screen(navigator: navigator)
        case .detail2:
            ProfileDetail2Screen(navigator: navigator)
        }
    }
}

struct ProfileRootScreen: View {
    let navigator: ProfileNavigator
    @State private var destination: ProfileDestination?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Button("Go to Profile Detail 1") {
                    navigator.push(.detail1)
                }
                .buttonStyle(.borderedProminent)

                Button("Show Alert") {
                    destination = .alert
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .alert("Profile Alert", isPresented: .init(
            get: { destination == .alert },
            set: { _ in destination = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This is an alert on the Profile root screen.")
        }
    }
}

// MARK: - Profile Destinations

@CasePathable
enum ProfileDestination {
    case alert
}

struct ProfileDetail1Screen: View {
    let navigator: ProfileNavigator
    @State private var destination: ProfileDetail1Destination?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Button("Go to Profile Detail 2") {
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
        .navigationTitle("Profile Detail 1")
        .sheet(isPresented: .init(
            get: { destination == .sheet },
            set: { _ in destination = nil }
        )) {
            ProfileBottomSheetView()
        }
    }
}

// MARK: - Profile Detail 1 Destinations

@CasePathable
enum ProfileDetail1Destination {
    case sheet
}

struct ProfileBottomSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Profile Bottom Sheet")
                .font(.headline)

            Text("This is a modal sheet presented from Profile Detail 1.")
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

struct ProfileDetail2Screen: View {
    let navigator: ProfileNavigator

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Button("Back to Profile Root") {
                navigator.popToRoot()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .navigationTitle("Profile Detail 2")
    }
}
