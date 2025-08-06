//
//  DescriptionProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 01/01/2025.
//

import Foundation

// sourcery: component = "description"
public struct DescriptionProperties {
    public enum Theme: Codable {
        case regular
        case inverted
    }

    public enum Style: Codable {
        case regular(Theme)
        case large(Theme)
    }

    public let title: String
    public let subtitle: String
    public let style: Style

    public init(title: String,
                subtitle: String,
                style: Style) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
    }
}

extension DescriptionProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> DescriptionProperties {
        return try properties.decode(DescriptionProperties.self, forKey: .properties)
    }
}
