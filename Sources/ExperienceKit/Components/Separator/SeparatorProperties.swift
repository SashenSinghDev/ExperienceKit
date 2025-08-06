//
//  SeparatorProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 25/07/2025.
//

import Foundation

// sourcery: component = "separator"
public struct SeparatorProperties {
    public let isFullWidth: Bool

    public init(isFullWidth: Bool) {
        self.isFullWidth = isFullWidth
    }
}

extension SeparatorProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> SeparatorProperties {
        return try properties.decode(SeparatorProperties.self, forKey: .properties)
    }
}
