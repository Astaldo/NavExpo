//
//  RouteDefinition.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import SwiftUI

@MainActor
public protocol DestinationRouterProtocol {
    func destination(for route: AppRoute) -> AnyView
    func destinationWithConfig(for route: AppRoute) -> (AnyView, NavigationBarDataFactory)
}
