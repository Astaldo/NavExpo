//
//  AppScreenFactoryProtocol.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI

// MARK: - Screen Factory Protocol

public protocol AppScreenFactoryProtocol {
    @MainActor func makeHomeDetail1(navigator: AppNavigator) -> AnyView
    @MainActor func makeHomeDetail2(navigator: AppNavigator) -> AnyView
    @MainActor func makeListDetail1(navigator: AppNavigator) -> AnyView
    @MainActor func makeListDetail2(navigator: AppNavigator) -> AnyView
    @MainActor func makeProfileDetail1(navigator: AppNavigator) -> AnyView
    @MainActor func makeProfileDetail2(navigator: AppNavigator) -> AnyView
}
