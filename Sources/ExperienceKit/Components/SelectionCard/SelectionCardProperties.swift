//
//  SelectionCardProperties.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 02/09/2026.
//

import Foundation

// sourcery: component = "selectioncard"
public struct SelectionCardProperties {
    public let title: String
    public let subtitle: String
    public let isSelected: Bool
    public let showBadge: Bool
    public let navigation: NavigationProperties?

    public init(title: String,
                subtitle: String,
                isSelected: Bool,
                showBadge: Bool,
                navigation: NavigationProperties?) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.showBadge = showBadge
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
                                                       subtitle: "$9.99 /mo",
                                                       isSelected: false,
                                                       showBadge: false,
                                                       navigation: nil),
                  id: UUID())
    }

    static var selectedMock: Component {
        Component(contentType: "selectioncard",
                  properties: SelectionCardProperties(title: "Yearly",
                                                       subtitle: "$89.99 /yr",
                                                       isSelected: true,
                                                       showBadge: true,
                                                       navigation: nil),
                  id: UUID())
    }
}
#endif
