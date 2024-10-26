//
//  WelcomeProperties.swift
//  
//
//  Created by Sashen Singh on 25/10/2024.
//

import Foundation

public struct WelcomeProperties {
    public let image: ExperienceImage

    public init(image: ExperienceImage) {
        self.image = image
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
                  properties: WelcomeProperties(image: .init(uri: "welcome-image", bundle: Bundle.main.bundleIdentifier ?? "")),
                  id: UUID())
    }
}
#endif
