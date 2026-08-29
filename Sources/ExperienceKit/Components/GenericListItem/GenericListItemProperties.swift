//
//  GenericListItemProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 12/07/2025.
//

import Foundation

// sourcery: component = "genericlistitem"
public struct GenericListItemProperties {
    public let title: String
    public let navigation: NavigationProperties?

    public init(title: String,
                navigation: NavigationProperties?) {
        self.title = title
        self.navigation = navigation
    }
}

extension GenericListItemProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> GenericListItemProperties {
        return try properties.decode(GenericListItemProperties.self, forKey: .properties)
    }
}
