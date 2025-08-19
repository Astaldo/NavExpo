import SwiftUI
import NavigationKit

public enum ListRoute: Hashable {
    case detail1
    case detail2
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
                    switch route {
                    case .detail1:
                        ListDetail1Screen(navigator: navigator)
                    case .detail2:
                        ListDetail2Screen(navigator: navigator)
                    }
                }
        }
    }
}

struct ListRootScreen: View {
    let navigator: ListNavigator
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            Spacer()

            Button("Go to List Detail 1") {
                navigator.push(.detail1)
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

struct ListDetail1Screen: View {
    let navigator: ListNavigator
    @State private var showSheet: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Button("Go to List Detail 2") {
                navigator.push(.detail2)
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

struct ListDetail2Screen: View {
    let navigator: ListNavigator

    var body: some View {
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
