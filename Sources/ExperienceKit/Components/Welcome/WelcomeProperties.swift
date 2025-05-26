//
//  WelcomeProperties.swift
//  
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation

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

#if DEBUG
public extension WelcomeProperties {
    static var mock: Component {
        Component(contentType: "welcomeComponent",
                  properties: mockProperties,
                  id: UUID())
    }

    static var mockProperties: WelcomeProperties {
        return WelcomeProperties(image: .init(uri: "welcome-image",
                                              bundle: Bundle.main.bundleIdentifier ?? ""),
                                 description: .init(title: "Welcome to 👋 GymBru",
                                                    subtitle: "A personal trainer in your pocket",
                                                    style: .large(.inverted)),
                                 primaryButton: .init(title: "Log In",
                                                      style: .secondary,
                                                      navigation: .init(navigationType: .push("secondaryDestination"), deferredLoadingWorkId: "nil")),
                                 secondaryButton: .init(title: "Get Started",
                                                        style: .primary,
                                                        navigation: .init(navigationType: .modal("primaryDestination"), deferredLoadingWorkId: "test")))
    }
}
#endif
