//
//  WelcomeProperties.swift
//  
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation

// sourcery: component = "welcome"
public struct WelcomeProperties {
    public let image: ExperienceImage
    public let description: DescriptionProperties
    public let primaryButton: ButtonProperties
    public let secondaryButton: ButtonProperties?

    public init(image: ExperienceImage,
                description: DescriptionProperties,
                primaryButton: ButtonProperties,
                secondaryButton: ButtonProperties?) {
        self.image = image
        self.description = description
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}

extension WelcomeProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> WelcomeProperties {
        return try properties.decode(WelcomeProperties.self, forKey: .properties)
    }
}
