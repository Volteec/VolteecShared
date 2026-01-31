import Foundation

/// Core logic for determining compatibility state.
/// Pure functions only (Enterprise Standard).
public enum VersionLogic {
    
    /// Calculates the compatibility state by comparing server protocol against relay requirements.
    /// - Parameters:
    ///   - serverProtocol: The protocol version string reported by the server (e.g., "1.1")
    ///   - relayMeta: The canonical version requirements from Relay.
    /// - Returns: The calculated traffic light state.
    public static func calculateState(serverProtocol: String, relayMeta: RelayMeta) -> CompatibilityState {
        guard let serverVer = SemanticVersion(string: serverProtocol),
              let relayCurrent = SemanticVersion(string: relayMeta.protocolVersion.current),
              let relayMin = SemanticVersion(string: relayMeta.protocolVersion.min) else {
            return .invalid
        }
        
        // 1. Red Check (Unsupported): If Server < Min
        if serverVer < relayMin {
            return .unsupported
        }
        
        // 2. Yellow Check (Deprecated): If Server < Current
        if serverVer < relayCurrent {
            return .deprecated
        }
        
        // 3. Green Check (Supported): Server >= Current
        return .supported
    }
}
