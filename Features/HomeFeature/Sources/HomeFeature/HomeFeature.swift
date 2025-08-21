import SwiftUI
import NavigationKit

// MARK: - Home Navigation State

@Observable
public class HomeModel {
    var destination: Destination?

    @CasePathable
    public enum Destination {
        case detailOne(model: String)
        case detailTwo(model: String)
        case alert(model: String)
        case bottomSheet(model: String)
    }

    func navigateToDetailOne() {
        self.destination = .detailOne(model: "Detail One Model")
    }

    func navigateToDetailTwo() {
        self.destination = .detailTwo(model: "Detail Two Model")
    }

    func presentAlert() {
        self.destination = .alert(model: "Alert Model")
    }

    func presentBottomSheet() {
        self.destination = .bottomSheet(model: "Bottom Sheet Model")
    }

    func popToRoot() {
        self.destination = nil
    }
}

// MARK: - Public Entry Point

public struct HomeEntryView: View {
    @State var model = HomeModel()
    @Environment(\.openURL) private var openURL

    public init() {}

    public var body: some View {
        NavigationStack() {
            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 16) {
                    Button("Go to Home Detail 1") {
                        model.navigateToDetailOne()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Go to deep in Profile") {
                        guard let url = URL(string: "navexpo://navexpo/profile/detail1/detail2") else { return }
                        openURL(url)
                    }
                    .buttonStyle(.bordered)

                    Button("Show Alert") {
                        model.presentAlert()
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .navigationTitle("Home")
            .navigationDestination(item: $model.destination.detailOne) { _ in
                HomeDetail1Screen(model: self.model)
            }
        }
    }
}

// MARK: - Home Root Screen

// MARK: - Detail Screens

struct HomeDetail1Screen: View {
    @State var model: HomeModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 16) {
                Button("Go to Home Detail 2") {
                    model.navigateToDetailTwo()
                }
                .buttonStyle(.borderedProminent)

                Button("Show Bottom Sheet") {
                    model.presentBottomSheet()
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .navigationTitle("Home Detail 1")
        .navigationDestination(item: $model.destination.detailTwo) { _ in
            HomeDetail2Screen(model: self.model)
        }
    }
}

struct HomeDetail2Screen: View {
    @State var model: HomeModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Button("Back to Home Root") {
                model.popToRoot()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .navigationTitle("Home Detail 2")
    }
}

struct HomeBottomSheetView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Home Bottom Sheet")
                .font(.headline)
            Text("This is a modal sheet presented from Home Detail 1.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Dismiss") {
                // TODO: dismiss
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
