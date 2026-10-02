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

    public enum BadgeStyle: String, Codable {
        /// Inverted promotional pill, for example "Save 44%".
        case prominent
        /// Quiet descriptive tag, for example "5 low · 2 high".
        case neutral
    }

    public let title: String
    public let subtitle: String
    /// Generic trailing label. `nil` switches the card to the choice-card
    /// layout, where the badge sits on the title row and the subtitle runs
    /// the full card width.
    public let value: String?
    public let isSelected: Bool
    public let badgeText: String?
    public let badgeStyle: BadgeStyle
    public let selectionId: String?
    public let selectionGroupId: String?
    public let selectionMode: SelectionMode
    public let navigation: NavigationProperties?

    public init(title: String,
                subtitle: String,
                value: String?,
                isSelected: Bool,
                badgeText: String?,
                badgeStyle: BadgeStyle = .prominent,
                selectionId: String? = nil,
                selectionGroupId: String? = nil,
                selectionMode: SelectionMode = .single,
                navigation: NavigationProperties?) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.isSelected = isSelected
        self.badgeText = badgeText
        self.badgeStyle = badgeStyle
        self.selectionId = selectionId
        self.selectionGroupId = selectionGroupId
        self.selectionMode = selectionMode
        self.navigation = navigation
    }
}

extension SelectionCardProperties: Properties, Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case value
        case isSelected
        case badgeText
        case badgeStyle
        case selectionId
        case selectionGroupId
        case selectionMode
        case navigation
    }

    // `badgeStyle` is optional in payloads so cards authored before the badge
    // style existed keep rendering the prominent pill.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        value = try container.decodeIfPresent(String.self, forKey: .value)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
        badgeText = try container.decodeIfPresent(String.self, forKey: .badgeText)
        badgeStyle = try container.decodeIfPresent(BadgeStyle.self, forKey: .badgeStyle) ?? .prominent
        selectionId = try container.decodeIfPresent(String.self, forKey: .selectionId)
        selectionGroupId = try container.decodeIfPresent(String.self, forKey: .selectionGroupId)
        selectionMode = try container.decode(SelectionMode.self, forKey: .selectionMode)
        navigation = try container.decodeIfPresent(NavigationProperties.self, forKey: .navigation)
    }

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

    static var choiceMock: Component {
        Component(contentType: "selectioncard",
                  properties: SelectionCardProperties(title: "Carb cycling",
                                                       subtitle: "Five lighter days and two at full maintenance.",
                                                       value: nil,
                                                       isSelected: true,
                                                       badgeText: "5 low · 2 high",
                                                       badgeStyle: .neutral,
                                                       navigation: nil),
                  id: UUID())
    }
}
#endif
