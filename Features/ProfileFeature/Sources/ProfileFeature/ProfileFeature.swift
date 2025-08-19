import SwiftUI
import NavigationKit

public enum ProfileRoute: Hashable {
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
                    switch route {
                    case .detail1:
                        ProfileDetail1Screen(navigator: navigator)
                    case .detail2:
                        ProfileDetail2Screen(navigator: navigator)
                    }
                }
        }
    }
}

struct ProfileRootScreen: View {
    let navigator: ProfileNavigator
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            Spacer()

            Button("Go to Profile Detail 1") {
                navigator.push(.detail1)
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

struct ProfileDetail1Screen: View {
    let navigator: ProfileNavigator
    @State private var showSheet: Bool = false

    var body: some View {
        VStack {
            Spacer()

            Button("Go to Profile Detail 2") {
                navigator.push(.detail2)
            }
            .buttonStyle(.borderedProminent)

            Button("Show Bottom Sheet") {
                showSheet = true
            }
            .padding(.top, 12)

            Spacer()
        }
        .navigationTitle("Profile Detail 1")
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

struct ProfileDetail2Screen: View {
    let navigator: ProfileNavigator

    var body: some View {
        VStack {
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
