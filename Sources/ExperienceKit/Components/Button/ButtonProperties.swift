//
//  ButtonProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 16/02/2025.
//

import Foundation

// sourcery: component = "button"
public struct ButtonProperties {
    public enum Style: Codable {
        case primary
        case secondary
    }

    public let title: String
    public let style: Style
    public let navigation: NavigationProperties
    public let isFullWidth: Bool

    public init(title: String,
                style: Style,
                isFullWidth: Bool,
                navigation: NavigationProperties) {
        self.title = title
        self.style = style
        self.isFullWidth = isFullWidth
        self.navigation = navigation
    }
}

extension ButtonProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ButtonProperties {
        return try properties.decode(ButtonProperties.self, forKey: .properties)
    }
}
