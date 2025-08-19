import Foundation

public enum AppEnvironment: String {
    case development
    case staging
    case production
}

public enum MatchPattern<E> {
    case empty
    case single(E)
    case pair(E, E)
    case triple(E, E, E)
    case quad(E, E, E, E)
    case quint(E, E, E, E, E)
    indirect case many(E, E, E, E, E, more: MatchPattern<E>)

    init(_ e: [E]) {
        switch e.count {
        case 0: self = .empty
        case 1: self = .single(e[0])
        case 2: self = .pair(e[0], e[1])
        case 3: self = .triple(e[0], e[1], e[2])
        case 4: self = .quad(e[0], e[1], e[2], e[3])
        case 5: self = .quint(e[0], e[1], e[2], e[3], e[4])
        default: self = .many(e[0], e[1], e[2], e[3], e[4], more: MatchPattern(Array(e[5...])))
        }
    }
}

public extension Array {
    var patternMatched: MatchPattern<Element> {
        MatchPattern(self)
    }
}

// Allows matching strings against regular expressions in Swift pattern matching.
public func ~= (regex: Regex<Substring>, string: String) -> Bool {
    return (try? regex.firstMatch(in: string)) != nil
}
