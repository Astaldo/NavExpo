//
//  ModeToggleView.swift
//  NavExpo
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI
import NavigationKit

struct ModeToggleView: View {
    
    @Binding var navigationMode: NavigationMode
    
    var body: some View {
        VStack {
            Spacer()

            Button("SwiftUI") {
                self.navigationMode = .swiftui
            }
            .if(self.navigationMode == .swiftui, if: { button in
                button.buttonStyle(.borderedProminent)
            }, else: { button in
                button.buttonStyle(.bordered)
            })
            
            Button("UIKit") {
                self.navigationMode = .uikit
            }
            .if(self.navigationMode == .uikit, if: { button in
                button.buttonStyle(.borderedProminent)
            }, else: { button in
                button.buttonStyle(.bordered)
            })
            
            Spacer()
        }
    }
}

private extension View {
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}

#Preview {
    ModeToggleView(navigationMode: .constant(.swiftui))
}
