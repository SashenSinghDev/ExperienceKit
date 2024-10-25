//
//  Component.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation

public struct Component {
    public let contentType: String
    public let properties: Properties
    public let id: UUID

    public init(contentType: String, properties: Properties, id: UUID) {
        self.contentType = contentType
        self.properties = properties
        self.id = id
    }
}

extension Component: Codable {
    public enum CodingKeys: String, CodingKey {
        case contentType, properties, id, dependancy
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.contentType = try container.decode(String.self, forKey: .contentType)

        for register in allRegisters where register.contentType == self.contentType {
            self.properties = try register.propertiesType.fromComponent(properties: container)
            return
        }

        fatalError("unregistered component sent to the apps")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(contentType, forKey: .contentType)
    }
}
