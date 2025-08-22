//
//  RouteDefinition.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI

// MARK: - Route Definition Protocol for View Decoupling

public protocol DestinationRouterProtocol {
    @MainActor func destination(for route: AppRoute) -> AnyView
}
