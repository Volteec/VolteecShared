import Foundation

private enum NotificationStatus {
    static let online = "online"
    static let upsOffline = "ups_offline"
    static let serverUp = "server_up"
    static let serverDown = "server_down"
    static let serverUpdateRequired = "server_update_required"
    static let serverUpdateAvailable = "server_update_available"
    static let onBattery = "on_battery"
}

public enum NotificationStrings {
    public static func statusBody(displayName: String, status: String) -> String {
        let key: String
        switch status {
        case NotificationStatus.online:
            key = "notification.status.online"
        case NotificationStatus.upsOffline:
            key = "notification.status.offline"
        case NotificationStatus.serverUp:
            key = "notification.status.online"
        case NotificationStatus.serverDown:
            key = "notification.status.offline"
        case NotificationStatus.serverUpdateRequired:
            key = "notification.status.update_required"
        case NotificationStatus.serverUpdateAvailable:
            key = "notification.status.update_available"
        case NotificationStatus.onBattery:
            key = "notification.status.on_battery"
        default:
            key = "notification.status.changed"
        }

        let format = SharedLocalization.localizedString(key)
        return String(format: format, displayName)
    }
}
