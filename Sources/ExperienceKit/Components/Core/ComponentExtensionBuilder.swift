//
//  ComponentExtensionBuilder.swift
//  ExperienceKit
//
//  Created by Sashen Singh on 09/07/2025.
//

import Foundation

public extension Component {
    static func sectionTitleComponent(title: String, showBottomBorder: Bool) -> Component {
        return Component(contentType: "sectionTitle",
                         properties: SectionTitleProperties(title: title, showBottomBorder: showBottomBorder),
                         id: UUID())
    }

    static func genericListItemComponent(title: String, navigation: NavigationProperties?) -> Component {
        return Component(contentType: "genericListItem",
                         properties: GenericListItemProperties(title: title,
                                                               navigation: navigation),
                         id: UUID())
    }

    static func welcomeComponent(properties: WelcomeProperties) -> Component {
        return Component(contentType: "welcomeComponent",
                         properties: properties,
                         id: UUID())
    }

    static func separatorComponent(properties: SeparatorProperties) -> Component {
        return Component(contentType: "separator",
                         properties: properties,
                         id: UUID())
    }

    static func buttonComponent(title: String, style: ButtonProperties.Style, isFullWidth: Bool, navigation: NavigationProperties) -> Component {
        return Component(contentType: "button",
                         properties: ButtonProperties(title: title,
                                                      style: style,
                                                      isFullWidth: isFullWidth,
                                                      navigation: navigation),
                         id: UUID())
    }
}
