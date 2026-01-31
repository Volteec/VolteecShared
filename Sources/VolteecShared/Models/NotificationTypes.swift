import Foundation

/// Constants for standardized notification event types.
public enum NotificationType {
    /// Standard UPS status change (Online, On Battery, etc.)
    public static let statusChange = "status_change"
    
    /// Server is back online
    public static let serverUp = "server_up"
    
    /// Server is considered offline
    public static let serverDown = "server_down"
    
    /// Server is outdated and requires immediate update (Task-023)
    public static let serverOutdated = "server_outdated"
}
