//
//  SelectionCardProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/09/2026.
//

import Foundation

// sourcery: component = "selectioncard"
public struct SelectionCardProperties {
    public enum SelectionMode: String, Codable {
        case single
        case multiple
    }

    public let title: String
    public let subtitle: String
    public let value: String
    public let isSelected: Bool
    public let badgeText: String?
    public let selectionId: String?
    public let selectionGroupId: String?
    public let selectionMode: SelectionMode
    public let navigation: NavigationProperties?

    public init(title: String,
                subtitle: String,
                value: String,
                isSelected: Bool,
                badgeText: String?,
                selectionId: String? = nil,
                selectionGroupId: String? = nil,
                selectionMode: SelectionMode = .single,
                navigation: NavigationProperties?) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.isSelected = isSelected
        self.badgeText = badgeText
        self.selectionId = selectionId
        self.selectionGroupId = selectionGroupId
        self.selectionMode = selectionMode
        self.navigation = navigation
    }
}

extension SelectionCardProperties: Properties, Codable {
    public static func fromComponent(properties: KeyedDecodingContainer<Component.CodingKeys>) throws -> SelectionCardProperties {
        return try properties.decode(SelectionCardProperties.self, forKey: .properties)
    }
}

#if DEBUG
public extension SelectionCardProperties {
    static var mock: Component {
        Component(contentType: "selectioncard",
                  properties: SelectionCardProperties(title: "Monthly",
                                                       subtitle: "Billed monthly",
                                                       value: "$9.99",
                                                       isSelected: false,
                                                       badgeText: nil,
                                                       navigation: nil),
                  id: UUID())
    }

    static var selectedMock: Component {
        Component(contentType: "selectioncard",
                  properties: SelectionCardProperties(title: "Annual",
                                                       subtitle: "Billed once a year",
                                                       value: "$39.99",
                                                       isSelected: true,
                                                       badgeText: "Save 63%",
                                                       navigation: nil),
                  id: UUID())
    }
}
#endif
