import SwiftUI
import SwiftNavigation
import NavigationKit

@CasePathable
public enum ListRoute: String, Hashable, CaseIterable {
    case listDetailsOne
    case listDetailsTwo
}

public typealias ListNavigator = FeatureNavigator<ListRoute>

public struct ListEntryView: View {
    @ObservedObject private var navigator: ListNavigator

    public init(navigator: ListNavigator) {
        self.navigator = navigator
    }

    public var body: some View {
        NavigationStack(path: $navigator.path) {
            ListRootScreen(navigator: navigator)
                .navigationTitle("List")
                .navigationDestination(for: ListRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: ListRoute) -> some View {
        switch route {
        case .listDetailsOne:
            ListDetail1Screen(navigator: navigator)
        case .listDetailsTwo:
            ListDetail2Screen(navigator: navigator)
        }
    }
}

struct ListRootScreen: View {
    let navigator: ListNavigator
    @State private var destination: ListDestination?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Button("Go to List Detail 1") {
                    navigator.push(.listDetailsOne)
                }
                .buttonStyle(.borderedProminent)

                Button("Show Alert") {
                    destination = .alert
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .alert("List Alert", isPresented: .init(
            get: { destination == .alert },
            set: { _ in destination = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This is an alert on the List root screen.")
        }
    }
}

// MARK: - List Destinations

@CasePathable
enum ListDestination {
    case alert
}

struct ListDetail1Screen: View {
    let navigator: ListNavigator
    @State private var destination: ListDetail1Destination?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Button("Go to List Detail 2") {
                    navigator.push(.listDetailsTwo)
                }
                .buttonStyle(.borderedProminent)

                Button("Show Bottom Sheet") {
                    destination = .sheet
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .navigationTitle("List Detail 1")
        .sheet(isPresented: .init(
            get: { destination == .sheet },
            set: { _ in destination = nil }
        )) {
            ListBottomSheetView()
        }
    }
}

// MARK: - List Detail 1 Destinations

@CasePathable
enum ListDetail1Destination {
    case sheet
}

struct ListBottomSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("List Bottom Sheet")
                .font(.headline)
            Text("This is a modal sheet presented from List Detail 1.")
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

struct ListDetail2Screen: View {
    let navigator: ListNavigator

    var body: some View {
        VStack(spacing: 20) {
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
