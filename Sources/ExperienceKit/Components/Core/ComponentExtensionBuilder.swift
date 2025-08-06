//
//  ComponentExtensionBuilder.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/07/2025.
//

import Foundation

public extension Component {
    static func sectionTitleComponent(properties: SectionTitleProperties) -> Component {
        return Component(contentType: "sectionTitle",
                         properties: properties,
                         id: UUID())
    }

    static func genericListItemComponent(properties: GenericListItemProperties) -> Component {
        return Component(contentType: "genericListItem",
                         properties: properties,
                         id: UUID())
    }

    static func welcomeComponent(properties: WelcomeProperties) -> Component {
        return Component(contentType: "welcome",
                         properties: properties,
                         id: UUID())
    }

    static func separatorComponent(properties: SeparatorProperties) -> Component {
        return Component(contentType: "separator",
                         properties: properties,
                         id: UUID())
    }

    static func buttonComponent(properties: ButtonProperties) -> Component {
        return Component(contentType: "button",
                         properties: properties,
                         id: UUID())
    }
}
