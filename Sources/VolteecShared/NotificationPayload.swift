//
//  NotificationPayload.swift
//  VolteecShared
//
//  Created by Teo Dragan on 15.01.2026.
//

import Foundation

/// Wrapper used to decode APNs userInfo into a strongly typed event.
/// This keeps NotificationService logic minimal and safe.
public struct NotificationPayload: Codable, Equatable {
    public let event: NotificationEvent

    public init(event: NotificationEvent) {
        self.event = event
    }

    /// Decode from APNs `userInfo` dictionary.
    public static func decode(from userInfo: [AnyHashable: Any]) throws -> NotificationPayload {
        let data = try JSONSerialization.data(withJSONObject: userInfo, options: [])
        do {
            return try JSONDecoder().decode(NotificationPayload.self, from: data)
        } catch {
            let event = try JSONDecoder().decode(NotificationEvent.self, from: data)
            return NotificationPayload(event: event)
        }
    }
}
