//
//  File.swift
//  
//
//  Created by Sashen Singh on 04/07/2024.
//

import Foundation

public struct ExampleProperties {
    let title: String
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
                  properties: ExampleProperties(title: "mockTitle"),
                  id: UUID())
    }
}
#endif
