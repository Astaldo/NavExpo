//
//  UINavigationStack+Modifiers.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI

// MARK: - SwiftUI View Modifiers for Navigation Bar Customization

public extension View {
    /// Sets the navigation title for UINavigationStack
    func uiNavigationTitle(_ title: String) -> some View {
        modifier(NavigationTitleModifier(title: title))
    }
}

// MARK: - View Modifiers Implementation

private struct NavigationTitleModifier: ViewModifier {
    let title: String
    @Environment(\.uinc) private var proxy
    @Environment(\.navigationConfiguration) private var configuration
    
    func body(content: Content) -> some View {
        switch configuration.mode {
        case .uikit:
            content
                .onAppear {
                    proxy.navigationBarData.title = title
                    proxy.updateNavigationBar()
                }
        case .swiftui:
            content
                .navigationTitle(title)
        }
    }
}


