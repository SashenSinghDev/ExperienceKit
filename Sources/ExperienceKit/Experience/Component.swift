//
//  Component.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation

public struct Component {
    let contentType: String
    let properties: Properties
    let id: UUID
}

extension Component: Codable {
    public enum CodingKeys: String, CodingKey {
        case contentType, properties, id
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
