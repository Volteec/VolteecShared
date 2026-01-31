import Foundation

public enum AliasStore {
    private static func defaults() -> UserDefaults? {
        SharedDefaults.defaults(context: "AliasStore")
    }

    private static func key(tenantId: String, upsId: String) -> String {
        "alias.\(tenantId).\(upsId)"
    }

    public static func setAlias(_ alias: String?, tenantId: String, upsId: String) {
        let trimmed = alias?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        setString(trimmed.isEmpty ? nil : trimmed, tenantId: tenantId, upsId: upsId)
    }

    public static func alias(tenantId: String, upsId: String) -> String? {
        getString(tenantId: tenantId, upsId: upsId)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func removeAlias(tenantId: String, upsId: String) {
        setString(nil, tenantId: tenantId, upsId: upsId)
    }
}

// MARK: - Shared File Store (App + NSE sync)

private enum AliasFileStore {
    private static let directoryName = "aliases"

    private static func baseURL() -> URL? {
        SharedDefaults.containerURL()
    }

    private static func fileURL(tenantId: String, upsId: String) -> URL? {
        guard let base = baseURL() else { return nil }
        return base.appendingPathComponent(directoryName, isDirectory: true)
            .appendingPathComponent("\(tenantId)_\(upsId).txt")
    }

    static func read(tenantId: String, upsId: String) -> String? {
        #if os(iOS)
        guard let url = fileURL(tenantId: tenantId, upsId: upsId) else { return nil }
        var value: String?
        let coordinator = NSFileCoordinator(filePresenter: nil)
        coordinator.coordinate(readingItemAt: url, options: [], error: nil) { readURL in
            value = try? String(contentsOf: readURL, encoding: .utf8)
        }
        return value
        #else
        return nil
        #endif
    }

    static func write(_ value: String?, tenantId: String, upsId: String) {
        #if os(iOS)
        guard let url = fileURL(tenantId: tenantId, upsId: upsId) else { return }
        let coordinator = NSFileCoordinator(filePresenter: nil)
        coordinator.coordinate(writingItemAt: url, options: .forReplacing, error: nil) { writeURL in
            let fm = FileManager.default
            let dir = writeURL.deletingLastPathComponent()
            try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
            if let value {
                try? value.data(using: .utf8)?.write(to: writeURL, options: .atomic)
            } else {
                try? fm.removeItem(at: writeURL)
            }
        }
        #else
        _ = value
        #endif
    }
}

// MARK: - Bridging Helpers

private extension AliasStore {
    static func getString(tenantId: String, upsId: String) -> String? {
        if let fileValue = AliasFileStore.read(tenantId: tenantId, upsId: upsId) {
            return fileValue
        }
        guard let defaults = defaults() else { return nil }
        return defaults.string(forKey: key(tenantId: tenantId, upsId: upsId))
    }

    static func setString(_ value: String?, tenantId: String, upsId: String) {
        AliasFileStore.write(value, tenantId: tenantId, upsId: upsId)
        guard let defaults = defaults() else { return }
        if let value {
            defaults.set(value, forKey: key(tenantId: tenantId, upsId: upsId))
        } else {
            defaults.removeObject(forKey: key(tenantId: tenantId, upsId: upsId))
        }
    }
}
