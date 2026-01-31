import Foundation

/// The traffic light compatibility state determined by the client.
public enum CompatibilityState: String, Codable, Sendable {
    /// 🟢 Green: Fully supported.
    case supported

    /// 🟡 Yellow: Supported, but update is available.
    case deprecated

    /// 🔴 Red: Outdated. Protocol version is below minimum.
    case unsupported

    /// ⚪️ Grey: Relay unreachable (network error, timeout, HTTP error).
    case unreachable

    /// ⚪️ Grey: Metadata invalid (parse error, malformed data).
    case invalid
}

/// The Metadata response from Relay (Source of Truth).
/// GET /meta
public struct RelayMeta: Codable, Sendable {
    public struct ProtocolVersion: Codable, Sendable {
        /// The latest recommended protocol version (e.g., "1.2")
        public let current: String
        /// The minimum supported protocol version (e.g., "1.1")
        public let min: String
        
        public init(current: String, min: String) {
            self.current = current
            self.min = min
        }
    }
    
    public let protocolVersion: ProtocolVersion
    public let deprecatedVersions: [String]
    public let message: String?
    
    public init(protocolVersion: ProtocolVersion, deprecatedVersions: [String] = [], message: String? = nil) {
        self.protocolVersion = protocolVersion
        self.deprecatedVersions = deprecatedVersions
        self.message = message
    }
}

/// The Status response from Backend Server.
/// GET /status
public struct ServerStatusResponse: Codable, Sendable {
    /// The actual software version of the backend (e.g., "1.1.0")
    public let version: String
    /// The protocol version implemented (e.g., "1.1")
    public let protocolVersion: String
    /// The compatibility state (calculated by the server itself against Relay, optional)
    public let compatibility: CompatibilityState?
    
    public init(version: String, protocolVersion: String, compatibility: CompatibilityState? = nil) {
        self.version = version
        self.protocolVersion = protocolVersion
        self.compatibility = compatibility
    }
}
