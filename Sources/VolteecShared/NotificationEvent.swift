//
//  NotificationEvent.swift
//  VolteecShared
//
//  Created by Teo Dragan on 15.01.2026.
//

import Foundation

/// Canonical notification event model shared between Backend payload,
/// App target, and Notification Service Extension.
///
/// This model is data-only and UI-agnostic.
public struct NotificationEvent: Codable, Equatable {
    public let tenantId: String?
    public let eventType: String
    public let upsId: String?
    public let upsAlias: String?
    public let status: String?
    public let serverId: String?
    public let environment: String

    public init(
        tenantId: String? = nil,
        eventType: String,
        upsId: String? = nil,
        upsAlias: String? = nil,
        status: String? = nil,
        serverId: String? = nil,
        environment: String
    ) {
        self.tenantId = tenantId
        self.eventType = eventType
        self.upsId = upsId
        self.upsAlias = upsAlias
        self.status = status
        self.serverId = serverId
        self.environment = environment
    }
}

// MARK: - Validation (soft, opt-in)

public enum NotificationValidationError: Error, CustomStringConvertible {
    case unsupportedEventType(String)
    case missingRequiredField(String)

    public var description: String {
        switch self {
        case .unsupportedEventType(let value):
            return "Unsupported eventType: \(value)"
        case .missingRequiredField(let field):
            return "Missing required field: \(field)"
        }
    }
}

public extension NotificationEvent {
    enum EventType: String {
        case statusChange = "status_change"
        case serverUp = "server_up"
        case serverDown = "server_down"
        case serverOutdated = "server_outdated"
        case batteryLow = "battery_low"
        case testNotification = "test_notification"
    }

    /// Soft validator for enterprise payload correctness.
    /// This is opt-in and does not change decoding behavior.
    func validate() throws {
        guard let type = EventType(rawValue: eventType) else {
            throw NotificationValidationError.unsupportedEventType(eventType)
        }

        switch type {
        case .statusChange:
            if upsId == nil { throw NotificationValidationError.missingRequiredField("upsId") }
            if status == nil { throw NotificationValidationError.missingRequiredField("status") }
        case .batteryLow:
            if upsId == nil { throw NotificationValidationError.missingRequiredField("upsId") }
        case .serverUp, .serverDown, .serverOutdated:
            if serverId == nil { throw NotificationValidationError.missingRequiredField("serverId") }
        case .testNotification:
            break
        }
    }
}
