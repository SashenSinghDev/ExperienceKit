//
//  ButtonProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 16/02/2025.
//

import Foundation

public struct ButtonProperties {
    public enum Style: Codable {
        case primary
        case secondary
    }

    public let title: String
    public let style: Style
    public let navigation: NavigationProperties

    public init(title: String,
                style: Style,
                navigation: NavigationProperties) {
        self.title = title
        self.style = style
        self.navigation = navigation
    }
}

extension ButtonProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ButtonProperties {
        return try properties.decode(ButtonProperties.self, forKey: .properties)
    }
}
