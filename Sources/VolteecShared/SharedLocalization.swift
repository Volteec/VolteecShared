import Foundation

public enum SharedLocalization {
    private static let languageKey = "appLanguage"

    /// Stores the preferred app language (resolved to a supported localization).
    public static func storePreferredLanguage(preferredLocalizations: [String]) {
        guard let defaults = SharedDefaults.defaults(context: "SharedLocalization.storePreferredLanguage") else {
            return
        }
        guard let resolved = resolveLanguage(preferredLocalizations: preferredLocalizations) else {
            return
        }
        defaults.set(resolved, forKey: languageKey)
    }

    /// Returns the resolved app language code from App Group storage.
    public static func appLanguage() -> String? {
        guard let defaults = SharedDefaults.defaults(context: "SharedLocalization.appLanguage") else {
            return nil
        }
        return defaults.string(forKey: languageKey)
    }

    /// Returns a localized bundle for the stored app language, falling back to module bundle.
    public static func bundleForAppLanguage() -> Bundle {
        let moduleBundle = Bundle.module
        guard let language = appLanguage() else {
            return moduleBundle
        }
        let normalized = normalize(language)
        if let bundle = bundleForLanguage(normalized, moduleBundle: moduleBundle) {
            return bundle
        }
        if let base = normalized.split(separator: "-").first.map(String.init),
           let bundle = bundleForLanguage(base, moduleBundle: moduleBundle) {
            return bundle
        }
        return moduleBundle
    }

    /// Localizes a key using the stored app language.
    public static func localizedString(_ key: String) -> String {
        let bundle = bundleForAppLanguage()
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }

    private static func resolveLanguage(preferredLocalizations: [String]) -> String? {
        let available = Bundle.module.localizations.map { normalize($0) }
        for language in preferredLocalizations {
            let normalized = normalize(language)
            if available.contains(normalized) {
                return normalized
            }
            if let base = normalized.split(separator: "-").first.map(String.init),
               available.contains(base) {
                return base
            }
        }
        return available.first
    }

    private static func bundleForLanguage(_ language: String, moduleBundle: Bundle) -> Bundle? {
        guard let path = moduleBundle.path(forResource: language, ofType: "lproj") else {
            return nil
        }
        return Bundle(path: path)
    }

    private static func normalize(_ language: String) -> String {
        return language.replacingOccurrences(of: "_", with: "-").lowercased()
    }
}
