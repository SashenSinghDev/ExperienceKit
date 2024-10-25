//
//  ExampleProperties.swift
//
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation

public struct ExampleProperties {
    public let title: String
    public let profilePlaceholder: String
    public let initialAmount: Int

    public init(title: String, profilePlaceholder: String, initialAmount: Int) {
        self.title = title
        self.profilePlaceholder = profilePlaceholder
        self.initialAmount = initialAmount
    }
}

extension ExampleProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> ExampleProperties {
        return try properties.decode(ExampleProperties.self, forKey: .properties)
    }
}

#if DEBUG
public extension ExampleProperties {
    static var mock: Component {
        Component(contentType: "exampleComponent",
                  properties: ExampleProperties(title: "mockTitle", 
                                                profilePlaceholder: "Enter your bio",
                                                initialAmount: 1),
                  id: UUID())
    }
}
#endif
