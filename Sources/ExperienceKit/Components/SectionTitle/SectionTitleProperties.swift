//
//  SectionTitleProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/07/2025.
//

import Foundation

// sourcery: component = "sectionTitle"
public struct SectionTitleProperties {
    public let title: String
    public let showBottomBorder: Bool

    public init(title: String, showBottomBorder: Bool) {
        self.title = title
        self.showBottomBorder = showBottomBorder
    }
}

extension SectionTitleProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> SectionTitleProperties {
        return try properties.decode(SectionTitleProperties.self, forKey: .properties)
    }
}
