import Foundation
import Testing
@testable import NavigationKit

struct DeepLinkTests {
    @Test
    func parses_home_list_profile() {
        #expect(DeepLink(from: URL(string: "navexpo://navexpo/home")!) == .home)
        #expect(DeepLink(from: URL(string: "navexpo://navexpo/list")!) == .list)
        #expect(DeepLink(from: URL(string: "navexpo://navexpo/profile")!) == .profile)
    }

    @Test
    func parses_profile_details() {
        #expect(DeepLink(from: URL(string: "navexpo://navexpo/profile/detail1")!) == .profileDetail1)
        #expect(DeepLink(from: URL(string: "navexpo://navexpo/profile/detail1/detail2")!) == .profileDetail2)
    }

    @Test
    func rejects_unknown() {
        #expect(DeepLink(from: URL(string: "navexpo://navexpo/unknown")!) == nil)
        #expect(DeepLink(from: URL(string: "https://navexpo/profile")!) == nil)
        #expect(DeepLink(from: URL(string: "navexpo://wronghost/profile")!) == nil)
    }
}


