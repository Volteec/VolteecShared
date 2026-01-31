import Foundation

enum SharedDefaults {
    static let suiteName = "group.com.volteec.volteec"

    static func defaults(context: String) -> UserDefaults? {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            #if DEBUG
            print("[VolteecShared] Missing app group suite: \(suiteName) (\(context))")
            #endif
            return nil
        }
        return defaults
    }

    static func containerURL() -> URL? {
        #if os(iOS)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: suiteName)
        #if DEBUG
        if url == nil {
            print("[VolteecShared] Missing app group container: \(suiteName)")
        }
        #endif
        return url
        #else
        return nil
        #endif
    }
}
