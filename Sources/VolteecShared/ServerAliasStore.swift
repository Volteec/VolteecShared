import Foundation

public enum ServerAliasStore {
    private static func defaults() -> UserDefaults? {
        SharedDefaults.defaults(context: "ServerAliasStore")
    }

    private static func key(tenantId: String, serverId: String) -> String {
        "server-alias.\(tenantId).\(serverId)"
    }

    public static func setAlias(_ alias: String?, tenantId: String, serverId: String) {
        guard let defaults = defaults() else { return }
        let trimmed = alias?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if trimmed.isEmpty {
            defaults.removeObject(forKey: key(tenantId: tenantId, serverId: serverId))
        } else {
            defaults.set(trimmed, forKey: key(tenantId: tenantId, serverId: serverId))
        }
    }

    public static func alias(tenantId: String, serverId: String) -> String? {
        guard let defaults = defaults() else { return nil }
        let value = defaults.string(forKey: key(tenantId: tenantId, serverId: serverId))
        return value?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func removeAlias(tenantId: String, serverId: String) {
        guard let defaults = defaults() else { return }
        defaults.removeObject(forKey: key(tenantId: tenantId, serverId: serverId))
    }
}
