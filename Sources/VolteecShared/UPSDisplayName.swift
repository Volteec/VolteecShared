//
//  UPSDisplayName.swift
//  VolteecShared
//
//  Created by Teo Dragan on 15.01.2026.
//

import Foundation

/// Pure helper used by App and Notification Service to resolve
/// the user-visible UPS name.
///
/// Rules:
/// - alias is optional
/// - leading/trailing whitespace is trimmed
/// - empty alias is treated as nil
/// - fallback is always upsId
public struct UPSDisplayName: Equatable, Hashable {
    public let upsId: String
    public let alias: String?

    public init(upsId: String, alias: String?) {
        self.upsId = upsId

        let trimmed = alias?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.alias = (trimmed?.isEmpty == false) ? trimmed : nil
    }

    /// Final resolved name to be shown to the user.
    public var resolved: String {
        return alias ?? upsId
    }
}
