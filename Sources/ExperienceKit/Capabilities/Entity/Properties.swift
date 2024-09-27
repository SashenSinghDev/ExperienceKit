//
//  Properties.swift
//
//
//  Created by Sashen Singh on 31/05/2024.
//

import Foundation

public protocol Properties {
    static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> Self
}
