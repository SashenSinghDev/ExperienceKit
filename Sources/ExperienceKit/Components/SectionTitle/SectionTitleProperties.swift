//
//  SectionTitleProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/07/2025.
//

import Foundation

// sourcery: component = "sectiontitle"
public struct SectionTitleProperties {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}

extension SectionTitleProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> SectionTitleProperties {
        return try properties.decode(SectionTitleProperties.self, forKey: .properties)
    }
}
