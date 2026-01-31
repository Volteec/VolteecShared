import Foundation

/// Represents a strict Semantic Version (Major.Minor.Patch).
/// Used for protocol negotiation and compatibility checks.
public struct SemanticVersion: Codable, Equatable, Comparable, CustomStringConvertible, Sendable {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public init(major: Int, minor: Int, patch: Int = 0) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    /// Parses a string like "1.2" or "1.2.3".
    /// Defaults to 0 for missing components.
    /// Returns nil if format is invalid.
    public init?(string: String) {
        let components = string.split(separator: ".").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard !components.isEmpty, components.count <= 3 else { return nil }
        
        self.major = components[0]
        self.minor = components.count > 1 ? components[1] : 0
        self.patch = components.count > 2 ? components[2] : 0
    }
    
    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
    
    public var description: String {
        return "\(major).\(minor).\(patch)"
    }
    
    /// Returns "Major.Minor" string, ignoring patch for protocol negotiation.
    public var protocolString: String {
        return "\(major).\(minor)"
    }
}
