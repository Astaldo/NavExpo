import Testing
@testable import FoundationKit

struct MatchPatternTests {
    @Test
    func empty() {
        switch [Int]().patternMatched {
        case .empty:
            break
        default:
            Issue.record("Expected .empty")
        }
    }

    @Test
    func single_pair_triple_quad_quint() {
        switch [1].patternMatched {
        case let .single(a):
            #expect(a == 1)
        default:
            Issue.record("Expected .single")
        }

        switch [1, 2].patternMatched {
        case let .pair(a, b):
            #expect([a, b] == [1, 2])
        default:
            Issue.record("Expected .pair")
        }

        switch [1, 2, 3].patternMatched {
        case let .triple(a, b, c):
            #expect([a, b, c] == [1, 2, 3])
        default:
            Issue.record("Expected .triple")
        }

        switch [1, 2, 3, 4].patternMatched {
        case let .quad(a, b, c, d):
            #expect([a, b, c, d] == [1, 2, 3, 4])
        default:
            Issue.record("Expected .quad")
        }

        switch [1, 2, 3, 4, 5].patternMatched {
        case let .quint(a, b, c, d, e):
            #expect([a, b, c, d, e] == [1, 2, 3, 4, 5])
        default:
            Issue.record("Expected .quint")
        }
    }

    @Test
    func many_recurses_correctly() {
        let input = [1, 2, 3, 4, 5, 6, 7, 8]
        let pat = input.patternMatched
        #expect(flatten(pat) == input)
    }

    @Test
    func match_pattern_with_regex() {
        let input = ["path", "name123"]
        let pat = input.patternMatched
        switch pat {
        case .pair("path", /name*/):
            break
        default:
            Issue.record("Expected match pattern with regex")
        }
    }

    // MARK: - Helpers

    private func flatten<E>(_ pattern: MatchPattern<E>) -> [E] {
        switch pattern {
        case .empty:
            return []
        case let .single(a):
            return [a]
        case let .pair(a, b):
            return [a, b]
        case let .triple(a, b, c):
            return [a, b, c]
        case let .quad(a, b, c, d):
            return [a, b, c, d]
        case let .quint(a, b, c, d, e):
            return [a, b, c, d, e]
        case let .many(a, b, c, d, e, more):
            return [a, b, c, d, e] + flatten(more)
        }
    }
}
