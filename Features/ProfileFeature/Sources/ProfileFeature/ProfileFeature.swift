import SwiftUI
import ComposableArchitecture

public struct ProfileEntryView: View {
    @Bindable var store: StoreOf<ProfileFeature>
    
    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }
    
    public var body: some View {
        @Bindable var store = self.store
        
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ProfileRootView(store: store)
                .navigationTitle("Profile")
        } destination: { store in
            switch store.case {
            case let .detail1(store):
                ProfileDetail1View(store: store)
            case let .detail2(store):
                ProfileDetail2View(store: store)
            }
        }
    }
}

struct ProfileRootView: View {
    @Bindable var store: StoreOf<ProfileFeature>
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text(store.username)
                .font(.title)
            
            Text(store.bio)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("View Profile Details") {
                store.send(.goToDetail1)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct ProfileDetail1View: View {
    let store: StoreOf<ProfileDetail1Feature>
    
    var body: some View {
        VStack {
            Text("Profile Detail 1")
                .font(.largeTitle)
            
            Button("Go to Detail 2") {
                store.send(.goToDetail2)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
        .navigationTitle("Profile Detail 1")
    }
}

struct ProfileDetail2View: View {
    let store: StoreOf<ProfileDetail2Feature>
    
    var body: some View {
        VStack {
            Text("Profile Detail 2")
                .font(.largeTitle)
            
            Button("Back to Root") {
                store.send(.popToRoot)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
        .navigationTitle("Profile Detail 2")
    }
}
