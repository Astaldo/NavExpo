//
//  DeepLink.swift
//  Shared
//
//  Created by David Blake on 22/08/2025.
//

import Foundation

public enum DeepLink: Equatable {
    case home
    case list
    case profile
    case profileDetail1
    case profileDetail2

    public init?(from url: URL) {
        guard url.scheme == "navexpo" else { return nil }
        guard url.host == "navexpo" else { return nil }

        switch url.pathComponents.patternMatched {
        case .pair(_, "home"):
            self = .home
        case .pair(_, "profile"):
            self = .profile
        case .triple(_, "profile", "detail1"):
            self = .profileDetail1
        case .quad(_, "profile", "detail1", "detail2"):
            self = .profileDetail2
        case .pair(_, "list"):
            self = .list
        default:
            return nil
        }
    }
    
    // Convert DeepLink to AppRoute for navigation
    public func toAppRoutes() -> [AppRoute] {
        switch self {
        case .home:
            return []
        case .list:
            return []
        case .profile:
            return []
        case .profileDetail1:
            return [.profileDetail1]
        case .profileDetail2:
            return [.profileDetail1, .profileDetail2]
        }
    }
}
